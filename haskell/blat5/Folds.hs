{-  1.)

foldr (:) [] = Eine gewöhnliche liste;
foldl (*) 1 = Produkt;
foldr (-) 1 = Abwechselnd + und -;
foldl (-) 1 = 1 minus Summe;

    2.)

foldr da eine foldl implementation die Reihenfolge der Elemente ändern würde oder ein ineffizientes (++) nutzen müsste,
außerdem wird lazy ausgewertet d.h. map ist auch für endlose listen ist möglich
-}
map2:: (a->b)->[a]->[b]
map2 f l = foldr ((:) . f) [] l


{-
hier lässt sich die Akkumulator eigenschaft von foldl gut nutzen für eine foldr imlementierung müsste (++) genutzt werden und wäre inefizient
-}
reverse2:: [a]->[a]
reverse2 l = (foldl (\x y-> y:x) [] l)

--  3.)

--foldr since unzip is a map from one list to two lists
unzip2::[(a, b)]->([a], [b])
unzip2 l = foldr (\(a,b) (ar,br) -> ((a:ar),(b:br))) ([],[]) l

--foldr da hier eine lazy auswertung gut funktionier und die Reihenfolge der ersten erscheinungen der Elemente erhält
nub2:: [Int]->[Int]
nub2 l = foldr (\x y-> x:  nub2 (filter (/= x) y)) [] l