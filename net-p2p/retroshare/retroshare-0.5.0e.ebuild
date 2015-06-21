# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils qt4-r2

MY_PN="RetroShare_v"
MY_P="${MY_PN}${PV}"
DESCRIPTION="P2P private sharing application - Library component"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/${MY_P}.tar.gz"
S="${WORKDIR}/v0.5.0/retroshare-gui/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="=net-libs/libretroshare-${PV}
	app-crypt/gpgme
	dev-libs/libgpg-error
	net-libs/libupnp
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PF}-qmake.patch"
	epatch "${FILESDIR}/${PF}-gcc-4.5.patch"
	chmod +x "${S}/version_detail.sh"
}
