#!/usr/bin/ghci

class Pretty a where
    pretty::a->String
    prettyIntern::a->[String]    

data Rose a = Rose a [Rose a]

instance Eq a => Eq (Rose a) where
    (==) (Rose a1 l1) (Rose a2 l2) = a1==a2&&l1==l2

instance Ord a => Ord (Rose a) where
    compare (Rose a1 l1) (Rose a2 l2) = case compare a1 a2 of
                                             EQ -> compare l1 l2
                                             res -> res
{-
instance Pretty a => Pretty [a] where
    prettyDepth d list = concatMap (prettyDepth d) list

instance (Show a) => Pretty (Rose a) where
    pretty (Rose a list)        = 
        where prettyRose::(Rose a)->(String,[Rose a])
              prettyRose (Rose a list) = (show a,list)
  -}
