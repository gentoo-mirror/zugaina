# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

DESCRIPTION="A code generator that converts electrical compact device models specified in high-level description language into ready-to-compile c code for the API of spice simulators."
HOMEPAGE="http://sourceforge.net/projects/mot-adms/"
SRC_URI="mirror://sourceforge/mot-adms/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/GD"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}_2.30_1180

src_prepare() {
	eautoreconf
}

src_configure() {
	chmod u+x configure
	econf --prefix=/usr
}

src_install() {
	emake install DESTDIR="${D}" || die
}