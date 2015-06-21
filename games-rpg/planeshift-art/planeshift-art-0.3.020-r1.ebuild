# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/planeshift-art/planeshift-art-0.3.020-r1.ebuild,v 1.3 2007/10/14 12:00:00 loux.thefuture Exp $

inherit games eutils

DESCRIPTION="Virtual fantasy world MMORPG"
HOMEPAGE="http://www.planeshift.it/"
MY_ART="art-0.3.020.tar.bz2"
MY_DATA="data-0.3.020.tar.bz2"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${MY_ART} http://dev.gentooexperimental.org/~loux/distfiles/${MY_DATA}"

LICENSE="PlaneShift"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=games-rpg/planeshift-0.3.020"

PLANESHIFT_PREFIX=/opt/planeshift
P_ART_PREFIX=/opt/planeshift/bin/art
P_DATA_PREFIX=/opt/planeshift/bin/data

src_unpack() {
	check_license ${FILESDIR}/PlaneShift
	einfo "create ART folder"
	mkdir -p "${S}/${P_ART_PREFIX}"
	cd "${S}/${P_ART_PREFIX}"
	einfo "unpack ART"
	unpack ${MY_ART}

	einfo "create DATA folder"
	mkdir -p "${S}/${P_DATA_PREFIX}"
	cd "${S}/${P_DATA_PREFIX}"
	einfo "unpack DATA"
	unpack ${MY_DATA}
}

src_install() {
	dodir ${PLANESHIFT_PREFIX}/bin
	einfo "copy ART to ${D}"
	cp -R "${S}/${P_ART_PREFIX}" ${D}${PLANESHIFT_PREFIX}/bin/.
	einfo "copy DATA to ${D}"
	cp -R "${S}/${P_DATA_PREFIX}" ${D}${PLANESHIFT_PREFIX}/bin/.

	chgrp -R games "${D}${PLANESHIFT_PREFIX}"
	chmod -R g+rw "${D}${PLANESHIFT_PREFIX}"
}

