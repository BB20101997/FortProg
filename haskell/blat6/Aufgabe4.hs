--1.1
{- Wenn f,g nicht global wären
erstens:: (a->c->d)->(b->a)->b->a->d
erstens f g x y = f (g x) y
-}
erstens:: a->b->c
erstens x y = f (g x) y

--1.2
zweitens:: a->b->c
zweitens x y = f (g (h x y)))
--1.3
drittens:: (a->b)->(b-c)->a->c
drittens f g x = g (f x)
