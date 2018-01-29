nodup([]).
nodup([_]).
nodup([E|R]) :- \+ member(E,R),nodup(R).

neq(X,X):-!,fail.
neq(X,Y).

%delete aus 2.2.2
remove(_,[],[]).
remove(X,[X|Xs],Ys) :- remove(X,Xs,Ys).
remove(X,[Y|Xs],[Y|Ys]) :- X\=Y,remove(X,Xs,Ys).

%TODO maybe resolve duplicate results
nub(L,L) :- nodup(L).
nub([E|L],[E|R]) :- remove(E,L,S),nub(S,R).
