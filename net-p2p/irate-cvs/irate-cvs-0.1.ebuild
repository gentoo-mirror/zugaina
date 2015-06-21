# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/linphone/linphone-0.12.1.ebuild,v 1.7 2004/06/24 22:56:15 agriffis Exp $

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

DEPEND="sys-devel/gcc"

pkg_setup () {
    if [ ! -f ${ROOT}/usr/bin/gcj ]
    then
	eerror "you need gcc compiled against gcj"
	eerror "export USE=\"gcj\" ;emerge gcc -p "
	die "Need gcj !"
    fi
}

src_compile() {
#	emake || die
    make || die
}

src_install () {
	make install DESTDIR=${D}
}
