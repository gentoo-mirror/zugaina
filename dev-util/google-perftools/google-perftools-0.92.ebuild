# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=107544 - The site http://gentoo.zugaina.org/ only host a copy.


inherit autotools

DESCRIPTION="Google profiling tools."
HOMEPAGE="http://goog-perftools.sourceforge.net/"
SRC_URI="http://google-perftools.googlecode.com/files/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="sys-libs/libunwind"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "make failed"
}

src_install() {
	dodoc AUTHORS ChangeLog README TODO

	if useq doc ; then
		dohtml -A gif -r doc/*
	fi

	make DESTDIR=${D} install || die "install failed"
}
