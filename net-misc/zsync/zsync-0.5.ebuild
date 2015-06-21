# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official zsync ebuild

DESCRIPTION="Partial/differential file download client over HTTP which uses the rsync algorithm"
HOMEPAGE="http://zsync.moria.org.uk/"
SRC_URI="http://zsync.moria.org.uk/download/${P}.tar.bz2"
LICENSE="Artistic-2"
DEPEND="virtual/libc"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

src_install() {
	dobin zsync zsyncmake
	dodoc COPYING NEWS README
	doman doc/zsync.1 doc/zsyncmake.1
}
