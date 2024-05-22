//
// krumm.pov -- gekrümmtes Balkenstück
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

#include "common.inc"

#declare R = 2;
#declare winkel = l / R;
#declare normalerechts = < 0, sin(winkel),  cos(winkel) >;
#declare normalelinks  = < 0, sin(winkel), -cos(winkel) >;

#macro huelle(delta)
intersection {
	plane { normalerechts, vdot(<0, R, 0>,  normalerechts) - delta }
	plane { normalelinks,  vdot(<0, R, 0>,  normalelinks) - delta }
	difference {
		cylinder {
			< -xl * xstep, R, 0 >,
			<  xl * xstep, R, 0 >,
			R + zl * zstep
		}
		cylinder {
			< -xl * xstep - 1, R, 0 >,
			<  xl * xstep + 1, R, 0 >,
			R - zl * zstep
		}
	}
	pigment {
		color boxfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro feder(xi, zi)
difference {
	cylinder {
		<  xi    * xstep + s, R, 0 >,
		< (xi+1) * xstep - s, R, 0 >,
		R + (-zi    ) * zstep - s
	}
	cylinder {
		<  xi    * xstep, R, 0 >,
		< (xl+1) * xstep, R, 0 >,
		R + (-zi - 1) * zstep + s
	}
}
#end

#macro federn()
intersection {
	plane { normalerechts, vdot(<0, R, 0>,  normalerechts) }
	plane { normalelinks,  vdot(<0, R, 0>,  normalelinks)  }
	union {
		#declare xi = -xl;
		#while (xi < xl)
			#declare zi = -zl;
			#while (zi < zl)
				feder(xi, zi)
				#declare zi = zi + 1;
			#end
			#declare xi = xi + 1;
		#end
	}
	pigment {
		color federfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

#macro biege()
intersection {
	plane { normalerechts, vdot(<0, R, 0>,  normalerechts) + 0.05 }
	plane { normalelinks,  vdot(<0, R, 0>,  normalelinks) + 0.05 }
	difference {
		cylinder {
			< -xl * xstep - 0.05, R, 0 >,
			<  xl * xstep + 0.05, R, 0 >,
			R + 0.5 * s
		}
		cylinder {
			< -xl * xstep - 1, R, 0 >,
			<  xl * xstep + 1, R, 0 >,
			R - 0.5 * s
		}
	}
	pigment {
		color biegefarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
#end

federn()
huelle(s)
biege()
