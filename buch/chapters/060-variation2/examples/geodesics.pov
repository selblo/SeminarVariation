//
// geodesics.pov -- geodesics
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<13, 16, 50>, <0, 0, 0>, 16/9, 0.024)
lightsource(<40, 30, -10>, 1, 0.45 * White)
lightsource(<10, 30, 60>, 1, 0.45 * White)
lightsource(<-10, 30, 60>, 1, 0.1 * White)

arrow(-1.17*e1, 1.17*e1, 0.01, White)
arrow(-0.67 * e2, 0.67 * e2, 0.01, White)
arrow(-1.17*e3, 1.17*e3, 0.01, White)

#declare kugelfarbe = rgb<0.8,0.8,0.8>;
#declare extremalfarbe = rgb<0.2,0.6,1.0>;
#declare geofarbe = rgb<1.0,0.4,1.0>;
#declare r = 0.01;

sphere { <0,0,0>, 1
	scale <1, 0.5, 1>
	pigment {
		color kugelfarbe
	}
	finish {
		specular 0.99
		metallic
	}
}

union {
	#declare phi = 0;
	#declare phistep = pi / 200;
	#declare p = < cos(phi), 0, sin(phi) >;
	#while (phi < 2 * pi - phistep/2)
		sphere { p, 0.5 * r }
		#declare phi = phi + phistep;
		#declare pneu = < cos(phi), 0, sin(phi) >;
		cylinder { p, pneu, 0.5 * r }
		#declare p = pneu;
	#end
	pigment {
		color kugelfarbe
	}
	finish {
		specular 0.99
		metallic
	}
}

union {
	sphere { <1,0,0>, 2.0 * r }
	sphere { <0,0,1>, 2.0 * r }
	#declare phi = 0;
	#declare phistep = pi / 200;
	#declare p = < cos(phi), 0, sin(phi) >;
	#while (phi < pi/2 - phistep/2)
		sphere { p, r }
		#declare phi = phi + phistep;
		#declare pneu = < cos(phi), 0, sin(phi) >;
		cylinder { p, pneu, r }
		#declare p = pneu;
	#end
	pigment {
		color extremalfarbe
	}
	finish {
		specular 0.99
		metallic
	}
}

#include "geodesics.inc"


union {
	ziel100(1)
	ziel100(-1)
	ziel110(1)
	ziel110(-1)
	ziel120(1)
	ziel120(-1)
	ziel130(1)
	ziel130(-1)
	ziel140(1)
	ziel140(-1)
	ziel150(1)
	ziel150(-1)
	ziel160(1)
	ziel160(-1)
	ziel170(1)
	ziel170(-1)
	pigment {
		color geofarbe
	}
	finish {
		specular 0.99
		metallic
	}
}

