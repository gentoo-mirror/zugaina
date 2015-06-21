# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This is a highly modified version of ebuild from http://bugs.gentoo.org/show_bug.cgi?id=97415

DESCRIPTION="Solipsis is a pure peer-to-peer system for a massively shared virtual world. There is no server at all: it only relies on end-users' machines. Built on twisted. "
HOMEPAGE="http://solipsis.netofpeers.net/"
SRC_URI="http://download.berlios.de/solipsis/${P}-src.tar.gz"
RESTRICT="nomirror"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/wxGTK-2.6.0
	>=dev-python/wxpython-2.6.0
        >=dev-python/twisted-2.0.0
	>=dev-python/elementtree-1.2
	>=dev-python/twisted-web-0.5.0
	>=dev-python/imaging-1.1.5"

src_install() {
        dodir /opt/${PN} /usr/bin
	insinto /opt/${PN}
	cp -dpR ${S}/{state,solipsis,resources,po,log,img,conf,avatars} ${D}/opt/${PN}
	chmod 777 ${D}/opt/${PN}/state/
        exeinto /opt/${PN}
	doexe *.py
	doexe *.sh
	cat << EOF > ${D}/usr/bin/${PN}
#!/bin/sh
cd /opt/${PN}
python navigator.py "\$@"
EOF
	chmod go+rx ${D}/usr/bin/${PN}
	dodoc *.txt
}
