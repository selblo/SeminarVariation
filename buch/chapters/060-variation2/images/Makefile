#
# Makefile -- build images
#
# (c) 2023 Prof Dr Andreas Müller
#
all:	sin2.pdf legendre.pdf jacobi.pdf xstern.pdf


sin2.pdf:	sin2.tex
	pdflatex sin2.tex

legendre.pdf:	legendre.tex
	pdflatex legendre.tex

jacobi0.png:	jacobi0.pov jacobi.inc
	povray +A0.1 -W1920 -H1080 -Ojacobi0.png jacobi0.pov
jacobi0.jpg:	jacobi0.png Makefile
	convert -extract 1080x1080+420+0 jacobi0.png jacobi0.jpg

jacobi1.png:	jacobi1.pov jacobi.inc
	povray +A0.1 -W1920 -H1080 -Ojacobi1.png jacobi1.pov
jacobi1.jpg:	jacobi1.png Makefile
	convert -extract 1080x1080+420+0 jacobi1.png jacobi1.jpg

jacobi2.png:	jacobi2.pov jacobi.inc
	povray +A0.1 -W1920 -H1080 -Ojacobi2.png jacobi2.pov
jacobi2.jpg:	jacobi2.png Makefile
	convert -extract 1080x1080+420+0 jacobi2.png jacobi2.jpg

jacobi.pdf:	jacobi.tex jacobi0.jpg jacobi1.jpg jacobi2.jpg
	pdflatex jacobi.tex

xstern.pdf:	xstern.tex
	pdflatex xstern.tex
