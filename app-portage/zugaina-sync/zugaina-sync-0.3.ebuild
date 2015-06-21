# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="Script to sync with Zugaina portage"
DESCRIPTION_FR="Script pour se synchroniser avec l'arbre de portage de Zugaina"

HOMEPAGE="http://gentoo.zugaina.org/"
SRC_URI="http://distfiles.zugaina.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa mips arm amd64 ia64 ppc64 ppc-macos"
IUSE=""

RESTRICT="nomirror"
RDEPEND=">=sys-apps/portage-2.0.50"

src_install() {
	dodir /bin/
	exeinto /bin
	doexe zugaina-webrsync || die
}

pkg_postinst() {
    einfo ""
    ewarn "To use Zugaina portage, you MUST add this to /etc/make.conf :"
    ewarn "PORTDIR_OVERLAY=\"/usr/local/zugaina-portage\""
    einfo ""
}