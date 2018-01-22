
queens(N,L) :- lengthBoard(N,L), queenOnBoard(N,L), queensDifferently(L), allSafe(L).


queenOnBoard(N,[E|RL]) :-  leq(E,N), queenOnBoard(N,RL).

leq(o , _ ).
leq(s(N), s(M)) :- leq(N,M).

lengthBoard(s(o),[_|[]]).
lengthBoard(s(N), [_|Qs]) :- lengthBoard(N,Qs).

queensDifferently([_|[]]).
queensDifferently([E|RL]) :- \+member(E,RL), queensDifferently(RL).


member(E,[E|_]).
member(E,[_|R]) :- member(E,R).


allSafe([]).
allSafe([Q|Qs]) :- safe(Q,Qs,s(o)), allSafe(Qs).

% P ist der Linienabstand von Q und Q1
safe(_, []     , _).
safe(Q, [Q1|Qs], P) :- differentDiags(Q, Q1, P), safe(Q, Qs, s(P)).

% Unterschiedliche Diagonalen?
differentDiags(Q, Q1, P) :-
  add(Q1, P, Q1PP), Q \= Q1PP, % unterschiedliche Diagonale \
  add(Q , P, QPP ), QPP \= Q1. % unterschiedliche Diagonale /
 
add(o,P,P). 
add(Q,s(P), s(QPP)) :- add(Q, P, QPP).  

  
  