#!/usr/bin/ghci
spaceLength::Char->Int->String
spcaeLength _ i | i<=0 = []
spaceLength c i = [c|i<-[1..i]]

diamondLine::Char->Int->Int->String
diamondLine c length 1 = let
                            padding = spaceLength ' ' (length-1)
                         in 
                            padding++"*"++padding
diamondLine c length i = let 
                            padding = spaceLength ' ' (length-i)
                            filling = spaceLength c ((i-1)*2-1)
                       in padding++"*"++filling++"*"++padding

diamond::Int->IO()
diamond i = putStrLn $ unlines [diamondLine ' ' i y|y<-(take (i*2-1) ([1..i]++[(i-1),(i-2)..1]))]

filledHalfDiamond::Int->IO()
filledHalfDiamond i = putStrLn $ unlines [diamondLine '*' i y|y<-[1..i]]

