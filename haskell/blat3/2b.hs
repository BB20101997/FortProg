#!/usr/bin/runghc
gaussSum :: Int -> Int
gaussSum n = div (n*(n+1)) 2

main::IO()
main = do let x = 5
          print("Ergebnis von gaussSum("++show(x)++") is "++ show(Main.gaussSum(x)))
