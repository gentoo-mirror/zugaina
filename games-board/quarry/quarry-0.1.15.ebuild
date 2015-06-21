# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit games

DESCRIPTION="A GUI for Go, Amazons and Othello. Allows to play against computer players or other humans."
DESCRIPTION_FR="Une interface pour les jeux de Go, Amazons et Othello. Permet de jouer contre l'ordinateur avec le programme GNU Go"
HOMEPAGE="http://home.gna.org/quarry/index.html"
SRC_URI="http://download.gna.org/quarry/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.4.0
	>=gnome-base/librsvg-2.5"

src_install() {
    egamesinstall || die
}