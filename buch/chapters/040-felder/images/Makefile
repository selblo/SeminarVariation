#
# Makefile -- build images
#
# (c) 2023 Prof Dr Andreas Müller
#
all:	2drand.pdf							\
	greenbeweis.pdf							\
	offen.pdf

2drand.pdf:	2drand.tex
	pdflatex 2drand.tex

greenbeweis.pdf:	greenbeweis.tex
	pdflatex greenbeweis.tex

offen.pdf:	offen.tex
	pdflatex offen.tex

domain.png:	domain.pov common.inc
	povray +A0.1 -W1920 -H1080 -Odomain.png domain.pov
domain.jpg:	domain.png Makefile
	convert -extract 1080x1080+440+0 domain.png domain.jpg
