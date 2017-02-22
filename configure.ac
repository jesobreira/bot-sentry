#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])

m4_define([VERSION_MAJOR], [1])
m4_define([VERSION_MINOR], [3])
m4_define([VERSION_MICRO], [0])

AC_INIT([bot-sentry],
        [VERSION_MAJOR.VERSION_MINOR.VERSION_MICRO],
        [http://pidgin-bs.sourceforge.net/])

# intltoolize cannot handle: AC_CONFIG_AUX_DIR([build-aux])
# see http://bugzilla.gnome.org/show_bug.cgi?id=323968
AC_CONFIG_AUX_DIR([.])
AC_CANONICAL_TARGET([])
AM_INIT_AUTOMAKE([1.10 -Wall -Werror subdir-objects no-dist-gzip dist-bzip2])

AC_CONFIG_SRCDIR([src/bot-sentry.c])
AC_CONFIG_HEADER([config.h])

[VERSION_MAJOR]=VERSION_MAJOR
[VERSION_MINOR]=VERSION_MINOR
[VERSION_MICRO]=VERSION_MICRO

m4_undefine([VERSION_MAJOR])
m4_undefine([VERSION_MINOR])
m4_undefine([VERSION_MICRO])

AC_SUBST([VERSION_MAJOR])
AC_SUBST([VERSION_MINOR])
AC_SUBST([VERSION_MICRO])

AC_DEFINE([PURPLE_PLUGINS], [1], [Define if plugins are enabled.])
AC_SUBST([GETTEXT_PACKAGE], [$PACKAGE])

GETTEXT_PACKAGE=$PACKAGE
AC_SUBST([GETTEXT_PACKAGE])
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$GETTEXT_PACKAGE"],
                   [Define the gettext package to be used])

# Checks for programs.
AC_PROG_CC
AC_GNU_SOURCE
AC_PREFIX_PROGRAM([pidgin])
AC_DISABLE_STATIC
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL
AC_PROG_INTLTOOL([0.40.0], [no-xml])

AC_PATH_PROG([HEAD], [head], [no])
test "x$HEAD" = "xno" && AC_MSG_ERROR([head is required.])

AC_PATH_PROG([MAKENSIS], [makensis], [no])
AM_CONDITIONAL([COND_MAKENSIS], [test "x$MAKENSIS" != "xno"])

PKG_PROG_PKG_CONFIG([0.15.0])

REQUIRED_PURPLE="purple >= 2.0 purple < 3.0"
PKG_CHECK_MODULES(
    [purple],
    ["$REQUIRED_PURPLE"],
    [
        AC_MSG_CHECKING([purple_CFLAGS])
        AC_SUBST([purple_CFLAGS])
        AC_MSG_RESULT([$purple_CFLAGS])
        AC_MSG_CHECKING([purple_LIBS])
        AC_SUBST([purple_LIBS])
        AC_MSG_RESULT([$purple_LIBS])
    ],
    [AC_MSG_ERROR(["$REQUIRED_PURPLE" not found.])]
)

AC_MSG_CHECKING([PURPLE_VERSION])
PURPLE_VERSION="`"$PKG_CONFIG" --modversion "$REQUIRED_PURPLE" | "$HEAD" -1`"
AC_SUBST([PURPLE_VERSION])
AC_MSG_RESULT([$PURPLE_VERSION])

AC_MSG_CHECKING([PURPLE_MAJOR_VERSION])
PURPLE_MAJOR_VERSION="`echo $PURPLE_VERSION|"$SED" -e's/^\([[^.]]*\).*$/\1/g'`"
AC_SUBST([PURPLE_MAJOR_VERSION])
AC_MSG_RESULT([$PURPLE_MAJOR_VERSION])

AC_MSG_CHECKING([purple_prefix])
purple_prefix="`"$PKG_CONFIG" --variable=prefix "$REQUIRED_PURPLE" \
    | "$AWK" '{print $1}'`"
AC_SUBST([purple_prefix])
AC_MSG_RESULT([$purple_prefix])

AC_MSG_CHECKING([purple_exec_prefix])
purple_exec_prefix="`"$PKG_CONFIG" --variable=exec_prefix "$REQUIRED_PURPLE" \
    | "$AWK" '{print $1}'`"
AC_SUBST([purple_exec_prefix])
AC_MSG_RESULT([$purple_exec_prefix])

AC_MSG_CHECKING([purple_libdir])
purple_libdir="`"$PKG_CONFIG" --variable=libdir "$REQUIRED_PURPLE" \
    | "$AWK" '{print $1}'`"
AC_SUBST([purple_libdir])
AC_MSG_RESULT([$purple_libdir])

AC_MSG_CHECKING([plugindir])
plugindir="${libdir}/purple-${PURPLE_MAJOR_VERSION}"
AC_SUBST([plugindir])
AC_MSG_RESULT([$plugindir])

#if test "x$GCC" = "xyes"; then
#    BS_GCC_FLAGS="-Wall -W -ansi -pedantic"
#    AC_SUBST([BS_GCC_FLAGS])
#fi

case "$host" in
*-*-mingw*)
    # purple for win defines LOCALEDIR in win32dep.h
    # mingw specific compiler flags
    AC_MSG_CHECKING([mingw_CFLAGS])
    mingw_CFLAGS="-mno-cygwin -mms-bitfields"
    AC_SUBST([mingw_CFLAGS])
    AC_MSG_RESULT([$mingw_CFLAGS])
;;
*)
    AC_MSG_CHECKING([locale_CPPFLAGS])
    locale_CPPFLAGS='-DLOCALEDIR=\"$(prefix)/$(DATADIRNAME)/locale\"'
    AC_SUBST([locale_CPPFLAGS])
    AC_MSG_RESULT([$locale_CPPFLAGS])
