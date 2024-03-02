//
// lagrangemult.inc -- common stuff for lagrange multiplier illustration
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"
#include "rand.inc"

#declare a = 0.7;

#declare haarlaenge = 0.1;
#declare haardurchmesser = 0.002;

#declare ffarbe = rgb<0.6,0.8,1.0>;
#declare ffarbetransparent = rgbt<0.6,0.8,1.0,0.4>;
#declare gfarbe = rgb<1.0,0.6,0.8>;
#declare fhaarfarbe = rgb<0.2,0.6,1.0>;
#declare ghaarfarbe = rgb<1.0,0.2,0.6>;

#declare fhaareanzahl = 100000;
#declare kurvehaareanzahl = 1000;

#declare g = function(X, Y) { (1-(X*X+Y*Y)) }
#declare gx = function(X, Y) { -2*X }
#declare gy = function(X, Y) { -2*Y }
#macro G(X, Y)
	<X, g(X,Y), Y>
#end
#macro Ggrad(X,Y)
	vnormalize(< gx(X,Y), 0, gy(X,Y) >)
#end
#macro ghaar(X, Y)
	cylinder {
		G(X,Y),
		G(X,Y) - haarlaenge * Ggrad(X,Y),
		haardurchmesser
	}
#end

#declare f = function(X, Y) { a * sin(pi*X) * sin(pi*Y) }
#declare fx = function(X, Y) { pi * cos(pi*X) * sin(pi*Y) }
#declare fy = function(X, Y) { pi * sin(pi*X) * cos(pi*Y) }
#macro F(X, Y) 
	<X, f(X,Y), Y>
#end
#macro Fgrad(X, Y)
	vnormalize(< fx(X,Y), 0, fy(X,Y) >)
#end
#macro fhaar(X,Y)
	sphere {
		F(X,Y) - haarlaenge * Fgrad(X, Y),
		haardurchmesser
	}
	sphere {
		F(X,Y) + haarlaenge * Fgrad(X, Y),
		haardurchmesser
	}
	cylinder {
		F(X,Y) + haarlaenge * Fgrad(X, Y),
		F(X,Y) - haarlaenge * Fgrad(X, Y),
		haardurchmesser
	}
#end

#declare Xmin = -1.1;
#declare Xmax = 1.1;
#declare Xsteps = 100;
#declare Xstep = (Xmax - Xmin) / Xsteps;
#declare Ymin = -1.1;
#declare Ymax = 1.1;
#declare Ysteps = 100;
#declare Ystep = (Ymax - Ymin) / Ysteps;

arrow(-1.3*e1, 1.3*e1, 0.01, White)
arrow(-1.3*e2, 0.9*e2, 0.01, White)
arrow(-1.3*e3, 1.3*e3, 0.01, White)

