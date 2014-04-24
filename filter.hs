import Data.Char
import Data.String.Utils
import Text.Pandoc
import Text.Pandoc.Walk
import Control.Monad
import System.FilePath.Posix
import Control.Concurrent
import System.Environment
import System.FilePath.Posix ((</>))
import System.FilePath.Find

import ArchWiki (cleanDoc)

nth :: Int -> String -> Char
nth _ [] = ' '
nth 0 (x:_) = x
nth n (_:xs) = nth (n-1) xs

interestedIn :: String -> Bool
interestedIn file | nonAscii title     = False
                  | isLangTagged title = False
                  | nth 0 title == '~' = False
                  | otherwise = True
  where title = takeFileName file
        nonAscii = any (not . isAscii)
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
srcDir = "usr/share/doc/arch-wiki/html/"

trimWiki :: String -> IO String
trimWiki file = do
    html <- readFile $ file
    let path = makeValid $ dstDir ++ (sanitize $ takeFileName file) ++ ".md"
    writeFile path (cleanDoc html)
    return file
  where 
    sanitize = replace "/" "_"

threadPoolIO :: Int -> (a -> IO b) -> IO (Chan a, Chan b)
threadPoolIO nr mutator = do
    input <- newChan
    output <- newChan
    forM_ [1..nr] $
        \_ -> forkIO (forever $ do
            i <- readChan input
            o <- mutator i
            writeChan output o)
    return (input, output)

runPool :: Int -> [IO a] -> IO ()
runPool n as = do
  (input, output) <- threadPoolIO n (id)
  forM_ as $ writeChan input
  replicateM_ (length as) (readChan output)
  
main :: IO ()
main = do
    getArgs >>= work
  where work [root] = do
          htmls <- find always
                   ((extension ==? ".html")
                    &&? (interestedIn `liftM` fileName))
                   (root </> srcDir)
          runPool 4 (map trimWiki htmls)
