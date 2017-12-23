#!/usr/bin/ghci
{-# LANGUAGE TemplateHaskell #-}

import Test.QuickCheck
import Data.Bool

--Begin der Vorgaben

data Queue a = Queue [a] [a]
    deriving (Show,Eq) --diese Zeile wurde ergänzt
-- smart constructor
queue :: [a] -> [a] -> Queue a
queue [] ys = Queue (reverse ys) ys
queue xs ys = Queue xs ys

-- empty queue
emptyQueue :: Queue a
emptyQueue = queue [] []

-- Is a queue empty?
isEmptyQueue :: Queue a -> Bool
isEmptyQueue (Queue _ ys) = null ys

-- add to a queue
enqueue :: a -> Queue a -> Queue a
enqueue x (Queue xs ys) = queue xs (x:ys)

-- get next element
next :: Queue a -> a
next (Queue (x:_) _) = x
next _               = error "Queue.next: empty queue"

-- remove first element
dequeue :: Queue a -> Queue a
dequeue (Queue (_:xs) ys) = queue ys xs
dequeue _                 = error "Queue.dequeue: empty queue"

-- size of a queue
size :: Queue a -> Int
size (Queue xs ys) = length xs + length ys

-- invariant a queue should fulfill
invariant :: Queue a -> Bool
invariant (Queue xs ys) = not (null xs) || null ys

--Ende der Vorgaben

instance (Arbitrary a)=>Arbitrary (Queue a) where
    arbitrary = do
                    inBound <- listOf arbitrary
                    outBound <- listOf arbitrary
                    return $ (queue outBound inBound)

prop_size_int::(Queue Int)->Property
prop_size_int = prop_size

prop_size::(Queue a)->Property
prop_size q@(Queue outB inB) = invariant q ==> size q == (length outB + length inB)

prop_smart_constructor::[a]->Bool
prop_smart_constructor qList = let q = (queue [] qList) in (length qList == size q) && (invariant q)

{-if we have a next element it should be the head of the out Bound list-}
prop_next::(Eq a)=>(Queue a)->Property
prop_next q@(Queue outB _) = invariant q&&(length outB>0) ==> (next q) == (head outB)

{-if both in bound list and out bound list are empty. It would, under the invariant, be enought to check if the out bound list is empty-}
prop_is_empty::(Queue a)->Property
prop_is_empty q@(Queue outB inB) = invariant q ==> isEmptyQueue q == ((length outB + length inB)==0)

{-
    given the invariant for an empty queue the new element should be added as the only element of the out bound list
                        for a non empty queue it should be added as the new head of the in bound list
-}
prop_enqueue::(Eq a)=>(Queue a)->a->Property
prop_enqueue q@(Queue []   [])  elm = invariant q ==> let nq@(Queue a b) = enqueue elm q in invariant nq && a==[elm]
prop_enqueue q@(Queue outB inB) elm = invariant q ==> let nq@(Queue a b) = enqueue elm q in invariant nq && (a==outB) && (b==(elm:inB))

prop_dequeue::(Eq a)=>(Queue a)->Property
prop_dequeue q@(Queue []       []) = False       ==> True {-empty q can't dequeue-}
prop_dequeue q@(Queue [hB]    inB) = invariant q ==> let res = dequeue q in (invariant res) && (res == (Queue (reverse inB) []))
prop_dequeue q@(Queue (hB:tB) inB) = invariant q ==> let res = dequeue q in (invariant res) && (res == (Queue tB           inB))

{-
    Da Überprüfe auch nicht "schreibe tests und schaue was passiert" heißen könnte sonder "untersuche die funktionen und 'sage' was nicht stimmt" hier eine Wändchen an Text

    size ist ok.
    
    smart constructor (queue) Fall 1 sollte (Queue (reverse ys [])) lauten
    smart constructer (queue) Fall 2 ok
    
    isEmptyQueue gegeben der Invarianz rechit hier zu prüfen ob die erste Liste Leer ist nicht aber die zweite
    
    enqueue ist ok
    
    dequeue sollte queue xs ys sein
    
    next ist ok

-}

return []
runTests = $quickCheckAll

