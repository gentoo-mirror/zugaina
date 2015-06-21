# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
AT_M4DIR=m4

inherit eutils autotools

MY_PV=${PV/_/.}
MY_PV2="2.8.3-12-rc1"

DESCRIPTION="Libpcap-based packet sniffer/logger/lightweight IDS"
HOMEPAGE="http://www.snort.org/"
SRC_URI="http://www.snort.org/dl/prerelease/${MY_PV2}/${PN}-${MY_PV}.tar.gz
	http://www.snort.org/pub-bin/downloads.cgi/Download/comm_rules/Community-Rules-2.4.tar.gz
	http://www.snort.org/pub-bin/downloads.cgi/Download/vrt_pr/snortrules-pr-2.4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 -sparc ~x86"
IUSE="postgres mysql selinux odbc prelude inline dynamicplugin timestats perfprofiling linux-smp-stats flexresp2 sguil gre"

DEPEND="virtual/libc
	>=dev-libs/libpcre-4.2-r1
	virtual/libpcap
	flexresp2? ( dev-libs/libdnet )
	react? ( ~net-libs/libnet-1.0.2a )
	postgres? ( || ( dev-db/postgresql dev-db/libpq ) )
	mysql? ( virtual/mysql )
	prelude? ( >=dev-libs/libprelude-0.9.0 )
	odbc? ( dev-db/unixODBC )
	>=sys-devel/libtool-1.4
	inline? (
		~net-libs/libnet-1.0.2a
		net-firewall/iptables
		)"

RDEPEND="${DEPEND}
	dev-lang/perl
	selinux? ( sec-policy/selinux-snort )"

S=${WORKDIR}/${PN}-${MY_PV}

pkg_setup() {
	enewgroup snort
	enewuser snort -1 -1 /dev/null snort

	if use flexresp && use flexresp2 ; then
		ewarn
		ewarn "You have both the 'flexresp' and 'flexresp2' USE"
		ewarn "flags set. You can use 'flexresp' or 'flexresp2'"
		ewarn "but not both."
		ewarn
		ewarn "Defaulting to flexresp2..."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-2.6.1.2-libdir.patch"
	sed -i "s:var RULE_PATH ../rules:var RULE_PATH /etc/snort/rules:" \
		etc/snort.conf

	if use prelude ; then
		sed -i -e "s:AC_PROG_RANLIB:AC_PROG_LIBTOOL:" configure.in
	fi

	einfo "Regenerating autoconf/automake files"
	eautoreconf
}

src_compile() {
	local myconf

	if use flexresp2; then
		myconf="${myconf} --enable-flexresp2"
	fi

	if use react; then
		myconf="${myconf} --enable-react"
	fi

	use gre && myconf="${myconf} --enable-gre"

	myconf="${myconf} --with-libipq-includes=/usr/include/libipq"

	econf \
		--without-oracle \
		$(use_with postgres postgresql) \
		$(use_with mysql) \
		$(use_with odbc) \
		$(use_enable prelude) \
		$(use_enable inline) \
		$(use_enable dynamicplugin) \
		$(use_enable timestats) \
		$(use_enable perfprofiling) \
		$(use_enable linux-smp-stats) \
		${myconf} || die "econf failed"

	# limit to single as reported by jforman on irc
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	keepdir /var/log/snort/

	dodoc doc/*
	dodoc ./RELEASE.NOTES
	docinto schemas ; dodoc schemas/*

	insinto /etc/snort
	doins etc/reference.config etc/classification.config \
		etc/*.map etc/threshold.conf
	use dynamicplugin || sed -i -e 's:^dynamic:# dynamic:g' etc/snort.conf
	sed -e "s:/usr/local/lib:/usr/$(get_libdir):g" -e 's:/usr/local/:/usr/:g' \
		etc/snort.conf > "${D}"/etc/snort/snort.conf.distrib

	newinitd "${FILESDIR}/snort.rc8" snort
	newconfd "${FILESDIR}/snort.confd" snort

	fowners snort:snort /var/log/snort
	fperms 0770 /var/log/snort

	# install rules
	insinto /etc/snort/rules
	doins -r "${WORKDIR}"/rules/*
}

pkg_postinst() {
	ewarn
	ewarn "If you find that snort is using too much memory, your system"
	ewarn "freezes, or snort crashes after a few minutes try adding the"
	ewarn "following to your snort.conf..."
	ewarn
	ewarn "'config detection: search-method ac-sparsebands'"
	ewarn
	ewarn "This will provide high pattern matching performance at a much"
	ewarn "lower cost to memory. For more information on the new features"
	ewarn "in snort 2.7, please take a look at the release notes located in..."
	ewarn
	ewarn "  /usr/share/doc/${PF}/RELEASE.NOTES.bz2"
	ewarn
	elog  "To use a database as a backend for snort you will have to"
	elog  "import the correct tables to the database."
	elog  "You will have to setup a database called snort before doing the"
	elog  "following..."
	elog
	elog  "  MySQL: bzcat /usr/share/doc/${PF}/schemas/create_mysql.bz2 | mysql -p snort"
	elog
	elog  "  PostgreSQL: import /usr/share/doc/${PF}/schemas/create_postgresql.bz2"
	elog
	elog  "  ODBC: look at /usr/share/doc/${PF}/schemas/"
	elog
	elog  "Users using the unified output plugin and barnyard do not need to"
	elog  "compile database support into snort, but still need to set up their"
	elog  "database as shown above."
	elog
	ewarn "Only a basic set of rules was installed."
	ewarn "Please add your other sets of rules to /etc/snort/rules."
	ewarn "For more information on rules, visit ${HOMEPAGE}."
	if use sguil ; then
		elog "SGUIL needs to catch up with recent snort. If you plan on using SGUIL"
		elog "you should unmerge ${P} and emerge snort-2.4.x"
	fi
}
