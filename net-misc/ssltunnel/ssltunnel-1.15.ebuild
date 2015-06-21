# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="SSLTunnel is a client/server program to create a PPP connection over a SSL/TLS session."
DESCRIPTION_FR="SSLTunnel est un ensemble client/serveur permettant de créer une liaison PPP au dessus d'une session SSL/TLS."
HOMEPAGE="http://ssltunnel.sourceforge.net/"
SRC_URI="mirror://sourceforge/ssltunnel/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=""

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

src_compile() {
	econf || die 'econf failed'
	emake || die 'emake failed'
}

src_install() {
	make install DESTDIR=${D} || die 'make install failed'
	dodir /usr/local/etc/ssltunnel /etc/init.d
	exeinto /etc/init.d
	doexe server/pppserver.sh
	insinto /usr/local/etc/ssltunnel
	doins server/users
	dodoc LICENSE TODO ChangeLog README
}

pkg_postinst() {
    ewarn "edit /usr/local/etc/ssltunnel/users and tunnel.conf"
    ewarn "You should really read /usr/share/docs/README.gz"
}