# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp depend.apache versionator eutils

MY_PB=$(get_version_component_range 1-2)
MY_P="${PN}-${PV/_/}"

DESCRIPTION="Bugzilla is the Bug-Tracking System from the Mozilla project"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/webtools/${MY_P}.tar.gz"
HOMEPAGE="http://www.bugzilla.org"

LICENSE="MPL-1.1 NPL-1.1"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="modperl extras graphviz mysql postgres sasl"

RDEPEND="
	virtual/httpd-cgi
	>=dev-lang/perl-5.8.1
	>=dev-perl/Email-MIME-1.861
	>=dev-perl/DBI-1.41
	>=dev-perl/Email-MIME-Modifier-1.442
	>=dev-perl/Email-Send-2.00
	>=dev-perl/MIME-tools-5.406
	>=dev-perl/Template-Toolkit-2.15
	dev-perl/TimeDate
	>=dev-perl/DateTime-0.28
	>=dev-perl/DateTime-TimeZone-0.71
	dev-perl/URI
	>=virtual/perl-CGI-2.93
	>=virtual/perl-File-Spec-0.84
	>=virtual/perl-MIME-Base64-3.01
	virtual/perl-Digest-SHA
	mysql? ( >=dev-perl/DBD-mysql-4.00.4-r1 )
	postgres? ( >=dev-perl/DBD-Pg-1.45 )
	graphviz? ( media-gfx/graphviz )
	sasl? ( dev-perl/Authen-SASL )
	modperl? (
		>=dev-perl/Apache-DBI-0.96
		>=virtual/perl-CGI-3.11
		=www-apache/mod_perl-2*
	)

	extras? (
		>=dev-perl/Chart-2.3
		dev-perl/Email-MIME-Attachment-Stripper
		dev-perl/Email-Reply
		>=dev-perl/GD-1.20
		dev-perl/GDGraph
		dev-perl/GDTextUtil
		>=dev-perl/HTML-Parser-3.40
		dev-perl/HTML-Scrubber
		dev-perl/libwww-perl
		>=dev-perl/PatchReader-0.9.4
		dev-perl/perl-ldap
		dev-perl/SOAP-Lite
		dev-perl/Template-GD
		dev-perl/XML-Twig
	)
"
S="${WORKDIR}/${MY_P}"

want_apache modperl

pkg_setup() {
	webapp_pkg_setup

	if use extras ; then
		if ! has_version media-gfx/imagemagick || ! built_with_use media-gfx/imagemagick perl ; then
			elog "Consider installing media-gfx/imagemagick with USE=\"perl\""
			elog "to convert BMP attachments to PNG"
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	ecvs_clean
}

src_install () {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	for f in bugzilla.cron.daily bugzilla.cron.tab; do
		doins "${FILESDIR}"/${MY_PB}/${f}
	done

	webapp_hook_script "${FILESDIR}"/${MY_PB}/reconfig
	webapp_postinst_txt en "${FILESDIR}"/${MY_PB}/postinstall-en.txt
	webapp_src_install

	# bug #124282
	chmod +x "${D}${MY_HTDOCSDIR}"/*.cgi
}
