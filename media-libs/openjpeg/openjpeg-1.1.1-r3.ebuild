# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs multilib

DESCRIPTION="An open-source JPEG 2000 codec written in C"
HOMEPAGE="http://www.openjpeg.org/"
SRC_URI="http://www.openjpeg.org/openjpeg_v${PV//./_}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/OpenJPEG"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-t1-memset.patch
	epatch "${FILESDIR}"/${P}-t1-static-luts.patch
	epatch "${FILESDIR}"/${P}-t1-slviewer-code-block-64.patch
	epatch "${FILESDIR}"/${P}-t1-flag-type.patch
	epatch "${FILESDIR}"/${P}-dwt-v2.patch
}

src_compile() {
	append-flags -fPIC
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" COMPILERFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dodir /usr/$(get_libdir)
	emake INSTALLDIR="${D}usr/$(get_libdir)" install || die "install failed"

	insinto /usr/include
	doins libopenjpeg/openjpeg.h

	dodoc README.linux
}
