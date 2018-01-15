mobile(fisch(W),G):- W=G.
mobile(bruecke(L,R), s(G) ):- mobile(L,G), mobile(R,G).