# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/cal3d/cal3d-0.12-r493.ebuild,v 1.5 2007/12/10 14:15:58 loux.thefuture Exp $

DESCRIPTION="Cal3D is a skeletal based character animation library"
HOMEPAGE="http://home.gna.org/cal3d"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${PF}.tar.bz2
http://loux.thefuture.free.fr/distfiles/${PF}.tar.bz2"

inherit eutils

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ppc ~x86 ~x86-fbsd"
IUSE="16bit-indices debug"

DEPEND=""

src_compile() {
	cd cal3d
	autoreconf --install --force
	econf \
		$(use_enable debug) \
		$(use_enable 16bit-indices) \
		|| die
	emake || die
}

src_unpack() {
       unpack ${A}
       cd "cal3d/src"
       epatch "${FILESDIR}"/strcasecmp_cal3d_converter.patch
       cd "cal3d"
       epatch "${FILESDIR}"/auto_ptr_loader.patch
}

src_install() {
	cd cal3d
	einstall || die
}
