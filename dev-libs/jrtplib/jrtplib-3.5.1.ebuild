# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://research.edm.luc.ac.be/jori/jrtplib/jrtplib.html - The site http://gentoo.zugaina.org/ only host a copy.

DESCRIPTION="JRTPLIB is an object-oriented RTP library written in C++."
HOMEPAGE="http://research.edm.luc.ac.be/jori/jrtplib/jrtplib.html"
SRC_URI="http://research.edm.luc.ac.be/jori/jrtplib/${P}.tar.bz2"
RESTRICT="nomirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="jthread"

DEPEND="jthread? ( >=dev-libs/jthread-1.1.2 )"

src_install() {
	newdoc ${S}/README.TXT README
	dodoc ${S}/TODO
	dodoc ${S}/ChangeLog
	dodoc ${S}/doc/jrtplib.tex
        make DESTDIR="${D}" install
}
