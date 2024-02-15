//
// fy.pov
//
// (c) 2023 Prof Dr Andreas Müller
//
#version 3.7;
#include "richtungsabl.common"
#include "richtungsabl.inc"
#declare a = 0.7;

flaeche(pi / 2, 3 * pi / 2, flaechefarbe)
fgitter(pi / 2, 3 * pi / 2, flaechefarbe)
flaeche(0, pi / 2, flaechefarbetransparent)
fgitter(0, pi / 2, flaechefarbe)
tangente(pi / 2, 0)
kurve(pi / 2, 0.3)
vektor(pi / 2)
