# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://darimasen.berlios.de/ - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

ESVN_REPO_URI="svn://svn.berlios.de/darimasen/trunk"
ESVN_PROJECT="darimasen"
ESVN_BOOTSTRAP="autogen.sh"
inherit subversion

DESCRIPTION="A file manager with menu-based navigation (SVN version)"
DESCRIPTION_FR="Un gestionnaire de fichiers (Version SVN)"
HOMEPAGE="http://darimasen.berlios.de/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
SLOT="0"

DEPEND=">=dev-libs/libsigc++-2.0.3
        >=dev-cpp/gtkmm-2.4.11
        >=dev-cpp/gnome-vfsmm-2.6.0
        x11-themes/gnome-icon-theme"
RDEPEND="!x11-misc/darimasen"

src_compile() {
	export WANT_AUTOCONF=2.5

	./configure --prefix=/usr ${myconf} || die
	emake || die
}

src_install() {
	einfo "Installing..."
	make DESTDIR=${D} install || die "make install failed"
	dodoc README* AUTHORS TODO* COPYING
}
