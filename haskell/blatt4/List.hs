#!/usr/bin/ghci
module List where

--laufzeit O(n(n+1)/2) also O(n²)
reversedRecursiv::[a]->[a]
reversedRecursiv [] = []
reversedRecursiv (a:b) = (reversedRecursiv b)++[a]

reversed::[a]->[a]
reversed a = revHelp a []
    where
        revHelp::[a]->[a]->[a]
        revHelp (h:t) b = revHelp t $! (h:b)
        revHelp [] a = a

indexOf::Int->[Int]->Maybe Int
indexOf e list = indexHelp e list 0
    where
        indexHelp::Int->[Int]->Int->Maybe Int
        indexHelp e (h:t) i
            | e == h = Just i
            | otherwise = indexHelp e t $! (i+1)
        indexHelp _ [] _ = Nothing

tails::[a]->[[a]]
tails a = tailHelp a []
    where
        tailHelp::[a]->[[a]]->[[a]]
        tailHelp (h:t) l = tailHelp t $! ((h:t):l)
        tailHelp [] l = []:l

inits::[a]->[[a]]
inits a = initHelp (reversed a) []
    where
        initHelp::[a]->[[a]]->[[a]]
        initHelp (h:t) l = initHelp t $! ((reversed (h:t)):l)
        initHelp [] l = []:l

insert::a->[a]->[[a]]
insert a list = insertHelp a [] (inits list) (reversed (tails list))
    where
        insertHelp::a->[[a]]->[[a]]->[[a]]->[[a]]
        insertHelp a list (hi:ti) (ht:tt) = (insertHelp a $! ((hi++[a]++ht):list)) ti tt
        insertHelp a list _ _ = list

perms::[a]->[[a]]
perms [] = [[]]
perms (h:t) = permHelp h t [[]] []
    where
        permHelp::a->[a]->[[a]]->[[a]]->[[a]]
        permHelp _ []    []    list = list
        permHelp _ (h:t) []    list = permHelp h t list []
        permHelp a b     (h:t) list = permHelp a b t $! ((insert a h)++list)
