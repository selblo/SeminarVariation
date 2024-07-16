//
// tangential.pov -- tangentialebene und lineare ersatzfunktion
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

place_camera(<13, 20, -50>, <0, 0.36, 0>, 16/9, 0.022)
lightsource(<-10, 50, -40>, 1, White)

arrow(-1.1*e1, 1.1*e1, 0.01, White)
arrow(-0.5*e2, 1.0*e2, 0.01, White)
arrow(-1.1*e3, 1.1*e3, 0.01, White)

#declare ax = 0.2;
#declare ay = 0.3;
#declare bx = -0.2;
#declare by = 0.2;
#declare o = 0.3;
#declare sigma2 = 1;

#declare Xt = 0;
#declare Yt = 0;

#declare e = function(X, Y) { exp(-(X*X+Y*Y)/sigma2) }
#declare f = function(X, Y) { X * Y * e(X, Y) + ay * Y * Y + ax * X * X + bx * X + by * Y + o }

/*
(%i3) Fx:diff(F,X)
                                 2    2
                              - Y  - X           2    2
                              ---------       - Y  - X
                        2      sigma2         ---------
                     2 X  Y %e                 sigma2
(%o3)              - ------------------ + Y %e          + ax
                           sigma2
*/
#declare fx = function(X, Y) { (-2 * X * X/sigma2 + 1) * Y * e(X,Y) + 2 * ax * X + bx }


/*
(%i4) Fy:diff(F,Y)
                                 2    2
                              - Y  - X           2    2
                              ---------       - Y  - X
                          2    sigma2         ---------
                     2 X Y  %e                 sigma2
(%o4)              - ------------------ + X %e          + ay
                           sigma2
*/
#declare fy = function(X, Y) { (-2 * Y * Y/sigma2 + 1) * X * e(X, Y) + 2 * ay * Y + by }


#macro F(X, Y)
	<X, f(X, Y), Y>
#end
#macro Xrichtung(X, Y)
	vnormalize(<1, fx(X, Y), 0>)
#end
#macro Yrichtung(X, Y)
	vnormalize(<0, fy(X, Y), 1>)
#end

#macro tangentpoint(X,Y)
	F(Xt,Yt) + < X-Xt, fx(Xt,Yt) * (X-Xt) + fy(Xt, Yt) * (Y-Yt), Y-Yt > 
#end

#declare xmin = -1;
#declare xmax = 1;
#declare xstep = 0.2;
#declare ymin = -1;
#declare ymax = 1;
#declare ystep = 0.2;
#declare N = 100;

#declare gr = 0.005;

#declare gridlinecolor = rgb<0.8,1.0,1.0>;
#declare surfacecolor = rgbf<0.8,1.0,1.0,0.8>;

#declare tangentplanecolor = rgbf<1.0,0.8,0.8,0.5>;
#declare tangentlinecolor = rgb<0.8,0,0>;

#macro gridlines()
union {
	#declare xx = xmin;
	#declare yystep = (ymax - ymin) / N;
	#while (xx < xmax + xstep/2)
		#declare yy = ymin;
		sphere { F(xx, yy), gr }
		#while (yy < ymax - yystep/2)
			cylinder { F(xx, yy), F(xx, yy + yystep), gr }
			#declare yy = yy + yystep;
			sphere { F(xx, yy), gr }
		#end
		#declare xx = xx + xstep;
	#end

	#declare yy = ymin;
	#declare xxstep = (xmax - xmin) / N;
	#while (yy < ymax + ystep/2)
		#declare xx = xmin;
		sphere { F(xx, yy), gr }
		#while (xx < xmax -- xxstep/2)
			cylinder { F(xx, yy), F(xx + xxstep, yy), gr }
			#declare xx = xx + xxstep;
			sphere { F(xx, yy), gr }
		#end
		#declare yy = yy + ystep;
	#end

