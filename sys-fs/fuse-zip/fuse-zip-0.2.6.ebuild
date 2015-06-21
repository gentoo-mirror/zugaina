# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="fuse-zip is a FUSE file system to navigate, extract, create and modify ZIP archives"
HOMEPAGE="http://code.google.com/p/fuse-zip/"
SRC_URI="http://fuse-zip.googlecode.com/files/${P}.tar.gz"
IUSE=""
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=sys-libs/glibc-2.3.3
	>=sys-fs/fuse-2.6.1
	dev-libs/libzip"

RDEPEND=">=sys-fs/fuse-2.6.1"

src_compile() {
	emake || die "Make failed"
}

src_install() {
	sed -i 's:INSTALLPREFIX=/usr:INSTALLPREFIX=${D}/usr:g' Makefile
	make install || die "Install failed"
}
