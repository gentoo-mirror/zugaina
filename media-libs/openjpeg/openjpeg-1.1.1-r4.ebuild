# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs multilib subversion
ESVN_REPO_URI="http://www.openjpeg.org/svn/trunk"
ESVN_PATCHES="${FILESDIR}/${PVR}/${P}-dwt-v3.patch"
DESCRIPTION="An open-source JPEG 2000 codec written in C"
HOMEPAGE="http://www.openjpeg.org/"
#SRC_URI="http://www.openjpeg.org/openjpeg_v${PV//./_}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#S="${WORKDIR}/OpenJPEG"

src_compile() {
#	unpack ${A}
#	cd ${S}
#	epatch "${FILESDIR}"/${PVR}/${P}-cvs-372.patch
#	cd ..
#	epatch "${FILESDIR}"/${PVR}/${PN}-1.1-makefile.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-memset.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-static-luts.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-flag-type.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-formatting-cleanup.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-use-prefix-increment.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-consolidate-redundant-calculations.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-dynamic-array.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-float.patch
#	epatch "${FILESDIR}"/${PVR}/${P}-t1-autovectorize.patch
	
#	epatch "${FILESDIR}"/${P}-dwt-v3.patch
	append-flags -fPIC
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" COMPILERFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dodir /usr/$(get_libdir)
	emake DESTDIR=${D} install || die "install failed"

	insinto /usr/include
	doins libopenjpeg/openjpeg.h

	dodoc README.linux
}
