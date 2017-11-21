{-  1.)

foldr (:) [] = Eine gewöhnliche liste;
foldl (*) 1 = Produkt;
foldr (-) 1 = Abwechselnd + und -;
foldl (-) 1 = 1 minus Summe;

    2.) -}

map2:: (a->b)->[a]->[b]
map2 f l = foldr ((:) . f) [] l


reverse2:: [a]->[a]
reverse2 l = (foldl (\x y-> y:x) [] l)

--  3.)

unzip2::[(a, b)]->([a], [b])
unzip2 l = foldr (\(a,b) (ar,br) -> ((a:ar),(b:br))) ([],[]) l

nub2:: [Int]->[Int]
nub2 l = foldr (\x y-> x:  nub2 (filter (/= x) y)) [] l