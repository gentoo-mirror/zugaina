# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="PHP5 only implementation of the XML-RPC protocol."
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-php/PEAR-Cache_Lite
	dev-php/PEAR-HTTP_Request2
	dev-lang/php[xmlrpc]
"
src_prepare() {
	sed -i '1.4d' ${S}/Makefile
}