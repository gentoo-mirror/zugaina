# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official tor ebuild

inherit eutils

MY_P="${PN}-${PV/_alpha/-alpha}"

DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://tor.eff.org"
SRC_URI="http://tor.eff.org/dist/${MY_P}.tar.gz"
RESTRICT="nomirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-libs/openssl
	dev-libs/libevent"
RDEPEND="net-proxy/tsocks"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup tor
	enewuser tor -1 -1 /var/lib/tor tor
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/torrc.sample-0.1.0.16.patch
}

src_install() {
	exeinto /etc/init.d ; newexe "${FILESDIR}"/tor.initd tor
	make DESTDIR="${D}" install || die

	dodoc README ChangeLog AUTHORS INSTALL \
		doc/{CLIENTS,FAQ,HACKING,TODO} \
		doc/{control-spec.txt,rend-spec.txt,tor-doc.css,tor-doc.html,tor-spec.txt}

	dodir /var/lib/tor
	dodir /var/log/tor
	fperms 750 /var/lib/tor /var/log/tor
	fowners tor:tor /var/lib/tor /var/log/tor
}

pkg_postinst() {
	einfo "You must create /etc/tor/torrc, you can use the sample that is in that directory"
	einfo "To have privoxy and tor working together you must add:"
	einfo "forward-socks4a / localhost:9050 ."
	einfo "to /etc/privoxy/config"
}
