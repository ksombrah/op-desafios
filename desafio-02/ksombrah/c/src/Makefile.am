include $(top_srcdir)/libsrc.am

AM_CFLAGS = -I. -Wwrite-strings @AM_CFLAGS@ 
AM_LDFLAGS = $(WIN_LD) @AM_LDFLAGS@ -pg -g2
AM_LDADD = $(WIN_LD) @AM_LDADD@ -pg -g2

bin_PROGRAMS = Desafio2 

Desafio2dir = $(includedir)

Desafio2_SOURCES = main.c principal.c
Desafio2_HEADERS = bibliotecas.h principal.h icones.h


Desafio2_CFLAGS = $(CFLAGS) 
Desafio2_CFLAGS += $(INCLUIR)
Desafio2_LDFLAGS = $(WIN_LD) $(LIBS) $(LDFLAGS) 
Desafio2_LDADD = $(WIN_LADD) $(LIBS) $(LDFLAGS)  
Desafio2_LDADD += $(BIBLIOTECA)

