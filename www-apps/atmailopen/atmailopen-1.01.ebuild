# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit webapp depend.php

DESCRIPTION="Ajax Webmail"
HOMEPAGE="http://atmail.org/"
SRC_URI="http://distfiles.zugaina.org/${P}.tgz"

LICENSE="Apache"
KEYWORDS="~alpha ~ppc ~sparc ~x86 ~amd64"
IUSE=""
RDEPEND=""

S=${WORKDIR}/${PN}

need_php
								
src_install() {
	webapp_src_preinst
#
#	dodoc doc/*
#	
	cp -r * "${D}/${MY_HTDOCSDIR}"
	webapp_serverowned ${MY_HTDOCSDIR}
#
#
##	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
#
	webapp_src_install
}
