//
// fx.pov
//
// (c) 2023 Prof Dr Andreas Müller
//
#version 3.7;
#include "richtungsabl.common"
#include "richtungsabl.inc"

#declare a = 0.7;

flaeche(0, pi, flaechefarbe)
fgitter(0, pi, flaechefarbe)
flaeche(pi, 2 * pi, flaechefarbetransparent)
fgitter(pi, 2 * pi, flaechefarbe)
tangente(0, 0)
kurve(0, -0.7)
vektor(0)
