# Copyright 2005 Only copyleft
# Distributed under the terms of GNU v2
# $Header: $
# Ebuild made by Tom Himanen <tom.himanen@raja-antura.org> the site http://gentoo.zugaina.org/ only host it.

S="${WORKDIR}/${P}"
DESCRIPTION="A lightweight text-based DirectConnect client."
SRC_URI="http://savannah.nongnu.org/download/microdc/${P}.tar.gz"
HOMEPAGE="http://www.nongnu.org/microdc/"
KEYWORDS="x86"
LICENSE="GPL-2"
DEPEND=""
RESTRICT="nomirror"
RDEPEND="sys-libs/readline"
SLOT="0"
src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}
