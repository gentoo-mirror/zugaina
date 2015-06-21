# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

MY_P="${P/_beta1/-beta}"
DESCRIPTION="A tool to analyze the Wired Equivalent Protocol (WEP) encryption security on wireless networks."
HOMEPAGE="http://weplab.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/${MY_P}"

DEPEND="net-libs/libpcap"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf || die "Configure failed"
	emake || die "Compile failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README NEWS INSTALL AUTHORS
}

