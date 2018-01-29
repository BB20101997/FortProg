/*1.
delete(_, []    , []    ) .
delete(X, [Y|Xs], Xs    ) :- X = Y.
delete(X, [Y|Xs], [Y|Ys]) :- delete(X, Xs, Ys).


?- delete(1, [1,0+1], Xs).
    %regel 2
    |- {X->1,Y -> 1, Xs -> [0+1]}
?- 1 = 1.
    Xs = [0+1].
?- .
    %regel 2
    |- {X->1,Y->1,Xs->[Y|Ys]}
    ?- delete(1,[0+1],Ys).
        %regel 2
        %das zwite Ys ist nicht das selbe wie das erste sondern das des rekursiven aufrufes
        |- {X->1, Y->0+1,Xs->[],Ys->[Y|Ys]}
        ?- delete(1,[],Ys).
        %regel 1
        |- {Ys->[]}
            ?- .
            Xs = [1,0+1]
*/

/*2.
%nur erstes vorkommen
delete(_,[],[]).
delete(X,[X|Xs],Xs).
delete(X,[Y|Xs],[Y|Ys]) :- X\=Y,delete(X,Xs,Ys).
*/

%alle vorkommen
delete(_,[],[]).
delete(X,[X|Xs],Ys) :- delete(X,Xs,Ys).
delete(X,[Y|Xs],[Y|Ys]) :- X\=Y,delete(X,Xs,Ys).