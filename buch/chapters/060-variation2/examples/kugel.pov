//
// 3dimage.pov -- -template for 3d images rendered by Povray
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<33, 20, 50>, <0, 0, 0>, 16/9, 0.0366)
lightsource(<10, 55, 40>, 1, White)

//arrow(-1.2 * e1, 1.2 * e1, 0.01, White)
arrow(-1.2 * e2, 1.2 * e2, 0.01, White)
//arrow(-1.2 * e3, 1.2 * e3, 0.01, White)

#declare pfadfarbe = rgb<1.0,0.2,1.0>;
#declare kugelfarbe = rgb<0.8,0.8,0.8>;
#declare r = 0.012;

#macro kugelpunkt(phi, theta)
	< cos(phi) * sin(theta), cos(theta), sin(phi) * sin(theta) >
#end

#declare r0 = 0.005;

union {
	sphere { <0, 0, 0>, 1 }
	#declare N = 12;
	#declare thetamax = pi;
	#declare thetastep = thetamax / N;
	#declare theta = thetastep;
	#while (theta < thetamax - thetastep/2)
		#declare phi = 0;
		#declare phimax = 2 * pi;
		#declare phistep = phimax / 200;
		#while (phi < phimax - phistep/2)
			sphere { kugelpunkt(phi, theta), r0 }
			cylinder {
				kugelpunkt(phi, theta),
				kugelpunkt(phi+phistep, theta),
				r0
			}
			#declare phi = phi + phistep;
		#end
		#declare theta = theta + thetastep;
	#end
	#declare thetastep = thetamax / 100;
	#declare phi = 0;
	#declare phistep = phimax / (2 * N);
	#while (phi < phimax - phistep/2)
		#declare theta = 0;
		#while (theta < thetamax - thetastep/2)
			sphere { kugelpunkt(phi, theta), r0 }
			cylinder {
				kugelpunkt(phi, theta),
				kugelpunkt(phi, theta+thetastep),
				r0
			}
			#declare theta = theta + thetastep;
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color kugelfarbe
	}
	finish {
		metallic
		specular 0.8
	}
}

#include "kugel.inc"

union {
	sphere { <1, 0, 0>, 2 * r }
	pfada()
	pfadb()
	pfadc()
	pfadd()
	pfade()
	pfadf()
	pfadg()
	pfadh()
	pfadi()
	pigment {
		color pfadfarbe
	}
	finish {
		metallic
		specular 0.99
	}
	rotate <0, -30, 0>
}
