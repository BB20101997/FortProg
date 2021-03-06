#!/usr/bin/ghci
type VarIndex = Int
type FunName = String

data Term = Var VarIndex
          | Comb FunName [Term]
  deriving (Show,Eq)

data Subst = Subst [(VarIndex, Term)]
  deriving Show

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
matchTerm (Comb _ _ ) (Var _) = Nothing
matchTerm (Comb funName terms) (Comb funName2 terms2) | (funName/=funName2) = Nothing --different functions don't match
                                                      | (length terms)/=(length terms2) = Nothing --different argument count doesn't match
                                                      | otherwise =  foldr mergeSubst (Just (Subst [])) (map (uncurry matchTerm) (zip terms terms2)) --matches for this level merge substitutions of all arguments
    where
            hasConflictingDuplicate::[(VarIndex, Term)]->[(VarIndex, Term)]->Bool 
            hasConflictingDuplicate _           []    = False --an empty list can't have a conflict
            hasConflictingDuplicate []          _     = False --as above
            hasConflictingDuplicate (head:tail) list2 = (foldr (\v b -> b||(doSubstConflict head v)) False list2) || hasConflictingDuplicate tail list2
                where 
                    doSubstConflict::(VarIndex,Term)->(VarIndex,Term)->Bool
                    doSubstConflict (v1,_) (v2,_) | v1/=v2 = False
                    doSubstConflict (_,t1) (_,t2)  = t1/=t2
            mergeSubst::(Maybe Subst)->(Maybe Subst)->(Maybe Subst)
            mergeSubst Nothing _ = Nothing --nothing and something merges to nothing as it means a partial term does not have valid substitutions 
            mergeSubst _ Nothing = Nothing --as above
            mergeSubst (Just (Subst list1)) (Just (Subst list2)) | hasConflictingDuplicate list1 list2 = Nothing --we have a substitution for the same VarIndex that is not equivalent  
                                                                 | otherwise = Just (Subst $ list1++list2)

isJust::(Maybe a)->Bool
isJust Nothing = False
isJust _       = True

selectRule :: Program -> Term -> Maybe Term
selectRule rules term = case (filter isJust (map (applyRule term) rules)) of
                            [] -> Nothing
                            (firstMatch:_) -> firstMatch
    where
        applyRule::Term->Rule->Maybe Term 
        applyRule t (Rule pred res) = case (matchTerm pred t) of Nothing -> Nothing
                                                                 Just s  -> Just $ applySubst s res

reduceAt :: Program -> Term -> Pos -> Maybe Term
reduceAt program term pos = case term <|> pos of
                                Nothing -> Nothing
                                Just t1  -> case selectRule program t1 of
                                                Nothing -> Nothing
                                                Just t2 -> replaceAt term pos t2

allPos :: Term -> [Pos]
allPos (Var i) = [[]]
allPos (Comb _ terms) = let
                            subPos = map allPos terms
                            subIndexed = zip [1..] subPos
                            indexPrePos = concatMap (\(p,subt) -> map ((:) p) subt) subIndexed
                        in
                            []:indexPrePos

reducablePos :: Program -> Term -> [Pos]
reducablePos p t = filter (isJust.selectRuleMaybe.(t <|>)) (allPos t)
    where selectRuleMaybe::Maybe Term->Maybe Term
          selectRuleMaybe Nothing  = Nothing
          selectRuleMaybe (Just j) = selectRule p j

isNormalForm :: Program -> Term -> Bool
isNormalForm p t = case reducablePos p t of
                        [] -> True
                        _  -> False

reduceWith :: Program -> Term -> Strategy -> Maybe Term
reduceWith p t _ | isNormalForm p t = Nothing
reduceWith p t s = reduceAt p t (s p t)

evalWith :: Program -> Term -> Strategy -> Term
evalWith p t s = case reduceWith p t s of
                    Just term -> evalWith p term s
                    Nothing   -> t

loStrat::Strategy
loStrat p = head.(reducablePos p)

square::Program
square = [Rule (Comb "sq" [Var 1]) (Comb "*" [Var 1,Var 1]),Rule (Comb "f" [Var 1]) (Comb "1" []),Rule (Comb "h" []) (Comb "h" []),Rule (Comb "==" [Var 1,Var 1]) (Comb "True" []), Rule (Comb "==" [Var 1,Var 2]) (Comb "False" [])]

termSquare::Term
termSquare = (Comb "sq" [Comb "2" []])

termLoTest::Term
termLoTest = (Comb "f" [Comb "h" []])

termTestEq::Term
termTestEq = (Comb "==" [Comb "1" [],Comb "2" []])
