mobile(fisch(W),G):- W=G.
mobile(bruecke(L,R), s(G) ):- mobile(L,G), mobile(R,G).

/*
?- mobile(bruecke(fisch(s(o)),fisch(s(o))),s(s(o))).
true.
Dies Bedeutet das das Mobile gültig ist.



?-  mobile(Mobile,s(s(s(o)))).
Mobile = fisch(s(s(s(o)))) ;
Mobile = bruecke(fisch(s(s(o))), fisch(s(s(o)))) ;
Mobile = bruecke(fisch(s(s(o))), bruecke(fisch(s(o)), fisch(s(o)))) ;
Mobile = bruecke(fisch(s(s(o))), bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(fisch(s(s(o))), bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o)))) ;
Mobile = bruecke(fisch(s(s(o))), bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), fisch(s(o))), fisch(s(s(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), fisch(s(o))), bruecke(fisch(s(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), fisch(s(o))), bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), fisch(s(o))), bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), fisch(s(o))), bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o))), fisch(s(s(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o))), bruecke(fisch(s(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o))), bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o))), bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o))), bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o))), fisch(s(s(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o))), bruecke(fisch(s(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o))), bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o))), bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o))), bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o))), fisch(s(s(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o))), bruecke(fisch(s(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o))), bruecke(fisch(s(o)), bruecke(fisch(o), fisch(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o))), bruecke(bruecke(fisch(o), fisch(o)), fisch(s(o)))) ;
Mobile = bruecke(bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o))), bruecke(bruecke(fisch(o), fisch(o)), bruecke(fisch(o), fisch(o)))) ;
false.

Jedes Mobile das ein Gewicht von 3 Hat.
