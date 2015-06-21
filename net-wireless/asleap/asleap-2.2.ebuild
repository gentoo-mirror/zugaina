# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="asleap - exploiting cisco leap"
HOMEPAGE="http://www.willhackforsushi.com/Asleap.html"
SRC_URI="http://www.willhackforsushi.com/code/${PN}/${PV}/${P}.tgz"
LICENSE="GPL-2"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

src_install() {
	dobin asleap genkeys
	dodoc COPYING README THANKS
}
