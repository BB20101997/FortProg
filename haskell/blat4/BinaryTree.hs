data SearchTree = Branch SearchTree SearchTree Int
                | Empty

insert::SearchTree->Int->SearchTree
insert (Branch l r i) n
        | i>n = insert l n
        | i<n = insert r n
        | i==n = Branch l r i
insert Empty n = Branch Empty Empty n

isElem::SearchTree->Int->Bool
isElem Empty n = False
isElem (Branch l r i) n
        | i==n = True
        | i<n  = isElem r n
        | i>n  = isElem l n