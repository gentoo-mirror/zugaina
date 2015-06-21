# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=63789 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit python eutils 

KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64"
DESCRIPTION="Python FUSE bindings"
HOMEPAGE="http://www.inf.bme.hu/~mszeredi/avfs/"
SRC_URI="http://richard.jones.name/google-hacks/gmail-filesystem/fuse-python.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
S="${WORKDIR}/${PN}"

RDEPEND=">=dev-lang/python-2.3
    	>=sys-fs/fuse-1.3"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/fix_fuse-compat.diff || die "patching failed"
}

src_compile() {
	python setup.py build || die "Couldn't compile"
}

src_install() {
	python setup.py install --prefix=${D}/usr || die "Couldn't install"
}
