package blatt6;

import java.util.LinkedList;
import java.util.List;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@SuppressWarnings({"unused", "WeakerAccess"})
public class Fold {
    
    public static <T, S> T foldr(BiFunction<S, T, T> funktion, T leer, List<S> alist) {
        if(alist != null && !alist.isEmpty()) {
            S head = alist.get(0);
            alist.remove(0);
            return funktion.apply(head, foldr(funktion, leer, alist));
        }
        return leer;
    }
    
    public static <T, S> T foldl(BiFunction<T, S, T> funktion, T leer, List<S> alist) {
        if(alist != null && !alist.isEmpty()) {
            S head = alist.get(0);
            alist.remove(0);
            return foldl(funktion, funktion.apply(leer, head), alist);
        }
        return leer;
        
    }
    
    /**
     * The following foldl and foldr implementations should be more efficient as they avoid creating Stack Frames for recursion
     * this also reduces the risk of StackOverflows
     * */
    
    public static <T, S> T foldrEfficient(BiFunction<S, T, T> funktion, T leer, List<S> alist) {
        T             retVal = leer;
        LinkedList<S> copy   = new LinkedList<>();
        copy.addAll(alist);
        
        while(!copy.isEmpty()){
            retVal = funktion.apply(copy.pollLast(), retVal);
        }
        
        return retVal;
    }
    
    public static <T, S> T foldlEfficient(BiFunction<T, S, T> funktion, T leer, List<S> alist) {
        T retVal = leer;
        LinkedList<S> copy = new LinkedList<>();
        copy.addAll(alist);
        while(!copy.isEmpty()){
            retVal = funktion.apply(retVal,copy.pollFirst());
        }
        return retVal;
    }
    
    public static void incrementFunctions() {
        
        List<Function<Integer, Integer>> incs = IntStream.rangeClosed(0, 10)
                                                         .mapToObj(i -> (Function<Integer, Integer>) (x -> x + i))
                                                         .collect(Collectors.toList());
        for(Function<Integer, Integer> f : incs){
            System.out.println(f.apply(0));
        }
        
    }
    
}