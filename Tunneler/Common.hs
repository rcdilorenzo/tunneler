{-# LANGUAGE OverloadedStrings #-}
module Tunneler.Common where

import System.Environment
import Text.Read
import Data.Maybe

data AppSettings = AppSettings
  { envUsername :: String
  , envPassword :: String
  , envPort :: Int } deriving Show

newAppSettings :: IO AppSettings
newAppSettings = do
  env <- getEnvironment

  return $ AppSettings
    (envVarStr env "TUSER" "admin")
    (envVarStr env "TPSWD" "pswd")
    (envVar env "PORT" 3000)

envVar :: (Read a) => [(String, String)] -> String -> a -> a
envVar env key defaultValue =
  case lookup key env of
    Just value ->
      fromMaybe defaultValue (readMaybe value)
    Nothing ->
      defaultValue

envVarStr :: [(String, String)] -> String -> String -> String
envVarStr env key defaultValue =
  fromMaybe defaultValue (lookup key env)
