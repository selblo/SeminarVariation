#
# crop images
#
all:									\
	diagoal-crop.png						\
	sin-crop.png							\
	squard-crop.png							\
	strait-crop.png

size=840x930+70+100

diagoal-crop.png: diagoal.png Makefile
	magick -extract $(size) diagoal.png diagoal-crop.png

sin-crop.png: sin.png Makefile
	magick -extract $(size) sin.png sin-crop.png

squard-crop.png: squard.png Makefile
	magick -extract $(size) squard.png squard-crop.png

strait-crop.png: strait.png Makefile
	magick -extract $(size) strait.png strait-crop.png
