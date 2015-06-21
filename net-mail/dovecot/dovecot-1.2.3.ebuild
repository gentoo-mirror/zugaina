# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=276480

EAPI="2"

inherit eutils versionator

major_minor="$( get_version_component_range 1-2 "${PV}" )"
sieve_version="0.1.11"
managesieve_version="0.11.8"
SRC_URI="http://dovecot.org/releases/${major_minor}/${P}.tar.gz
	sieve? ( http://www.rename-it.nl/dovecot/${major_minor}/dovecot-${major_minor}-sieve-${sieve_version}.tar.gz )
	managesieve? (
		http://www.rename-it.nl/dovecot/${major_minor}/dovecot-${PV}-managesieve-${managesieve_version}.diff.gz
		http://www.rename-it.nl/dovecot/${major_minor}/dovecot-${major_minor}-managesieve-${managesieve_version}.tar.gz
	)"
DESCRIPTION="An IMAP and POP3 server written with security primarily in mind"
HOMEPAGE="http://www.dovecot.org/"

SLOT="0"
LICENSE="LGPL-2.1" # MIT too?
KEYWORDS="~amd64 ~x86"

IUSE="berkdb bzip2 caps cydir dbox doc kerberos ldap lucene maildir managesieve mbox mysql pam postgres sieve sqlite ssl suid vpopmail zlib"

DEPEND="berkdb? ( sys-libs/db )
	caps? ( sys-libs/libcap )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	lucene? ( dev-cpp/clucene )
	mysql? ( virtual/mysql )
	pam? ( virtual/pam )
	postgres? ( virtual/postgresql-base )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	vpopmail? ( net-mail/vpopmail )"

RDEPEND="${DEPEND}"

pkg_setup() {
	if use managesieve && ! use sieve; then
		eerror "managesieve USE flag selected but sieve USE flag unselected"
		die "USE flag problem"
	fi

	# Add user and group for login process (same as for fedora/redhat)
	enewgroup dovecot 97
	enewuser dovecot 97 -1 /dev/null dovecot
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	use managesieve && epatch "${WORKDIR}"/dovecot-${PV}-managesieve-${managesieve_version}.diff
}

src_configure() {
	local conf=""

	if use postgres || use mysql || use sqlite; then
		conf="${conf} --with-sql=plugin"
	fi

	use ldap && conf="${conf} --with-ldap=plugin"
	use kerberos && conf="${conf} --with-gssapi=plugin"

	local storages=""
	for storage in cydir dbox maildir mbox; do
		use ${storage} && storages="${storages} ${storage}"
	done
	[ "${storages}" ] || storages="maildir"

	econf \
		--sysconfdir=/etc/dovecot \
		--localstatedir=/var \
		--with-moduledir="/usr/$( get_libdir )/dovecot" \
		$( use_with berkdb db ) \
		$( use_with bzip2 bzlib ) \
		$( use_with caps libcap ) \
		$( use_with lucene ) \
		$( use_with mysql ) \
		$( use_with pam ) \
		$( use_with postgres pgsql ) \
		$( use_with sqlite ) \
		$( use_with ssl ) \
		$( use_with vpopmail ) \
		$( use_with zlib ) \
		--with-storages="${storages}" \
		--with-pic \
		--enable-header-install \
		${conf} \
		|| die "configure failed"

	if use sieve; then
		# The sieve plugin needs this file to be build to determine the plugin
		# directory and the list of libraries to link to.
		emake dovecot-config || die "emake dovecot-config failed"
		cd "../dovecot-${major_minor}-sieve-${sieve_version}"
		econf --with-dovecot="${S}"

		if use managesieve; then
			cd "../dovecot-${major_minor}-managesieve-${managesieve_version}"
			econf --with-dovecot="${S}" --with-dovecot-sieve="../dovecot-${major_minor}-sieve-${sieve_version}"
		fi
	fi
}

src_compile() {
	emake || die "make failed"

	if use sieve; then
		cd "../dovecot-${major_minor}-sieve-${sieve_version}"
		emake || die "make failed"

		if use managesieve; then
			cd "../dovecot-${major_minor}-managesieve-${managesieve_version}"
			emake || die "make failed"
		fi
	fi
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	use suid && fperms u+s /usr/libexec/dovecot/deliver

	rm -f "${D}"/etc/dovecot/*.conf

	newinitd "${FILESDIR}"/dovecot.init-r2 dovecot

	rm -rf "${D}"/usr/share/doc/dovecot
	use doc && dodoc AUTHORS NEWS README TODO dovecot-example.conf doc/dovecot-{db,dict-sql,ldap,sql}-example.conf doc/{securecoding,auth-protocol,documentation}.txt doc/dovecot-openssl.cnf 

	if use sieve; then
		cd "../dovecot-${major_minor}-sieve-${sieve_version}"
		emake DESTDIR="${D}" install || die "make install failed"

		if use managesieve; then
			cd "../dovecot-${major_minor}-managesieve-${managesieve_version}"
			emake DESTDIR="${D}" install || die "make install failed"
		fi
	fi

	dodir /var/run/dovecot
	fowners root:root /var/run/dovecot
	fperms 0755 /var/run/dovecot
	keepdir /var/run/dovecot/login
	fowners root:dovecot /var/run/dovecot/login
	fperms 0750 /var/run/dovecot/login
	
	ewarn "If you are upgrading from Dovecot 1.1, read "
	ewarn " http://wiki.dovecot.org/Upgrading/1.2"
	if use sieve; then
		ewarn "Read this too: "
		ewarn " http://wiki.dovecot.org/LDA/Sieve/Dovecot#Migration_from_CMUSieve"
	fi
}
