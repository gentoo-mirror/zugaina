# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="A bluesnarginf utility"
HOMEPAGE="http://www.alighieri.org/project.html"
SRC_URI="http://www.alighieri.org/tools/${PN}.tar.gz"
LICENSE="as-is"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

S=${WORKDIR}/${PN}

src_install() {
	dobin bluesnarfer
	dodoc README
}
