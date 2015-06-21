# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tor/tor-0.2.3.2_alpha-r3.ebuild,v 1.1 2011/08/30 13:57:42 blueness Exp $

EAPI=4

inherit autotools eutils flag-o-matic versionator

#MY_PV="$(replace_version_separator 4 -)"
MY_PV="${PV}.r553"
MY_PF="${PN}-${MY_PV}"
DESCRIPTION="An IP-Transparent Tor Hidden Service Connector"
HOMEPAGE="http://www.cypherpunk.at/onioncat/wiki/OnionCat"
SRC_URI="http://www.cypherpunk.at/ocat/download/Source/0.2.2/${MY_PF}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=""

# The tordns patch for tsocks avoids some leakage of information thus raising anonymity
RDEPEND="${DEPEND}
	net-misc/tor"

src_install() {
	newinitd "${FILESDIR}"/onioncat.initd onioncat
	emake DESTDIR="${D}" install || die
	insinto /var/lib/tor
	doins glob_id.txt hosts.onioncat
	dodoc README ChangeLog
}

pkg_postinst() {
	einfo "Add the following text to the /etc/tor/torrc file :"
	einfo "HiddenServiceDir /var/lib/tor/ocat"
	einfo "HiddenServicePort 8060 127.0.0.1:8060"
	einfo "You should also modify /var/lib/tor/ocat/hostname"
}