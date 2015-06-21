# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils games

MY_P=${PN}_${PV/./_}
DESCRIPTION="Invasion - Battle of Survival is a real-time strategy game using the Stratagus game engine"
HOMEPAGE="http://bos.seul.org/"
SRC_URI="http://bos.seul.org/files/${MY_P}.tar.gz
	http://dev.gentoo.org/~genstef/files/bos.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="=games-engines/stratagus-2.2*"

S=${WORKDIR}

src_install() {
	dodir "${GAMES_BINDIR}"
	echo "${GAMES_BINDIR}/stratagus -d \"${GAMES_DATADIR}\"/${PN} \$*" >> "${D}${GAMES_BINDIR}/${PN}"
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data.bos/* || die "doins failed"

	dodoc README.txt

	doicon "${DISTDIR}"/bos.png
	make_desktop_entry ${PN} "Invasion - Battle of Survival"
	prepgamesdirs
}
