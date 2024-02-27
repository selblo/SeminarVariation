//
// flaeche.pov -- Variation einer Funktion von zwei Variablen
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "variation.inc"

domain()

#declare phistart = 0;
#declare phiend = 2 * pi;
flaeche(phistart, phiend, 0.2, flaechefarbe)

Rand(phistart, phiend, randfarbe)
