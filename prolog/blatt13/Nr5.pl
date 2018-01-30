#!/usr/bin/prolog
:- use_module(library(clpfd)).
%------BEGIN DER VORGABEN-----
sudoku(Rows) :-

% Alle Zellen dürfen nur die Ziffern 1 bis 9 enthalten. Hierfür nutzen wir
% das Prädikat `append/2`, das erfüllt ist, wenn das erste
% Argumente eine Liste von Listen und das zweite Argument deren
% Konkatenation ist (entspricht `concat` in Haskell)
    append(Rows,Cells)
  , Cells ins 1..9    % SWI-Prolog
  % , domain(Cells,1,9) % Sicstus-Prolog

% Die Zellen jeder Zeile müssen unterschiedlich sein
  , each_distinct(Rows)


% Das Gleiche gilt für die Spalten:
  , trans(Rows,Cols), each_distinct(Cols)


% und für die Quadrate:
  , squaresOf9(Rows,Squares), each_distinct(Squares)

% Zum Schluss das Aufzählen:
  , labeling([],Cells).

writeSudoku([]).
writeSudoku([Z|Zs]) :- write(Z), nl, writeSudoku(Zs).
%------ENDE DER VORGABEN-------

nodup([]).
nodup([E|R]) :- notElem(E,R),nodup(R).

notElem(_,[]).
notElem(E,[H|T]) :- E#\=H,notElem(E,T).

each_distinct([]).
each_distinct([R|Rs]):-nodup(R),each_distinct(Rs).

trans([[E]],[[E]]).
trans([[L|R]],[[L]|RT]):- trans([R],RT).
trans([H|T],HTT) :- trans(T,TT),trans([H],HT),zip(TT,HT,HTT).

zip([],T,T).
zip([L1|T1],[L2|T2],[A12|Z12]) :- append([L1,L2],A12),zip(T1,T2,Z12).

squaresOf9([],[]).
squaresOf9([[],[],[]|R],RS) :- squaresOf9(R,RS).
squaresOf9([[F1,F2,F3|R1],[F4,F5,F6|R2],[F7,F8,F9|R3]|R],[[F1,F2,F3,F4,F5,F6,F7,F8,F9]|RS]) :- squaresOf9([R1,R2,R3|R],RS).

labeling([],Cells).
