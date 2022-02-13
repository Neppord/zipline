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
import Html (a, li, ul)

renderFileTree :: String -> Array String -> String
renderFileTree path files = files
    # foldMap (\file -> li (a (path <> "/" <> file) file))
    # ul

app :: AppM Unit
app = do
    get "*" $ do
        path <- getPath
        setStatus 200
        dir <- liftAff $ readdir ("." <> path)
        let linkPrefix = stripSuffix (Pattern "/") path
                # fromMaybe path
        send $ renderFileTree linkPrefix dir

main :: Effect Unit
main = void $ listenHttp app 8080 (\_ -> log "listening to port 8080")
