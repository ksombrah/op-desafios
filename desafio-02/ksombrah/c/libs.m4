AC_SUBST([LIBEX_dir],[])
AC_SUBST([LIBEX_include],[])
AC_SUBST([LIBEX_libs],[])
AC_SUBST([LIBBANCOPG_dir],[])
AC_SUBST([LIBBANCOPG_include],[])
AC_SUBST([LIBBANCOPG_libs],[])
AC_SUBST([LIBBANCOMY_dir],[])
AC_SUBST([LIBBANCOMY_include],[])
AC_SUBST([LIBBANCOMY_libs],[])
AC_SUBST([LIBBANCOSL_dir],[])
AC_SUBST([LIBBANCOSL_include],[])
AC_SUBST([LIBBANCOSL_libs],[])
AC_SUBST([LIBMSSQL_dir],[])
AC_SUBST([LIBMSSQL_include],[])
AC_SUBST([LIBMSSQL_libs],[])
AC_SUBST([LIBHPDF_dir],[])
AC_SUBST([LIBHPDF_include],[])
AC_SUBST([LIBHPDF_libs],[])
AC_SUBST([LIBMDB_dir],[])
AC_SUBST([LIBMDB_include],[])
AC_SUBST([LIBMDB_libs],[])
AC_SUBST([LIBODBC_dir],[])
AC_SUBST([LIBODBC_include],[])
AC_SUBST([LIBODBC_libs],[])
#Seleção do modo de Compilação
# --with-dinamico
AC_ARG_WITH(dinamico,
  [AS_HELP_STRING([--with-dinamico],[Compilação Dinâmica])
  ],
  [ ],
  [with_dinamico=yes]
)
AC_DEFUN([CHECK_OS],[
#Testando plataforma
#AC_CANONICAL_HOST
AC_MSG_NOTICE([Checando SO: $host_os])
case "$host_os" in
	linux*)
		WIN_LD=""
		WIN_libs=""
		AC_SUBST([WIN_LADD],[''])
		AM_CONDITIONAL([MINGW32], false)
		;;
	*)
		AC_CHECK_TOOL([WINDRES], [windres], AC_MSG_ERROR([windres not found]))
		WIN_LD="-mwindows -D_WIN32_WINNT=0x0501"
		WIN_libs="-lws2_32"
		AC_SUBST([WIN_LADD],['$(top_builddir)/win32/win32.o'])
		AM_CONDITIONAL([MINGW32], true)
		;;
