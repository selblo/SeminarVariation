#
# Makefile
#
# (c) 2024 Prof Dr Andreas Müller
#
all:	dbr.pdf brechung.pdf nichtdiff.pdf hermite.pdf sinspline.pdf

dbr.pdf:	dbr.tex
	pdflatex dbr.tex

brechung.pdf:	brechung.tex
	pdflatex brechung.tex

nichtdiff.pdf:	nichtdiff.tex
	pdflatex nichtdiff.tex

hermite.pdf:	hermite.tex
	pdflatex hermite.tex

sinspline.pdf:	sinspline.tex sinpath.tex
	pdflatex sinspline.tex

sinpath.tex:	sinspline.m
	octave sinspline.m

