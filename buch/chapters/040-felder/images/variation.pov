//
// variation.pov -- Variation einer Funktion von zwei Variablen
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<33, 20, 50>, <0, 0, 0>, 16/9, 0.04)
lightsource(<40, 5, 10>, 1, White)

#declare phisteps = 180;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;

#declare C = <1.5,0,1.5>;
#declare c = C + <0, 0.5, 0>;

arrow(-e1, 2.5*e1, 0.01, White)
arrow(-e2,     e2, 0.01, White)
arrow(-e3, 2.5*e3, 0.01, White)

#macro F(R, phi, epsilon)
	<R * cos(phi), R*R*cos(phi)*sin(phi) - 0.2*R*cos(phi) -0.3*R*sin(phi) + epsilon*(1-R)*(1-R), R * sin(phi)>
#end

#macro domain()
cylinder { C - 0.001 * e2, C + 0.001 * e2, 1
	pigment {
		color 0.8*White
	}
	finish {
		metallic
		specular 0.95
	}
}
union {
	#declare phi = 0;
	#while (phi < 2*pi-phistep/2)
		sphere {
			C + <cos(phi), 0, sin(phi)>,
			0.01
		}
		cylinder {
			C + <cos(phi), 0, sin(phi)>,
			C + <cos(phi+phistep), 0, sin(phi+phistep)>,
			0.01
		}
		#declare phi = phi + phistep;
	#end
	pigment {
		color rgb<1.0,0.8,0.0>
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

domain()

