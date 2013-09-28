module ArchWiki where

import Text.Pandoc
import Text.Pandoc.Walk
import Text.HTML.TagSoup

cleanAttr :: Block -> Block
cleanAttr (Header 3 _ xs)  = Header 3 nullAttr ([Str "> "] ++ xs)
cleanAttr (Header n _ xs)  = Header n nullAttr xs
cleanAttr (CodeBlock _ xs) = CodeBlock nullAttr xs
cleanAttr x = x
  
filterWiki html = renderTags $ (take 4 skip) ++ cont
  where tags = parseTags html
        skip = dropWhile (~/= "<h1 id=firstHeading>") tags
        cont = takeWhile (~/= "<div id=p-cactions>") $
                 dropWhile (~/= "<div id=mw-content-text>") skip
        
readDoc :: String -> Pandoc
readDoc = readHtml def

writeDoc :: Pandoc -> String
writeDoc = writePlain def

cleanDoc :: String -> String
cleanDoc = writeDoc . walk cleanAttr . readDoc . filterWiki

main :: IO ()
main = interact cleanDoc