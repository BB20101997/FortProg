#!/usr/bin/runghc
sum :: Int -> Int
sum 0 = 0
sum i = Main.sum(i-1) + i

main::IO()
main = do let x = 5
          print("Ergebnis von sum("++show(x)++") is "++ show(Main.sum(x)))
