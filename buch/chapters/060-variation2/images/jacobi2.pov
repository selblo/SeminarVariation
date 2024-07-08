//
// jacobi2.pov -- jacobi images
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "jacobi.inc"

bogen(0, radians(200), 0.015, kaltefarbe)
bogen(radians(200), radians(360), 0.020, bogenfarbe)

nachbarbogen(0, radians(200), 0.015, kaltefarbe, -20)

sphere {
	punkt(radians(180)), 0.02
	pigment {
		color kaltefarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
