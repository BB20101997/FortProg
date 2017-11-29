#!/usr/bin/ghci

class Pretty a where
    pretty::a->String

data Rose a = Rose a [Rose a]

instance Eq a => Eq (Rose a) where
    (==) (Rose a1 l1) (Rose a2 l2) = a1==a2&&l1==l2

instance Ord a => Ord (Rose a) where
    compare (Rose a1 l1) (Rose a2 l2) = case compare a1 a2 of
                                             EQ -> compare l1 l2
pretListElem::String->[String]->String
pretListElem tailPrefix (head:tail) = unlines $ ("+-- "++head):(map (tailPrefix++) tail)
pretListElem tailprefix [] = ""

instance Pretty a => Pretty [a] where
    pretty [] = ""
    pretty (a:[]) = pretListElem "    " (lines.pretty $ a)
    pretty (a:tail) =  (pretListElem "|   " (lines.pretty $ a))++(pretty tail)

instance Pretty Int where
    pretty = show

instance (Pretty a) => Pretty (Rose a) where
    pretty (Rose a list) =  pretty a ++"\n"++ pretty list
