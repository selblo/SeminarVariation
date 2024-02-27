//
// 3dimage.pov -- -template for 3d images rendered by Povray
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

#declare C = <5, 3, 4>;

place_camera(<33, 20, 50>, C + <0, 0.44, 0.3>, 16/9, 0.093)
lightsource(<40, 50, 20>, 1, White)
lightsource(<0, -10, 20>, 1, 0.3 * White)

#declare r = 0.05;

arrow(-e1, 8 * e1, r, White)
arrow(-e2, 4.5 * e2, r, White)
arrow(-e3, 5.0 * e3, r, White)

#declare O = <0, 0, 0>;
#declare ax = 4;
#declare ay = 3;
#declare az = 2;
#declare a = <ax, az, ay>;

#macro aequator(T, achse1, achse2)
	(C + vdot(a, achse1) * cos(T) * achse1 + vdot(a, achse2) * sin(T) * achse2)
#end

#macro domain(normalenvektor, achse1, achse2)
	intersection {
		sphere { O, 1 
			scale a
			translate C
		}
		plane { -normalenvektor, vdot(-normalenvektor, C) }
		pigment {
			color rgb<0.8,0.4,0.6>
		}
		finish {
			metallic
			specular 0.95
		}
	}
	intersection {
		sphere { O, 1 
			scale a
			translate C
		}
		plane { normalenvektor, vdot(normalenvektor, C) }
		pigment {
			color rgb<0.4,0.6,0.8>
		}
		finish {
			metallic
			specular 0.95
		}
	}
	#declare phimin = 0;
	#declare phimax = 2 * pi;
	#declare phistep = (phimax - phimin) / 180;
	union {
		#declare phi = phimin;
		#while (phi < phimax - phistep/2)
			sphere {
				aequator(phi, achse1, achse2)
				r
			}
			cylinder {
				aequator(phi, achse1, achse2),
				aequator(phi + phistep, achse1, achse2),
				r
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
