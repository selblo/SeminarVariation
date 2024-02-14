#
# Makefile -- build images
#
# (c) 2023 Prof Dr Andreas Müller
#
all:	karteextremum.pdf schwarz.pdf

karteextremum.pdf: karte.pdf karteextremum.tex
	pdflatex karteextremum.tex

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
