//
// schwarzx.pov -- image for schwarz counterexample
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "schwarz.inc"

#macro fpunkt(R,PHI,s)
	< R * cos(PHI), fx(R,PHI) * s, R * sin(PHI) >
#end

flaeche()
gitter()
roteachsen()
