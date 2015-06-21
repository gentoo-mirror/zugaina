# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="mobile phone bluebug exploitation"
HOMEPAGE="http://www.remote-exploit.org/codes_bluebugger.html"
SRC_URI="http://www.remote-exploit.org/codes/bluebugger/${P}.tar.gz"
LICENSE="as-is"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

src_install() {
	dobin bluebugger
	dodoc README
}
