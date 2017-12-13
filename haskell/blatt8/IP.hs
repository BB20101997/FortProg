#!/usr/bin/ghci
printMenu::[String]-> IO()
printMenu = print 1
    where
        print::Int -> [String]->IO()
        print i (x:[]) = putStrLn ((show i)++": "++x)
        print i (x:xs) = do
                            putStrLn (show i++": "++x++",") -- new line after entry looks better than just a space (personal preference)
                            print (i+1) xs

menu::[String] -> IO Int
menu [] =  return (0-1)
menu entryList = do
                    printMenu entryList
                    x <- getLine
                    let 
                        y =  (reads x)::[(Int,String)]
                        in
                            case y of
                                ((i,_):_) | i>0&&i<=(length entryList) -> return i
                                _ -> do
                                         putStrLn "Not a Vaild Number!"
                                         menu entryList
                                        

wordCount::FilePath->IO()
wordCount file = do
                    x<-menu ["count chars","count words","count lines","quit"]
                    content <- readFile file
                    case x of
                        1 -> do
                                putStr (show (length content))
                                putStrLn " Characters"
                                wordCount file
                        2 -> do
                                putStr (show (length (words content)))
                                putStrLn " Words"
                                wordCount file
                        3 -> do
                                putStr (show (length (lines content)))
                                putStrLn " Lines"
                                wordCount file
                        _ -> do 
                                putStrLn "Bye"

