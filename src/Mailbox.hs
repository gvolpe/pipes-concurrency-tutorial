module Mailbox where

import Control.Monad
import Pipes
import Control.Concurrent.Async
import qualified Pipes.Prelude as P
import Pipes.Concurrent
import Worker

mailbox :: IO ()
mailbox = do
    (output, input) <- spawn $ bounded 1

    as <- forM [1..3] $ \i ->
          async $ do runEffect $ fromInput input >-> P.take 2 >-> worker i
                     performGC

    a  <- async $ do runEffect $ each [1..] >-> P.chain print >-> toOutput output
                     performGC

    mapM_ wait (a:as)
