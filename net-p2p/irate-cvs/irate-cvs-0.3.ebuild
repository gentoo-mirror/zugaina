# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# Thanks to Mark Byers for an other search technique for gjc

ECVS_SERVER="cvs.sourceforge.net:/cvsroot/irate"
ECVS_MODULE="irate"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
inherit cvs eutils

IUSE=""

MY_P="irate"
DESCRIPTION="irate"
HOMEPAGE="http://irate.sf.net"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
S=${WORKDIR}/${ECVS_MODULE}

DEPEND="sys-devel/gcc
	sys-apps/which"

pkg_setup () {
    if [ -z "$(which gcj 2>/dev/null)" ]
    then
	eerror "It seems that your system doesn't provides a Java compiler."
	eerror "Re-emerge sys-devel/gcc with \"java\" and \"gcj\" enabled. "
	die "gcj not found"
    fi
}

src_compile() {
    make || die
}

src_install () {
	make install DESTDIR=${D}
}
