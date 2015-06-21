# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils 

DESCRIPTION="Decode and encodes sample catalog for OpenTTD"
HOMEPAGE="http://www.openttd.org/"
SRC_URI="http://gb.binaries.openttd.org/binaries/extra/${PN}/${PV}/${P}-source.tar.bz2
	http://distfiles.zugaina.org/${P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""

src_install() {
	dobin catcodec || die
}
