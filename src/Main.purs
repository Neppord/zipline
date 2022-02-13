module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.Express.App (AppM, get, listenHttp)
import Node.Express.Response (send, setStatus)

app :: AppM Unit
app = do
    get "/" $ do
        setStatus 200
        send "<h1>hello world!</h1>"

main :: Effect Unit
main = do
  _ <- listenHttp app 8080 (\_ -> log "listening to port 8080")
  pure unit