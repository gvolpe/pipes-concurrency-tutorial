module Broadcast where

import Control.Monad
import Control.Concurrent.Async
import Pipes
import Pipes.Concurrent
import qualified Pipes.Prelude as P
import Data.Monoid

bcast :: IO ()
bcast = do
    (output1, input1) <- spawn unbounded
    (output2, input2) <- spawn unbounded
    
    a1 <- async $ do
        runEffect $ P.stdinLn >-> toOutput (output1 <> output2)
        performGC

    as <- forM [input1, input2] $ \input -> async $ do
        runEffect $ fromInput input >-> P.take 2 >-> P.stdoutLn
        performGC

    mapM_ wait (a1:as)
