#!/usr/bin/runhaskell
data Tree a = Leaf a 
              | Branch (Tree a) (Tree a)

flatTree::Tree (Tree a) ->Tree a
flatTree (Leaf a)     = a
flatTree (Branch a b) = Branch (flatTree a) (flatTree b)

mapTree::(a->b) -> Tree a -> Tree b
mapTree mapFunc (Leaf a)     = Leaf (mapFunc a)
mapTree mapFunc (Branch a b) = Branch (mapTree mapFunc a) (mapTree mapFunc b)

foldTree::(a->b)->(b->b->b)->Tree a->b
foldTree lFunc _     (Leaf a)     = lFunc a
foldTree lFunc bFunc (Branch a b) = bFunc (foldTree lFunc bFunc a) (foldTree lFunc bFunc b)

extendTree::(a -> Tree b) -> Tree a -> Tree b
extendTree extFunc (Leaf a) = extFunc a
extendTree extFunc (Branch a b) = Branch (extendTree extFunc a) (extendTree extFunc b)
