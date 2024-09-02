#
# Makefile -- build the book cover
#
# (c) 2018 Prof Dr Andreas Müller, Hochschule Rapperswil
#
all:	buchcover.jpg backcover.jpg front.pdf back.pdf lncover.png

buchcover.pdf:	buchcover.tex helicoid-alpha.png surface-alpha.png
	pdflatex buchcover.tex

buchcover.png:	buchcover2.pdf  Makefile
	convert -density 300 -extract 2054x2900+2630+190 buchcover2.pdf \
		buchcover.png
buchcover.jpg:	buchcover.png
	convert buchcover.png buchcover.jpg
buchcover-small.jpg:	buchcover.jpg
	convert buchcover.jpg -scale 50% buchcover-small.jpg

backcover.png:	buchcover2.pdf Makefile
	convert -density 300 -extract 2054x2900+192+190 buchcover2.pdf \
		backcover.png
backcover.jpg:	backcover.png
	convert backcover.png backcover.jpg

front.pdf:	front.tex buchcover.pdf
	pdflatex front.tex
front.jpg:	front.pdf
	convert -density 150 front.pdf front.jpg

back.pdf:	back.tex buchcover.pdf
	pdflatex back.tex

lncover.pdf:	lncover.tex
	pdflatex lncover.tex
lncover.png:	lncover.pdf Makefile
	convert -density 300 -extract 2007x2834+0+0 lncover.pdf \
		lncover.png

helicoid.png:	helicoid.pov common.inc
	povray +A0.1 -W3840 -H2160 -Ohelicoid.png helicoid.pov
#	povray +A0.1 -W960 -H540 -Ohelicoid.png helicoid.pov
#	povray +A0.1 -W1920 -H1080 -Ohelicoid.png helicoid.pov
#	povray +A0.1 -W480 -H270 -Ohelicoid.png helicoid.pov
helicoid-alpha.png:	helicoid.png Makefile
	convert helicoid.png -alpha on -channel rgba -fill 'rgba(0,0,0,0)' \
		-opaque '#000' helicoid-alpha.png


buchcover2.pdf:	buchcover2.tex
	pdflatex buchcover2.tex

buchcover2.png:	buchcover2.pdf  Makefile
	convert -density 300 -extract 2054x2900+2630+190 buchcover2.pdf \
		buchcover2.png

front2.pdf:	front2.tex buchcover2.pdf
	pdflatex front2.tex
front2.jpg:	front2.pdf
	convert -density 150 front2.pdf front2.jpg

back2.pdf:	back2.tex buchcover2.pdf
	pdflatex back2.tex
back2.jpg:	back2.pdf
	convert -density 150 back2.pdf back2.jpg

mathsem.jpg:	vroh.jpg Makefile
	magick -extract 2000x1600+1300+2400 vroh.jpg -scale 50% mathsem.jpg
