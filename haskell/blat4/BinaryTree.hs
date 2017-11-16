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
delete Empty n = Empty
delete (Branch l Empty i) n
         |i==n = l
         |i<n = Branch l Empty i
         |i>n = Branch (delete l n) Empty i
delete (Branch l r i) n
         |i==n = let 
                    removeMin (Branch Empty r i) = r
                    removeMin (Branch l r i)     = Branch (removeMin l) r i
                    removeMin Empty              = Empty
                    getMin (Branch Empty r i)    = i
                    getMin (Branch l r i)        = (getMin l)
                 in
                    Branch l (removeMin r) (getMin r)
         |i<n = Branch l (delete r n) i
         |i>n = Branch (delete l n) r i