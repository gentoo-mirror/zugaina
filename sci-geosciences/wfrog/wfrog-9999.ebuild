# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="2"

inherit python eutils subversion

DESCRIPTION="A weather station software for the web, ftp and more. Highly extensible, however easy to use."
HOMEPAGE="http://code.google.com/p/wfrog/"
ESVN_REPO_URI="http://wfrog.googlecode.com/svn/trunk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/cheetah
	dev-python/lxml
	dev-python/pyusb
	dev-python/pyserial
	dev-python/pyyaml
	dev-python/pygooglechart"

DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/lib/${PN}
	dodir /usr/bin
	dodir /var/lib/${PN}
	
	insinto /usr/lib/${PN}
	cp -r bin/ wfcommon/ wfdriver/ wflogger/ wfrender/ ${D}/usr/lib/${PN}
	# init
	dodir /etc/init.d
	exeinto /etc/init.d
	doexe init.d/wflogger
	doexe init.d/wfrender
	
	dosym /usr/lib/wfrog/bin/wfrog /usr/bin/wfrog
}

pkg_postinst() {
	einfo "You have to run wfrog to configure it."
}