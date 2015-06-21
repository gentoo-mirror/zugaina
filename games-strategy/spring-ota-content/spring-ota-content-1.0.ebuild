# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from Spring overlay

inherit games

DESCRIPTION="Files required to run certain Spring mods"
HOMEPAGE="http://ipxserver.dyndns.org/games/spring/mods/xta/"
SRC_URI="http://ipxserver.dyndns.org/games/spring/mods/xta/base-ota-content.zip"
LICENSE="unknown"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

DEPEND="${RDEPEND}
app-arch/zip
"

S="${WORKDIR}"

src_install(){
	insinto	"${GAMES_DATADIR}/spring/base"
	doins -r *
	prepgamesdirs
}
