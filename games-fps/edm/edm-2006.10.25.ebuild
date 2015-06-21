# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils games

DESCRIPTION="a fork of the Sauerbraten FPS engine which adds new gameplay and engine features."
HOMEPAGE="http://edm-fps.net/"
SRC_URI="http://distfiles.zugaina.org/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libpng
	sys-libs/zlib
	virtual/opengl"

S=${WORKDIR}/${PN}-bin

src_unpack() {
	unpack ${A}
	find -name CVS -print0 | xargs -0 rm -rf
}

src_compile() {
	echo eat
}

src_install() {
	exeinto "${GAMES_LIBDIR}"/${PN}
	doexe bin_unix/${PN}_{client,server}_32 || die

	insinto "${GAMES_DATADIR}"
	doins -r data packages || die

	local x
	for x in client server ; do
		newgamesbin "${FILESDIR}"/wrapper ${PN}_${x}-bin || die
		sed -i \
			-e "s:@GENTOO_GAMESDIR@:${GAMES_DATADIR}:g" \
			-e "s:@GENTOO_EXEC@:${GAMES_LIBDIR}/${PN}/${PN}_${x}_32:g" \
			"${D}/${GAMES_BINDIR}"/${PN}_${x}-bin
	done

	dohtml -r README.html docs/*

	make_desktop_entry ${PN}_client-bin ${PN}

	prepgamesdirs
}
