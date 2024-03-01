#
# Makefile -- build images
#
# (c) 2023 Prof Dr Andreas Müller
#
all:	karteextremum.pdf 						\
	schwarz.pdf							\
	fxy.pdf								\
	richtungsabl.pdf						\
	partabl.pdf							\
	nebenbedingung.pdf

karteextremum.pdf: karte.pdf karteextremum.tex
	pdflatex karteextremum.tex

#
# Partielle Ableitungen
#
partabl.png:	partabl.pov
	povray +A0.1 -W1920 -H1080 -Opartabl.png partabl.pov
partabl.jpg:	partabl.png Makefile
	convert partabl.png partabl.jpg
partabl.pdf:	partabl.tex partabl.jpg
	pdflatex partabl.tex

#
# Gegenbeispiel von Schwarz
#
schwarzimages = schwarz.jpg schwarzx.jpg schwarzy.jpg schwarzxy.jpg
ausschnitt = -extract 1730x1000+95+50

schwarz.png:	schwarz.pov schwarz.inc
	povray +A0.1 -W1920 -H1080 -Oschwarz.png schwarz.pov
schwarz.jpg:	schwarz.png Makefile
	convert $(ausschnitt) schwarz.png schwarz.jpg

schwarzx.png:	schwarzx.pov schwarz.inc
	povray +A0.1 -W1920 -H1080 -Oschwarzx.png schwarzx.pov
schwarzx.jpg:	schwarzx.png Makefile
	convert $(ausschnitt) schwarzx.png schwarzx.jpg

schwarzy.png:	schwarzy.pov schwarz.inc
	povray +A0.1 -W1920 -H1080 -Oschwarzy.png schwarzy.pov
schwarzy.jpg:	schwarzy.png Makefile
	convert $(ausschnitt) schwarzy.png schwarzy.jpg

schwarzxy.png:	schwarzxy.pov schwarz.inc
	povray +A0.1 -W1920 -H1080 -Oschwarzxy.png schwarzxy.pov
schwarzxy.jpg:	schwarzxy.png Makefile
	convert $(ausschnitt) schwarzxy.png schwarzxy.jpg

schwarz.pdf:	$(schwarzimages) schwarz.tex
	pdflatex schwarz.tex

#
# Partielle Ableitungen und Richtungsableitung
#
richtungsablausschnitt = -extract 1480x1080+220+0
richtungsablfiles = richtungsabl.inc richtungsabl.params richtungsabl.common

fx.png:	fx.pov $(richtungsablfiles)
	povray +A0.1 -W1920 -H1080 -Ofx.png fx.pov
fx.jpg:	fx.png Makefile
	convert $(richtungsablausschnitt) fx.png fx.jpg

fy.png:	fy.pov $(richtungsablefiles)
	povray +A0.1 -W1920 -H1080 -Ofy.png fy.pov
fy.jpg:	fy.png Makefile
	convert $(richtungsablausschnitt) fy.png fy.jpg

fxy.pdf:	fxy.tex fx.jpg fy.jpg
	pdflatex fxy.tex

richtungsabl.png:	richtungsabl.pov $(richtungsablfiles)
	povray +A0.1 -W1920 -H1080 -Orichtungsabl.png richtungsabl.pov
richtungsabl.jpg:	richtungsabl.png
	convert $(richtungsablausschnitt) richtungsabl.png richtungsabl.jpg
richtungsabl.pdf:	richtungsabl.tex richtungsabl.jpg
	pdflatex richtungsabl.tex

#
# Nebenbedingung für eine Funktion von 2 Variablen
#
nebenbedingung.pdf:	nebenbedingung.tex
	pdflatex nebenbedingung.tex

#
# Lagrange multiplier illustration
#
lagrangemult.png:	lagrangemult.pov lagrangemult.inc
	povray +A0.1 -W1920 -H1080 -Olagrangemult.png lagrangemult.pov
lagrangedetail.png:	lagrangedetail.pov lagrangemult.inc
	povray +A0.1 -W1920 -H1080 -Olagrangedetail.png lagrangedetail.pov
