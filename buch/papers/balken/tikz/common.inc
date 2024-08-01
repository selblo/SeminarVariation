/*
 * common.inc
 *
 * (c) 2024 Prof Dr Andreas Müller
 */
place_camera(<73, 20, 30>, <0, 0, 0>, 16/9, 0.016)
lightsource(<40, 5, 10>, 1, White)

arrow(-0.65 * e1, 0.65 * e1, 0.01, White)
arrow(-0.65 * e2, 0.65 * e2, 0.01, White)
arrow(-0.3 * e3, 0.3 * e3, 0.01, White)

#declare l = 0.15;
#declare s = 0.008;
#declare d = 0.1;
#declare xl = 5;
#declare zl = 5;
#declare xstep = 0.1;
#declare zstep = 0.1;

#declare boxfarbe = rgbf<0.8,0.8,0.8,0.8>;
#declare federfarbe = rgb<0.6,0.8,1.0>;
#declare biegefarbe = rgbf<0.8,0,0,0.9>;

