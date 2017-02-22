if COND_PO
MAYBE_PO = po
endif

SUBDIRS = $(MAYBE_PO)

AM_CFLAGS = $(mingw_CFLAGS)

AM_CPPFLAGS = $(locale_CPPFLAGS) $(purple_CFLAGS)

AM_LDFLAGS = -module -avoid-version -no-undefined $(purple_LIBS)

EXTRA_DIST = \
	po/Makevars.in \
	README.mingw

DISTCLEANFILES = \
	po/Makevars

dist_noinst_DATA = \
	nsis/installer.nsi \
	nsis/Arabic.nsh \
	nsis/Czech.nsh \
	nsis/English.nsh \
	nsis/German.nsh \
	nsis/Italian.nsh \
	nsis/Norwegian.nsh \
	nsis/Russian.nsh \
	nsis/Spanish.nsh

dist_noinst_SCRIPTS = mingw-purple-dev.sh

plugin_LTLIBRARIES = src/bot-sentry.la

src_bot_sentry_la_SOURCES = src/bot-sentry.c

src_bot_sentry_la_LIBADD = $(INTLLIBS)

update-po:
	cd $(top_builddir)/po && $(MAKE) $(AM_MAKEFLAGS) update-po

# too many renames
install-exec-hook:
	rm -f $(DESTDIR)$(plugindir)/libbot-challenger.*
	rm -f $(DESTDIR)$(plugindir)/libgaim-bs.*
	rm -f $(DESTDIR)$(plugindir)/libpidgin-bs.*

distcheck-hook:
if COND_PO
if COND_MAKENSIS
	dc_install_base=`$(am__cd) $(distdir)/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \
	  && cd $(distdir)/_build \
	  && ../configure --srcdir=.. --prefix="$$dc_install_base" \
	    $(DISTCHECK_CONFIGURE_FLAGS) \
	  && $(MAKE) $(AM_MAKEFLAGS) installer

# from po/Makefile
itlocaledir = $(prefix)/$(DATADIRNAME)/locale

installer:
	rm -fr destdir.tmp $(PACKAGE)-$(VERSION).exe
	$(MAKE) $(AM_MAKEFLAGS) install DESTDIR=`pwd`/destdir.tmp
	$(MAKENSIS) \
		-NOCD \
		-DLIBDIR="`pwd`/destdir.tmp/$(plugindir)" \
		-DLOCALEDIR="`pwd`/destdir.tmp/$(itlocaledir)" \
		-DOUTFILE="$(PACKAGE)-$(VERSION).exe" \
		-DPACKAGE_BUGREPORT="$(PACKAGE_BUGREPORT)" \
		-DPACKAGE="$(PACKAGE)" \
		-DPURPLE_MAJOR_VERSION="$(PURPLE_MAJOR_VERSION)" \
		-DTOP_SRCDIR="$(top_srcdir)" \
		-DVERSION="$(VERSION)" \
		-DVERSION_MAJOR="$(VERSION_MAJOR)" \
		-DVERSION_MINOR="$(VERSION_MINOR)" \
		$(top_srcdir)/nsis/installer.nsi
	chmod a+x $(PACKAGE)-$(VERSION).exe
	rm -fr destdir.tmp
endif
endif

clean-local:
	rm -fr destdir.tmp $(PACKAGE)-$(VERSION).exe
