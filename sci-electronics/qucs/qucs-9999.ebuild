# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils git-2 autotools

DESCRIPTION="Quite Universal Circuit Simulator is a Qt based circuit simulator"
HOMEPAGE="http://qucs.sourceforge.net/"
EGIT_PROJECT=${PN}
EGIT_REPO_URI="git://git.code.sf.net/p/qucs/git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtcore:4
	dev-qt/qt3support:4
	dev-qt/qtxmlpatterns:4
	>=sci-electronics/freehdl-0.0.7
	sci-electronics/adms"
DEPEND="${RDEPEND}"

src_prepare() {
	cd qucs
	# Maybe export QTDIR work...
	sed -i 's:paths="$QTDIR/lib:paths="/usr/lib/qt4:' configure.ac || die
	eautoreconf
	cd ../qucs-core
	eautoreconf
	sed -i 's:hicumL2V2p31n.core.h::g' src/components/verilog/Makefile.in || die
}

src_configure() {
	cd qucs
	econf --enable-maintainer-mode
	cd ../qucs-core
	econf --with-mkadms=/usr/bin/admsXml --enable-maintainer-mode
}

src_compile() {
	cd qucs
	emake || die
	cd ../qucs-core
	emake || die
}

src_install() {
	cd qucs
	emake install DESTDIR="${D}" || die
	cd qucs-core
	emake install DESTDIR="${D}" || die

	# Need to make doc...
	
#	newicon qucs/bitmaps/big.qucs.xpm qucs.xpm || die
#	make_desktop_entry qucs Qucs qucs "Qt;Science;Electronics"
}
