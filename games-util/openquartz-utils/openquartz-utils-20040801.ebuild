# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=43867 - The site http://gentoo.zugaina.org/ only host a copy.

inherit games

MY_PV="2004.08.01"
DESCRIPTION="Utils for PAK creation"
HOMEPAGE="http://openquartz.sourceforge.net/"
SRC_URI="mirror://sourceforge/openquartz/oq-utils-src-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND=">=sys-apps/sed-4"

S=${WORKDIR}/utils

src_unpack() {
	unpack ${A}
	cd "${S}"
	einfo "fixing the docs"
	mkdir docs
	cp mdl2map/readme.txt docs/mdl2map
	cp mesh2map/mesh2map.txt docs/mesh2map
	cp par/pak-format.txt docs
	cp qutils/history.txt docs/ChangeLog
	cp qutils/readme.txt docs/qutils
	cp toon/toon.txt docs/toon
	cp raw2map/raw2map.txt docs/raw2map
	cp tri2map/tri2map.txt docs/tri2map

	einfo "fixing manpages"
	mkdir man
	cp par/par.1 man
	
	if use doc; then
		einfo "fixing HTML docs"
		mkdir docs-html
		mv raw2map/index.html raw2map/raw2map.html
		cp raw2map/01.gif raw2map/02.gif raw2map/03.gif raw2map/17x17.map raw2map/17x17.raw raw2map/raw2map.html docs
		mv toon/index.html toon/toon.html
		cp toon/toon.gif toon/toon.html toon/1.gif toon/2.gif docs
	fi
}

src_compile() {
	cd "${S}"
	find -name CVS -exec rm -rf '{}' \; >& /dev/null
	sed -i \
		-e "s:CFLAGS=-g -O2 -Wall:CFLAGS=${CXXFLAGS}:" \
		qutils/makefile \
		toon/makefile \
		raw2map/makefile \
		mdl2map/makefile \
		tri2map/makefile \
		|| \
				            die "sed Makefile failed"
	emake || die "emake died"
}

src_install() {
	insinto ${GAMES_BINDIR}/qutils
	doins bin/* || die "installing converters failed"
	rm -rf qutils/bin/djgpp qutils/bin/mingw qutils/bin/old
	doins qutils/bin/* || die "installing qutils failed"

	dodoc docs/*
	doman man/*
	if use doc; then
		dohtml docs-html/*
	fi

	prepgamesdirs
}
										
