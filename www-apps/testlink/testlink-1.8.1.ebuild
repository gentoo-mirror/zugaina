# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit webapp depend.php

DESCRIPTION="TestLink enables easily to create and manage Test cases as well as organize them into Test plans. "
HOMEPAGE="http://testlink.org"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tgz"

LICENSE="GPL"
KEYWORDS="~alpha ~ppc ~sparc ~x86 ~amd64"
IUSE="mysql postgre bugzilla mantis"
RDEPEND="mysql? ( >=virtual/mysql-4.1 )
	postgre? ( dev-db/postgresql )
	bugzilla? ( www-apps/bugzilla )
	mantis? ( www-apps/mantisbt )"
S="${WORKDIR}"/${PN}

need_php
pkg_setup() {
        webapp_pkg_setup
	
        if ! use mysql && ! use postgres ; then
	    eerror "You must select at least one database backend, by enabling"
	    eerror "at least one of the 'mysql' or 'postgres' USE flags."
	    die "no database backend selected"
	fi
}
								
src_install() {
	webapp_src_preinst

	dodoc readme license CODE_REUSE CHANGELOG SCHEMA_CHANGES docs/*

	cp -r * "${D}/${MY_HTDOCSDIR}"

	# Files that need to be owned by webserver
	webapp_serverowned ${MY_HTDOCSDIR}/gui/templates_c
	webapp_serverowned ${MY_HTDOCSDIR}/
	webapp_serverowned ${MY_HTDOCSDIR}/upload_area
#
##	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
#
	webapp_src_install
}
