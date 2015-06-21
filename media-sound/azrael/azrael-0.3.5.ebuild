# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

IUSE=""

inherit eutils 
DESCRIPTION="A GTK XMMS2 client"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="https://sourceforge.net/projects/azrael/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~hppa ~mips ~ppc64 ~alpha ~ia64"

S=${WORKDIR}/${PN}

DEPEND=">=x11-libs/gtk+-2.6
	>=media-sound/xmms2-0.2.1"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dodir /usr/bin
	make DESTDIR=${D}usr/bin install || die "install failed"
}
