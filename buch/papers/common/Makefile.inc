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
	papers/doppelpendel/main.tex \
	papers/kettenlinie/main.tex \
	papers/balken/main.tex \
	papers/relativ/main.tex \
	papers/maxwell/main.tex \
	papers/geodaeten/main.tex \
	papers/minimalflaechen/main.tex \
	papers/leo/main.tex \
	papers/circuit/main.tex \
	papers/antennen/main.tex \
	papers/schwimmen/main.tex \
	papers/planet/main.tex \
	papers/varalg/main.tex \
	papers/cahnhilliard/main.tex \
	papers/luke/main.tex \
	
$(workdir)/buch1-blx.bbl:	$(workdir)/buch1-blx.aux
	cd $(workdir); bibtex buch1-blx

$(workdir)/$(seminar)1-blx.bbl:	$(workdir)/$(seminar)1-blx.aux
	cd $(workdir); bibtex $(seminar)1-blx

$(workdir)/buch2-blx.bbl:	$(workdir)/buch2-blx.aux
	cd $(workdir); bibtex buch2-blx

$(workdir)/$(seminar)2-blx.bbl:	$(workdir)/$(seminar)2-blx.aux
	cd $(workdir); bibtex $(seminar)2-blx

$(workdir)/buch3-blx.bbl:	$(workdir)/buch3-blx.aux
	cd $(workdir); bibtex buch3-blx

$(workdir)/$(seminar)3-blx.bbl:	$(workdir)/$(seminar)3-blx.aux
	cd $(workdir); bibtex $(seminar)3-blx

$(workdir)/buch4-blx.bbl:	$(workdir)/buch4-blx.aux
	cd $(workdir); bibtex buch4-blx

$(workdir)/$(seminar)4-blx.bbl:	$(workdir)/$(seminar)4-blx.aux
	cd $(workdir); bibtex $(seminar)4-blx

$(workdir)/buch5-blx.bbl:	$(workdir)/buch5-blx.aux
	cd $(workdir); bibtex buch5-blx

$(workdir)/$(seminar)5-blx.bbl:	$(workdir)/$(seminar)5-blx.aux
	cd $(workdir); bibtex $(seminar)5-blx

$(workdir)/buch6-blx.bbl:	$(workdir)/buch6-blx.aux
	cd $(workdir); bibtex buch6-blx

$(workdir)/$(seminar)6-blx.bbl:	$(workdir)/$(seminar)6-blx.aux
	cd $(workdir); bibtex $(seminar)6-blx

$(workdir)/buch7-blx.bbl:	$(workdir)/buch7-blx.aux
	cd $(workdir); bibtex buch7-blx

$(workdir)/$(seminar)7-blx.bbl:	$(workdir)/$(seminar)7-blx.aux
	cd $(workdir); bibtex $(seminar)7-blx

$(workdir)/buch8-blx.bbl:	$(workdir)/buch8-blx.aux
	cd $(workdir); bibtex buch8-blx

$(workdir)/$(seminar)8-blx.bbl:	$(workdir)/$(seminar)8-blx.aux
	cd $(workdir); bibtex $(seminar)8-blx

$(workdir)/buch9-blx.bbl:	$(workdir)/buch9-blx.aux
	cd $(workdir); bibtex buch9-blx

$(workdir)/$(seminar)9-blx.bbl:	$(workdir)/$(seminar)9-blx.aux
	cd $(workdir); bibtex $(seminar)9-blx

$(workdir)/buch10-blx.bbl:	$(workdir)/buch10-blx.aux
	cd $(workdir); bibtex buch10-blx

$(workdir)/$(seminar)10-blx.bbl:	$(workdir)/$(seminar)10-blx.aux
	cd $(workdir); bibtex $(seminar)10-blx

$(workdir)/buch11-blx.bbl:	$(workdir)/buch11-blx.aux
	cd $(workdir); bibtex buch11-blx

$(workdir)/$(seminar)11-blx.bbl:	$(workdir)/$(seminar)11-blx.aux
	cd $(workdir); bibtex $(seminar)11-blx

$(workdir)/buch12-blx.bbl:	$(workdir)/buch12-blx.aux
	cd $(workdir); bibtex buch12-blx

$(workdir)/$(seminar)12-blx.bbl:	$(workdir)/$(seminar)12-blx.aux
	cd $(workdir); bibtex $(seminar)12-blx

