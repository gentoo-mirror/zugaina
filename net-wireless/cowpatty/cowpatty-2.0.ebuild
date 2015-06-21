# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="coWPAtty is designed to audit the security of pre-shared keys selected in WiFi Protected Access (WPA) networks. "
HOMEPAGE="http://cowpatty.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
LICENSE="GPL-2"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

S=${WORKDIR}/${PN}

src_compile() {
        make || die
}

src_install() {
	dobin cowpatty
	dodoc AUTHORS CHANGELOG COPYING FAQ README INSTALL TODO WISHLIST
}
