module Main where
  
-- import Control.Monad ( (<<) )

import System( getArgs )
import System.IO( stderr, hPutStrLn )

import System.Process( runCommand, waitForProcess)

import Data.List( nub, sort, isPrefixOf )
  
main = do args <- getArgs
          if (length args >= 2) then
              do  let file = head args
                  let current_word = (head . tail) args
                  procHandle <- runCommand $ command file
                  exitcode <- waitForProcess procHandle
                  
                  text <- readFile "/tmp/textmatetags"
                  mapM_ (putStrLn) $ sort . nub . filter (isPrefixOf current_word) 
                                   $ map (head . words) (lines text)
            else
              hPutStrLn stderr "Provide a haskell file and a current word!"
  where command file = "echo \":ctags /tmp/textmatetags\" | ghci " ++ file ++" &> /tmp/runtags"
