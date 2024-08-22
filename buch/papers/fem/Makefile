#
# Makefile -- make file for the paper fem
#
# (c) 2020 Prof Dr Andreas Mueller
#

images:	images/linearer_ansatz.pdf images/quadratischer_ansatz.pdf images/kubischer_ansatz.pdf

images/linearer_ansatz.pdf: images/linearer_ansatz.tex
	pdflatex --output-directory images images/linearer_ansatz.tex

images/quadratischer_ansatz.pdf: images/quadratischer_ansatz.tex
	pdflatex --output-directory images images/quadratischer_ansatz.tex

images/kubischer_ansatz.pdf: images/kubischer_ansatz.tex
	pdflatex --output-directory images images/kubischer_ansatz.tex

# # PovRay bild
# ausschnitt = -extract 1480x1080+220+0
# target2.png:	target2.pov
# 	povray +A0.1 -W1920 -H1080 -Otarget2.png target2.pov
# target2.jpg:	target2.png Makefile
# 	convert $(ausschnitt) target2.png target2.jpg
# target2.pdf:	target2.tex target2.jpg
# 	pdflatex target2.tex
