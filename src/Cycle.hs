module Cycle where

import Control.Concurrent.Async
import Pipes
import Pipes.Concurrent
import qualified Pipes.Prelude as P

nodeadlock :: IO ()
nodeadlock = do
    (out1, in1) <- spawn unbounded
    (out2, in2) <- spawn unbounded

    a1 <- async $ do
        runEffect $ (each [1,2] >> fromInput in1) >-> toOutput out2
        performGC

    a2 <- async $ do
        runEffect $ fromInput in2 >-> P.chain print >-> P.take 6 >-> toOutput out1
        performGC

    mapM_ wait [a1, a2]
