//
// schwarz.pov -- image for schwarz counterexample
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "schwarz.inc"

#declare s = 1;

#macro fpunkt(R,PHI,s)
	< R * cos(PHI), f(R,PHI) * s, R * sin(PHI) >
#end

flaeche()
gitter()