$(workdir)/buch13-blx.bbl:	$(workdir)/buch13-blx.aux
	cd $(workdir); bibtex buch13-blx

$(workdir)/$(seminar)13-blx.bbl:	$(workdir)/$(seminar)13-blx.aux
	cd $(workdir); bibtex $(seminar)13-blx

$(workdir)/buch14-blx.bbl:	$(workdir)/buch14-blx.aux
	cd $(workdir); bibtex buch14-blx

$(workdir)/$(seminar)14-blx.bbl:	$(workdir)/$(seminar)14-blx.aux
	cd $(workdir); bibtex $(seminar)14-blx

$(workdir)/buch15-blx.bbl:	$(workdir)/buch15-blx.aux
	cd $(workdir); bibtex buch15-blx

$(workdir)/$(seminar)15-blx.bbl:	$(workdir)/$(seminar)15-blx.aux
	cd $(workdir); bibtex $(seminar)15-blx

$(workdir)/buch16-blx.bbl:	$(workdir)/buch16-blx.aux
	cd $(workdir); bibtex buch16-blx

$(workdir)/$(seminar)16-blx.bbl:	$(workdir)/$(seminar)16-blx.aux
	cd $(workdir); bibtex $(seminar)16-blx

$(workdir)/buch17-blx.bbl:	$(workdir)/buch17-blx.aux
	cd $(workdir) bibtex buch17-blx

$(workdir)/$(seminar)17-blx.bbl:	$(workdir)/$(seminar)17-blx.aux
	cd $(workdir) bibtex $(seminar)17-blx

BLXFILES = $(workdir)/buch.bbl \
	$(workdir)/buch1-blx.bbl \
	$(workdir)/buch2-blx.bbl \
	$(workdir)/buch3-blx.bbl \
	$(workdir)/buch4-blx.bbl \
	$(workdir)/buch5-blx.bbl \
	$(workdir)/buch6-blx.bbl \
	$(workdir)/buch7-blx.bbl \
	$(workdir)/buch8-blx.bbl \
	$(workdir)/buch9-blx.bbl \
	$(workdir)/buch10-blx.bbl \
	$(workdir)/buch11-blx.bbl \
	$(workdir)/buch12-blx.bbl \
	$(workdir)/buch13-blx.bbl \
	$(workdir)/buch14-blx.bbl \
	$(workdir)/buch15-blx.bbl \
	$(workdir)/buch16-blx.bbl \


SBLXFILES = $(workdir)/$(seminar).bbl\
	$(workdir)/$(seminar)1-blx.bbl \
	$(workdir)/$(seminar)2-blx.bbl \
	$(workdir)/$(seminar)3-blx.bbl \
	$(workdir)/$(seminar)4-blx.bbl \
	$(workdir)/$(seminar)5-blx.bbl \
	$(workdir)/$(seminar)6-blx.bbl \
	$(workdir)/$(seminar)7-blx.bbl \
	$(workdir)/$(seminar)8-blx.bbl \
	$(workdir)/$(seminar)9-blx.bbl \
	$(workdir)/$(seminar)10-blx.bbl \
	$(workdir)/$(seminar)11-blx.bbl \
	$(workdir)/$(seminar)12-blx.bbl \
	$(workdir)/$(seminar)13-blx.bbl \
	$(workdir)/$(seminar)14-blx.bbl \
	$(workdir)/$(seminar)15-blx.bbl \
	$(workdir)/$(seminar)16-blx.bbl \


PAPER_DIRECTORIES = \
	doppelpendel \
	kettenlinie \
	balken \
	relativ \
	maxwell \
	geodaeten \
	minimalflaechen \
	leo \
	circuit \
	antennen \
	schwimmen \
	planet \
	varalg \
	cahnhilliard \
	luke \
	
PAPER_MAKEFILEINC = \
	papers/doppelpendel/Makefile.inc \
	papers/kettenlinie/Makefile.inc \
	papers/balken/Makefile.inc \
	papers/relativ/Makefile.inc \
	papers/maxwell/Makefile.inc \
	papers/geodaeten/Makefile.inc \
	papers/minimalflaechen/Makefile.inc \
	papers/leo/Makefile.inc \
	papers/circuit/Makefile.inc \
	papers/antennen/Makefile.inc \
	papers/schwimmen/Makefile.inc \
	papers/planet/Makefile.inc \
	papers/varalg/Makefile.inc \
	papers/cahnhilliard/Makefile.inc \
	papers/luke/Makefile.inc \
	
