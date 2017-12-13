#!/usr/bin/ghci
printMenu::[String]-> IO()
printMenu = print 1
    where
        print::Int -> [String]->IO()
        print i (x:[]) = putStrLn ((show i)++": "++x)
        print i (x:xs) = do
                            putStrLn (show i++": "++x++",") -- new line after entry looks better than just a space (personal preference)
                            print (i+1) xs

--try getting input till it is a number betrween 1 and to (both inclusive)
select::Int->IO Int
select to = do 
                x <- getLine
                let 
                    y = (reads x)::[(Int,String)]
                    in
                        case y of
                            ((i,_):_) | i>0 && i<=to -> return i
                            _ -> return (-1)

menu::[String] -> IO Int
menu [] =  return (0-1)
menu entryList = do
                    printMenu entryList
                    x <- getLine
                    i <- select (length entryList) 
                    case i of
                        (-1) -> do
                                    putStrLn "Not a vaild Entry!"
                                    menu entryList                                    
                        _  -> return i

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

onSelect::[(String,IO a)]->IO a
onSelect actions = do
                        printMenu [x|(x,_)<-actions]
                        x <- select (length actions)
                        case x of
                            (-1) -> do
                                        putStrLn "Not a valid entry!"
                                        onSelect actions
                            _    -> let
                                        (_,a) =  actions !! (x-1)
                                        in
                                            a

wordCountWithOnSelect::FilePath->IO()
wordCountWithOnSelect file =    onSelect [
                                ("count chars",do
                                                    content <- readFile file
                                                    putStr (show (length content))
                                                    putStrLn " Characters"
                                                    wordCount file
                                ),
                                ("count words",do 
                                                    content <- readFile file
                                                    putStr (show (length (words content)))
                                                    putStrLn " Words"                                               
                                                    wordCount file
                                ),
                                ("count lines",do 
                                                    content <- readFile file
                                                    putStr (show (length (lines content)))
                                                    putStrLn " Lines"
                                                    wordCount file
                                ),
                                ("quit" ,putStrLn "Bye")
                             ]

menuWithOnSelect::[String]->IO Int
menuWithOnSelect entries = onSelect [(x,return a)|(x,a)<- (zip entries [1..])] 
