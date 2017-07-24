module Peek where

import Control.Concurrent (threadDelay)
import Control.Monad
import Pipes
import qualified Pipes.Prelude as P
import Control.Concurrent.Async
import Pipes.Concurrent

-- Fast input updates
inputDevice :: (Monad m) => Producer Integer m ()
inputDevice = each [1..]

-- Slow output updates
outputDevice :: Consumer Integer IO r
outputDevice = forever $ do
    n <- await
    lift $ do
        print n
        threadDelay 1000000

peek :: IO ()
peek = do
    -- An alternative here is to use newest (a sort of non-blocking bounded mailbox)
    (output, input) <- spawn (latest 0) 

    a1 <- async $ do runEffect $ inputDevice >-> toOutput output
                     performGC

    a2 <- async $ do runEffect $ fromInput input >-> P.take 5 >-> outputDevice
                     performGC

    mapM_ wait [a1, a2]
