#!/usr/bin/ghci
import Data.Maybe

first::[Int]
first = [(2*i)+1 | i<-[1..5]]

second::[(Int,Bool)]
second = [(5*i,(mod i 2 == 0)) | i<-[1..5], i/=2,i/=3]

third::[Maybe Int]
third = [Just (i^2) | i<-[1..5], mod i 2==1   ]


fourth::[(Int,Int)]
fourth = [(i,j) | i<-[1..5], j<-[5,4..1], j>i]

mapWithComp::(a->b)->[a]->[b]
mapWithComp f a = [f c |c<-a ]

lookupWithComp:: Eq a => a -> [(a, b)] -> Maybe b
lookupWithComp elem list = listToMaybe [e | (d,e)<-list, d==elem]

replicateWithComp:: Int -> a -> [a] 
replicateWithComp n obj = [obj|i<-[1..n]]

filterWithComp::(a -> Bool) -> [a] -> [a]
filterWithComp f list = [c | c<-list, f c]

test::[(Int,Int)]
test = [(1,5),(2,6),(3,7),(4,8),(5,9),(6,0)]