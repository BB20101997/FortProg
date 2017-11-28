--1.1
{- Wenn f,g nicht global wären
erstens:: (a->c->d)->(b->c)->b->a->c
erstens f g x y = f (g x) y
-}
erstens:: a->b->c
erstens = f . g

--1.2
zweitens:: a->b->c
zweitens=f . (.) . (.) g h
--1.3
drittens:: (a->b)->(b-c)->a->c
drittens f g = g . f


--2.1
flipid:: b->(b->c)->c
flipid = \x f-> f x
--2.2
eule::(b->c)->(a1->a2-b)->a1->a2->c
eule = \f g x y -> f . g x y

--3.
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipwith f x y = map f (zip x y)