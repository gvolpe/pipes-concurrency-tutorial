module Callback where

import Control.Monad
import Pipes
import Pipes.Concurrent
import qualified Pipes.Prelude as P

onLines :: (String -> IO a) -> IO b
onLines callback = forever $ do
    str <- getLine
    callback str

onLines' :: Producer String IO ()
onLines' = do
    (output, input) <- lift $ spawn $ bounded 1

    lift $ forkIO $ onLines (\str -> atomically $ send output str)

    fromInput input

callback :: IO ()
callback = runEffect $ onLines' >-> P.takeWhile (/= "quit") >-> P.stdoutLn
