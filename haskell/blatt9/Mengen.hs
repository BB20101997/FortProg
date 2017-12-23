#!/usr/bin/ghci
{-# LANGUAGE TemplateHaskell #-}

import Test.QuickCheck

data Set a = Set [a]
    deriving Show

empty :: Set a
empty = Set []

isEmpty :: Set a -> Bool
isEmpty (Set xs) = null xs

insert :: a -> Set a -> Set a
insert x (Set xs) = Set (x:xs)

member :: Eq a => a -> Set a -> Bool
member x (Set xs) = elem x xs

delete :: Eq a => a -> Set a -> Set a
delete x (Set xs) = Set (remove x xs)
  where
  remove _ []                 = []
  remove y (z:zs) | y == z    = zs
                  | otherwise = remove y zs

union :: Set a -> Set a -> Set a
union (Set xs) (Set ys) = Set (xs ++ ys)

intersect :: Ord a => Set a -> Set a -> Set a
intersect (Set s1) (Set s2) = Set (merge s1 s2)
  where
  merge []     ys     = ys
  merge xs     []     = xs
  merge (x:xs) (y:ys) = case compare x y of
    LT -> x : y : merge xs ys
    EQ -> y : merge xs ys
    GT -> y : x : merge xs ys

size :: Set a -> Int
size (Set xs) = length xs

isSubSet::(Eq a)=>(Set a)->(Set a)->Bool
isSubSet (Set sub) super =(length ["Somthing from Sub is not in Super therefore not a Subset"|inSub <- sub,not (inSub `member` super)]) == 0

instance (Arbitrary a) =>  Arbitrary (Set a)  where
    arbitrary = do
                    list <- listOf arbitrary
                    return $ foldr insert empty list

prop_add_is_not_empty::(Arbitrary a) => a->(Set a)->Bool
prop_add_is_not_empty a = not.isEmpty.(insert a)

prop_add_is_element::(Arbitrary a, Eq a) => a->(Set a)->Bool
prop_add_is_element elem = (member elem).(insert elem)

prop_remove_is_not_element::(Arbitrary a,Eq a) => a ->(Set a)->Bool
prop_remove_is_not_element elem = not.(member elem).(delete elem)

prop_remove_int_size_check::Int->(Set Int)->Bool
prop_remove_int_size_check = prop_remove_reduce_size_by_at_most_one

prop_remove_reduce_size_by_at_most_one::(Arbitrary a,Eq a) => a->(Set a)->Bool
prop_remove_reduce_size_by_at_most_one a set = let 
                                                    redSize = size (delete a set)
                                                    origSize    = size set
                                                        in (origSize==redSize)||((origSize-1)==redSize)

prop_merge_test_int::(Set Int)->(Set Int)->Bool
prop_merge_test_int = prop_merge_test

prop_merge_test::(Arbitrary a,Eq a) => (Set a)->(Set a)->Bool
prop_merge_test set1@(Set l1) set2@(Set l2) = let
                                                 all = union set1 set2
                                                 inl1 = isSubSet set1 all
                                                 inl2 = isSubSet set2 all
                                                 allInl1Orl2 = isSubSet all (Set (l1++l2))
                                               in inl1&&inl2&&allInl1Orl2

prop_empty_check::(Set a)->Bool
prop_empty_check s@(Set l) = (isEmpty s) == ((length l)==0)

prop_intersect_check::(Arbitrary a,Ord a) => (Set a)->(Set a)->Bool
prop_intersect_check s1 s2 = let
                                section  = intersect s1 s2
                                sectIns1 = isSubSet section s1
                                sectIns2 = isSubSet section s2
                             in sectIns1 && sectIns2

prop_size_test::(Set a)->Bool
prop_size_test set@(Set list) = (size set) == (length list)

return []
runTests = $quickCheckAll
