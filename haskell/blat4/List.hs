#!/usr/bin/ghci
module List where

reversedRecursiv::[a]->[a]
reversedRecursiv [] = []
reversedRecursiv (a:b) = (reversedRecursiv b)++[a]

reversed::[a]->[a]
reversed a = revHelp a []
    where
        revHelp::[a]->[a]->[a]
        revHelp (h:t) b = revHelp t (h:b)
        revHelp [] a = a

indexOf::Int->[Int]->Maybe Int
indexOf e list = indexHelp e list 0
    where
        indexHelp::Int->[Int]->Int->Maybe Int
        indexHelp e (h:t) i
            | e == h = Just i
            | otherwise = indexHelp e t $! (i+1)
        indexHelp _ [] _ = Nothing
--inits
--tails
--insert
--perms
