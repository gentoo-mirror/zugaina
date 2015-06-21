# Copyright 2008 SpringLobby.info
# Distributed under the terms of the GNU General Public License, v2 or later
# EBuild Author: Kaot
# EMail: Kaot@SpringLobby.info
# Author of the Modification: Thorh3
####
# Ycarus : This ebuild come from spring overlay with small modifications
####

inherit games

DESCRIPTION="Spring - Modification - NOTA 1.56"
HOMEPAGE="http://spring.jobjol.nl/show_file.php?id=1988"
LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"

SRC_URI="http://spring.vsync.de/5/NOTA156.sd7"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="nomirror"

RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	FILENAME="${A/download.*file=/}"
	cp "${DISTDIR}/${A}" "${WORKDIR}/${FILENAME}"
}

src_install() {
	FILENAME="${A/download.*file=/}"
	insinto "${GAMES_DATADIR}/spring/mods"
	doins -r "${FILENAME}"
	prepgamesdirs
}