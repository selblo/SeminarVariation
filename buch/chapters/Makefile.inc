#
# Makefile.inc
#
# (c) 2022 Prof Dr Andreas Müller, OST Ostschweizer Fachhochschule
#

CHAPTERFILES = 								\
	chapters/part1.tex						\
	chapters/vorwort.tex

#include chapters/000-einleitung/Makefile.inc
include chapters/010-fuvar/Makefile.inc
include chapters/020-variation/Makefile.inc
include chapters/030-felder/Makefile.inc
include chapters/040-nebenbedingungen/Makefile.inc
include chapters/050-variation2/Makefile.inc
include chapters/060-direkt/Makefile.inc
include chapters/070-mechanik/Makefile.inc
include chapters/080-symmetrien/Makefile.inc
