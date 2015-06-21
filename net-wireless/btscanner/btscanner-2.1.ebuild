# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="btscanner is a tool designed specifically to extract as much information as possible from a Bluetooth device without the requirement to pair."
HOMEPAGE="http://www.pentest.co.uk/"
SRC_URI="http://www.pentest.co.uk/src/${P}.tar.bz2"
LICENSE="GPL-2"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

src_unpack() {
    unpack ${A}
    cd ${S}
    sed -i 's:-Wimplicit-function-dec::g' configure
}

src_install() {
	make DESTDIR=${D} install || die
}