;;
esac

saved_CFLAGS="$CFLAGS"
saved_CPPFLAGS="$CPPFLAGS"
saved_LDFLAGS="$LDFLAGS"

CFLAGS="$mingw_CFLAGS $CFLAGS"
CPPFLAGS="$locale_CPPFLAGS $purple_CFLAGS $CPPFLAGS"
LDFLAGS="$purple_LIBS $LDFLAGS"

# Checks for libraries.
AC_SEARCH_LIBS([g_get_current_time], [glib-2.0], [],
               [AC_MSG_ERROR([cannot link to glib-2.0])])
AC_SEARCH_LIBS([purple_account_get_connection], [purple], [],
               [AC_MSG_ERROR([cannot link to purple])])

AM_GLIB_GNU_GETTEXT
AM_CONDITIONAL([COND_PO], [test "x$gt_cv_have_gettext" = "xyes"])

# Checks for header files.
AC_CHECK_HEADERS([glib.h], [],
                 [AC_MSG_ERROR([cannot compile glib.h])])
AC_CHECK_HEADERS([plugin.h], [],
                 [AC_MSG_ERROR([cannot compile plugin.h])])
AC_CHECK_HEADERS([version.h], [],
                 [AC_MSG_ERROR([cannot compile version.h])],
                 [#include <plugin.h>])
AC_CHECK_HEADERS([util.h], [],
                 [AC_MSG_ERROR([cannot compile util.h])],
                 [#ifndef G_GNUC_NULL_TERMINATED
                  #  if __GNUC__ >= 4
                  #    define G_GNUC_NULL_TERMINATED __attribute__((__sentinel__))
                  #  else
                  #    define G_GNUC_NULL_TERMINATED
                  #  endif /* __GNUC__ >= 4 */
                  #endif /* G_GNUC_NULL_TERMINATED */])
AC_CHECK_HEADERS([debug.h], [],
                 [AC_MSG_ERROR([cannot compile debug.h])])
AC_CHECK_HEADERS([account.h], [],
                 [AC_MSG_ERROR([cannot compile account.h])],
                 [#ifndef G_GNUC_NULL_TERMINATED
                  #  if __GNUC__ >= 4
                  #    define G_GNUC_NULL_TERMINATED __attribute__((__sentinel__))
                  #  else
                  #    define G_GNUC_NULL_TERMINATED
                  #  endif /* __GNUC__ >= 4 */
                  #endif /* G_GNUC_NULL_TERMINATED */])
AC_CHECK_HEADERS([accountopt.h], [],
                 [AC_MSG_ERROR([cannot compile accountopt.h])])
AC_CHECK_HEADERS([privacy.h], [],
                 [AC_MSG_ERROR([cannot compile privacy.h])],
                 [#ifndef G_GNUC_NULL_TERMINATED
                  #  if __GNUC__ >= 4
                  #    define G_GNUC_NULL_TERMINATED __attribute__((__sentinel__))
                  #  else
                  #    define G_GNUC_NULL_TERMINATED
                  #  endif /* __GNUC__ >= 4 */
                  #endif /* G_GNUC_NULL_TERMINATED */])

case "$host" in
*-*-mingw*)
    AC_CHECK_HEADERS([win32dep.h], [],
                     [AC_MSG_ERROR([cannot compile win32dep.h])])
;;
esac

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST

# Checks for library functions.

CFLAGS="$saved_CFLAGS"
CPPFLAGS="$saved_CPPFLAGS"
LDFLAGS="$saved_LDFLAGS"

AC_CONFIG_FILES([Makefile
                 po/Makefile.in
                 po/Makevars])

AC_OUTPUT

AC_MSG_NOTICE([=== $PACKAGE $VERSION configured installation directories ===])
AC_MSG_NOTICE([    prefix      = $prefix])
AC_MSG_NOTICE([    exec_prefix = $exec_prefix])
AC_MSG_NOTICE([    libdir      = $libdir])
AC_MSG_NOTICE([    plugindir   = $plugindir])
AC_MSG_NOTICE([    datarootdir = $datarootdir])
AC_MSG_NOTICE([    itlocaledir = $prefix/$DATADIRNAME/locale])
AC_MSG_NOTICE([=== $PACKAGE $VERSION configured installation directories ===])

# Plugin Directories can be one of the following:
#   ${libdir}/purple-${PURPLE_MAJOR_VERSION}
#   ~/.purple/plugins

AC_MSG_CHECKING([if $PACKAGE libdir and purple libdir are the same])
eval bs_libdir="${libdir}"
eval bs_libdir="\"${bs_libdir}\""
if test "$purple_libdir" = "$bs_libdir"
then
    bs_purple_libdir_match=yes
else
    bs_purple_libdir_match=no
fi
AC_MSG_RESULT([$bs_purple_libdir_match])
if test "$bs_purple_libdir_match" = "no"
then
    AC_MSG_WARN([*** purple and $PACKAGE libdir settings do not match ***])
    AC_MSG_WARN([    According to $PKG_CONFIG:])
    AC_MSG_WARN([        purple libdir = $purple_libdir])
    AC_MSG_WARN([    However you have configured:])
    AC_MSG_WARN([        $PACKAGE libdir = $bs_libdir])
    AC_MSG_WARN([    You should probably re-run $0])
    AC_MSG_WARN([    with these additional options:])
    AC_MSG_WARN([        --prefix="$purple_prefix"])
    AC_MSG_WARN([        --exec-prefix="$purple_exec_prefix"])
    AC_MSG_WARN([        --libdir="$purple_libdir"])
    AC_MSG_WARN([*** purple and $PACKAGE libdir settings do not match ***])
fi

# vim:tabstop=4:shiftwidth=4:expandtab:
