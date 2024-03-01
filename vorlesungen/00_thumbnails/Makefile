#
# Makefile -- thumbnails
#
# (c) 2017 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	MathSem-00-thumbnails.pdf

include ../slides/Makefile.inc

SOURCES = common.tex slides.tex $(slides)

MathSem-00-thumbnails.pdf:	MathSem-00-thumbnails.tex $(SOURCES)
	pdflatex MathSem-00-thumbnails.tex

thumbnail:	thumbnail-mathsem.jpg thumbnail-mathstudio.jpg

thumbnail1.pdf:	MathSem-00-thumbnails.pdf
	pdfjam --outfile thumbnail1.pdf --papersize '{16cm,9cm}' \
		MathSem-00-thumbnails.pdf 1
thumbnail-mathsem.jpg:	thumbnail1.pdf
	convert -density 300 thumbnail1.pdf \
                -resize 1920x1080 -units PixelsPerInch thumbnail-mathsem.jpg

thumbnail2.pdf:	MathSem-00-thumbnails.pdf
	pdfjam --outfile thumbnail2.pdf --papersize '{16cm,9cm}' \
		MathSem-00-thumbnails.pdf 2
thumbnail-mathstudio.jpg:	thumbnail2.pdf
	convert -density 300 thumbnail2.pdf \
                -resize 1920x1080 -units PixelsPerInch thumbnail-mathstudio.jpg

