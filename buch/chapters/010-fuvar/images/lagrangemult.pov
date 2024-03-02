//
// lagrangemult.pov -- -template for 3d images rendered by Povray
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "lagrangemult.inc"

#declare zielpunkt = <0, 0.35, 0>;

place_camera(<33, 20, 50>, zielpunkt, 16/9, 0.03)
lightsource(<40, 50, 10>, 1, White)
lightsource(<10, -5, 40>, 1, 0.5 * White)
lightsource(<40, 1, 40>, 1, 0.5 * White)

Fflaeche()
Fhaare()
NBkurve()
NBhaare()


