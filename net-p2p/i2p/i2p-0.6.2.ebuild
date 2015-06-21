# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="I2P is an anonymous network, exposing a simple layer that applications can use to anonymously and securely send messages to each other."
SRC_URI="http://mirror.i2p2.de/i2pheadless_${PV}.tar.bz2"
HOMEPAGE="http://www.i2p.net/"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
IUSE=""
DEPEND="virtual/jre"

S=${WORKDIR}/${PN}


src_install() {
	dodir /opt/i2p /usr/bin
	cp -r "${S}"/* "${D}"/opt/i2p/
	chmod u+x "${D}"/opt/i2p/postinstall.sh
	chmod 755 "${D}"/opt/i2p/i2prouter
	chmod 755 "${D}"/opt/i2p/osid
	chmod 755 "${D}"/opt/i2p/*.config
	if [ "${ARCH}" == "x86" ] ; then
	    cp "${D}"/opt/i2p/lib/wrapper/linux/libwrapper.so "${D}"/opt/i2p/lib/
	    cp "${D}"/opt/i2p/lib/wrapper/linux/wrapper.jar "${D}"/opt/i2p/lib/
	    cp "${D}"/opt/i2p/lib/wrapper/linux/i2psvc "${D}"/opt/i2p/
	elif [ "${ARCH}" == "amd64" ] ; then
	    cp "${D}"/opt/i2p/lib/wrapper/linux64/libwrapper.so "${D}"/opt/i2p/lib/
	    cp "${D}"/opt/i2p/lib/wrapper/linux64/wrapper.jar "${D}"/opt/i2p/lib/
	    cp "${D}"/opt/i2p/lib/wrapper/linux64/i2psvc "${D}"/opt/i2p/
	fi
	
	chmod 755 "${D}"/opt/i2p/i2psvc
	chmod 755 "${D}"/opt/i2p/scripts/i2pbench.sh
	chmod 755 "${D}"/opt/i2p/scripts/i2ptest.sh
	rm -rf "${D}"/opt/i2p/icons
	rm -rf "${D}"/opt/i2p/lib/wrapper
	rm -f "${D}"/opt/i2p/lib/*.dll
	rm -f "${D}"/opt/i2p/*.bat
	chmod 755 "${D}"/opt/i2p
	dosym "${D}"/opt/i2p/i2prouter /usr/bin/i2prouter
}

pkg_postinst() {
	einfo "Configure the router now : http://localhost:7657/index.jsp"
	einfo "Use 'i2prouter start' to run I2P and 'i2prouter stop' to stop it."
}