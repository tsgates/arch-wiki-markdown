import Data.Char
import Data.String.Utils
import Text.Pandoc
import Text.Pandoc.Walk
import Control.Monad
import System.FilePath.Posix

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
  
main :: IO ()
main = do
  index <- parseIndex $ src ++ "index.html"
  forM_ index $ \(file, title) -> do
    html <- readFile $ src ++ file
    let path = makeValid $ dst ++ (sanitize title) ++ ".md"
    writeFile path (cleanDoc html)
  where dst = "wiki/"
        src = "/usr/share/doc/arch-wiki/html/"
        sanitize = replace "/" "_"
