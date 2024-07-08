#
# Makefile -- zweitevariation
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	zweitevariation-handout.pdf MathSem-07-zweitevariation.pdf

include ../slides/Makefile.inc

SOURCES = common.tex slides.tex $(slides)

MathSem-07-zweitevariation.pdf:	MathSem-07-zweitevariation.tex $(SOURCES)
	pdflatex MathSem-07-zweitevariation.tex

zweitevariation-handout.pdf:	zweitevariation-handout.tex $(SOURCES)
	pdflatex zweitevariation-handout.tex

thumbnail:	thumbnail.jpg # fix1.jpg

thumbnail.pdf:	MathSem-07-zweitevariation.pdf
	pdfjam --outfile thumbnail.pdf --papersize '{16cm,9cm}' \
		MathSem-07-zweitevariation.pdf 1
thumbnail.jpg:	thumbnail.pdf
	convert -density 300 thumbnail.pdf \
                -resize 1920x1080 -units PixelsPerInch thumbnail.jpg

fix1.pdf:	MathSem-07-zweitevariation.pdf
	pdfjam --outfile fix1.pdf --papersize '{16cm,9cm}' \
		MathSem-07-zweitevariation.pdf 1
fix1.jpg:	fix1.pdf
	convert -density 300 fix1.pdf \
                -resize 1920x1080 -units PixelsPerInch fix1.jpg

