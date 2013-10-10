import Data.Char
import Data.String.Utils
import Text.Pandoc
import Text.Pandoc.Walk
import Control.Monad
import System.FilePath.Posix
import Control.Concurrent

import ArchWiki (cleanDoc)

nth :: Int -> String -> Char
nth _ [] = ' '
nth 0 (x:_) = x
nth n (_:xs) = nth (n-1) xs

interestedIn :: String -> Bool
interestedIn title | nonAscii title = False
                   | isLangTagged title = False
                   | nth 0 title == '~' = False
                   | otherwise = True
  where nonAscii = any (not . isAscii)
        isLangTagged = isAsciiUpper . nth 1 . dropWhile (/= '(')

enDoc :: Inline -> [(String, String)]
enDoc (Link [Str t] (u,_)) | interestedIn t = [(u,t)]
                           | otherwise = []
enDoc _ = []

parseIndex :: FilePath -> IO [(String, String)]
parseIndex path = do
  html <- readFile path
  return $ query enDoc (readHtml def html)

fork :: IO () -> IO (MVar ())
fork io = do
  mvar <- newEmptyMVar
  forkFinally io (\_ -> putMVar mvar ())
  return mvar

dstDir = "wiki/"
srcDir = "/usr/share/doc/arch-wiki/html/"

trimWiki :: (String, String) -> IO ()
trimWiki (file, title) = do
    html <- readFile $ srcDir ++ file
    let path = makeValid $ dstDir ++ (sanitize title) ++ ".md"
    writeFile path (cleanDoc html)
  where 
    sanitize = replace "/" "_"

main :: IO ()
main = do
  index <- parseIndex $ srcDir ++ "index.html"
  mvars <- mapM (fork . trimWiki) index
  mapM_ takeMVar mvars