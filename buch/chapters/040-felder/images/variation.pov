//
// variation.pov -- Variation einer Funktion von zwei Variablen
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "variation.inc"

domain()

#declare phistart = 0.5*pi;
#declare phiend = phistart + (3/2) * pi;
flaeche(phistart, phiend, 0.2, flaechefarbe)

#declare epsilon0 = -0.4;
#while (epsilon0 < 0.15)
	flaeche(phistart, phiend, epsilon0, variationfarbe)
	#declare epsilon0 = epsilon0 + 0.1;
#end
#declare epsilon0 = 0.3;
#while (epsilon0 < 0.7)
	flaeche(phistart, phiend, epsilon0, variationfarbe)
	#declare epsilon0 = epsilon0 + 0.1;
#end

Rand(phistart, phiend, randfarbe)
