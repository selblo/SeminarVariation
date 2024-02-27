//
// variation.pov -- Variation einer Funktion von zwei Variablen
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<33, 20, 50>, <0, -0.037, 0>, 16/9, 0.0254)
lightsource(<40, 50, 10>, 1, White)
lightsource(<10, 5, 50>, 1, 0.5 * White)

#declare phisteps = 180;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;

#declare C = <0.7,0,1.3>;
#declare c = C + <0, 0.5, 0>;
#declare r0 = 0.01;
#declare flaechefarbe = rgb<1.0,0.6,0.8>;
#declare flaechefarbe = rgb<1.0,0.4,0.8>;
#declare variationfarbe = rgbf<0.6,0.6,1.0,0.4>;
#declare variationfarbe = rgbf<0.6,1.0,1.0,0.6>;
#declare randfarbe = rgb<1.0,0.8,0.0>;

arrow(-0.2*e1, 1.2*e1, r0, White)
arrow(-0.2*e2, 0.8*e2, r0, White)
arrow(-0.2*e3, 2.3*e3, r0, White)

#macro F(R, phi, epsilon)
	c + <R * cos(phi), -0.18*R*R*sin(2*phi) - 0.14*R*cos(phi) -0.28*R*sin(phi) + epsilon*(1-R*R)*(1+0.8*epsilon*R*cos(phi)), R * sin(phi)>
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
			r0
		}
		cylinder {
			C + <cos(phi), 0, sin(phi)>,
			C + <cos(phi+phistep), 0, sin(phi+phistep)>,
			r0
		}
		#declare phi = phi + phistep;
	#end
	pigment {
		color randfarbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

#macro flaeche(phifrom, phito, epsilon, farbe)
mesh {
	#declare rstep = 0.02;
	#declare phi = phifrom;
	#declare phistep = (phito - phifrom) / 180;
	#while (phi < phito - phistep/2)
		triangle {
			F(0, 0, epsilon),
			F(rstep, phi, epsilon),
			F(rstep, phi + phistep, epsilon)
		}
		#declare r = rstep;
		#while (r < 1 - rstep/2)
			triangle {
				F(r,         phi,           epsilon),
				F(r,         phi + phistep, epsilon),
				F(r + rstep, phi + phistep, epsilon)
			}
			triangle {
				F(r,         phi,           epsilon),
				F(r + rstep, phi + phistep, epsilon),
				F(r + rstep, phi,           epsilon)
			}
			#declare r = r + rstep;
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color farbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

#macro Rand(phifrom, phito, farbe)
union {
	#declare phi = phifrom;
	#declare phistep = (phito - phifrom) / 90;
	#while (phi < phito - phistep/2)
		cylinder { F(1, phi, 0), F(1, phi + phistep, 0), r0 }
		#if (phi + phistep < phito)
			sphere { F(1, phi + phistep, 0), r0 }
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color farbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

