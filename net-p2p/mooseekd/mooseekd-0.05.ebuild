# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils


DESCRIPTION="File-sharing application for the Soulseek peer-to-peer network."
SRC_URI="http://files.beep-media-player.org/releases/mooseekd/mooseekd-0.05.tar.bz2"
RESTRICT="nomirror"
HOMEPAGE="http://bmpx.beep-media-player.org"
SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
IUSE=""
DEPEND=">=dev-cpp/libxmlpp-2.14.0
	dev-libs/glib"
	

src_install() {
    make DESTDIR=${D} install
}

