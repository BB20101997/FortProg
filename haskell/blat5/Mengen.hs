#!/usr/bin/runhaskell
type Set = (Int -> Bool)

empty::Set
empty=(\_->False)  

insert::Set->Int->Set
insert s i = (\x -> x==i||(s i))

remove::Set->Int->Set
remove s i = (\x -> i/=x&&(s i))

isElem::Set->Int->Bool
isElem m i = m i 

union::Set->Set->Set
union m1 m2 = (\x -> (m1 x)||(m2 x))

intersection::Set->Set->Set
intersection m1 m2 = (\x -> (m1 x)&&(m2 x))

difference::Set->Set->Set
difference m1 m2 = (\x -> (m1 x) && not (m2 x))

complement::Set->Set
complement m = (\x -> not (m x))

listToSet::[Int]->Set
listToSet [] = empty 
listToSet (x:xs) = insert (listToSet xs) x 

