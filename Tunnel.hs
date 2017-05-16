{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}

module Tunnel where

import Data.Aeson
import GHC.Generics
import Network.HTTP.Simple
import Data.Text
import Data.HashMap.Strict as HashMap
import Data.List as List

data Tunnel = Tunnel
  { port :: Int } deriving (Show, Generic)

instance FromJSON Tunnel where
  parseJSON (Object obj) = do
    let Just (String url) = HashMap.lookup "public_url" obj
    let tunnelPort = List.last $ split (==':') url
    return $ Tunnel $ read $ unpack tunnelPort

  parseJSON _ = return $ Tunnel 0

instance ToJSON Tunnel

data TResponse = TResponse
  { tunnels :: [Tunnel] } deriving (Show, Generic)

instance FromJSON TResponse

getTunnelInfo :: IO (Maybe Tunnel)
getTunnelInfo = do
  let request = setRequestHost "127.0.0.1"
              $ setRequestPort 4040
              $ setRequestPath "/api/tunnels"
              $ setRequestHeader "Content-Type" ["application/json"] defaultRequest

  rawResponse <- httpJSONEither request
    :: IO (Response (Either JSONException TResponse))

  case getResponseBody rawResponse of
    Right (TResponse [tunnel]) ->
      return (Just tunnel)

    _ ->
      return Nothing
