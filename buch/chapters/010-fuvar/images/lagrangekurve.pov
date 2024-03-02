//
// lagrangekurve.pov -- Nebenbedingung als Zylinder, Kurve
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "lagrangemult.inc"

#declare zielpunkt = <0, 0.05, 0>;

place_camera(<-5, 20, 55>, zielpunkt, 16/9, 0.028)
lightsource(<40, 50, 10>, 1, White)
lightsource(<10, -5, 40>, 1, 0.5 * White)
//lightsource(<40, 1, 40>, 1, 0.5 * White)

FflaecheZylinder()
FflaecheRing(1.20)
//FzylinderHaare(400000)
NBzylinder()
//NBzylinderHaare(300000)
kurve()
gitter()
