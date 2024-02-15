//
// richtungsabl.pov
//
// (c) 2023 Prof Dr Andreas Müller
//
#version 3.7;
#include "richtungsabl.common"
#include "richtungsabl.inc"

#declare a = 0.7;

flaeche(pi/3, 4*pi/3, flaechefarbe)
flaeche(4*pi/3, 6 * pi / 3, flaechefarbetransparent)

fgitter(0, 2 * pi, flaechefarbe)
tangente(pi / 3,0)
kurve(pi/3, 0)
vektor(pi/3)
