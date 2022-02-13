module Html where

import Prelude

tag :: String -> String -> String
tag name children = "<" <> name <> ">" <> children <> "</" <> name <> ">"

ul :: String -> String
ul = tag "ul"

li :: String -> String
li = tag "li"

a :: String -> String -> String
a href content = "<a href='" <> href <> "'>"<> content <>"</a>"