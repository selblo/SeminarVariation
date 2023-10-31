#
# Makefile.inc -- Makefile Targets und Variablen für Papers
#
# Achtung: dieses File wird erzeugt vom Skript scripts/mkmakefile
#
# (c) 2020 Prof Dr Andreas Müller, Hochschule Rapperswil
#
PAPERFILES = \
	papers/part2.tex \
	papers/uebersicht.tex \
	papers/beispiel/main.tex \
	
buch1-blx.bbl:	buch1-blx.aux
	bibtex buch1-blx

buch2-blx.bbl:	buch2-blx.aux
	bibtex buch2-blx

BLXFILES = buch.bbl \
	buch1-blx.bbl \
	buch2-blx.bbl \

PAPER_DIRECTORIES = \
	beispiel \
	
PAPER_MAKEFILEINC = \
	papers/beispiel/Makefile.inc \
	
