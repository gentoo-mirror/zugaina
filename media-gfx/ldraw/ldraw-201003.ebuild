# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils toolchain-funcs


DESCRIPTION="LDraw parts library"
HOMEPAGE="http://www.ldraw.org/"
SRC_URI="http://www.ldraw.org/library/updates/complete.zip"

LICENSE="CCPL-Attribution-2.0 LDRAW-NONFREE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}"


src_install() {
	insinto /usr/share/ldraw
	doins -r *
}