esac
AC_SUBST([WIN_LD])
AC_SUBST([WIN_libs])
])
#LIBEX
AC_DEFUN([LIBEX],[
AC_SUBST([LIBEX_dir], ['libex'])
AC_SUBST([LIBEX_include], ['-I$(top_srcdir)/libex/src -I$(top_builddir)/libex/src '])
AC_SUBST([LIBEX_libs], ['$(top_builddir)/libex/src/libex-1.0.a '])
])
#POSTGRESQL
AC_DEFUN([LIBBANCOPG],[
AC_ARG_WITH(pg_config, [	--with-pg_config=DIR	pg_config for PostgreSQL],
[
if test "$withval" != no
then
	PG_CONFIG="$withval"
	if test ! -f "${PG_CONFIG}"
	then
		AC_MSG_ERROR([Could not find your PostgreSQL installation])
	fi
fi
],
[
STANDARD_PREFIXES="/usr /usr/local /opt /local /mingw /mingw32 /mingw64"
PG_CONFIG=""

for i in `echo "$STANDARD_PREFIXES"`; do
	if test -f "$i/bin/pg_config"; then
		PG_CONFIG="$i/bin/pg_config"
    	break;
    fi
done])
AC_CHECK_PROGS([PG_CONFIG], [pg_config], [pg_config], [$PATH:/opt/bin:/local/bin:/mingw/bin:/mingw32/bin:/mingw64/bin])
if test x"$PG_CONFIG" = x; then
    AC_MSG_ERROR([$PACKAGE requires pg_config])
fi
if test "x$with_dinamico" = "xyes"; then
	AC_CANONICAL_HOST
	AC_MSG_NOTICE([Plataforma: $host $host_os $host_cpu $host_vendor])
	STANDARD_PREFIXES="/usr/lib /usr/lib/$host_cpu-$host_os
	 /usr/local/lib /usr/local/lib/$host_cpu-$host_os /opt/lib /opt/lib/$host_cpu-$host_os /local/lib /local/lib/$host_cpu-$host_os /mingw/lib /mingw/lib/$host_cpu-$host_os /mingw32/lib /mingw32/lib/$host_cpu-$host_os /mingw64/lib /mingw64/lib/$host_cpu-$host_os"
	SSL_A=""
	case "$host_os" in
		linux*)
			for i in `echo "$STANDARD_PREFIXES"`; do
				if test -f "$i/libssl.a"; then
					SSL_A="$i/libssl.a"
					break;
				fi
			done
			;;
		*)
			for i in `echo "$STANDARD_PREFIXES"`; do
				if test -f "$i/libssl.a"; then
					SSL_A="$i/libssl.a"
					break;
				fi
			done
			if test x"$SSL_A" = x; then
				for i in `echo "$STANDARD_PREFIXES"`; do
					if test -f "$i/libssl.dll.a"; then
						SSL_A="$i/libssl.dll.a"
						break;
					fi
				done
			fi 
			;;
	esac
	if test -f "$SSL_A" ; then
		AC_SUBST([SSL_ADD],[`echo ${SSL_A}`])
		AC_MSG_NOTICE([SSL: ${SSL_ADD}])
	else
		AC_MSG_ERROR([$PACKAGE requires libssl.a or libssl.dll.a])
	fi
fi
PKG_CHECK_MODULES([SSL], [openssl >= 0.9.8])
LIBPQ_A=""
AC_SUBST([PG_LIBS],  [`$PG_CONFIG --libs`])
PG_LIBS=$(echo "$PG_LIBS" | sed 's/-lpgcommon//g')
PG_LIBS=$(echo "$PG_LIBS" | sed 's/-lpgport//g')
AC_SUBST([PG_LIBS])
AC_SUBST([PG_LIB],  [`$PG_CONFIG --libdir`])
AC_SUBST([PG_INCLUDE], [`$PG_CONFIG --includedir`])
AC_SUBST([PG_CFLAGS],  ['-I${PG_INCLUDE}'])
AC_SUBST([PG_CPPFLAGS],  ['-I${PG_INCLUDE}'])
AC_SUBST([PG_LDFLAGS], ['-L${PG_LIB} ${PG_LIBS} -lpthread'])
case "$host_os" in
	linux*)
		AC_SUBST([PG_LDFLAGS], ['-L${PG_LIB} ${PG_LIBS} -lldap -lpthread -lpq'])
		LIBPQ_A="$PG_LIB/libpq.a";
		;;
	*)
		AC_SUBST([PG_LDFLAGS], ['-L${PG_LIB} ${PG_LIBS} -lpthread -lpq'])
		if test -f "$PG_LIB/libpq.a"; then
			LIBPQ_A="$PG_LIB/libpq.a";
		else
			LIBPQ_A="$PG_LIB/libpq.dll.a";
		fi
		;;
esac
AC_SUBST([LIBBANCOPG_dir],['libbancopg'])
AC_SUBST([LIBBANCOPG_include],['-I$(top_srcdir)/libbancopg/src -I$(top_builddir)/libbancopg/src -I${PG_INCLUDE} ${SSL_CFLAGS}'])
AC_MSG_CHECKING([PostGreSQL: Identificando modo de compilação: ])
if test -f "$LIBPQ_A" ; then
	AC_SUBST([LIBPQ_ADD],[`echo ${LIBPQ_A}`])
	AC_MSG_NOTICE([LIBPQA: ${LIBPQ_ADD}])
else
	AC_MSG_ERROR([$PACKAGE requires libpq.a or libpq.dll.a])
