# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="IP over ICMP."
HOMEPAGE="http://thomer.com/icmptx/"
SRC_URI="http://thomer.com/icmptx/icmptx-0.01.tar.gz"
LICENSE="as-is"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

src_install() {
	dobin icmptx
	dodoc README
}
