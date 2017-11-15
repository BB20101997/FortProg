#!/usr/bin/ghci
data SearchTree = Branch SearchTree SearchTree Int
                | Empty
    deriving Show
insert::SearchTree->Int->SearchTree
insert (Branch l r i) n
        | i>n =  Branch (insert l n) r i
        | i<=n =  Branch l (insert r n) i
insert Empty n = Branch Empty Empty n

isElem::SearchTree->Int->Bool
isElem Empty n = False
isElem (Branch l r i) n
        | i==n = True
        | i<n  = isElem r n
        | i>n  = isElem l n

delete::SearchTree->Int->SearchTree
delete Empty          n = Empty
delete (Branch l r i) n | i<n = Branch l (delete r n) i
                        | i>n = Branch (delete l n) r i
                        | otherwise = join l r
    where
        join::SearchTree->SearchTree->SearchTree
        join a Empty = a
        join Empty b = b
        join a     b = Branch a (treeButLeftMost b) (leftMost b)
            where
                leftMost::SearchTree->Int
                leftMost (Branch Empty _ i) = i
                leftMost (Branch a _ _) = leftMost a
                
                treeButLeftMost::SearchTree->SearchTree
                treeButLeftMost (Branch Empty b i) = b
                treeButLeftMost (Branch a Empty i) = Branch (treeButLeftMost a) Empty i
                treeButLeftMost (Branch a b     i) = Branch (treeButLeftMost a) b i



