{-# LANGUAGE DeriveGeneric #-}
module ResultStatus where

import GHC.Generics
import Data.Aeson
import Tunnel

data ResultStatus = ResultStatus
  { status :: String
  , tunnel :: Maybe Tunnel } deriving (Show, Generic)

instance FromJSON ResultStatus
instance ToJSON ResultStatus

okStatusWith :: Maybe Tunnel -> ResultStatus
okStatusWith tunnel =
  ResultStatus "OK" tunnel

okStatus :: ResultStatus
okStatus =
  ResultStatus "OK" Nothing

errorStatus :: ResultStatus
errorStatus =
  ResultStatus "ERROR" Nothing
