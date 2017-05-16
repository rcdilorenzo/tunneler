{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
module Application where

import Tunneler.Common
import Web.Simple
import Web.Frank
import Data.String
import System.Process
import System.Exit
import Control.Monad.IO.Class
import Data.Aeson
import Control.Exception
import Network.HTTP.Simple

import ResultStatus
import Tunnel

app :: (Application -> IO ()) -> IO ()
app runner = do
  settings <- newAppSettings

  runner $ controllerApp settings $ do
    get "/" $
      respond $ okJson $ encode okStatus

    post "/actions/stop" $
      runCmd "killall ngrok" okStatus errorStatus

    get "/actions/status" $ do
      result <- liftIO (try getTunnelInfo :: IO (Either HttpException (Maybe Tunnel)))
      case result of
        Left _ ->
          respond $ okJson $ encode errorStatus

        Right maybeTunnel ->
          runCmd "pgrep ngrok > /dev/null"
            (ResultStatus "RUNNING" maybeTunnel)
            (ResultStatus "STOPPED" Nothing)

    post "/actions/start" $ do
      let command = "ngrok start --all -log=stdout > /dev/null"
      result <- liftIO $ spawnCommand command
      respond $ okJson $ encode (ResultStatus "STARTING" Nothing)

runCmd :: String -> ResultStatus -> ResultStatus -> ControllerT s IO b
runCmd command success err = do
  result <- liftIO $ system command
  case result of
    ExitSuccess ->
      respond $ okJson $ encode success
    ExitFailure _ ->
      respond $ okJson $ encode err

