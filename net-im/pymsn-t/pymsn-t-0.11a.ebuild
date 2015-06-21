# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official pymsn-t ebuild

inherit eutils python

MY_PN="pymsnt"
S=${WORKDIR}/${MY_PN}-0.11
DESCRIPTION="MSN transport for Jabber"
HOMEPAGE="http://msn-transport.jabberstudio.org/"
SRC_URI="http://msn-transport.jabberstudio.org/tarballs/${MY_PN}-${PV}.tar.gz"
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
		dev-python/imaging"
IUSE=""

src_unpack()
{
	unpack ${A}
	cd ${S}
	rm -rf src/.svn
	rm -rf src/baseproto/.svn
	rm -rf src/legacy/.svn
	rm -rf src/tlib/.svn
	rm -rf src/tlib/jabber/.svn
}

src_install()
{
	python_version
	#Dont like this, have to find way to do recursive copy with doins
	dodir /usr/lib/python${PYVER}/site-packages/${PN}/src /usr/lib/python${PYVER}/site-packages/${PN}/data
	cp -r src/* ${D}/usr/lib/python${PYVER}/site-packages/${PN}/src
	cp -r data/* ${D}/usr/lib/python${PYVER}/site-packages/${PN}/data


	exeinto /usr/lib/python${PYVER}/site-packages/${PN}
	doexe PyMSNt.py
	sed -i \
		-e "s/.*<spooldir>.*/<spooldir>\/var\/spool\/jabber\/<\/spooldir>/"\
		-e "s/.*<pid>.*/<pid>\/var\/run\/jabber\/pymsn-t.pid<\/pid>/"\
		-e "s/.*<debugLog>.*/<debugLog>\/var\/log\/jabber\/${PN}-debug.log<\/debugLog>/"\
			config-example.xml
	insinto /etc/jabber
	newins config-example.xml pymsn-t.xml

	exeinto /etc/init.d
	newexe ${FILESDIR}/pymsn-t-0.11.initd pymsn-t
	sed -i -e "s/PATH/python${PYVER}/" ${D}/etc/init.d/pymsn-t
}

pkg_postinst() {
	einfo "A sample configuration file has been installed in /etc/jabber/pymsn-t.xml."
	einfo "Please edit it, and the configuration of you Jabber server to match."
	einfo "You also need to create a directory msn.yourdomain.com in"
	einfo "/var/spool/jabber/ and chown it to jabber:jabber."
}
