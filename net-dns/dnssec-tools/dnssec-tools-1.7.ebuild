# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils autotools toolchain-funcs flag-o-matic

DESCRIPTION=""
HOMEPAGE="http://www.isc.org/software/bind"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="SPARTA"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ipv6 nsec3 dlv"

DEPEND="dev-perl/Net-DNS
	dev-perl/Net-DNS-SEC
	perl-core/ExtUtils-MakeMaker
	perl-core/Text-Tabs+Wrap
	perl-core/MIME-Base32
	dev-perl/TimeDate
	dev-perl/MailTools
	media-gfx/graphviz
	dev-perl/GraphViz"

RDEPEND="${DEPEND}"

src_configure() {
	local myconf=""

	econf \
		$(use_with ipv6) \
		$(use_with nsec3) \
		$(use_with-dlv) \
		--with-resolv-conf=/etc/resolv.conf \
		--with-root-hints=/etc/dnssec-tools/root.hints \
		--sysconfdir=/etc
		${myconf}
}

src_install() {
	sed -i 's:$(MKPATH) $(mandir):$(MKPATH) $(DESTDIR)/$(mandir):g' Makefile
	emake DESTDIR="${D}" install || die
	dodoc COPYING INSTALL NEWS README ChangeLog || die
}

pkg_postinst() {
	einfo "Run 'dtinitconf' in order to set up the required /etc/dnssec-tools/dnssec-tools.conf file"
}
