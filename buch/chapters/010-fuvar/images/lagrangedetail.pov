//
// lagrangedetail.pov -- -template for 3d images rendered by Povray
//
// (c) 2023 Prof Dr Andreas Müller
//
#include "lagrangemult.inc"

#declare Xmin = 0.4;
#declare Xmax = 0.9;
#declare Ymin = 0.4;
#declare Ymax = 0.9;

#declare fhaareanzahl = 20000;

#declare haardurchmesser = 0.3 * haardurchmesser;

#declare zielpunkt = F(sqrt(2)/2, sqrt(2)/2);

place_camera(<33, 20, 50>, zielpunkt, 16/9, 0.002)
lightsource(<40, 50, 10>, 1, White)

lightsource(<40, 0.6331, 40>, 1, 0.4 * White)

Fflaeche()
Fhaare()
NBkurve()
NBhaare()



