# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils qt4-r2

MY_PN="v"
MY_PV="0.5.0b"
MY_P="${MY_PN}${MY_PV}"
DESCRIPTION="P2P private sharing application - Library component"
HOMEPAGE="http://retroshare.sourceforge.net"
SRC_URI="mirror://sourceforge/retroshare/v${MY_PV}.tar.gz"
S="${WORKDIR}/v0.5.0/libretroshare/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-crypt/gpgme
	dev-libs/libgpg-error
	net-libs/libupnp"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PF}.patch"
}