fi
if test "x$with_dinamico" = "xyes"; then 
	AC_SUBST([LIBBANCOPG_libs],['$(top_builddir)/libbancopg/src/libbancopg-2.0.a -L${PG_LIB} ${PG_LIBS} -lpq  ${SSL_LIBS} '])
    AC_MSG_RESULT([Dinâmica])
	break;
else
	AC_SUBST([LIBBANCOPG_libs],['$(top_builddir)/libbancopg/src/libbancopg-2.0.a ${SSL_ADD} ${LIBPQ_ADD} ${PG_LDFLAGS} ${SSL_ADD} '])
	AC_MSG_RESULT([Estática])
fi
AC_ARG_WITH(pghost,
  [AS_HELP_STRING([--with-pghost=HOST],[Hostname servidor PostgreSQL])],
  [pghost=$withval],
  [pghost=127.0.0.1]
)
AC_SUBST([PGHOST],[$pghost])

AC_ARG_WITH(pgbanco,
  [AS_HELP_STRING([--with-pgbanco=BANCO],[Nome da Base de Dados PostgreSQL])],
  [pgbanco=$withval],
  [pgbanco=postgres]
)
AC_SUBST([PGBANCO],[$pgbanco])

AC_ARG_WITH(pguser,
  [AS_HELP_STRING([--with-pguser=USER],[Usuário do PostgreSQL])],
  [pguser=$withval],
  [pguser=postgres]
)
AC_SUBST([PGUSER],[$pguser])

AC_ARG_WITH(pgsenha,
  [AS_HELP_STRING([--with-pgsenha=SENHA],[Senha do Usuário do PostgreSQL])],
  [pgsenha=$withval],
  [pgsenha=postgres]
)
AC_SUBST([PGSENHA],[$pgsenha])
])
#MYSQL
AC_DEFUN([LIBBANCOMY],[

AC_ARG_ENABLE(mysql_dinamico,
  [AS_HELP_STRING([--enable-mysql_dinamico],[Compilação Dinâmica MYSQL])
  ],
  [enable_dinamico=yes],
  [ ]
)
AC_CANONICAL_HOST
case "$host_os" in
	mingw*)
		AC_SUBST([MY_PATH],['/mingw'])
		;;
	*)
		AC_SUBST([MY_PATH],['/usr'])
		;;
esac
AC_ARG_WITH(mysql_config, [	--with-mysql_config=DIR	mysql_config for MySQL],
[
if test "$withval" != no
then
	MY_CONFIG="$withval"
	if test ! -f "${MY_CONFIG}"
	then
		AC_MSG_ERROR([Could not find your MySQL installation])
	fi
	AC_SUBST([MY_PATH],[`echo "bin/${MY_CONFIG}" | sed 's/\/bin\/mysql_config//'`])
fi
],
[
STANDARD_PREFIXES="/usr /usr/local /opt /local /mingw"
MY_CONFIG=""
for i in `echo "$STANDARD_PREFIXES"`; do
	if test -f "$i/bin/mysql_config"; then
		MY_CONFIG="$i/bin/mysql_config"
		AC_SUBST([MY_PATH],[$i])
    	break;
    fi
done
])
AC_CHECK_PROGS([MY_CONFIG], [mysql_config], [mysql_config], [$PATH:/opt/bin:/local/bin:/mingw/bin:/mingw32/bin:/mingw64/bin])
if test x"$MY_CONFIG" = x; then
    AC_MSG_ERROR([$PACKAGE requires mysql_config])
fi
AC_SUBST([MY_LIBS],[`$MY_CONFIG --libs`])
AC_SUBST([MY_CFLAGS],[`$MY_CONFIG --cflags`])
case "$host_os" in
	mingw*)
		AC_SUBST([MY_SFLAGS],['$(MY_PATH)/lib/liblibmysql.a'])
		;;
	*)
		AC_SUBST([MY_SFLAGS],['$(MY_PATH)/lib/libmysqlclient.a'])
		;;