#macro Gflaeche()
mesh {
	#declare Xstep = (Xmax - Xmin) / Xsteps;
	#declare Ystep = (Ymax - Ymin) / Ysteps;
	#declare X = Xmin;
	#while (X < Xmax - Xstep/2)
		#declare Y = Ymin;
		#while (Y < Ymax - Ystep/2)
			triangle {
				G(X,         Y),
				G(X + Xstep, Y),
				G(X + Xstep, Y + Ystep)
			}
			triangle {
				G(X,         Y),
				G(X + Xstep, Y + Ystep),
				G(X,         Y + Ystep)
			}
			#declare Y = Y + Ystep;
		#end
		#declare X = X + Xstep;
	#end
	pigment {
		color gfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro Ghaare()
union {
	#declare counter = 0;
	#while (counter <= 100000)
		#declare X = RRand(Xmin, Xmax, RdmA);
		#declare Y = RRand(Ymin, Ymax, RdmA);
		ghaar(X, Y)
		#declare counter = counter + 1;
	#end
	pigment {
		color ghaarfarbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

#macro Fflaeche()
mesh {
	#declare Xstep = (Xmax - Xmin) / Xsteps;
	#declare Ystep = (Ymax - Ymin) / Ysteps;
	#declare X = Xmin;
	#while (X < Xmax - Xstep/2)
		#declare Y = Ymin;
		#while (Y < Ymax - Ystep/2)
			triangle {
				F(X,         Y),
				F(X + Xstep, Y),
				F(X + Xstep, Y + Ystep)
			}
			triangle {
				F(X,         Y),
				F(X + Xstep, Y + Ystep),
				F(X,         Y + Ystep)
			}
			#declare Y = Y + Ystep;
		#end
		#declare X = X + Xstep;
	#end
	pigment {
		color ffarbe
	}
	finish {
		metallic
		specular 0.90
	}
}
#end

#macro Fhaare()
union {
	#declare counter = 0;
	#while (counter <= fhaareanzahl)
		#declare X = RRand(Xmin, Xmax, RdmA);
		#declare Y = RRand(Ymin, Ymax, RdmA);
		fhaar(X, Y)
		#declare counter = counter + 1;
	#end
	pigment {
		color fhaarfarbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

#macro NBkurve()
#declare phisteps = 360;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
union {
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		sphere { F(cos(phi), sin(phi)), 0.01 }
		cylinder {
			F(cos(phi), sin(phi)),
			F(cos(phi + phistep), sin(phi + phistep)),
			0.01
		}
		#declare phi = phi + phistep;
	#end
	pigment {
		color Red
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro NBhaare()
#declare phisteps = 1440;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
union {
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		#declare X = cos(phi);
		#declare Y = sin(phi);
		cylinder {
			F(X,Y) + 1.4 * haarlaenge * Ggrad(X,Y),
			F(X,Y) - 1.4 * haarlaenge * Ggrad(X,Y),
			1.5 * haardurchmesser
		}
		sphere {
			F(X,Y) + 1.4 * haarlaenge * Ggrad(X,Y),
			1.5 * haardurchmesser
		}
		sphere {
			F(X,Y) - 1.4 * haarlaenge * Ggrad(X,Y),
			1.5 * haardurchmesser
		}
		#declare phi = phi + phistep;
	#end
/*
	#declare counter = 0;
	#while (counter < kurvehaareanzahl)
		#declare phi = RRand(0, 2 * pi, RdmA);
		#declare X = cos(phi);
		#declare Y = sin(phi);
		cylinder {
			F(X,Y) + 1.4 * haarlaenge * Ggrad(X,Y),
			F(X,Y) - 1.4 * haarlaenge * Ggrad(X,Y),
			1.5 * haardurchmesser
		}
		#declare counter = counter + 1;
	#end
*/
	pigment {
		color ghaarfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro FflaecheZylinder()
#declare phisteps = 720;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
#declare rmin = 0;
#declare rmax = 1;
#declare rsteps = 90;
#declare rstep = (rmax - rmin) / rsteps;
mesh {
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		#declare r = rstep;
		triangle {
			F(0, 0),
			F(r * cos(phi), r * sin(phi)),
			F(r * cos(phi + phistep), r * sin(phi + phistep))
		}
		#while (r < rmax - rstep/2)
			triangle {
				F(r * cos(phi), r * sin(phi)),
				F(r * cos(phi + phistep), r * sin(phi + phistep)),
				F((r + rstep) * cos(phi + phistep), (r + rstep) * sin(phi + phistep))
			}
			triangle {
				F(r * cos(phi), r * sin(phi)),
				F((r + rstep) * cos(phi + phistep), (r + rstep) * sin(phi + phistep)),
				F((r + rstep) * cos(phi), (r + rstep) * sin(phi))
			}
			#declare r = r + rstep;
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color ffarbe
	}
	finish {
		metallic
		specular 0.80
	}
}
#end

#macro FflaecheRing(rmax)
#declare phisteps = 720;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
#declare rmin = 1;
//#declare rmax = 2;
#declare rsteps = 60;
#declare rstep = (rmax - rmin) / rsteps;
mesh {
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		#declare r = rmin;
		#while (r < rmax - rstep/2)
			triangle {
				F(r * cos(phi), r * sin(phi)),
				F(r * cos(phi + phistep), r * sin(phi + phistep)),
				F((r + rstep) * cos(phi + phistep), (r + rstep) * sin(phi + phistep))
			}
			triangle {
				F(r * cos(phi), r * sin(phi)),
				F((r + rstep) * cos(phi + phistep), (r + rstep) * sin(phi + phistep)),
				F((r + rstep) * cos(phi), (r + rstep) * sin(phi))
			}
			#declare r = r + rstep;
		#end
		#declare phi = phi + phistep;
	#end
	pigment {
		color ffarbetransparent
	}
	finish {
		metallic
		specular 0.80
	}
}
#end

#macro FzylinderHaare(anzahl)
union {
	#declare counter = 0;
	#while (counter < anzahl)
		#declare phi = RRand(0, 2 * pi, RdmA);
		#declare r = sqrt(RRand(0, 1, RdmA));
		#declare X = r * cos(phi);
		#declare Y = r * sin(phi);
		cylinder {
			F(X, Y) + haarlaenge * Fgrad(X, Y),
			F(X, Y) - haarlaenge * Fgrad(X, Y),
			haardurchmesser
		}
		sphere {
			F(X, Y) + haarlaenge * Fgrad(X, Y),
			haardurchmesser
		}
		sphere {
			F(X, Y) - haarlaenge * Fgrad(X, Y),
			haardurchmesser
		}
		#declare counter = counter + 1;
	#end
	pigment {
		color ffarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro NBzylinder()
#declare phisteps = 720;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
mesh {
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		triangle {
			< cos(phi),           -1, sin(phi) >,
			< cos(phi + phistep), -1, sin(phi + phistep) >,
			F(cos(phi + phistep), sin(phi + phistep))
		}
		triangle {
			< cos(phi),           -1, sin(phi) >,
			F(cos(phi + phistep), sin(phi + phistep)),
			F(cos(phi), sin(phi))
		}
		#declare phi = phi + phistep;
	#end
	pigment {
		color gfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro NBzylinderHaare(anzahl) 
union {
	#declare counter = 0;
	#while (counter < anzahl)
		#declare phi = RRand(0, 2 * pi, RdmA);
		#declare h = RRand(-1, 1, RdmA);
		#declare X = cos(phi);
		#declare Y = sin(phi);
		#declare Z = f(X,Y);
		#if (h < Z)
			cylinder {
				< X, h, Y > + 1.0 * haarlaenge * Ggrad(X, Y),
				< X, h, Y > - 1.0 * haarlaenge * Ggrad(X, Y),
				haardurchmesser
			}
			sphere {
				< X, h, Y > + 1.0 * haarlaenge * Ggrad(X, Y),
				haardurchmesser
			}
			sphere {
				< X, h, Y > - 1.0 * haarlaenge * Ggrad(X, Y),
				haardurchmesser
			}
		#end
		#declare counter = counter + 1;
	#end
	pigment {
		color ghaarfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro kurve()
#declare phisteps = 720;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
union {
	#declare phi = 0;
	#while (phi < phimax - phistep/2)
		sphere { F(cos(phi), sin(phi)), 0.01 }
		cylinder {
			F(cos(phi), sin(phi)),
			F(cos(phi+phistep), sin(phi+phistep)),
			0.01
		}
		#declare phi = phi + phistep;
	#end
	#declare s = sqrt(2) / 2;
	sphere { F( s,  s), 0.02 }
	sphere { F(-s,  s), 0.02 }
	sphere { F( s, -s), 0.02 }
	sphere { F(-s, -s), 0.02 }
	pigment {
		color Red
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro gitter()
#declare gitterdurchmesser = 0.003;
#declare phisteps = 720;
#declare phimin = 0;
#declare phimax = 2 * pi;
#declare phistep = (phimax - phimin) / phisteps;
union {
	#declare rmin = 0;
	#declare rmax = 1.2;
	#declare rstep = 0.1;
	#declare r = rstep;
	// Kreise
	#while (r < rmax + rstep/2)
		#declare phi = phimin;
		#while (phi < phimax - phistep/2)
			cylinder {
				F(r * cos(phi),           r * sin(phi)),
				F(r * cos(phi + phistep), r * sin(phi + phistep)),
				gitterdurchmesser
			}
			sphere {
				F(cos(phi), sin(phi)),
				gitterdurchmesser
			}
			#declare phi = phi + phistep;
		#end
		#declare r = r + rstep;
	#end
	// Strahlen
	#declare rstep = (rmax - rmin)/70;
	#declare phi = phimin;
	#while (phi < phimax - phistep/2)
		#declare r = rmin;
		#while (r < rmax - rstep/2)
			cylinder {
				F(r * cos(phi), r * sin(phi)),
				F((r + rstep) * cos(phi), (r + rstep) * sin(phi)),
				gitterdurchmesser
			}
			#declare r = r + rstep;
			sphere {
				F(r * cos(phi), r * sin(phi)),
				gitterdurchmesser
			}
		#end
		#declare phi = phi + pi/18;
	#end
	pigment {
		color ffarbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end
