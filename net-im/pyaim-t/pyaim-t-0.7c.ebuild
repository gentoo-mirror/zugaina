# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official pymsn-t ebuild

inherit eutils python

DESCRIPTION="AIM transport for Jabber"
HOMEPAGE="http://http://pyicq-t.blathersource.org/"
SRC_URI="http://www.blathersource.org/download.php/pyaim-t/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="nomirror"
DEPEND=">=net-im/jabber-base-0.0
		>=dev-lang/python-2.3"
RDEPEND="virtual/jabber-server
		>=dev-python/twisted-2
		dev-python/twisted-words
		dev-python/twisted-xish
		dev-python/twisted-web
		dev-python/imaging
		net-zope/zopeinterface
		web? ( dev-python/nevow )
		xdb? ( dev-python/mysql-python )"
IUSE="web xdb"

src_install()
{
	python_version
	#Dont like this, have to find way to do recursive copy with doins
	dodir /usr/lib/python${PYVER}/site-packages/${PN}/src /usr/lib/python${PYVER}/site-packages/${PN}/data /usr/lib/python${PYVER}/site-packages/${PN}/tools
	cp -r src/* ${D}/usr/lib/python${PYVER}/site-packages/${PN}/src
	cp -r data/* ${D}/usr/lib/python${PYVER}/site-packages/${PN}/data
	cp -r tools/* ${D}/usr/lib/python${PYVER}/site-packages/${PN}/tools


	exeinto /usr/lib/python${PYVER}/site-packages/${PN}
	doexe PyAIMt.py
	sed -i \
		-e "s/.*<spooldir>.*/<spooldir>\/var\/spool\/jabber\/<\/spooldir>/"\
		-e "s/.*<pid>.*/<pid>\/var\/run\/jabber\/pyaim-t.pid<\/pid>/"\
		-e "s/.*<debugLog>.*/<debugLog>\/var\/log\/jabber\/${PN}-debug.log<\/debugLog>/"\
			config_example.xml
	insinto /etc/jabber
	newins config_example.xml pyaim-t.xml

	exeinto /etc/init.d
	newexe ${FILESDIR}/pyaim-t-0.7c.initd pyaim-t
	sed -i -e "s/PATH/python${PYVER}/" ${D}/etc/init.d/pyaim-t
}

pkg_postinst() {
	einfo "A sample configuration file has been installed in /etc/jabber/pyaim-t.xml."
	einfo "Please edit it, and the configuration of you Jabber server to match."
	einfo "You also need to create a directory aim.yourdomain.com in"
	einfo "/var/spool/jabber/ and chown it to jabber:jabber."
}
