#
# Makefile
#
# (c) 2024 Prof Dr Andreas Müller
#
all:	geodesics.pdf

geodesics.inc:	rotgeo.m
	octave rotgeo.m

geodesics.png:	geodesics.pov geodesics.inc
	povray +A0.1 -W1920 -H1080 -Ogeodesics.png geodesics.pov

geodesics.jpg:	geodesics.png Makefile
	convert -extract 1920x1080+0+0 geodesics.png geodesics.jpg

geodesics.pdf:	geodesics.tex geodesics.jpg
	pdflatex geodesics.tex
