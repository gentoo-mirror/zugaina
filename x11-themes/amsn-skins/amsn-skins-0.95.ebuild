# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=116921 - The site http://gentoo.zugaina.org/ only host a copy.

S=${WORKDIR}
DESCRIPTION="Collection of AMSN themes"
HOMEPAGE="http://amsn.sourceforge.net/"
THEME_URI="mirror://sourceforge/amsn/"
SRC_URI="${THEME_URI}/amsn-for-mac-0.95.zip
	${THEME_URI}/aDarwinV.4-0.95.zip
	${THEME_URI}/AQUA-0.95.zip
	${THEME_URI}/BrushedMetal-0.95.zip
	${THEME_URI}/sheeny-0.95.zip
	${THEME_URI}/snowgrey-0.95.zip
	${THEME_URI}/TheNoNameBrand-0.95.zip
	${THEME_URI}/Ubuntu-Human-0.95.zip
	${THEME_URI}/Unified-0.95.zip"
RESTRICT="nomirror"
SLOT="0"
LICENSE="freedist"
KEYWORDS="alpha amd64 ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="net-im/amsn"

src_install () {
	dodir /usr/share/amsn/skins
	cp -r ${S}/* ${D}/usr/share/amsn/skins/
}