esac
AC_SUBST([LIBBANCOMY_dir],['libbancomy'])
AC_SUBST([LIBBANCOMY_include],['-I$(top_srcdir)/libbancomy/src -I$(top_builddir)/libbancomy/src $(MY_CFLAGS)'])
AC_MSG_CHECKING([MYSQL: Identificando modo de compilação: ])
if test "x$enable_dinamico" = "xyes"; then
	AC_SUBST([LIBBANCOMY_libs],['$(top_builddir)/libbancomy/src/libbancomy-1.0.a $(MY_LIBS)'])
    AC_MSG_RESULT([Dinâmica])
	break;
else
	AC_SUBST([LIBBANCOMY_libs],['$(top_builddir)/libbancomy/src/libbancomy-1.0.a $(MY_SFLAGS)'])
	AC_MSG_RESULT([Estática])
fi
AC_ARG_WITH(myhost,
  [AS_HELP_STRING([--with-myhost=HOST],[Hostname servidor MySQL])],
  [myhost=$withval],
  [myhost=127.0.0.1]
)
AC_SUBST([MYHOST],[$myhost])

AC_ARG_WITH(mybanco,
  [AS_HELP_STRING([--with-mybanco=BANCO],[Nome da Base de Dados MySQL])],
  [mybanco=$withval],
  [mybanco=mysql]
)
AC_SUBST([MYBANCO],[$mybanco])

AC_ARG_WITH(myuser,
  [AS_HELP_STRING([--with-myuser=USER],[Usuário do MYSQL])],
  [myuser=$withval],
  [myuser=mysql]
)
AC_SUBST([MYUSER],[$myuser])

