.rc.o:
	$(WINDRES) -DVERSION="\"$(VERSION)\"" -o $@ $<

dist_noinst_DATA = win32.rc

if MINGW32
nodist_noinst_DATA = \
		win32.o
CLEANFILES = $(nodist_noinst_DATA)
endif
