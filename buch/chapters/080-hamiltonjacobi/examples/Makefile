#
# Makefile
#
# (c) 2024 Prof Dr Andreas Müller
#
all:	eindim.pdf

eindim.pdf:	eindim.tex paths.tex
	pdflatex eindim.tex

paths.tex:	eindim.m
	octave eindim.m
