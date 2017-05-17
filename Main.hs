{-# LANGUAGE OverloadedStrings #-}
module Main where

import Application
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.RequestLogger
import System.Environment
import Tunneler.Common

main :: IO ()
main = do
  settings <- newAppSettings
  app (run (envPort settings) . logStdout)

