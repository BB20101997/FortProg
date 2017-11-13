#!/usr/bin/ghci
module Tree where

data Tree a = Leaf a
            | Branch (Tree a) (Tree a)

--rekursiv
sumTreeRec::Tree Int -> Int
sumTreeRec (Leaf a) = a
sumTreeRec (Branch a b) = (sumTreeRec a) + (sumTreeRec b)

--mit Akkumulator
sumTreeAku::Tree Int ->Int
sumTreeAku b = akuHelper b 0
    where
        akuHelper::Tree Int->Int->Int
        akuHelper (Leaf a) aku = aku+a
        akuHelper (Branch a b) aku = akuHelper a $! (akuHelper b aku)

mirrorTree::Tree a->Tree a
mirrorTree (Leaf a) = (Leaf a)
mirrorTree (Branch a b) = (Branch (mirrorTree b) (mirrorTree a))

treeToList::Tree a->[a]
treeToList t = ttlHelp t []
    where
        ttlHelp::Tree a->[a]->[a]
        ttlHelp (Leaf a) list = a : list
        ttlHelp (Branch a b) list = (ttlHelp a $! (ttlHelp b list))
