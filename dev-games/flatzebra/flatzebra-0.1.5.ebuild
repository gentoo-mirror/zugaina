# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A generic game engine for 2D double-buffering animation"
HOMEPAGE="http://perso.b2b2c.ca/sarrazip/dev"
SRC_URI="http://perso.b2b2c.ca/sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i \
		-e '/^doc_DATA =/s/^/NOTHANKS/' \
		Makefile.in \
		|| die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README THANKS TODO
}
