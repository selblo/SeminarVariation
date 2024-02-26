//
// 3dimage.pov -- -template for 3d images rendered by Povray
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"
#include "common.inc"

#declare Xsteps = 30;
#declare Ysteps = 30;

place_camera(<33, 20, 50>, <0, 0, 0>, 16/9, 0.067)
lightsource(<40, 60, 10>, 1, White)
lightsource(<-40, 0, 40>, 1, 0.5 * White)

arrow(-(R + 0.2) * e1, (R + 0.2) * e1, 0.02, White)
arrow(-(R + 0.2) * e2, (R + 0.2) * e2, 0.02, White)
arrow(-(R + 0.2) * e3, (R + 0.2) * e3, 0.02, White)

#declare zh = 0.2;
#declare P = <0, 2 * R, 0>;
#declare r0 = 0.015;

#macro punkt2(X, Y)
	< X, -sqrt(R*R - X*X - Y*Y) - R, Y >
#end

#macro punkt3(X, Y, Z)
	(<0, R, 0> + (1 - zh * Z) * punkt2(X, Y))
#end

#macro Xline(Y, Z)
	#declare H = (Xmax - Xmin) / Xsteps;
	#declare X = Xmin;
	#while (X <= Xmax - H/2)
		sphere { punkt3(X, Y, Z), r0 }
		cylinder { punkt3(X, Y, Z), punkt3(X + H, Y, Z), r0 }
		#declare X = X + H;
	#end
	sphere { punkt3(X, Y, Z), r0 }
#end

#macro Yline(X, Z)
	#declare H = (Ymax - Ymin) / Ysteps;
	#declare Y = Ymin;
	#while (Y <= Ymax - H/2)
		sphere { punkt3(X, Y, Z), r0 }
		cylinder { punkt3(X, Y, Z), punkt3(X, Y + H, Z), r0 }
		#declare Y = Y + H;
	#end
	sphere { punkt3(X, Y, Z), r0 }
#end

#macro Xlines()
union {
	#declare Z = Zmin;
	#while (Z <= Zmax + Zstep/2)
		#declare Y = Ymin;
		#while (Y <= Ymax + Ystep/2)
			Xline(Y, Z)
			#declare Y = Y + Ystep;
		#end
		#declare Z = Z + Zstep;
	#end
	pigment {
		color rot
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro Ylines()
union {
	#declare Z = Zmin;
	#while (Z <= Zmax + Zstep/2)
		#declare X = Xmin;
		#while (X <= Xmax + Xstep/2)
			Yline(X, Z)
			#declare X = X + Ystep;
		#end
		#declare Z = Z + Zstep;
	#end
	pigment {
		color gruen
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro Zlines()
union {
	#declare X = Xmin;
	#while (X < Xmax + Xstep/2)
		#declare Y = Ymin;
		#while (Y < Ymax + Ystep/2)
			cylinder { punkt3(X, Y, Zmin), punkt3(X, Y, Zmax), r0 }
			#declare Y = Y + Ystep;
		#end
		#declare X = X + Xstep;
	#end
	pigment {
		color blau
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro Xarrow()
union {
	cylinder { punkt3(Xmax, 0, 0), punkt3(Xmax + 0.1, 0, 0), r0 }
	cone { punkt3(Xmax + 0.1, 0, 0), 2 * r0, punkt3(Xmax + 0.2, 0, 0), 0 }
	pigment {
		color rot
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro Yarrow()
union {
	cylinder { punkt3(0, Ymax, 0), punkt3(0, Ymax + 0.1, 0), r0 }
	cone { punkt3(0, Ymax + 0.1, 0), 2 * r0, punkt3(0, Ymax + 0.2, 0), 0 }
	pigment {
		color gruen
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro flaeche()
intersection {
	difference {
		sphere { O, 1.001 * R }
		sphere { O, 0.999 * R }
	}
	#declare n = <1, 0, 0>;
	plane { -n, vdot(-n, punkt2(Xmin, Ymin)) }
	plane {  n, vdot( n, punkt2(Xmax, Ymax)) }
	#declare n = <0, 0, 1>;
	plane { -n, vdot(-n, punkt2(Xmin, Ymin)) }
	plane {  n, vdot( n, punkt2(Xmax, Ymax)) }
	plane { <0, 1, 0>, 0 }
	pigment {
		color White
	}
	finish {
		metallic
		specular 0.6
	}
}
#end

union {
	Xlines()
	Ylines()
	Zlines()
	Xarrow()
	Yarrow()
	flaeche()
	rotate <   0,  20, 0 >
	rotate <-100,   0, 0 >
	rotate <   0,  -5, 0 >
}

sphere { < 0, 0, 0>, R 
	pigment {
		color rgbf<1, 1, 1, 0.6>
	}
	finish {
//		metallic
		specular 0.20
	}
}