AC_ARG_WITH(mysenha,
  [AS_HELP_STRING([--with-mysenha=SENHA],[Senha do Usuário do MySQL])],
  [mysenha=$withval],
  [mysenha=mysql]
)
AC_SUBST([MYSENHA],[$mysenha])
])
#SQLite
AC_DEFUN([LIBBANCOSL],[
AC_SUBST([LIBBANCOSL_dir],['libbancosl'])
AC_SUBST([LIBBANCOSL_include],['-I$(top_srcdir)/libbancosl/src -I$(top_builddir)/libbancosl/src -I$(top_srcdir)/libbancosl/sqlite -I$(top_builddir)/libbancosl/sqlite'])
AC_SUBST([LIBBANCOSL_libs],['$(top_builddir)/libbancosl/src/libbancosl-1.0.a $(top_builddir)/libbancosl/sqlite/.libs/libsqlite3.a'])
])
#SQL Server
AC_DEFUN([LIBMSSQL],[
CHECK_OS
AC_CANONICAL_HOST
AC_MSG_NOTICE([Plataforma: $host $host_os $host_cpu $host_vendor])
STANDARD_PREFIXES="/usr /usr/local /opt /local /mingw /mingw32 /mingw64"
FREETDS_DIR=""
for i in `echo "$STANDARD_PREFIXES"`; do
	if test -f "$i/sybdb.h"; then
		FREETDS_DIR="$i"
    	break;
    fi
done
AC_MSG_CHECKING([FreeTDS ])
if test x"$FREETDS_DIR" = x; then
    AC_MSG_ERROR([$PACKAGE requires FreeTDS])
else
	AC_MSG_RESULT([$FREETDS_DIR])
	AC_SUBST([FREETDS_DIR])
fi
STANDARD_PREFIXES="/usr/lib /usr/lib/$host_cpu-$host_os
 /usr/local/lib /usr/local/lib/$host_cpu-$host_os /opt/lib /opt/lib/$host_cpu-$host_os /local/lib /local/lib/$host_cpu-$host_os /mingw/lib /mingw/lib/$host_cpu-$host_os /mingw32/lib /mingw32/lib/$host_cpu-$host_os /mingw64/lib /mingw64/lib/$host_cpu-$host_os"
FREETDS_LIB=""
for i in `echo "$STANDARD_PREFIXES"`; do
	if test -f "$i/libsybdb.so"; then
		FREETDS_LIB="$i"
    	break;
	fi
done
if test "x$FREETDS_LIB" = x ; then
	AC_MSG_ERROR([$PACKAGE requires libsybdb.so])
else
	AC_MSG_RESULT([$FREETDS_LIB])
	AC_SUBST([FREETDS_LIB])
fi
AC_SUBST(MSSQL_LIBS,  ['-L${FREETDS_LIB}'])
AC_SUBST(MSSQL_INCLUDE, ['-I${FREETDS_DIR}/include'])
AC_SUBST([LIBMSSQL_dir],['libmssql'])
AC_SUBST([LIBMSSQL_include],['-I$(top_srcdir)/libmssql/src -I$(top_builddir)/libmssql/src -I$(MSSQL_INCLUDE) ${WIN_LD}'])
AC_SUBST([LIBMSSQL_libs],['$(top_builddir)/libmssql/src/libmssql-1.0.a ${MSSQL_LIBS} -lsybdb ${WIN_libs}'])
])
#HARU
AC_DEFUN([LIBHPDF],[
AC_CANONICAL_HOST
AC_MSG_NOTICE([Plataforma: $host $host_os $host_cpu $host_vendor])
STANDARD_PREFIXES="/usr/include /usr/include/$host_cpu-$host_os /usr/local/include /usr/local/include/$host_cpu-$host_os /opt/include /opt/include/$host_cpu-$host_os /local/include /local/include/$host_cpu-$host_os /mingw/include /mingw/include/$host_cpu-$host_os /mingw32/include /mingw32/include/$host_cpu-$host_os /mingw64/include /mingw64/include/$host_cpu-$host_os"

# --with-libdir
AC_ARG_WITH(libdir,
  [AS_HELP_STRING([--with-libdir],[look for libraries in .../NAME rather than .../lib])
  ],
  [LIBDIR=$with_libdir],
  [LIBDIR=lib]
)

# --with-zlib
AC_ARG_WITH(zlib,
  [AS_HELP_STRING([--with-zlib],[specify Zlib install prefix])
  ],
  [ ],
  [with_zlib=yes]
)

if test "x$with_zlib" = "xno"; then
  AC_DEFINE([HAVE_NOZLIB], [], [zlib is not available])
else
  AC_MSG_CHECKING([Zlib install prefix])

  if test "x$with_zlib" = "xyes"; then
    for i in `echo "$STANDARD_PREFIXES"`; do
      if test -f "$i/zlib.h"; then
        ZINCLUDE_DIR="$i";
		ZLIB_DIR=$(echo "$ZINCLUDE_DIR" | sed 's/include/lib/g');
        break;
      fi
    done
  else
    if test -f "$with_zlib/include/zlib.h"; then
      ZINCLUDE_DIR="$with_zlib/include";
	  ZLIB_DIR=$(echo "$ZINCLUDE_DIR" | sed 's/include/lib/g');
      break;
    else
      AC_MSG_ERROR([Can't find Zlib headers under $with_zlib directory]);
    fi
  fi

  AC_MSG_RESULT([Libdir: $ZLIB_DIR Includedir: $ZINCLUDE_DIR])
  AC_CANONICAL_HOST
  if test "x$ZLIB_DIR" = "x"; then
    AC_MSG_ERROR([Unable to locate Zlib headers, please use --with-zlib=<DIR>]);
  fi
  if test -f "$ZLIB_DIR/libz.a"; then
	 LIBZ_DIR="$ZLIB_DIR";
	 break;
  else
  	if test -f "$ZLIB_DIR/$host_cpu-$host_os/libz.a"; then
     	LIBZ_DIR="$ZLIB_DIR/$host_cpu-$host_os";
	 	break;
  	else
    	AC_MSG_ERROR([Unable to locate Zlib lib, please use --with-zlib=<DIR>]);
	fi
  fi
  AC_MSG_RESULT([$ZLIB_DIR $LIBZ_DIR])
  AC_MSG_RESULT([Libdir: $ZLIB_DIR Includedir: $ZINCLUDE_DIR])
  LDFLAGS="$LDFLAGS -L$LIBZ_DIR"
  CFLAGS="$CFLAGS -I$ZINCLUDE_DIR"
  LIBS="$LIBS -lz"
  ZLIB_PREFIXES="/usr/lib /usr/lib/$host_cpu-$host_os /usr/lib/include /usr/local/lib/$host_cpu-$host_os /opt/lib /opt/lib/$host_cpu-$host_os /local/lib /local/lib/$host_cpu-$host_os /mingw/lib /mingw/lib/$host_cpu-$host_os /mingw32/include /mingw32/lib/$host_cpu-$host_os /mingw64/lib /mingw64/lib/$host_cpu-$host_os"
  for i in `echo "$ZLIB_PREFIXES"`; do
	  if test -f "$i/libz.a"; then
		ZLIBA="$i/libz.a"
		break;
	  fi
  done
  
  if test "x$ZLIBA" = "x"; then
    AC_MSG_ERROR([Unable to locate Zlib static, please use --with-zlib=<DIR>])
  else
    AC_SUBST([ZLIBA])
    AC_MSG_RESULT([$ZLIBA])
  fi

  HAVE_ZLIB=yes
fi
AC_SUBST([LIBHPDF_dir],['libhpdf'])
AC_SUBST([LIBHPDF_include],['-I$(top_srcdir)/libhpdf/include -I$(top_builddir)/libhpdf/include'])
if test "x$with_dinamico" = "xyes"; then
	AC_SUBST([LIBHPDF_libs],['$(top_builddir)/libhpdf/src/libhpdf.a -lpng'])
	AC_CHECK_LIB([z], [deflate], [], [AC_MSG_ERROR([deflate() is missing, check config.log for more details])])
else
	AC_SUBST([LIBHPDF_libs],['$(top_builddir)/libhpdf/src/libhpdf.a $(ZLIBA) -lpng'])
fi
])
#HARU
AC_DEFUN([LIBMDB],[
AM_PROG_LEX
AC_PROG_YACC
AC_SUBST([LibMDB],['-lmdb'])
sql=true
AC_MSG_CHECKING( Are we using flex )
if test "x$LEX" = "xflex"; then
LFLAGS="$LFLAGS -i"
AC_MSG_RESULT( yes );
else
AC_MSG_RESULT( no - SQL engine disable);
sql=false
fi

if test "x$YACC" = "x"; then
sql=false
fi

if test "x$sql" = "xtrue"; then
	AC_SUBST([LibMDB],['-DSQL'])
fi
PKG_CHECK_MODULES([LibDEP], [glib-2.0])

AC_SUBST([LIBMDB_dir],['libmdb'])
AC_SUBST([LIBMDB_include],['-I$(top_srcdir)/libmdb/include -I$(top_builddir)/libmdb/include $(LibDEP_CFLAGS)'])
AC_SUBST([LIBMDB_libs],['$(top_builddir)/libmdb/src/libmdb.la $(LibMDB) $(LibDEP_LIBS)'])
])
AC_DEFUN([LIBODBC],[
AC_CANONICAL_HOST
AC_MSG_NOTICE([Plataforma: $host_os])
case "$host_os" in
	linux*)
		OS_HOST="yes";
		;;
	mingw*)
		OS_HOST="no";
		;;
esac;

if test x"$OS_HOST" = xyes; then
	AC_ARG_WITH(odbc_config, [--with-odbc_config=DIR	odbc_config for UnixODBC],
	[
	if test "$withval" != no
	then
		ODBC_CONFIG="$withval"
		if test ! -f "${ODBC_CONFIG}"
		then
			AC_MSG_ERROR([Could not find your UnixODBC installation])
		fi
	fi
	],
	[
	AC_CANONICAL_HOST
	AC_MSG_NOTICE([Plataforma: $host $host_os $host_cpu $host_vendor])
	STANDARD_PREFIXES="/usr /usr/local /opt /local /mingw /mingw32 /mingw64"
	ODBC_CONFIG=""
	for i in `echo "$STANDARD_PREFIXES"`; do
		if test -f "$i/bin/odbc_config"; then
			ODBC_CONFIG="$i/bin/odbc_config"
			break;
		fi
	done
	])
	AC_CHECK_PROGS([ODBC_CONFIG], [odbc_config], [odbc_config], [$PATH:/opt/bin:/local/bin:/mingw/bin:/mingw32/bin:/mingw64/bin])
	if test x"$ODBC_CONFIG" = x; then
		AC_MSG_ERROR([$PACKAGE requires odbc_config])
	fi
	AC_SUBST([ODBC_LIBS],  [`$ODBC_CONFIG --libs`])
	AC_SUBST([ODBC_INCLUDE], [`$ODBC_CONFIG --include-prefix`])
	AC_SUBST([ODBC_CPPFLAGS],  [`$ODBC_CONFIG --cflags`])
	AC_SUBST([ODBC_LDFLAGS], [`$ODBC_CONFIG --libs`])
	AC_SUBST([ODBC_STFLAGS], [`$ODBC_CONFIG --static-libs`])
	AC_SUBST([LIBODBC_dir],['libbancoodbc'])
	AC_SUBST([LIBODBC_include],['-I$(top_srcdir)/libbancoodbc/src -I$(top_builddir)/libbancoodbc/src $(ODBC_CPPFLAGS)'])
	AC_MSG_CHECKING([UnixODBC: Identificando modo de compilação: ])
	if test "x$with_dinamico" = "xyes"; then
		AC_SUBST([LIBODBC_libs],['$(top_builddir)/libbancoodbc/src/libbancoodbc-1.0.a $(ODBC_LIBS)'])
		AC_MSG_RESULT([Dinâmica])
		break;
	else
		AC_SUBST([LIBODBC_libs],['$(top_builddir)/libbancoodbc/src/libbancoodbc-1.0.a $(ODBC_STFLAGS) -lltdl'])
		AC_MSG_RESULT([Estática])
	fi
	AC_ARG_ENABLE(datafw, 
	[AS_HELP_STRING([--enable-datafw],[Formataçao especial para data no UnixODBC
						Se habilitado para o SQL Server usara o formato YYYY-MM-DD
						caso contrario ira usar o padrao DD/MM/YYYY])],
	[AC_DEFINE([DATAFW],[1],[Formataçao especial para datas no UnixODBC])],
	[]
	)
else
	AC_SUBST([LIBODBC_dir],['libbancoodbc'])
	AC_SUBST([LIBODBC_include],['-I$(top_srcdir)/libbancoodbc/src -I$(top_builddir)/libbancoodbc/src'])
	AC_SUBST([LIBODBC_libs],['$(top_builddir)/libbancoodbc/src/libbancoodbc-1.0.a -lodbc32'])
fi
])
AC_DEFUN([LIBAPDF],[
AC_CANONICAL_HOST
AC_MSG_NOTICE([Plataforma: $host $host_os $host_cpu $host_vendor])
STANDARD_PREFIXES="/usr/include /usr/include/$host_cpu-$host_os /usr/local/include /usr/local/include/$host_cpu-$host_os /opt/include /opt/include/$host_cpu-$host_os /local/include /local/include/$host_cpu-$host_os /mingw/include /mingw/include/$host_cpu-$host_os /mingw32/include /mingw32/include/$host_cpu-$host_os /mingw64/include /mingw64/include/$host_cpu-$host_os"

AC_ARG_WITH(libdir,
  [AS_HELP_STRING([--with-libdir],[look for libraries in .../NAME rather than .../lib])
  ],
  [LIBDIR=$with_libdir],
  [LIBDIR=lib]
)

# --with-zlib
AC_ARG_WITH(zlib,
  [AS_HELP_STRING([--with-zlib],[specify Zlib install prefix])
  ],
  [ ],
  [with_zlib=yes]
)

if test "x$with_zlib" = "xno"; then
  AC_DEFINE([HAVE_NOZLIB], [], [zlib is not available])
else
  AC_MSG_CHECKING([Zlib install prefix])

  if test "x$with_zlib" = "xyes"; then
    for i in `echo "$STANDARD_PREFIXES"`; do
      if test -f "$i/zlib.h"; then
        ZINCLUDE_DIR="$i";
		ZLIB_DIR=$(echo "$ZINCLUDE_DIR" | sed 's/include/lib/g');
        break;
      fi
    done
  else
    if test -f "$with_zlib/include/zlib.h"; then
      ZINCLUDE_DIR="$with_zlib/include";
	  ZLIB_DIR=$(echo "$ZINCLUDE_DIR" | sed 's/include/lib/g');
      break;
    else
      AC_MSG_ERROR([Can't find Zlib headers under $with_zlib directory]);
    fi
  fi

  AC_MSG_RESULT([Libdir: $ZLIB_DIR Includedir: $ZINCLUDE_DIR])
  AC_CANONICAL_HOST
  if test "x$ZLIB_DIR" = "x"; then
    AC_MSG_ERROR([Unable to locate Zlib headers, please use --with-zlib=<DIR>]);
  fi
  if test -f "$ZLIB_DIR/libz.a"; then
	 LIBZ_DIR="$ZLIB_DIR";
	 break;
  else
  	if test -f "$ZLIB_DIR/$host_cpu-$host_os/libz.a"; then
     	LIBZ_DIR="$ZLIB_DIR/$host_cpu-$host_os";
	 	break;
  	else
    	AC_MSG_ERROR([Unable to locate Zlib lib, please use --with-zlib=<DIR>]);
	fi
  fi
  AC_MSG_RESULT([$ZLIB_DIR $LIBZ_DIR])
  LDFLAGS="$LDFLAGS -L$LIBZ_DIR"
  CFLAGS="$CFLAGS -I$ZINCLUDE_DIR"
  LIBS="$LIBS -lz"
  ZLIB_PREFIXES="/usr/lib /usr/lib/$host_cpu-$host_os /usr/lib/include /usr/local/lib/$host_cpu-$host_os /opt/lib /opt/lib/$host_cpu-$host_os /local/lib /local/lib/$host_cpu-$host_os /mingw/lib /mingw/lib/$host_cpu-$host_os /mingw32/include /mingw32/lib/$host_cpu-$host_os /mingw64/lib /mingw64/lib/$host_cpu-$host_os"
  for i in `echo "$ZLIB_PREFIXES"`; do
	  if test -f "$i/libz.a"; then
		ZLIBA="$i/libz.a"
		break;
	  fi
  done
  
  if test "x$ZLIBA" = "x"; then
    AC_MSG_ERROR([Unable to locate Zlib static, please use --with-zlib=<DIR>])
  else
    AC_SUBST([ZLIBA])
    AC_MSG_RESULT([$ZLIBA])
  fi

  AC_CHECK_LIB([z], [deflate], [], [
    AC_MSG_ERROR([deflate() is missing, check config.log for more details])
  ])

  HAVE_ZLIB=yes
fi
AC_SUBST([LIBAPDF_dir],['libapdf'])
AC_SUBST([LIBAPDF_include],['-I$(top_srcdir)/libapdf/src -I$(top_builddir)/libapdf/src -I$(top_srcdir)/libapdf/libex/src -I$(top_builddir)/libapdf/libex/src -I$(top_srcdir)/libapdf/libhpdf/include -I$(top_builddir)/libapdf/libhpdf/include '])
if test "x$with_dinamico" = "xyes"; then
	AC_SUBST([LIBAPDF_libs],['$(top_builddir)/libapdf/src/libapdf-1.0.a $(top_builddir)/libapdf/libex/src/libex-1.0.a $(top_builddir)/libapdf/libhpdf/src/libhpdf.a -lpng'])
else
	AC_SUBST([LIBAPDF_libs],['$(top_builddir)/libapdf/src/libapdf-1.0.a $(top_builddir)/libapdf/libex/src/libex-1.0.a $(top_builddir)/libapdf/libhpdf/src/libhpdf.a $(ZLIBA) -lpng'])
fi
])
AC_SUBST([INCLUIR])
AC_SUBST([BIBLIOTECA])