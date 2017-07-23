module Worker where

import Control.Concurrent (threadDelay)
import Control.Monad
import Pipes
import Control.Concurrent.Async
import qualified Pipes.Prelude as P
import Pipes.Concurrent

worker :: (Show a) => Int -> Consumer a IO r
worker i = forever $ do
    a <- await
    lift $ threadDelay 1000000  -- 1 second
    lift $ putStrLn $ "Worker #" ++ show i ++ ": Processed " ++ show a

user :: Producer String IO ()
user = P.stdinLn >-> P.takeWhile (/= "quit")

start :: IO ()
start = do
    (output, input) <- spawn unbounded

    as <- forM [1..3] $ \i ->
          async $ do runEffect $ fromInput input  >-> worker i
                     performGC

    a  <- async $ do runEffect $ user >-> toOutput output -- replace user for each [1..10] for another example
                     performGC

    mapM_ wait (a:as)
