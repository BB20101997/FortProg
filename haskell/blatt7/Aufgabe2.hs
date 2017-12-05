#!/usr/bin/ghci
type VarIndex = Int
type FunName = String

data Term = Var VarIndex
          | Comb FunName [Term]
  deriving (Show,Eq)

data Subst = Subst [(VarIndex, Term)]
  deriving (Show,Eq)

type Pos = [Int]

type Strategy = Program -> Term -> Pos

data Rule = Rule Term Term

type Program = [Rule]

--Ende der Type and Data declerationen

(<|>) :: Term -> Pos -> Maybe Term
t <|> []     = Just t
t <|> (i:is) = case t of
  Comb _ ts | i > 0 && i <= length ts -> (ts !! (i - 1)) <|> is
  _                                   -> Nothing

applySubst :: Subst -> Term -> Term
applySubst (Subst s) (Var v) =
  case lookup v s of
    Nothing -> Var v
    Just r  -> r
applySubst sigma     (Comb f ts) = Comb f (map (applySubst sigma) ts)

replaceAt :: Term -> Pos -> Term -> Maybe Term
replaceAt t           []     s = Just s
replaceAt (Comb f ts) (i:is) s
  | i > 0 && i <= length ts = case replaceAt ti is s of
                                Nothing -> Nothing
                                Just r  -> Just (Comb f (ts1 ++ r : ts2))
  where (ts1, ti:ts2) = splitAt (i - 1) ts
replaceAt _           _      _ = Nothing

--Ende der Vorgaben aus Vorlesung

doSubstConflict::(VarIndex,Term)->(VarIndex,Term)->Bool
doSubstConflict (v1,_) (v2,_) | v1/=v2 = False
doSubstConflict (_,t1) (_,t2)  = t1/=t2

--Implementing Library functions is fun
nub::(Eq a)=>[a]->[a]
nub (h:t) = h:nub (filter (\e->e/=h)  t)
nub [] = []

matchTerm :: Term -> Term -> Maybe Subst
matchTerm (Var i) t =  Just (Subst [(i,t)])
matchTerm (Comb funName terms) (Comb funName2 terms2) | (funName/=funName2) = Nothing --different functions don't match
                                                      | (length terms)/=(length terms2) = Nothing --different argument count doesn't match
                                                      | otherwise =  foldr mergeSubst (Just (Subst [])) (map (uncurry matchTerm) (zip terms terms2)) --matchis for this level merge substitutions of all arguments
    where
            hasConflictingDuplicate::[(VarIndex, Term)]->[(VarIndex, Term)]->Bool 
            hasConflictingDuplicate _           []    = False --an empty list can't have a conflict
            hasConflictingDuplicate []          _     = False --as above
            hasConflictingDuplicate (head:tail) list2 = (foldr (\v b -> b||(doSubstConflict head v)) False list2) || hasConflictingDuplicate tail list2
            
            mergeSubst::(Maybe Subst)->(Maybe Subst)->(Maybe Subst)
            mergeSubst Nothing _ = Nothing --nothing and something merges to nothing as it means a partial term does not have valid substitutions 
            mergeSubst _ Nothing = Nothing --as above
            mergeSubst (Just (Subst list1)) (Just (Subst list2)) | hasConflictingDuplicate list1 list2 = Nothing --we have a substitution for the save VarIndex that is not equivalent  
                                                                 | otherwise = Just (Subst (nub  $ list1++list2)) --remove duplicate identical substitutions

isJust::(Maybe a)->Bool
isJust Nothing = False
isJust _       = True

foldMaybe::[a]->Maybe a->[a]
foldMaybe list  Nothing  = list
foldMaybe list (Just m)  = m:list

applyRule::Term->Rule->Maybe Term 
applyRule t (Rule pred res) = case (matchTerm pred t) of Nothing -> Nothing
                                                         Just s  -> Just $ applySubst s res

selectRule :: Program -> Term -> Maybe Term
selectRule rules term = (foldl foldMaybe (map (applyRule term) rules) []) !! 0

{-
reduceAt :: Program -> Term -> Pos -> Maybe Term

reducablePos :: Program -> Term -> [Pos]

allPos :: Term -> [Pos]

isNormalForm :: Program -> Term -> Bool

reduceWith :: Program -> Term -> Strategy -> Maybe Term

evalWith :: Program -> Term -> Strategy -> Term
-}

