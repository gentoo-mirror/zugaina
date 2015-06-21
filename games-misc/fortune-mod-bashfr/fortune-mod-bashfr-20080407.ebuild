# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Fortune database of quotes from bashfr.org"
HOMEPAGE="http://www.bashfr.org/"
SRC_URI="http://distfiles.zugaina.org/bashfr-20080407.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="games-misc/fortune-mod"

S=${WORKDIR}

src_compile() {
	mv bashfr-${PV} bashfr || die
	strfile bashfr || die
}

src_install() {
	insinto /usr/share/fortune/fr
	doins bashfr bashfr.dat || die
}
