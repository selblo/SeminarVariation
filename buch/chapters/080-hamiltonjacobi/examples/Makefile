#
# Makefile
#
# (c) 2024 Prof Dr Andreas Müller
#
all:	eindim.pdf kreis.pdf

eindim.pdf:	eindim.tex paths.tex
	pdflatex eindim.tex

paths.tex:	eindim.m
	octave eindim.m

kreispfad.tex:	kreis.m
	octave kreis.m
kreis.pdf:	kreis.tex kreispfad.tex
	pdflatex kreis.tex

