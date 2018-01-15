mobile(fisch(W),G):- W=G.
mobile(bruecke(L,R), s(G) ):- mobile(L,N), mobile(R,M), N=G,M=G.