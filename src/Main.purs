module Main where

import Prelude

import Data.Array (foldMap, (!!))
import Data.Maybe (fromMaybe)
import Data.String (stripSuffix)
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.Aff.Class (liftAff)
import Effect.Console (log)
import Html (a, li, ul)
import Node.Express.App (AppM, get, listenHttp)
import Node.Express.Request (getPath)
import Node.Express.Response (send, setStatus)
import Node.FS.Aff (readdir, stat)
import Node.FS.Stats (isDirectory)
import Node.Process (argv)

renderFileTree :: String -> Array String -> String
renderFileTree path files = files
    # foldMap (\file -> li (a (path <> "/" <> file) file))
    # ul

app :: String -> AppM Unit
app baseDir = do
    get "*" $ do
        path <- getPath
        let filePath = baseDir <> path
        setStatus 200
        s <- liftAff $ stat filePath
        if isDirectory s then do
            dir <- liftAff $ readdir filePath
            let linkPrefix = stripSuffix (Pattern "/") path
                    # fromMaybe path
            send $ renderFileTree linkPrefix dir
        else
            send "Not a directory"
main :: Effect Unit
main = void do
    args <- argv
    let baseDir = args !! 1 # fromMaybe "."
    listenHttp (app baseDir) 8080 (\_ -> log "listening to port 8080")
