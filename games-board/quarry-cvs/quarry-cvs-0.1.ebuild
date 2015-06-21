# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

ECVS_SERVER="cvs.gna.org:/cvs/quarry"
ECVS_MODULE="quarry"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"

inherit games cvs

DESCRIPTION="A GUI for Go, Amazons and Othello. It allows users to play against computer players (third-party programs, e.g. GNU Go) or other humans (CVS version)."
DESCRIPTION_FR="Une interface pour les jeux de Go, Amazons et Othello. Permet de jouer contre l'ordinateur avec le programme GNU Go (Version CVS)"
HOMEPAGE="http://home.gna.org/quarry/index.html"
S=${WORKDIR}/${ECVS_MODULE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.4.0
	>=gnome-base/librsvg-2.5"

src_install() {
    egamesinstall || die
}