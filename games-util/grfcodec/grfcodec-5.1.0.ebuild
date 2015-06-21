# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/grfcodec/grfcodec-0_pre2306.ebuild,v 1.6 2010/05/28 18:14:22 josejx Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="http://binaries.openttd.org/extra/grfcodec/"
SRC_URI="http://ftp.snt.utwente.nl/pub/games/openttd/binaries/extra/grfcodec/${PV}/${PN}-${PV}-source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

S=${WORKDIR}/${PN}-${PV}-source

DEPEND="dev-lang/perl
	dev-libs/boost"
RDEPEND=""

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
	dobin ${PN} grf{diff,merge} nforenum || die
	dodoc docs/*.txt changelog.txt || die
}
