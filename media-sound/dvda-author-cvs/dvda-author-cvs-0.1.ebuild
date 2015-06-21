# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

ECVS_SERVER="dvd-audio.cvs.sourceforge.net:/cvsroot/dvd-audio"
ECVS_MODULE="dvda-author"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"

inherit eutils cvs

DESCRIPTION="Tools for generating DVD Audio files to be played on standalone DVD Audio players"
HOMEPAGE="http://dvd-audio.sourceforge.net/"
S=${WORKDIR}/${ECVS_MODULE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND="app-cdr/cdrtools"

src_compile() {
    cd src
    make || die "Make failed"
}

src_install() {
    exeinto /usr/bin
    doexe src/dvda-author
    dodoc README CHANGES
}
