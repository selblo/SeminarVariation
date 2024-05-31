//
// gerade.pov -- gerades Balkenstück
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "../../../common/common.inc"

#include "common.inc"

box {
	< -xl * xstep, -zl * zstep, -l + s >, < xl * xstep, zl * zstep, l - s >
	pigment {
		color boxfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}

union {
	#declare xi = -xl;
	#while (xi < xl)
		#declare zi = -zl;
		#while (zi < zl)
			box {
				< xstep * xi + s,   zstep * zi + s,   -l >,
				< xstep * xi + d-s, zstep * zi + d-s,  l >
			}
			#declare zi = zi + 1;
		#end
		#declare xi = xi + 1;
	#end
	pigment {
		color federfarbe
	}
	finish {
		metallic
		specular 0.99
	}
}

box {
	< -xl * xstep - 0.05, -0.5 * s, -l - 0.05 >,
	<  xl * xstep + 0.05 , 0.5 * s,  l + 0.05 >
	pigment {
		color biegefarbe
	}
	finish {
		metallic
		specular 0.99
	}
}
