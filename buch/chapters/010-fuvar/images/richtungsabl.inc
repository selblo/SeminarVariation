//
// richtungsabl.inc
//
// (c) 2023 Prof Dr Andreas Müller
//

#macro U(X,Y)
	< X, 0.5 * (-X * X * X - 0.6 * X + (1/a) * Y * Y * Y + Y * Y - 0.6 * Y), Y >
#end

#macro Ux(X, Y)
	0.5 * (-3 * X * X - 0.6)
#end

#macro Uy(X, Y)
	0.5 * (3 * (1/a) * Y * Y + 2 * Y - 0.6)
#end

#macro Ur(phi, r)
	Ux(r * cos(phi), r * sin(phi)) * cos(phi)
	+
	Uy(r * cos(phi), r * sin(phi)) * sin(phi)
#end

#macro Urad(phi,r)
	U(r*cos(phi), r*sin(phi))
#end

#macro Urtangent(phi, r)
	< cos(phi), Ur(phi, r), sin(phi) >
#end

#macro flaeche(phimin, phimax, farbe)
mesh {
	#declare rmin = 0;
	#declare rmax = 1;
	#declare rstep = (rmax - rmin) / N;
	#declare phi = phimin;
	#declare phistep = (phimax - phimin) / (3 * N);
	#while (phi < phimax - phistep/2)
		triangle {
			Urad(0, 0),
			Urad(phi, rstep),
			Urad(phi + phistep, rstep)
		}
		#declare r = rstep;
		#while (r < rmax - rstep/2)
			triangle {
				Urad(phi, r),
				Urad(phi, r + rstep),
				Urad(phi + phistep, r)
			}
			triangle {
				Urad(phi + phistep, r),
				Urad(phi, r + rstep),
				Urad(phi + phistep, r + rstep)
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
		specular 0.9
	}
}
#end

#macro gitterkreis(phimin, phimax, r, farbe)
	#declare phistep = (phimax - phimin) / (3 * N);
	#declare phi = phimin;
	sphere {
		Urad(phi, r),
		gitterr
	}
	#while (phi < phimax - phistep/2)
		cylinder {
			Urad(phi, r),
			Urad(phi + phistep, r),
			gitterr
		}
		sphere {
			Urad(phi + phistep, r),
			gitterr
		}
		#declare phi = phi + phistep;
	#end
#end

#macro gitterradius(phi, farbe)
	#declare rmin = 0;
	#declare rmax = 1;
	#declare rstep = (rmax - rmin) / N;
	#declare r = rmin;
	sphere { Urad(phi, r), gitterr }
	#while (r < rmax - rstep/2)
		cylinder {
			Urad(phi, r),
			Urad(phi, r + rstep),
			gitterr
		}
		sphere { Urad(phi, r + rstep), gitterr }
		#declare r = r + rstep;
	#end
#end

#macro fgitter(phimin, phimax, farbe)
union {
	#declare rmin = 0;
	#declare rmax = 1;
	#declare rstep = (rmax - rmin) / 5;
	#declare phi = phimin;
	#declare phistep = (phimax - phimin) / (3 * N);
	// circles
	#declare r = rstep;
	#while (r < rmax + rstep/2)
		gitterkreis(phimin, phimax, r, farbe)
		#declare r = r + rstep;
	#end
	// radials
	#declare rstep = (rmax - rmin) / N;
	#declare phistep = pi / 6;
	#declare phi = phimax;
	#while (phi > phimin)
		gitterradius(phi, farbe)
		#declare phi = phi - phistep;
	#end
	gitterradius(phimin, farbe)
	pigment {
		color farbe
	}
	finish {
		metallic
		specular 0.9
	}
}
#end

#macro tangente(phi, r)
intersection {
	cylinder {
		<0, 0, -1.2>, <0, 0, 1.2>, 1.2
	}
	cylinder {
		Urad(phi, r) - 2 * Urtangent(phi, r),
		Urad(phi, r) + 2 * Urtangent(phi, r),
		tangenteradius
	}
	pigment {
		color rgb<0.8,0.4,0.8>
	}
	finish {
		metallic
		specular 0.9
	}
}
#end

#macro kurve00(phi, from, to, durchmesser)
	#declare rstep = (to - from) / floor(N * (to - from) / 2 + 1);
	#declare r = from;
	sphere {
		Urad(phi, r),
		durchmesser
	}
	#while (r < to - rstep/2)
		cylinder {
			Urad(phi, r),
			Urad(phi, r + rstep),
			durchmesser
		}
		sphere {
			Urad(phi, r + rstep),
			durchmesser
		}
		#declare r = r + rstep;
	#end
#end

#macro kurve0(phi, from, to, durchmesser)
	#if (from > to)
		kurve00(phi, to, from, durchmesser)
	#else
		kurve00(phi, from, to, durchmesser)
	#end
#end

#macro kurve(phi, T)
union {
	kurve0(phi, -1, 1, 1.4 * gitterr)
	kurve0(phi, 0, T, kurveradius)
	sphere { Urad(phi, T), 1.5 * kurveradius }
	pigment {
		color Red
	}
	finish {
		metallic
		specular 0.9
	}
}
#end

#macro vektor(phi)
arrow(0, <cos(phi), 0, sin(phi)>, vektorradius, vektorfarbe)
#end
