# DOXYGEN SUPPORT
include $(top_srcdir)/doxygen.am
include $(top_srcdir)/libs.am

SUBDIRS += win32 src

Desafiodocdir = $(prefix)/docs
Desafiodoc_DATA = README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS\
	CREDITS

Desafioimgdir = $(prefix)/img
Desafioimg_DATA = img/tux.ico img/tux.xpm

desktopdir = $(HOME)/.local/share/applications
desktop_DATA = desafio.desktop

directorydir = $(HOME)/.local/share/desktop-directories
directory_DATA = desafio.directory

menudir = $(HOME)/.config/menus/applications-merged
menu_DATA = desafio.menu

EXTRA_DIST = $(Desafiodoc_DATA) $(Desafioimg_DATA) doxygen.cfg autogen.sh