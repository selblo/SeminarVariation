//
// jacobi.inc -- auxiliary functions for jacobi images
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<-43, 20, 40>, <0, 0, 0>, 16/9, 0.033)
lightsource(<-80, 70, 10>, 1, White)

/*
arrow(-e1, e1, 0.01, White)
arrow(-e2, e2, 0.01, White)
arrow(-e3, e3, 0.01, White)
*/

#declare kugelfarbe = rgbt<0.8,0.8,0.8,0.5>;
#declare bogenfarbe = rgb<1.0,0.4,0.4>;
#declare kaltefarbe = rgb<0.6,0.8,1.0>;

sphere {
	O, 1
	pigment {
		color kugelfarbe
	}
	finish {
		metallic
		specular 0.8
	}
}

#macro punkt(theta)
	< cos(theta), 0, sin(theta) >
#end

#macro bogen(von, bis, r, farbe)
union {
	sphere { punkt(von), 1.5 * r }
	sphere { punkt(bis), 1.5 * r }
	#declare theta = von;
	#declare thetastep = (bis - von) / 100;
	#while (abs(theta - bis) > (1.1 * thetastep))
		sphere { punkt(theta), r }
		cylinder { punkt(theta), punkt(theta+thetastep), r }
		#declare theta = theta + thetastep;
	#end
	sphere { punkt(theta), r }
	cylinder { punkt(theta), punkt(bis), r }
	pigment {
		color farbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro nachbarbogen(von, bis, r, farbe, winkel)
object {
	bogen(von, bis, r, farbe)
	rotate <winkel, 0, 0>
}
#end

