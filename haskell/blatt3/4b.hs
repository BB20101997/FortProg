#!/usr/bin/runghc
optExponentiation :: Int -> Int  -> Int
optExponentiation b 0 = 1
optExponentiation b e 
                     | even e = (Main.optExponentiation b (div e 2))^2
                     | otherwise =  b * (Main.optExponentiation b (div e 2))^2

main::IO()
main = do  let b = 4
               e = 5
               res = Main.optExponentiation b e
           putStr "Ergebnis con opExponentiation("
           putStr(show(b))
           putStr " "
           putStr(show(e))
           putStr ") is "
           putStrLn(show(res))
