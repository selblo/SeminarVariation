//
// jacobi1.pov -- jacobi images
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "jacobi.inc"

bogen(0, radians(180), 0.02, bogenfarbe)

#declare w = 15;
#declare wstep = 15; 
#while (w < 350)
	nachbarbogen(0, radians(180), 0.015, bogenfarbe, w)
	#declare w = w + wstep;
#end
