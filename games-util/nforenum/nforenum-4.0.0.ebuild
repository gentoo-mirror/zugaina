# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A tool checking NFO code for errors"
HOMEPAGE="http://binaries.openttd.org/extra/nforenum/"
SRC_URI="http://ftp.snt.utwente.nl/pub/games/openttd/binaries/extra/${PN}/${PV}/${PN}-${PV}-source.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-libs/boost
	dev-lang/perl"
RDEPEND=""

S="${WORKDIR}/${PN}-${PV}-source"

src_prepare() {
	cat > Makefile.local <<-__EOF__
		CC = $(tc-getCC)
		CXX = $(tc-getCXX)
		CFLAGS = ${CFLAGS}
		CXXFLAGS = ${CXXFLAGS}
		LDOPT = ${LDFLAGS}
		STRIP = :
		V = 1
	__EOF__
}

src_install() {
	dobin nforenum || die
	dodoc docs/*.en.txt || die
}
