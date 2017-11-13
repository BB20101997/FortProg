#!/usr/bin/ghci
module Tree where

data Tree a = Leaf a
            | Branch Tree a Tree a

--rekursiv
sumTreeRec::Tree Int -> Int
sumTreeRec (Leaf a) = a
sumTreeRec (Tree a b) = (sumTreeRec a) + (sumTreeRec b)

--mit Akkumulator? TODO ist das so richtig?
sumTreeAku::Tree Int ->Int
sumTreeAku b = akuHelper b 0
    where
        akuHelper::Tree->Int->Int
        akuHelper (Leaf a) aku = aku+a+b
        akuHelper (Branch a b) aku = akuHelper a $! (akuHelper b aku)

mirrorTree::Tree->Tree
mirrorTree (Leaf a) = (Leaf a)
mirrorTree (Branch a b) = (Branch (mirrorTree b) (mirrorTree a))

treeToList::Tree a->[a]
treeToList t = ttlHelp t []
    where
        ttlHel::Tree a->[a]->[a]
        ttlHelp (Leaf a) list = a : list
        ttlHelp (Tree a b) list = (ttlHelp a $! (ttlHelp b list))
