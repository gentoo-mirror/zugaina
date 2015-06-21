# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/planeshift-art/planeshift-art-0.3.018-r1.ebuild,v 1.3 2007/04/26 12:00:00 loux.thefuture Exp $

inherit eutils

DESCRIPTION="Virtual fantasy world MMORPG"
HOMEPAGE="http://www.planeshift.it/"
MY_P="PlaneShift_CBV0.3.018.bin"
SRC_URI="http://www.planeshift.eu/downloads/planeshift/linux/${MY_P} http://www.planeshift.it/download/temp/hydlaa_plaza.zip http://mob.xordan.com/mick/bronzedoors.zip"

LICENSE="|| ( GPL-2 Planeshift )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=games-rpg/planeshift-0.3.018"

S=${WORKDIR}/art

PLANESHIFT_PREFIX=/opt/planeshift

src_unpack() {
	cp ${DISTDIR}/${MY_P} ${WORKDIR}/.
	chmod +x ${WORKDIR}/${MY_P}
	${WORKDIR}/${MY_P} --prefix ${WORKDIR} --mode unattended
}

src_install() {
	dodir ${PLANESHIFT_PREFIX}/bin
	cp -R ${WORKDIR}/art ${D}${PLANESHIFT_PREFIX}/bin/.
	cp -R ${WORKDIR}/data ${D}${PLANESHIFT_PREFIX}/bin/.
	cp ${DISTDIR}/hydlaa_plaza.zip ${D}${PLANESHIFT_PREFIX}/bin/art/world/.
	cp ${DISTDIR}/bronzedoors.zip ${D}${PLANESHIFT_PREFIX}/bin/art/world/.

	chgrp -R games "${D}${PLANESHIFT_PREFIX}"
	chmod -R g+rw "${D}${PLANESHIFT_PREFIX}"
}

