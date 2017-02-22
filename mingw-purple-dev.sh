#! /bin/sh -e

usage () {
	echo "Usage:  $0 [pidgin dir] [gtk_2_0 dir] [compiler] [windres]"
}

if test $# -ne 4
then
	usage
	exit 1
fi

PIDGIN_DIR="$(cd $1 ; pwd)"
GTK_DIR="$(cd $2 ; pwd)"
MINGW_CC="$(which $3)"
MINGW_WINDRES="$(which $4)"

if [ "x$PIDGIN_DIR" == "x" -o "x$GTK_DIR" == "x" -o "x$MINGW_CC" == "x" -o "x$MINGW_WINDRES" == "x" ] ; then
	usage
	exit 1
fi

PURPLE_VERSION=$("$PIDGIN_DIR/configure" -V | head -n 1 | sed -e 's!^.* !!g')

PURPLE_MAJOR_VERSION=$(echo "$PURPLE_VERSION" | sed -e 's/^\([^.]*\).*$/\1/g')

cd "$PIDGIN_DIR"

cp config.h.mingw config.h

sed \
	-e 's!@exec_prefix@!${prefix}!g' \
	-e 's!@libdir@!${exec_prefix}/lib!g' \
	-e 's!@includedir@!${exec_prefix}/include!g' \
	-e 's!@datadir@!${prefix}/share!g' \
	-e 's!@sysconfdir@!${prefix}/etc!g' \
	-e 's!@VERSION@!'${PURPLE_VERSION}'!g' \
	libpurple/purple.pc.in > "$GTK_DIR/lib/pkgconfig/purple.pc"

cd libpurple

make -f Makefile.mingw libpurple.dll CC="$MINGW_CC" WINDRES="$MINGW_WINDRES"

mv libpurple.dll "$GTK_DIR/lib/libpurple.dll"

mkdir -p "$GTK_DIR/include/libpurple"
cp *.h  "$GTK_DIR/include/libpurple/."
find win32 -name \*.h -exec cp {} "$GTK_DIR/include/libpurple/." ';'

cd "$GTK_DIR/lib/pkgconfig"

for i in *.pc ; do
	sed -e 's/^prefix.*$/prefix=@prefix@/g' $i >$i.in
done

for i in *.pc.in ; do
	i=$(echo $i | sed -e 's!\.pc\.in$!!g')
	sed -e 's!@prefix@!'${GTK_DIR}'!g' $i.pc.in >$i.pc
done

echo "Your mingw purple header files and libraries are located in:"
echo "${GTK_DIR}"