	pigment {
		color gridlinecolor
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro surface()
union {
	#declare xx = xmin;
	#declare xxstp = (xmax - xmin) / N;
	#declare yystp = (ymax - ymin) / N;
	#while (xx < xmax - xxstep/2)
		#declare yy = ymin;
		#while (yy < ymax - yystep/2)
			triangle {
				F(xx,          yy),
				F(xx + xxstep, yy),
				F(xx + xxstep, yy + yystep)
			}
			triangle {
				F(xx,          yy),
				F(xx + xxstep, yy + yystep),
				F(xx,          yy + yystep)
			}
			#declare yy = yy + yystep;
		#end
		#declare xx = xx + xxstep;
	#end
	pigment {
		color surfacecolor
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro tangentplane()
union {
	triangle {
		tangentpoint(-1,-1), tangentpoint(1,-1), tangentpoint(1,1)
	}
	triangle {
		tangentpoint(-1,-1), tangentpoint(1,1), tangentpoint(-1,1)
	}
	pigment {
		color tangentplanecolor
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro tangents()
union {
	cylinder {
		tangentpoint(xmin, 0),
		tangentpoint(xmax, 0),
		gr
	}
	cylinder {
		tangentpoint(0, ymin),
		tangentpoint(0, ymax),
		gr
	}
	#declare xx = xmin;
	#while (xx < xmax + xstep/2)
		cylinder {
			tangentpoint(xx, ymin),
			tangentpoint(xx, ymax),
			0.5 * gr
		}
		#declare xx = xx + xstep;
	#end
	#declare yy = ymin;
	#while (yy < ymax + ystep/2)
		cylinder {
			tangentpoint(xmin, yy),
			tangentpoint(xmax, yy),
			0.5 * gr
		}
		#declare yy = yy + ystep;
	#end
	pigment {
		color tangentlinecolor
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#declare l = 0.7;

#macro dreiecke()
union {
	// X-Dreieck
	cylinder {
		F(Xt, Yt),
		F(Xt, Yt) + l * <1, 0, 0>,
		0.5 * gr
	}
	cylinder {
		F(Xt, Yt) + l * <1, 0, 0>,
		F(Xt, Yt) + l * <1, fx(Xt, Yt), 0>,
		0.5 * gr
	}
	sphere {
		F(Xt, Yt) + l * <1, 0, 0>,
		0.5 * gr
	}
	triangle {
		F(Xt, Yt),
		F(Xt, Yt) + l * <1, fx(Xt, Yt), 0>,
		F(Xt, Yt) + l * <1, 0, 0>
	}
	triangle {
		F(Xt, Yt),
		F(Xt, Yt) - l * <1, fx(Xt, Yt), 0>,
		F(Xt, Yt) - l * <1, 0, 0>
	}
	// Y-Dreieck
	cylinder {
		F(Xt, Yt),
		F(Xt, Yt) + l * <0, 0, 1>,
		0.5 * gr
	}
	cylinder {
		F(Xt, Yt) + l * <0, 0, 1>,
		F(Xt, Yt) + l * <0, fy(Xt, Yt), 1>,
		0.5 * gr
	}
	sphere {
		F(Xt, Yt) + l * <0, 0, 1>,
		0.5 * gr
	}
	triangle {
		F(Xt, Yt),
		F(Xt, Yt) + l * <0, fy(Xt, Yt), 1>,
		F(Xt, Yt) + l * <0, 0, 1>
	}
	triangle {
		F(Xt, Yt),
		F(Xt, Yt) - l * <0, fy(Xt, Yt), 1>,
		F(Xt, Yt) - l * <0, 0, 1>
	}
	pigment {
		color tangentlinecolor
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

sphere {
	F(Xt, Yt), 2.7 * gr
	pigment {
		color tangentlinecolor
	}
	finish {
		metallic
		specular 0.99
	}
}

gridlines()
surface()
tangentplane()
tangents()
dreiecke()
