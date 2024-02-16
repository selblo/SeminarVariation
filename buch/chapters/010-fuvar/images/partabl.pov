//
// partabl.pov -- partielle Ableitungen als Steigungen der Koordinatenlinien
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<-15, 20, -50>, <0.46, 0.43, 0.5>, 16/9, 0.0363)
lightsource(<-30, 50, -10>, 1)

arrow(-e1, 2.2 * e1, 0.01, White)
arrow(-e2, 1.7 * e2, 0.01, White)
arrow(-e3, 2.2 * e3, 0.01, White)

#declare Xsteps_default = 0.01;
#declare Ysteps_default = 0.01;

#macro xcomponent(vektor)
	vdot(vektor, <1, 0, 0>)
#end
#macro ycomponent(vektor)
	vdot(vektor, <0, 0, 1>)
#end
#macro zcomponent(vektor)
	vdot(vektor, <0, 1, 0>)
#end

#macro U(X,Y)
	-sin(X * Y) * cos(X + Y)
#end
#macro Ux(X,Y)
	-Y * cos(X * Y) * cos(X + Y) + sin(X * Y) * sin(X + Y)
#end
#macro Uy(X,Y)
	-X * cos(X * Y) * cos(X + Y) + sin(X * Y) * sin(X + Y)
#end
#macro Ugradient(X, Y)
	<Ux(X, Y), 0, Uy(X, Y)>
#end
#macro vUgradient(vektor)
	Ugradient(xcomponent(vektor), ycomponent(vektor))
#end
#macro punkt(X, Y)
	<X, U(X, Y), Y>
#end
#macro steigung(X, Y, Xdot, Ydot)
	punkt(X, Y) + <Xdot, vdot(Ugradient(X, Y), <Xdot, 0, Ydot>), Ydot>
#end
#macro vpunkt(vektor)
	punkt(xcomponent(vektor), ycomponent(vektor))
#end
#macro vsteigung(startpunkt, richtung)
	steigung(xcomponent(startpunkt), ycomponent(startpunkt),
		xcomponent(richtung), ycomponent(richtung))
#end
#macro tangente(startpunkt, richtung, durchmesser)
	cylinder {
		vsteigung(startpunkt,  richtung),
		vsteigung(startpunkt, -richtung),
		durchmesser
	}
#end

#macro flaeche(Xmin, Xmax, Ymin, Ymax, farbe)
	#declare Xsteps = int((Xmax - Xmin) / Xsteps_default) + 1;
	#declare Ysteps = int((Ymax - Ymin) / Ysteps_default) + 1;
	#declare Xstep = (Xmax - Xmin) / Xsteps;
	#declare Ystep = (Ymax - Ymin) / Ysteps;
	mesh {
		#declare X = Xmin;
		#while (X < Xmax - Xstep/2)
			#declare Y = Ymin;
			#while (Y < Ymax - Ystep/2)
				triangle {
					punkt(X,         Y), 
					punkt(X + Xstep, Y), 
					punkt(X + Xstep, Y + Ystep)
				}
				triangle {
					punkt(X,         Y), 
					punkt(X + Xstep, Y + Ystep),
					punkt(X,         Y + Ystep)
				}
				#declare Y = Y + Ystep;
			#end
			#declare X = X + Xstep;
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

#macro linienpunkt(T, startpunkt, richtung)
	vpunkt(startpunkt + T * richtung)
#end

#macro linie(Tmin, Tmax, startpunkt, richtung, farbe, durchmesser)
	#declare Tsteps = int(((Tmax - Tmin) * vlength(richtung)) / vlength(<Xsteps_default, 0, Ysteps_default>)) + 1;
	#declare Tstep = (Tmax - Tmin) / Tsteps;
	#declare T = Tmin;
union {
	#while (T < Tmax - Tstep/2)
		cylinder {
			linienpunkt(T,         startpunkt, richtung),
			linienpunkt(T + Tstep, startpunkt, richtung),
			durchmesser
		}
		sphere { linienpunkt(T, startpunkt, richtung), durchmesser }
		#declare T = T + Tstep;
	#end
	sphere { linienpunkt(T, startpunkt, richtung), durchmesser }
	pigment {
		color farbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

#macro koordinatenlinieX(Xmin, Xmax, Y, farbe, durchmesser)
	linie(0, 1, <Xmin, 0, Y>, <Xmax - Xmin, 0, 0>, farbe, durchmesser)
#end

#macro koordinatenlinieY(X, Ymin, Ymax, farbe, durchmesser)
	linie(0, 1, <X, 0, Ymin>, <0, 0, Ymax - Ymin>, farbe, durchmesser)
#end

#macro gitter(Xmin, Xmax, Xschritt, Ymin, Ymax, Yschritt, farbe, durchmesser)
	#declare X = Xmin;
	#while (X < Xmax + Xschritt/2)
		koordinatenlinieY(X, Ymin, Ymax, farbe, durchmesser)
		#declare X = X + Xschritt;
	#end
	#declare Y = Ymin;
	#while (Y < Ymax + Yschritt/2)
		koordinatenlinieX(Xmin, Xmax, Y, farbe, durchmesser)
		#declare Y = Y + Yschritt;
	#end
#end

#macro tangenten(X, Y, durchmesser, farbe)
union {
	tangente(<X, 0, Y>, <2, 0, 0>, durchmesser)
	tangente(<X, 0, Y>, <0, 0, 2>, durchmesser)
	sphere { punkt(X, Y), 2 * durchmesser }
	pigment {
		color farbe
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

#declare flaechefarbe = rgb<0.4,0.6,0.8>;
#declare flaechefarbetransparent = rgbt<0.4,0.6,0.8,0.7>;
#declare tangentenfarbe = rgb<0.8,0.4,0.8>;

flaeche(0.5, 2, 1, 2, flaechefarbe)
flaeche(-1, 0.5, 1, 2, flaechefarbetransparent)
flaeche(-1, 2, -0.5, 1, flaechefarbetransparent)
gitter(-1, 2, 0.25, -0.5, 2, 0.25, flaechefarbe, 0.005)

koordinatenlinieX(-1, 2, 1, Red, 0.011)
koordinatenlinieY(0.5, -0.5, 2, Red, 0.011)

tangenten(0.5,1,0.01, tangentenfarbe)

