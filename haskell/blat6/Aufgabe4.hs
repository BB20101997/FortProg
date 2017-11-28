
--1.1
erstens:: a->b->c
erstens = f . g

--1.2
zweitens:: a->b->c
zweitens=f . (.) . (.) g h

--1.3
drittens:: (a->b)->(b->c)->a->c
drittens = flip (.)

--2.1
flipid:: b->(b->c)->c
flipid = \x f -> f x

--2.2
eule::(b->c)->(a1->a2->b)->a1->a2->c
eule = \f g x y -> f . g x y

--3.
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith f x y = map (uncurry f) (zip x y)
