# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="An open-source interface to Z-Wave networks."
HOMEPAGE="http://openzwave-control-panel.googlecode.com"
ESVN_REPO_URI="http://openzwave-control-panel.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
SLOT="0"

DEPEND="dev-libs/open-zwave"
RDEPEND="${RDEPEND}"

src_compile() {
	cp ${FILESDIR}/Makefile ${S}
	epatch ${FILESDIR}/webserver.patch
	epatch ${FILESDIR}/ozwcp.patch
	emake || die
}

src_install() {
	dodir /usr/share/${PN}
	dodir /usr/bin
	insinto /usr/share/${PN}
	doins cp.html cp.js openzwavetinyicon.png
	exeinto /usr/bin
	doexe ozwcp
	dodoc README TODO
}
