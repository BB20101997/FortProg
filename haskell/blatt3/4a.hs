#!/usr/bin/runghc
exponentiation :: Int -> Int  -> Int
exponentiation b 0 = 1
exponentiation b e = b * (Main.exponentiation b (e - 1))

main::IO()
main = do  let b = 4
               e = 5
               res = Main.exponentiation b e
           putStr "Ergebnis con exponentiation("
           putStr(show(b))
           putStr " "
           putStr(show(e))
           putStr ") is "
           putStrLn(show(res))
