AC_INIT([Desafio-02], [1.0.0], [sombra@alcionesytes.net], [desafio02], [http://www.alcionesytes.net])
AC_PREREQ([2.50])
AC_CONFIG_AUX_DIR([.])
AM_INIT_AUTOMAKE([gnu 1.11 -Wall dist-xz])
AC_CONFIG_MACRO_DIR([m4])
m4_pushdef([AC_INCLUDES_DEFAULT], [$1])

AC_COPYRIGHT([Alcione Ferreira])
AC_REVISION([$Revison: 1.0.0 $])

AC_PROG_CC 
AC_LANG([C])
AM_PROG_LIBTOOL

AC_CANONICAL_HOST
AC_MSG_NOTICE([Plataforma: $host_os])

case "$host_os" in
	linux*)
		if test "x$with_dinamico" = "xyes"; then
			AC_CHECK_LIB([bsd], [getpeereid], [], [AC_MSG_ERROR([getpeereid() is missing, check config.log for more details])])
			AC_CHECK_LIB([resolv], [inet_net_ntop], [], [AC_MSG_ERROR([inet_net_ntop() is missing, check config.log for more details])])
			AC_MSG_NOTICE([Compilação Dinâmica])
		else
			LT_INIT([static])
			LDFLAGS="-static-libgcc -static-libstdc++ -static $LDFLAGS "
			AC_CHECK_LIB([resolv], [inet_net_ntop], [], [AC_MSG_ERROR([inet_net_ntop() is missing, check config.log for more details])])
			AC_CHECK_LIB([bsd], [getpeereid], [], [AC_MSG_ERROR([getpeereid() is missing, check config.log for more details])])
			AC_MSG_NOTICE([Compilação Estática])
		fi
		;;
	*)
		if test "x$with_dinamico" = "xyes"; then
			#AC_CHECK_LIB([bsd], [getpeereid], [], [AC_MSG_ERROR([getpeereid() is missing, check config.log for more details])])
			#AC_CHECK_LIB([resolv], [inet_net_ntop], [], [AC_MSG_ERROR([inet_net_ntop() is missing, check config.log for more details])])
			AC_MSG_NOTICE([Compilação Dinâmica])
		else
			LT_INIT([static])
			LDFLAGS="-static-libgcc -static-libstdc++ -static $LDFLAGS "
			AC_MSG_NOTICE([Compilação Estática])
			#AC_CHECK_LIB([pthread], [pthread_key_create], [], [AC_MSG_ERROR([pthread_key_create() is missing, check config.log for more details])])
		fi
		;;
esac
AC_CACHE_SAVE
######################################################################
# DOXYGEN SUPPORT
######################################################################

DX_HTML_FEATURE(ON)
DX_CHM_FEATURE(OFF)
DX_CHI_FEATURE(OFF)
DX_MAN_FEATURE(OFF)
DX_RTF_FEATURE(OFF)
DX_XML_FEATURE(OFF)
DX_PDF_FEATURE(ON)
DX_PS_FEATURE(ON)

DX_INIT_DOXYGEN([$PACKAGE_NAME],[doxygen.cfg],[doc])

######################################################################

AC_HEADER_STDC
AC_CHECK_HEADERS([stdio.h stdlib.h string.h],,, [AC_INCLUDES_DEFAULT])

AC_CHECK_FILES([src/bibliotecas.h src/principal.h])
AC_TYPE_SIZE_T
AC_CACHE_SAVE

CHECK_OS
AC_CACHE_SAVE

AC_SUBST([AM_CFLAGS])
AC_SUBST([AM_LDFLAGS])
AC_SUBST([AM_LDADD])
AC_CACHE_SAVE

AC_PREFIX_DEFAULT([~/programas/desafio-02])
AC_CACHE_SAVE

AH_TOP([
#ifndef __CONFIG_H__
#define __CONFIG_H__ 1

#if  defined(__WIN32__) || defined(__WIN__)
#define NO_LINUX 1
#include <windows.h>
#endif
])
AH_BOTTOM([
#ifdef HAVE_IOSTREAM
# include <iostream>
#endif
#ifdef HAVE_STRING
# include <string>
#endif
#ifdef HAVE_FSTREAM
# include <fstream>
#endif
#ifdef HAVE_VECTOR
# include <vector>
#endif
#ifdef HAVE_MEMORY
# include <memory>
#endif
#ifdef HAVE_CTIME
# include <ctime>
#endif
#ifdef HAVE_CSTDIO
# include <cstdio>
#endif
#ifdef HAVE_CSTDLIB
# include <cstdlib>
#endif
#ifdef HAVE_CTYPE_H
# include <ctype.h>
#endif
#ifdef HAVE_LTDL_H
# include <ltdl.h>
#endif
#ifdef HAVE_DLFCN_H
# include <dlfcn.h>
#endif
#ifdef HAVE_STDIO_H
# include <stdio.h>
#endif
#ifdef HAVE_STDLIB_H
# include <stdlib.h>
#endif
#ifdef HAVE_STRING_H
# include <string.h>
#endif
#ifdef HAVE_HPDF_H
# include <hpdf.h>
#endif
#ifdef HAVE_ZLIB_H
# include <zlib.h>
#endif
#ifdef HAVE_CMATH
# include <cmath>
#endif

#endif /*__CONFIG_H__*/
])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile win32/win32.rc win32/Makefile src/Makefile desafio.desktop desafio.directory desafio.menu])

AC_OUTPUT
