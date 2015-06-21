# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="Tapioca UI"
HOMEPAGE="http://tapioca-voip.sf.net"
SRC_URI="mirror://sourceforge/tapioca-voip/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
DEPEND="net-im/tapioca-coreclient
	net-im/tapioca-xmpp
	dev-libs/glib
	x11-libs/gtk+"

src_compile() {
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D}
}