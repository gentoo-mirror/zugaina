# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

MY_P="fortunes-fr-0.02"
DESCRIPTION="set of fortunes in french"
HOMEPAGE="http://www.fortunes-fr.org/ - http://www.le-gnu.net/"
SRC_URI="http://distfiles.zugaina.org/${MY_P}.tar.gz
	http://gnu.free.fr/chapitres/unix/gcu.tgz
	http://gnu.free.fr/chapitres/unix/gge.tgz
	http://gnu.free.fr/chapitres/unix/glp.tgz
	http://gnu.free.fr/chapitres/unix/gmp.tgz
	http://gnu.free.fr/chapitres/unix/gnu.tgz
	http://gnu.free.fr/chapitres/unix/npc.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips amd64"
S="${WORKDIR}/${MY_P}"

DEPEND="games-misc/fortune-mod"

src_compile() {
	econf --with-fortunesdir=/usr/share/fortune/fr/ || die "Configure failed"
	emake || die "Compile failed"
}

src_install() {
    make DESTDIR=${D} install || die "Install failed"
    cd ..
    dodir /usr/share/fortune/fr/
    insinto /usr/share/fortune/fr/
    doins *
}

pkg_postinst() {
    ewarn
    ewarn "If you want to add a fortune when you run bash : "
    ewarn "add \"fortune /usr/share/fortune/fr/\" "
    ewarn "to the end of ~.bashrc"
    ewarn
    sleep 8
}