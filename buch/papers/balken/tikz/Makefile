#
# Makefile -- build drawings
#
# (c) 2024 Prof Dr Andreas Müller
#
all:	balken.pdf							\
	biegelinie.pdf							\
	federgesetz.pdf							\
	einzellast.pdf							\
	drehmoment.pdf							\
	koordinatensystem.pdf

balken.pdf:	balken.tex
	pdflatex balken.tex

biegelinie.pdf:	biegelinie.tex
	pdflatex biegelinie.tex

gerade.png:	gerade.pov common.inc
	povray +A0.1 -W1920 -H1080 -Ogerade.png gerade.pov
gerade.jpg:	gerade.png Makefile
	convert -extract 660x1080+630+0 gerade.png gerade.jpg

krumm.png:	krumm.pov common.inc
	povray +A0.1 -W1920 -H1080 -Okrumm.png krumm.pov
krumm.jpg:	krumm.png Makefile
	convert -extract 660x1080+630+0 krumm.png krumm.jpg

federgesetz.pdf:	federgesetz.tex gerade.jpg krumm.jpg
	pdflatex federgesetz.tex

einzellast.pdf:	einzellast.tex common.tex
	pdflatex einzellast.tex

drehmoment.pdf:	drehmoment.tex common.tex
	pdflatex drehmoment.tex

koordinatensystem.pdf:	koordinatensystem.tex
	pdflatex koordinatensystem.tex

