# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit webapp depend.php

DESCRIPTION="gestionnaire de fichier utilisant PHP et MySQL"
HOMEPAGE="http://www.hyla-project.org"
SRC_URI="http://www.hyla-project.org/download/index.php?p=obj-download,/hyla-0.8.2.tar.gz"

LICENSE="GPL"
KEYWORDS="~alpha ~ppc ~sparc ~x86 ~amd64"
IUSE=""
RDEPEND="dev-db/mysql"

need_php
								
src_install() {
	webapp_src_preinst

	dodoc COPYING ChangeLog INSTALL docs/*

	cp -r * "${D}/${MY_HTDOCSDIR}"

	# Files that need to be owned by webserver
	webapp_serverowned ${MY_HTDOCSDIR}/conf
	webapp_serverowned ${MY_HTDOCSDIR}/sys/cache
	webapp_serverowned ${MY_HTDOCSDIR}/sys/anon
#
##	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
#
	webapp_src_install
}
