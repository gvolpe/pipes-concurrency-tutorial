module Main where

--import Game (start)
import Worker (start)
import Mailbox (mailbox)

main :: IO ()
main = mailbox
