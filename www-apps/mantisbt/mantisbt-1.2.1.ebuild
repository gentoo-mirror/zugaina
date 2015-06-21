# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils webapp depend.php

DESCRIPTION="PHP/MySQL/Web based bugtracking system"
HOMEPAGE="http://www.mantisbt.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	virtual/httpd-php
	virtual/httpd-cgi
	dev-php/adodb"

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use pcre
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -r "${S}/core/adodb/" # We use external adodb
}

src_install() {
	webapp_src_preinst
	rm doc/{LICENSE,INSTALL}
	dodoc doc/*

	rm -rf doc packages
	mv config_inc.php.sample config_inc.php
	cp -R . "${D}/${MY_HTDOCSDIR}"

	webapp_configfile "${MY_HTDOCSDIR}/config_inc.php"
	webapp_postinst_txt en "${FILESDIR}/postinstall-en-1.0.0.txt"
	webapp_src_install
}
