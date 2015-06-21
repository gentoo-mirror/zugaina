# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=304733

EAPI=2

inherit autotools confutils eutils multilib

DESCRIPTION="An open-source turn-key solution for DNSSEC"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://distfiles.zugaina.org/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+auditor debug mysql opensc +softhsm sqlite"

DEPEND=">=net-libs/ldns-1.6.4
	>=dev-libs/libxml2-2.6.16
	>=dev-lang/ruby-1.8.7_p249[ssl]
	>=dev-ruby/dnsruby-1.46
	>=dev-python/4suite-1.0.2-r1
	mysql? ( >=virtual/mysql-5.0 )
	opensc? ( >=dev-libs/opensc-0.11.12 )
	softhsm? ( >=dev-libs/softhsm-1.1.3 )
	sqlite? ( >=dev-db/sqlite-3.3.9 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use mysql; then
		ewarn "Use of MySQL is still considered experimental upstream"
	fi

	confutils_require_one mysql sqlite

	enewgroup opendnssec
	enewuser opendnssec -1 -1 -1 opendnssec
}

src_prepare() {
	eautoreconf

	# Patch removes comments to enable privilege dropping: will probably stay for a long time
	#epatch "${FILESDIR}"/"${PN}"-drop-privileges.patch || die "epatch failed"	
}

src_configure() {
	local myconf=""
	use softhsm && myconf="$myconf --with-pkcs11-softhsm=/usr/$(get_libdir)/libsofthsm.so"
	use opensc && myconf="$myconf --with-pkcs11-opensc=/usr/$(get_libdir)/opensc-pkcs11.so"

	econf $myconf \
	$(use_enable auditor) \
	$(use_enable debug timeshift) \
	$(use_enable mysql) 
	# this does not work, but sqlite will be picked up when installed in default location
	#$(use_with sqlite sqlite3)

}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/opendnssec.initd opendnssec || die "newinitd failed"
	dodoc KNOWN_ISSUES NEWS README || die "dodoc failed"
	rm "${D}"/usr/share/opendnssec.spec || die "failed to remove spec file"

	config_files="conf.xml kasp.xml zonelist.xml zonefetch.xml"
	config_base="/etc/opendnssec"
	for file in $config_files; do
		sed -i -e 's/<!-- \$Id:.* \$ -->//g' "${D}$config_base/$file" || die "sed failed on $config_base/$file"
		fowners root:opendnssec "$config_base/$file" || die "fowners failed for $config_base/$file"
	done

	var_dirs="opendnssec opendnssec/signconf opendnssec/signed opendnssec/tmp"
	var_base="/var/lib"
	for dir in $var_dirs; do
		fowners opendnssec:opendnssec "$var_base/$dir" || die "fowners failed for $var_base/$dir"
	done
}


pkg_postinst() {
	if use softhsm; then
		elog "Please make sure that you create your softhsm database in a location readable"
		elog "by the opendnssec user. You can set its location in softhsm.conf"
	fi
}
