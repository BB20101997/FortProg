#!/usr/bin/ghci
allCombinations::[a]->[[a]]
allCombinations list = []:(higherOrder [[]] list)
    where higherOrder::[[a]]->[a]->[[a]]
          higherOrder lista listb = let
                                       listc = (concatMap (\b -> map (\a->a++[b] ) lista) listb)
                                    in
                                        listc++(higherOrder listc listb)
