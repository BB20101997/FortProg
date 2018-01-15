#!/usr/bin/prolog
boolean(false).
boolean(true).

and(X,Y,true) :- boolean(X),boolean(Y),X,Y.
and(X,Y,false) :- boolean(X),boolean(Y),\+ (X,Y).

or(X,_,true) :- boolean(X),X.
or(_,X,true) :- boolean(X),X.
or(X,Y,false) :- not(X,true),not(Y,true).

not(X,true) :- boolean(X),\+ X.
not(X,false) :- boolean(X),X.

ex1(X,Y,Z,RES) :- and(X,Y,V),or(V,Z,RES).
ex2(X,Y,Z,RES) :- and(X,Y,V1),and(Y,Z,V2),and(V2,Z,V3),or(V1,V3,RES).
ex3(X,Y,Z,RES) :- not(Y,NY),and(X,NY,V1),and(V1,Z,V2),or(V2,V3,RES),and(Z,Y,V4),or(V4,Z,V3).

/*
Für X=true:

ex1(true,Y,Z,Res).
Y = Res, Res = true ;
Y = Z, Z = Res, Res = true ;
Y = false,
Z = Res, Res = true ;
Y = Z, Z = Res, Res = false ;

ex2(true,Y,Z,Res).
Y = Z, Z = Res, Res = true ;
Y = Z, Z = Res, Res = true ;
Y = Res, Res = true,
Z = false ;
Y = Z, Z = Res, Res = false ;
Y = Res, Res = false,
Z = true ;

ex3(true,Y,Z,Res).
Y = false,
Z = Res, Res = true ;
Y = false,
Z = Res, Res = true ;
Y = Z, Z = Res, Res = false ;
Y = true,
Z = Res, Res = false ;
Y = Z, Z = Res, Res = true ;
Y = Z, Z = Res, Res = true ;

Ergebnis true:

ex1(X,Y,Z,true).
X = Y, Y = true ;
X = Y, Y = Z, Z = true ;
X = Y, Y = false,
Z = true ;
X = false,
Y = Z, Z = true ;
X = Z, Z = true,
Y = false ;

ex2(X,Y,Z,true).
X = Y, Y = Z, Z = true ;
X = Y, Y = Z, Z = true ;
X = Y, Y = true,
Z = false ;
X = false,
Y = Z, Z = true ;

ex3(X,Y,Z,true).
X = Z, Z = true,
Y = false ;
X = Z, Z = true,
Y = false ;
X = Y, Y = false,
Z = true ;
X = false,
Y = Z, Z = true ;
X = false,
Y = Z, Z = true ;
X = Y, Y = Z, Z = true ;
X = Y, Y = Z, Z = true ;

Die dritte Gleichung ist nur von Z abhängig.

*/

