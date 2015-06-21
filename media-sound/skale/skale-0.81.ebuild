# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=57507 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit eutils

CUSTOM_P="skale081"
D_DIR="/opt/${PN}"

RESTRICT="nomirror nostrip"
DESCRIPTION="Sk@le Tracker - FastTracker 2 clone"
HOMEPAGE="http://www.skale.org/"
SRC_URI="ftp://ftp.scenesp.org/pub/skale/${CUSTOM_P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc"
DEPEND="app-arch/unzip"
RDEPEND="virtual/libc
	media-libs/libsdl"
S=${WORKDIR}/Skale081

src_unpack() {
    unzip -q ${DISTDIR}/${A} || die "Sk@le unpacking failed"
}

src_install() {
	dodir ${D_DIR}

	# setting up wrapper script
	mv Skale.x86 skale.bin
	cp ${FILESDIR}/skale.wrapper-0.80a skale

	# installing bin/wrapper
	exeinto ${D_DIR}
	doexe skale.bin
	doexe skale
	fowners root:audio ${D_DIR}/skale.bin
	fowners root:audio ${D_DIR}/skale

	# installing misc data
	insinto ${D_DIR}
	doins Skale.dat
	dodir ${D_DIR}/Skins
	insinto ${D_DIR}/Skins
	doins Skins/*.sks

	# installing doc
	if use doc; then
		dohtml -r Docs/*
	fi

	# installing config files
	dodir /etc/${PN}
	insinto /etc/${PN}
	cp ${FILESDIR}/config-SkaleLinux.cfg-0.80a SkaleLinux.cfg
	doins KeybLinux.cfg SkaleLinux.cfg

	# making some symlinks
	dosym /etc/${PN}/KeybLinux.cfg ${D_DIR}/KeybLinux.cfg
	dosym /etc/${PN}/SkaleLinux.cfg ${D_DIR}/SkaleLinux.cfg
	dodir /usr/bin
	dosym ${D_DIR}/skale /usr/bin/skale
}

pkg_postinst () {
	# some comments
	einfo ""
	einfo "to run Sk@le Tracker -> /usr/bin/skale"
	einfo ""
	einfo "To customize your Sk@le settings, edit the file"
	einfo "/etc/${PN}/SkaleLinux.cfg"
	einfo ""
}
