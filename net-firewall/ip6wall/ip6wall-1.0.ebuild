# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A bash firewall script for ip6tables."
HOMEPAGE="http://www.no-net.org/ip6wall/"
SRC_URI="http://www.no-net.org/miasma/ip6wall/download/ip6wall-1.0.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"
RDEPEND=">=net-firewall/iptables-1.2.5"

src_install() {
	exeinto /etc/ip6wall
	doexe ${S}/*
	exeinto /etc/ip6wall/scripts
	doexe ${S}/scripts/*
	dosym /etc/ip6wall/ip6wall.sh /etc/init.d/ip6wall	
}

pkg_postinst () {
	einfo "Don't forget to add the 'ip6wall' startup script  to your default"
	einfo "runlevel by typing the following command:"
	einfo ""
	einfo "	 rc-update add ip6wall default"
	einfo ""
	einfo "You need to edit /etc/ip6wall/ip6wall.conf before using"
	einfo "it.  Enter the right vars in the file, start the script"
	einfo "by typing: '/etc/init.d/ip6wall start' and it should work."
	einfo ""
	einfo "Don't forget to change the path to iptables!!!"
	einfo ""
	einfo "Note: If You are stopping the firewall, all iptables rulesets"
	einfo "will be flushed!!!"
	einfo ""
}
