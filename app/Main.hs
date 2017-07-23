module Main where

import Game (game)
import Worker (start)
import Mailbox (mailbox)
import Broadcast (bcast)

main :: IO ()
main = bcast
