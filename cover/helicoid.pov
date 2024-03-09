//
// 3dimage.pov -- -template for 3d images rendered by Povray
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "common.inc"
#include "textures.inc"

place_camera(<13, 0.3, -20>, <0.5, 0, 0>, 16/9, 0.14)
lightsource(<10, 5, -40>, 1, White)

//arrow(-3.2 * e1, 3.2 * e1, 0.01, White)
//arrow(-1.2 * e2, 1.2 * e2, 0.01, White)
//arrow(-1.2 * e3, 1.2 * e3, 0.01, White)

#declare helicoidalpha = -2 * pi;
#declare helicoidrotation = pi / 4;
#declare helicoidcolor = rgb<0.6,0.8,1.0>;
#declare achsfarbe = rgb<1.0,1.0,0.4>;
#declare drahtfarbe = rgb<1.0,0.6,0.2>;

#declare thetamin = -2.5;
#declare thetamax = thetamin + 5.5;
#declare thetasteps = 200;
#declare thetastep = (thetamax - thetamin) / thetasteps;
#declare rhomin = 0;
#declare rhomax = 1;
#declare rhosteps = 20;
#declare rhostep = (rhomax - rhomin) / rhosteps;

#declare use_smooth_triangles = 1;
#declare show_normals = 0;

#declare SoapBubbleTex = texture {
        pigment {
                rgbt < 0.7, 1, 0.7, 0.5>
        }
        finish {
                Shiny
                diffuse 0.2
                irid {
                        3.3 thickness 0.44 turbulence 0.2
                }
                conserve_energy
        }
}

#macro punkt(rho, theta)
	< theta,
		rho * sin(helicoidalpha * theta + helicoidrotation),
		rho * cos(helicoidalpha * theta + helicoidrotation) >
#end
#macro normale(rho, theta)
vnormalize(vcross(
	<1,
	rho * helicoidalpha * cos(helicoidalpha * theta + helicoidrotation),
	-rho * helicoidalpha * sin(helicoidalpha * theta + helicoidrotation)>,
	<0,
	sin(helicoidalpha * theta + helicoidrotation),
	cos(helicoidalpha * theta + helicoidrotation) >
	))
#end

#macro quad(rho, theta, rhostep, thetastep)
#if (use_smooth_triangles > 0)
	smooth_triangle {
		punkt(rho,             theta),
		normale(rho,           theta),
		punkt(rho + rhostep,   theta),
		normale(rho + rhostep, theta),
		punkt(rho + rhostep,   theta + thetastep),
		normale(rho + rhostep, theta + thetastep)
	}
	smooth_triangle {
		punkt(rho,             theta),
		normale(rho,           theta),
		punkt(rho + rhostep,   theta + thetastep),
		normale(rho + rhostep, theta + thetastep),
		punkt(rho,             theta + thetastep),
		normale(rho,           theta + thetastep)
	}
#else
	triangle {
		punkt(rho,           theta),
		punkt(rho + rhostep, theta),
		punkt(rho + rhostep, theta + thetastep)
	}
	triangle {
		punkt(rho,           theta),
		punkt(rho + rhostep, theta + thetastep),
		punkt(rho,           theta + thetastep)
	}
#end
#end

mesh {
	#declare theta = thetamin;
	#while (theta < thetamax - thetastep/2)
		#declare rho = rhomin;
		#while (rho < rhomax - rhostep/2)
			quad(rho, theta, rhostep, thetastep)
			#declare rho = rho + rhostep;
		#end
		#declare theta = theta + thetastep;
	#end
	texture {
		SoapBubbleTex
	}
	finish {
		metallic
		specular 0.95
	}
}

#if (show_normals > 0)
union {
	#declare theta = thetamin;
	#while (theta < thetamax - thetastep/2)
		#declare rho = rhomin;
		#while (rho < rhomax - rhostep/2)
			cylinder {
				punkt(rho, theta) - 0.25 * normale(rho, theta),
				punkt(rho, theta) + 0.25 * normale(rho, theta),
				0.01
			}
			#declare rho = rho + rhostep;
		#end
		#declare theta = theta + thetastep;
	#end
	pigment {
		color rgb<0.8,1.0,0.8>
	}
	finish {
		metallic
		specular 0.95
	}
}
#end

//
// Draht
//
union {
	cylinder { punkt(0, thetamin), punkt(rhomax, thetamin), 0.02 }
	sphere { punkt(0, thetamin), 0.02 }
	cylinder { punkt(0, thetamax), punkt(rhomax, thetamax), 0.02 }
	sphere { punkt(0, thetamax), 0.02 }
	#declare theta = thetamin;
	sphere { punkt(rhomax, theta), 0.02 }
	#while (theta < thetamax - thetastep/6)
		cylinder {
			punkt(rhomax, theta),
			punkt(rhomax, theta + thetastep/3),
			0.02
		}
		#declare theta = theta + thetastep/3;
		sphere {
			punkt(rhomax, theta), 0.02
		}
	#end
	pigment {
		color drahtfarbe
	}
	finish {
		metallic
		specular 0.95
	}
}

//
// Achse
//
cylinder {
	thetamin * e1, thetamax * e1, 0.04
	pigment {
		color achsfarbe
	}
	finish {
		metallic
		specular 0.95
	}
}

//
// Gitter
//
union {
	#declare r = 0.003;
	#declare rhostep = 0.2;
	#declare rho = rhostep;
	#while (rho < rhomax + rhostep/2)
		#declare theta = thetamin;
		sphere { punkt(rho, theta), r }
		#while (theta < thetamax - thetastep/6)
			cylinder {
				punkt(rho, theta),
				punkt(rho, theta + thetastep/3),
				r
			}
			#declare theta = theta + thetastep/3;
			sphere {
				punkt(rho, theta), r
			}
		#end
		#declare rho = rho + rhostep;
	#end
	#declare thetastep = 1/16;
	#declare theta = thetamin;
	#while (theta < thetamax + thetastep/2)
		cylinder { punkt(0, theta), punkt(rhomax, theta), r }
		#declare theta = theta + thetastep;
	#end
	pigment {
		color helicoidcolor
	}
	finish {
		metallic
		specular 0.95
	}
}
