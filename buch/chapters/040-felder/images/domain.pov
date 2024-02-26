//
// domain.pov -- Darstellung des Definitionsbereichs der Koordinatenabbildung
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"
#include "common.inc"

place_camera(<5, 4, 10>, <0, 0.915, 0>, 16/9, 0.24)
lightsource(<40, 50, 10>, 1, White)

arrow(-1.3 * e1, 1.3 * e1, 0.015, rot)
arrow(-0.3 * e2, 2.3 * e2, 0.015, blau)
arrow(-1.3 * e3, 1.3 * e3, 0.015, gruen)

#declare r = 0.01;

#macro Xlinien()
union {
	#declare Z = Zmin;
	#while (Z <= Zmax + Zstep/2)
		#declare Y = Ymin;
		#while (Y <= Ymax + Ystep/2)
			cylinder { < Xmin, Z, Y>, < Xmax, Z, Y>, r }
			#declare Y = Y + Ystep;
		#end
		sphere { < Xmin, Z, Ymin>, r }
		sphere { < Xmin, Z, Ymax>, r }
		sphere { < Xmax, Z, Ymin>, r }
		sphere { < Xmax, Z, Ymax>, r }
		#declare Z = Z + Zstep;
	#end
	pigment {
		color rot
	}
	finish {
		metallic
		specular 0.95
	}
	no_shadow
}
#end

#macro Ylinien()
union {
	#declare Z = Zmin;
	#while (Z <= Zmax + Zstep/2)
		#declare X = Xmin;
		#while (X <= Xmax + Xstep/2)
			cylinder { < X, Z, Ymin>, < X, Z, Ymax>, r }
			#declare X = X + Xstep;
		#end
		sphere { < Xmin, Z, Ymin>, r }
		sphere { < Xmin, Z, Ymax>, r }
		sphere { < Xmax, Z, Ymin>, r }
		sphere { < Xmax, Z, Ymax>, r }
		#declare Z = Z + Zstep;
	#end
	pigment {
		color gruen
	}
	finish {
		metallic
		specular 0.95
	}
	no_shadow
}
#end

#macro Zlinien()
union {
	#declare X = Xmin;
	#while (X <= Xmax + Xstep/2)
		#declare Y = Ymin;
		#while (Y <= Ymax + Ystep/2)
			cylinder { < X, Zmin, Y>, < X, Zmax, Y>, r }
			#declare Y = Y + Ystep;
		#end
		#declare X = X + Xstep;
	#end
	pigment {
		color blau
	}
	finish {
		metallic
		specular 0.95
	}
	no_shadow
}
#end

#macro Rand()
	box { < Xmin, 0, Ymin>, < Xmax, 0.002, Ymax>
		pigment {
			color White
		}
		finish {
			metallic
			specular 0.99
		}
	}
#end

Xlinien()
Ylinien()
Zlinien()

Rand()

box { <Xmin, Zmin, Ymin>, <Xmax, Zmax, Ymax>
	pigment {
		color rgbf<1,1,1,0.8>
	}
	finish {
		metallic
		specular 0.99
	}
}

