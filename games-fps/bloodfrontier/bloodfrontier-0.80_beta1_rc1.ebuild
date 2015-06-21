# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib games

DESCRIPTION="free multiplayer/singleplayer first person shooter (use Cube Engine 2)"
HOMEPAGE="http://bloodfrontier.com/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-B1-RC1-linux.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND="sys-libs/glibc
	x86? (
		media-libs/libsdl
		media-libs/sdl-mixer
		media-libs/sdl-image
		media-libs/libpng
		virtual/opengl
	)
	amd64? (
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-sdl
	)"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	find -name CVS -print0 | xargs -0 rm -rf
}

src_install() {
	use amd64 && multilib_toolchain_setup x86

	exeinto "$(games_get_libdir)"/${PN}
	doexe bin/bf{client,server} || die

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die

	local x
	for x in client server ; do
		newgamesbin "${FILESDIR}"/wrapper ${PN}_${x}-bin || die
		sed -i \
			-e "s:@GENTOO_GAMESDIR@:${GAMES_DATADIR}/${PN}:g" \
			-e "s:@GENTOO_EXEC@:$(games_get_libdir)/${PN}/bf${x}:g" \
			"${D}/${GAMES_BINDIR}"/${PN}_${x}-bin
	done

	dohtml -r README.html docs

	make_desktop_entry ${PN}_client-bin ${PN}

	prepgamesdirs
}
