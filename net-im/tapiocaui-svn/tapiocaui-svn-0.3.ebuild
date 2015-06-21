# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/tapioca-voip/trunk/tapiocaui"

inherit eutils subversion

DESCRIPTION="Tapioca UI"
HOMEPAGE="http://tapioca-voip.sf.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/tapioca-coreclient-svn
	net-im/tapioca-xmpp-svn
	x11-libs/gtk+
	dev-libs/glib"

src_compile() {
    ./autogen.sh
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D}
}