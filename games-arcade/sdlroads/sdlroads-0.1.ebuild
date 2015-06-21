# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit games

DESCRIPTION="SDLRoads is a cross platform remake of the Bluemoon classic Skyroads."
DESCRIPTION_FR="SDLRoads est un remake de Skyroads."
HOMEPAGE="http://sdlroads.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

RDEPEND="virtual/opengl
	>=media-libs/sdl-mixer-1.2.0
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

src_compile() {
    egamesconf 
    emake || die
}

src_install() {
    make DESTDIR=${D} install || die
}