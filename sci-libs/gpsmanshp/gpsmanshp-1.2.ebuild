# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=143280 - The site http://gentoo.zugaina.org/ only host a copy.

inherit toolchain-funcs

DESCRIPTION="A Tcl package to read and write shapefiles."
SRC_URI="http://www.ncc.up.pt/gpsmanshp/gpsmanshp_${PV}.tgz"
HOMEPAGE="http://www.ncc.up.pt/gpsmanshp/GPSManSHP.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-lang/tcl-8.4*
        >=sci-libs/shapelib-1.2.10"

src_unpack() {
	unpack ${A} || die "unpack failed"

	# upstream uses an underscore instead of a dash
	mv ${WORKDIR}/${PN}_${PVR} ${WORKDIR}/${PF} || die "rename ${S} failed"

	# fix for bug in tcl-8.4
	cp ${FILESDIR}/package-8.3.tcl ${S}/
}

src_compile() {
	# clean up Makefile from upstream to use user's flags and compiler
	sed -i -e "s:-c:-c ${CFLAGS}:" \
		-e "s:\$(CC):$(tc-getCC):" \
		-e "s:/usr/include/tcl:/usr/lib/tcl:" \
		Makefile || die "failed to update Makefile"

	make pkgIndex.tcl || die "failed to make pkgIndex.tcl"
}

src_install() {
	GPSDIR="/usr/lib/tcl8.4"
	dodir ${GPSDIR} || die "failed to create ${GPSDIR}"
	insinto ${GPSDIR} && \
	doins gpsmanshp.so pkgIndex.tcl || die "failed to install gpsmanshp"
}

