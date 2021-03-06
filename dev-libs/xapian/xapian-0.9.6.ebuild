# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official xapian ebuild

DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://www.oligarchy.co.uk/xapian/${PV}/xapian-core-${PV}.tar.gz"
RESTRICT="nomirror"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc
	sys-apps/gawk
	sys-apps/grep
	sys-apps/sed
	sys-devel/libtool
	sys-devel/gcc"

RDEPEND="virtual/libc"

S=${WORKDIR}/xapian-core-${PV}


src_test() {
	if has_version '<=dev-util/valgrind-2.3.0';
	then
		#valgrind-2.2 caused errors here.
		make check VALGRIND= || die "check failed"
	else
		make check || die "check failed"
	fi
}


src_install () {
	emake -j1 DESTDIR="${D}" install || die

	#docs tly et installed under /usr/share/doc/xapian-core,
	# lets move them under /usr/share/doc..
	mv "${D}/usr/share/doc/xapian-core" "${D}/usr/share/doc/${PF}"

	dodoc AUTHORS HACKING PLATFORMS README
}
