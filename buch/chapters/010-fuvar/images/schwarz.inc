//
// schwarz.pov -- image for schwarz counterexample
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<-33, 20, 50>, <0, 0, 0>, 16/9, 0.02)
lightsource(<10, 50, 40>, 1)

arrow(-e1, e1, 0.01, White)
arrow(-0.60*e2, 0.60*e2, 0.01, White)
arrow(-e3, e3, 0.01, White)

#declare s = 0.20;
#declare worm = 0.005;
#declare innermost = 0;

#macro f(R,PHI)
	R * R * (pow(cos(PHI),2)-pow(sin(PHI),2)) * sin(PHI) * cos(PHI)
#end
#macro fx(R,PHI)
	R * (pow(cos(PHI),4)*sin(PHI)+4*pow(cos(PHI),2)*pow(sin(PHI),3)-pow(sin(PHI),5))
#end
#macro fy(R,PHI)
	R * (pow(cos(PHI),5)-4*pow(cos(PHI),3)*pow(sin(PHI),2)+pow(cos(PHI),5))
#end
#macro fxy(R,PHI)
	(pow(cos(PHI),6)+9*pow(cos(PHI),4)*pow(sin(PHI),2)-9*pow(cos(PHI),2)*pow(sin(PHI),4)-pow(sin(PHI),6))
#end
#macro fpunkt(R,PHI,s)
	< R * cos(PHI), fxy(R,PHI) * s, R * sin(PHI) >
#end


#declare O = <0, 0, 0>;

#macro flaeche()
mesh {
	#declare rsteps = 60;
	#declare rmin = 0.01;
	#declare rstep = (1 - rmin) / rsteps;
	#declare rmax = 1 - rstep/2;

	#declare phisteps = 400;
	#declare phistep = 2 * pi / phisteps;
	#declare phi = 0;
	#declare phimax = 2 * pi - phistep/2;

	#while (phi < phimax)
		#declare r = rmin;
		#if (innermost > 0)
		triangle {
			O,
			fpunkt(r, phi, s),
			fpunkt(r, phi + phistep, s)
		}
		#end
		#while (r < rmax)
			triangle {
				fpunkt(r,         phi,           s),
				fpunkt(r,         phi + phistep, s),
				fpunkt(r + rstep, phi + phistep, s)
			}
			triangle {
				fpunkt(r,         phi,           s),
				fpunkt(r + rstep, phi + phistep, s),
				fpunkt(r + rstep, phi,           s)
			}
			#declare r = r + rstep;
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color rgb<0.8,0.8,1>
	}
	finish {
		metallic
		specular 0.90
	}
}
#end

#macro gitter()
union {
	#declare phisteps = 16;
	#declare phistep = pi / phisteps;
	#declare rmax = 1;
	#declare rsteps = 20;
	#declare rstep = rmax / rsteps;
	#declare r = 0;
	#while (r < rmax - rstep/2)
		#declare phi = 0;
		#while (phi < 2 * pi - phistep/2)
			#declare phi = phi + phistep;
			cylinder {
				fpunkt(r, phi, s),
				fpunkt(r + rstep, phi, s),
				worm
			}
			sphere { fpunkt(r + rstep, phi, s), worm }
		#end
		#declare r = r + rstep;
	#end

	#declare phisteps = 400;
	#declare phistep = 2 * pi / phisteps;
	#declare rsteps = 5;
	#declare rstep = rmax / rsteps;
	#declare r = rstep;
	#while (r < rmax + rstep/2)
		#declare phi = 0;
		#while (phi < 2 * pi - phistep/2)
			cylinder {
				fpunkt(r, phi,           s),
				fpunkt(r, phi + phistep, s),
				worm
			}
			sphere { fpunkt(r, phi, s), worm }
			#declare phi = phi + phistep;
		#end
		#declare r = r + rstep;
	#end
	pigment {
		color rgb<1,0.8,0.6>
	}
	finish {
		metallic
		specular 0.90
	}
}
#end

#macro roteachsen()
union {
	#declare worm2 = 1.5 * worm;
	sphere { fpunkt(0, 0, s), worm2 }
	sphere { fpunkt(0, pi/2, s), worm2 }
	cylinder { fpunkt(0, 0, s), fpunkt(1, 0, s), worm2 }
	sphere { fpunkt(1, 0, s), worm2 }
	cylinder { fpunkt(0, pi/2, s), fpunkt(1, pi/2, s), worm2 }
	sphere { fpunkt(1, pi/2, s), worm2 }
	cylinder { fpunkt(0, pi, s), fpunkt(1, pi, s), worm2 }
	sphere { fpunkt(1, pi, s), worm2 }
	cylinder { fpunkt(0, 3*pi/2, s), fpunkt(1, 3*pi/2, s), worm2 }
	sphere { fpunkt(1, 3*pi/2, s), worm2 }
	pigment {
		color rgb<0.8,0,0>
	}
	finish {
		metallic
		specular 0.90
	}
}
#end
