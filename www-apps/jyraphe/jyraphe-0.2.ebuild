# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit webapp depend.php

DESCRIPTION="application web de dépôt de fichier"
HOMEPAGE="http://home.gna.org/jyraphe/"
SRC_URI="http://download.gna.org/jyraphe/jyraphe-0.2.tar.gz"

LICENSE="GPL"
KEYWORDS="~alpha ~ppc ~sparc ~x86 ~amd64"
IUSE=""
RDEPEND=""

S=${WORKDIR}/${PN}
need_php
								
src_install() {
	webapp_src_preinst

	dodoc doc/*
	
	cp -r pub/* "${D}/${MY_HTDOCSDIR}"

	# Files that need to be owned by webserver
	webapp_serverowned ${MY_HTDOCSDIR}/var/files
	webapp_serverowned ${MY_HTDOCSDIR}/var/trash
	webapp_serverowned ${MY_HTDOCSDIR}/var/links
#
##	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
#
	webapp_src_install
}
