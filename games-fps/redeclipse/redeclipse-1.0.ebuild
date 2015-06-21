# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="free multiplayer/singleplayer first person shooter (use Cube Engine 2)"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}/${PN}_${PV}_linux.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND="sys-libs/glibc
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libpng
	virtual/opengl
	"

S=${WORKDIR}/${PN}

src_install() {
	exeinto "$(games_get_libdir)"/${PN}
	use x86 && doexe bin/re{client,server}_linux
	use amd64 && doexe bin/re{client,server}_linux_64

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data || die

	local x
	for x in client server ; do
		newgamesbin "${FILESDIR}"/wrapper ${PN}_${x}-bin || die
		sed -i \
			-e "s:@GENTOO_GAMESDIR@:${GAMES_DATADIR}/${PN}:g" \
			"${D}/${GAMES_BINDIR}"/${PN}_${x}-bin
		use x86 && sed -i \
			-e "s:@GENTOO_EXEC@:$(games_get_libdir)/${PN}/re${x}_linux:g" \
			"${D}/${GAMES_BINDIR}"/${PN}_${x}-bin
		use amd64 && sed -i \
			-e "s:@GENTOO_EXEC@:$(games_get_libdir)/${PN}/re${x}_linux_64:g" \
			"${D}/${GAMES_BINDIR}"/${PN}_${x}-bin
	done

	make_desktop_entry ${PN}_client-bin ${PN}

	prepgamesdirs
}
