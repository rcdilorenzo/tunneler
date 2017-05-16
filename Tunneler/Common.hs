
module Tunneler.Common where

import Control.Applicative
import Web.Simple




data AppSettings = AppSettings {  }

newAppSettings :: IO AppSettings
newAppSettings = do
  
  return $ AppSettings

