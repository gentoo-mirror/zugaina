# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://home.exetel.com.au/tjaden/adelie/ - The site http://gentoo.zugaina.org/ only host a copy.

DESCRIPTION="Adelie is a fast replacement for equery"
HOMEPAGE="http://home.exetel.com.au/tjaden/adelie/"
SRC_URI="http://home.exetel.com.au/tjaden/adelie/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ghc-6.4"
RDEPEND=""

src_install() {
	exeinto /usr/bin
	doexe adelie
}
