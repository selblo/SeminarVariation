#
# Makefile -- direkt
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	direkt-handout.pdf MathSem-06-direkt.pdf

include ../slides/Makefile.inc

SOURCES = common.tex slides.tex $(slides)

MathSem-06-direkt.pdf:	MathSem-06-direkt.tex $(SOURCES)
	pdflatex MathSem-06-direkt.tex

direkt-handout.pdf:	direkt-handout.tex $(SOURCES)
	pdflatex direkt-handout.tex

thumbnail:	thumbnail.jpg # fix1.jpg

thumbnail.pdf:	MathSem-06-direkt.pdf
	pdfjam --outfile thumbnail.pdf --papersize '{16cm,9cm}' \
		MathSem-06-direkt.pdf 1
thumbnail.jpg:	thumbnail.pdf
	convert -density 300 thumbnail.pdf \
                -resize 1920x1080 -units PixelsPerInch thumbnail.jpg

fix1.pdf:	MathSem-06-direkt.pdf
	pdfjam --outfile fix1.pdf --papersize '{16cm,9cm}' \
		MathSem-06-direkt.pdf 1
fix1.jpg:	fix1.pdf
	convert -density 300 fix1.pdf \
                -resize 1920x1080 -units PixelsPerInch fix1.jpg

