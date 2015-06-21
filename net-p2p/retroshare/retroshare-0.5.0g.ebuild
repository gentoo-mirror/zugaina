# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils qt4-r2 versionator

MY_PN="RetroShare_v"
MY_P="${MY_PN}${PV}"
DESCRIPTION="P2P private sharing application - Library component"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/${MY_P}.tar.gz"
S="${WORKDIR}/v0.5.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui nogui debug"

RDEPEND="=net-libs/libretroshare-${PV}
	x11-libs/qt-core:4
	gui? ( x11-libs/qt-gui:4
	x11-libs/qt-opengl:4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-gui-${PV}-qmake.patch"
	epatch "${FILESDIR}/${PN}-nogui-${PV}.patch"
	epatch "${FILESDIR}/${PN}-gui-${PV}-gcc-4.5.patch"
}

src_configure() {
	if use gui; then
		cd ${S}/${PN}-gui/src
		eqmake4 RetroShare.pro
	fi
	if use nogui; then
		cd ${S}/${PN}-nogui/src
		eqmake4 ${PN}-nogui.pro
	fi
}

src_compile() {
	if use gui; then
		cd ${S}/${PN}-gui/src
		emake || die
	fi
	if use nogui; then
		cd ${S}/${PN}-nogui/src
		emake || die
	fi
}

src_install() {
	if use gui; then
		cd ${S}/${PN}-gui/src
		emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die
	fi
	if use nogui; then
		cd ${S}/${PN}-nogui/src
		emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die
	fi
}

pkg_postinst() {
	if use gui; then
		einfo "The GUI executable name is: RetroShare"
	fi
	if use nogui; then
		einfo "The NOGUI executable name is: retroshare-nogui"
	fi
}
