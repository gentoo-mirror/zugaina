# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit webapp depend.php

DESCRIPTION="Web file deposit"
HOMEPAGE="http://home.gna.org/jyraphe/"
SRC_URI="http://download.gna.org/jyraphe/${P}.tar.gz"

LICENSE="GPL"
KEYWORDS="~alpha ~ppc ~sparc ~x86 ~amd64"
IUSE=""
RDEPEND=""

need_php
								
src_install() {
	webapp_src_preinst

	dodoc doc/*
	
	cp -r pub/* "${D}/${MY_HTDOCSDIR}"

#
##	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
#
	webapp_src_install
}
