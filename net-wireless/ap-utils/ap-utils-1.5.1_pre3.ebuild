# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official ap-utils ebuild

inherit eutils

IUSE="nls"

MY_P="${PN}-${PV/_/}"
DESCRIPTION="Wireless Access Point Utilities for Unix"
HOMEPAGE="http://ap-utils.polesye.net/"
SRC_URI="ftp://linux.zhitomir.net/ap-utils/${MY_P}.tar.bz2"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND=">=sys-devel/bison-1.34"
RDEPEND=""
S=${WORKDIR}/${MY_P}

src_compile() {
	econf --build=${CHOST} `use_enable nls` || die
	emake || die
}

src_install () {
	einstall || die
	dodoc ChangeLog NEWS README THANKS TODO
}
