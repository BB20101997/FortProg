#!/usr/bin/prolog

kandidat(meier).
kandidat(müller).
kandidat(schröder).
kandidat(schulz).

vorstand(Vorsitz, Schriftführer, Kassenwart) :- kandidat(Vorsitz),
						kandidat(Schriftführer),
						kandidat(Kassenwart),
	 					korrektervorstand(Vorsitz, Schriftführer, Kassenwart).

imvorstand(D,D,_,_).
imvorstand(D,_,D,_).
imvorstand(D,_,_,D).

%schulz vorsitzender oder müller nicht im vorstand
mvsv(V,S,K) :- \+ imvorstand(müller,V,S,K).
mvsv(schulz,_,_).

korrektervorstand(V, S, K) :- 	\+ V==S, \+ V==K, \+ S==K, %jeder hat maximal eine Vorstandsposition(dreiköpfig)
				\+ (imvorstand(müller,V,S,K) , imvorstand(meier,V,S,K)), %nicht müller und meier
				\+ (imvorstand(müller,V,S,K) , \+ V==schulz), %müller nur unter vorsitz von schulz
				\+ (imvorstand(schröder,V,S,K) , \+ imvorstand(meier,V,S,K)), %schröder nur mit meier
				\+ (imvorstand(meier,V,S,K) , S==schulz), %nicht meier im vorstand beim schriftführer schulz
				\+ (imvorstand(schulz,V,S,K), V==schröder).%nicht schulz im vorstand beim vorsitzenden schröder
