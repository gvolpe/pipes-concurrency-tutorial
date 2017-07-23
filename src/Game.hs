module Game where

import Control.Concurrent (threadDelay)
import Control.Monad (forever)
import Pipes
import Pipes.Concurrent

data Event = Harm Integer | Heal Integer | Quit deriving (Show)

user :: IO Event
user = do
    command <- getLine
    case command of
        "potion" -> return (Heal 10)
        "quit"   -> return  Quit
        _        -> do
            putStrLn "Invalid command"
            user  -- Try again

acidRain :: Producer Event IO r
acidRain = forever $ do
    lift $ threadDelay 2000000  -- Wait 2 seconds
    yield (Harm 1)

handler :: Consumer Event IO ()
handler = loop 100
  where
    loop health = do
        lift $ putStrLn $ "Health = " ++ show health
        event <- await
        case event of
            Harm n -> loop (health - n)
            Heal n -> loop (health + n)
            Quit   -> return ()

start :: IO ()
start = do
  (output, input) <- spawn unbounded

  forkIO $ do runEffect $ lift user >~  toOutput output
              performGC

  forkIO $ do runEffect $ acidRain  >-> toOutput output
              performGC

  runEffect $ fromInput input >-> handler
