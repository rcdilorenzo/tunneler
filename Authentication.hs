{-# LANGUAGE OverloadedStrings #-}
module Authentication
  ( authenticatedRoute
  , authenticated ) where

import Web.Simple.Auth
import Control.Monad
import Data.ByteString.Base64
import qualified Data.ByteString.Char8 as S8
import Data.Maybe
import Network.HTTP.Types
import Network.Wai
import Web.Simple.Controller

requireAuthentication :: String -> Response
requireAuthentication realm =
  responseLBS status401
    [ (hContentType, "application/json")
    , ("WWW-Authenticate", S8.concat ["Basic realm=", S8.pack . show $ realm]) ]
    "{\"error\": \"UNAUTHORIZED\"}"

authenticatedRoute :: String -> AuthRouter r a
authenticatedRoute realm testAuth next = do
  req <- request
  let authStr = fromMaybe "" $ lookup hAuthorization (requestHeaders req)
  when (S8.take 5 authStr /= "Basic") requireAuth

  case fmap (S8.split ':') $ decode $ S8.drop 6 authStr of
    Right [user, pwd] -> do
      mfin <- testAuth req user pwd
      maybe requireAuth (\finReq -> localRequest (const finReq) next) mfin
    _ -> requireAuth
  where requireAuth = respond $ requireAuthentication realm

authenticated :: String ->
                 String ->
                 String ->
                 Controller r a ->
                 Controller r a
authenticated realm user pwd =
  authRewriteReq (authenticatedRoute realm)
    (\u p -> return $ u == S8.pack user && p == S8.pack pwd)
