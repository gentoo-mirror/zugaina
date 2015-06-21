# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://forums.gentoo.org/viewtopic-t-438701.html - The site http://gentoo.zugaina.org/ only host a copy.

inherit eutils

DESCRIPTION="A multithreaded MPD client for Audioscrobbler"
HOMEPAGE="http://scmpc.berlios.de"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-misc/curl-7.10.0
   dev-libs/libdaemon
   dev-libs/confuse
   dev-libs/argtable"
RDEPEND=""

src_install() {
   make DESTDIR="${D}" install || die "Install failed!"
}

pkg_postinst() {
   echo
   einfo "You will need to set up your scmpc.conf file before running scmpc"
   einfo "for the first time. An example has been installed in"
   einfo "${ROOT}usr/share/scmpc/scmpc.conf, which can be copied to"
   einfo "${ROOT}etc/scmpc.conf. For more details, please see the scmpc(1)"
   einfo "manual page."
   echo
}