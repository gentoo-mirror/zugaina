# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=143280 - The site http://gentoo.zugaina.org/ only host a copy.

DESCRIPTION="A graphical GPS data manager that supports several devices."
SRC_URI="http://www.ncc.up.pt/gpsman/gpsmanhtml/${P}.tgz"
HOMEPAGE="http://www.ncc.up.pt/gpsman/wGPSMan.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=sci-libs/gpsmanshp-1.2"

GPSDIR="/usr/lib/gpsman/"

src_install() {
	unpack ${A} || die "failed to unpack"

	sed -i -e "s:gmsrc:${GPSDIR}/gmsrc:" gpsman.tcl \
		|| die "failed to update gmsrc path"

	for t in ./ ./gmsrc ./util
		do
			dodir ${GPSDIR}${t} || die "failed to create ${t}"
			insinto ${GPSDIR}${t} && \
			doins ${t}/* || die "failed to install files into ${t}"
		done

	fperms 555 ${GPSDIR}/gpsman.tcl ${GPSDIR}/util/* || die "failed to set permissions"

	if use doc ; then
		doman "${S}"/man/man1/gpsman.1 || die "failed to install man page"
		dodoc manual/* || die "failed to install manual"
	fi
}

pkg_postinst() {
	einfo "Support for the Garmin USB protocal requires a"
	einfo "kernel >= version 2.6.11 and the USB_SERIAL_GARMIN"
	einfo "option set. See ${GPSDIR}/manual for more info."
	einfo ""
	einfo "To run GPSMan: $ ${GPSDIR}/gpsman.tcl"
}

