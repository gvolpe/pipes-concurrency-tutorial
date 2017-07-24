module Main where

import Game (game)
import Worker (start)
import Mailbox (mailbox)
import Broadcast (bcast)
import Peek (peek)
import Callback (callback)
import Cycle (nodeadlock)

main :: IO ()
main = nodeadlock
