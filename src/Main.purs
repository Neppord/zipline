module Main where

import Prelude

import Data.Array (foldMap)
import Data.String (stripSuffix)
import Effect (Effect)
import Effect.Aff.Class (liftAff)
import Effect.Console (log)
import Node.Express.App (AppM, get, listenHttp)
import Node.Express.Request (getPath)
import Node.Express.Response (send, setStatus)
import Node.FS.Aff (readdir)
import Data.String.Pattern (Pattern(..))
import Data.Maybe (fromMaybe)

tag :: String -> String -> String
tag name children = "<" <> name <> ">" <> children <> "</" <> name <> ">"

ul :: String -> String
ul = tag "ul"

li :: String -> String
li = tag "li"

a :: String -> String -> String
a href content = "<a href='" <> href <> "'>"<> content <>"</a>"

app :: AppM Unit
app = do
    get "*" $ do
        path <- getPath
        setStatus 200
        dir <- liftAff $ readdir ("." <> path)
        let linkPrefix = stripSuffix (Pattern "/") path
                # fromMaybe path
        dir
            # foldMap (\file -> li (a (linkPrefix <> "/" <> file) file))
            # ul
            # send

main :: Effect Unit
main = void $ listenHttp app 8080 (\_ -> log "listening to port 8080")
