


avalanche::Integer->Integer->Integer->Integer
avalanche x y z = 3^x * 5^y * 7^z

isInAvalanche::Integer->Bool 
isInAvalanche 1 = True
isInAvalanche n =  ((mod n 3 == 0)&&(isInAvalanche (div n 3)))||((mod n 5 == 0)&&(isInAvalanche (div n 5)))||((mod n 7 == 0)&&(isInAvalanche (div n 7)))

avalancheList::[Integer]
avalancheList = [x |x<-[1..] ,isInAvalanche x]