# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

IUSE=""

MY_P="C-MD5"
DESCRIPTION="A program written to test the security of md5'd passwords by attempting to brutefoce them."
HOMEPAGE="http://www.davehope.co.uk/"
SRC_URI="http://www.davehope.co.uk/Projects/${MY_P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
S="${WORKDIR}/MD5 Brute Force"



DEPEND="dev-libs/openssl"

src_unpack() {
	unpack ${A}
}

src_compile() {
	./config.sh
}

src_install () {
	dodir /usr/bin
	exeinto /usr/bin
	doexe md5
}