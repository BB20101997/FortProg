#!/usr/bin/ghci
module Tree where

data Tree a = Leaf a
            | Branch (Tree a) (Tree a)

--Die akkumulator variante von sumTree sollte auf grund von Tail rekursion effizienter sein

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
        akuHelper (Branch a b) aku = akuHelper a (akuHelper b aku)

mirrorTree::Tree a->Tree a
mirrorTree (Leaf a) = (Leaf a)
mirrorTree (Branch a b) = (Branch (mirrorTree b) (mirrorTree a))


-- die Laufzeit sollte in O(n) liegen da jeder Knoten des Baumes einmal Besucht wird und
-- an den Blättern wird jeweils in Konstanter Zeit ein Element als Head an eine Liste angefügt
treeToList::Tree a->[a]
treeToList t = ttlHelp t []
    where
        ttlHelp::Tree a->[a]->[a]
        ttlHelp (Leaf a) list = a : list
        ttlHelp (Branch a b) list = (ttlHelp a (ttlHelp b list))
