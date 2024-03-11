#
# Makefile -- felder
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	felder-handout.pdf MathSem-04-felder.pdf

include ../slides/Makefile.inc

SOURCES = common.tex slides.tex $(slides)

MathSem-04-felder.pdf:	MathSem-04-felder.tex $(SOURCES)
	pdflatex MathSem-04-felder.tex

felder-handout.pdf:	felder-handout.tex $(SOURCES)
	pdflatex felder-handout.tex

thumbnail:	thumbnail.jpg # fix1.jpg

thumbnail.pdf:	MathSem-04-felder.pdf
	pdfjam --outfile thumbnail.pdf --papersize '{16cm,9cm}' \
		MathSem-04-felder.pdf 1
thumbnail.jpg:	thumbnail.pdf
	convert -density 300 thumbnail.pdf \
                -resize 1920x1080 -units PixelsPerInch thumbnail.jpg

fix1.pdf:	MathSem-04-felder.pdf
	pdfjam --outfile fix1.pdf --papersize '{16cm,9cm}' \
		MathSem-04-felder.pdf 1
fix1.jpg:	fix1.pdf
	convert -density 300 fix1.pdf \
                -resize 1920x1080 -units PixelsPerInch fix1.jpg

