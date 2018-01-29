:- use_module(library(clpfd)).

limettes(K, M) :-
            K = [99,L], %Preis vom gekauften
			L in 1..2000, % 1 Cent bis 20 Euro (nicht gratis)
			M = [A,E], %werte des Kassenbongs anfang und ende
			A in 1..9, %Da mit Zwanziger bezahlt min 1
            E in 0..9,
			99+16*L#= 1000*A+200+E, % Zuckerrohr und 16 Limetten sind A2,0E
			labeling([],K).
			
			/*
			L = 69, Limetten kosten 69 cent
M = [1, 3] 
Unknown action: , (h for help)
Action? ;
L = 194,   Limetten kosten 1,94 Euro
M = [3, 3] ;
L = 319,   Limetten kosten 3,19 Euro
M = [5, 3] ;
L = 444,    Limetten kosten 4,44 Euro
M = [7, 3] ;
L = 569,    Limetten kosten 5,69 Euro
M = [9, 3].