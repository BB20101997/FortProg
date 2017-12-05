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

matchTerm :: Term -> Term -> Maybe Subst
matchTerm (Var i) t =  Just (Subst [(i,t)])
matchTerm (Comb funName terms) (Comb funName2 terms2) | (funName==funName2&&(length terms)==(length terms2)) = foldr mergeSubst (Just (Subst [])) (map (uncurry matchTerm) (zip terms terms2))
                                                      | otherwise =  Nothing
    where
            hasDuplicate::[(VarIndex, Term)]->[(VarIndex, Term)]->Bool
            hasDuplicate _ [] = False
            hasDuplicate [] _ = False
            hasDublicate (head:tail) list2 = (foldr (\v b -> b||(isDuplicate head v)) False list2) || hasDuplicate tail list2
                where isDuplicate::(VarIndex,Term)->(VarIndex,Term)->Bool
                      isDuplicate (i,t) (i2,t2) = i==i&&t/=t2
            mergeSubst::(Maybe Subst)->(Maybe Subst)->(Maybe Subst)
            mergeSubst Nothing _ = Nothing
            mergeSubst _ Nothing = Nothing
            mergeSubst (Just (Subst list1)) (Just (Subst list2)) | hasDuplicate list1 list2 = Nothing
                                                                 | otherwise = Just (Subst $ list1++list2)

{-
selectRule :: Program -> Term -> Maybe Term

reduceAt :: Program -> Term -> Pos -> Maybe Term

reducablePos :: Program -> Term -> [Pos]

allPos :: Term -> [Pos]

isNormalForm :: Program -> Term -> Bool

reduceWith :: Program -> Term -> Strategy -> Maybe Term

evalWith :: Program -> Term -> Strategy -> Term
-}

