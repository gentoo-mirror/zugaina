# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

# Bad but working ebuild... Need to make choice for xml, gconf and gtk.

ESVN_REPO_URI="http://svn.beep-media-player.org/mcs/trunk/mcs"

inherit autotools subversion

DESCRIPTION="Modular configuration system. A library that provides a backend to store an application's configuration with either an XML-file or GConf backend."
HOMEPAGE="http://bmpx.beep-media-player.org/site/Chroma"
LICENSE="GPL-2"
RESTRICT="nomirror"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="dev-libs/boost
	dev-libs/libxml2
	dev-cpp/gconfmm
	dev-cpp/gtkmm
	dev-util/pkgconfig"
	
S=${WORKDIR}/${PN}

src_compile() {
    ./autogen.sh
    econf || die
    emake || die
}

src_install() {
    make DESTDIR=${D} install || die
}