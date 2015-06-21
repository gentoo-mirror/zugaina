# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="2"

inherit distutils-r1 python-r1 eutils

DESCRIPTION="A free home automation solution"
HOMEPAGE="http://www/domogik.org/"
SRC_URI="http://repo.domogik.org/${PN}-${PV/_/-}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
#IUSE="mysql postgres"
#REQUIRED_USE="|| ( mysql postgres )"

RDEPEND="dev-python/setuptools
	dev-python/mysql-python
	>=dev-python/pyserial-2.5
	>=dev-python/sqlalchemy-0.7.5
	>=dev-python/sqlalchemy-migrate-0.7.2
	>=dev-python/simplejson-1.9.2
	>=dev-python/httplib2-0.6.0
	dev-python/psutil
	dev-python/pyinotify
	dev-python/pip
	dev-python/pyserial
	dev-python/Distutils2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${PV/_/-}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
	    -e '/ez_setup.use_setuptools()/d' \
	    -e '/install_requires=\[.*\],/d' \
	    setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile
}

pkg_preinst() {
	enewgroup domogik
	enewuser domogik -1 -1 /var/lib/domogik "domogik"
}

src_install() {
	distutils_src_install

	dodir /etc/domogik
	fowners -R domogik /etc/domogik
	fperms 755 /etc/domogik
	dodir /var/cache/domogik
	fowners -R domogik /var/cache/domogik
	dodir /var/lib/domogik
	fowners -R domogik /var/lib/domogik
	dodir /var/lock/domogik
	fowners -R domogik:uucp /var/lock/domogik
	
	# Create folder for packages management
	for pkg_rep in pkg-cache cache; do
	    dodir /var/cache/domogik/${pkg_rep}
	    fowners -R domogik /var/cache/domogik/${pkg_rep}
	done
	for pkg_rep in domogik_packages domogik_packages/plugins domogik_packages/externals domogik_packages/stats domogik_packages/url2xpl domogik_packages/design domogik_packages/data; do
	    dodir "/var/lib/domogik/${pkg_rep}"
	    fowners -R domogik "/var/lib/domogik/${pkg_rep}"
	done
	
	insinto /etc/domogik
	doins src/domogik/examples/config/domogik.cfg
	fowners domogik /etc/domogik/domogik.cfg
	fperms 640 /etc/domogik/domogik.cfg
	doins src/domogik/examples/packages/sources.list
	fowners domogik /etc/domogik/sources.list
	fperms 640 /etc/domogik/sources.list
	
	# system-wide config
#	dodir /etc/default
#	insinto /etc/default
#	doins src/domogik/examples/default/domogik
	dodir /etc/conf.d
	insinto /etc/conf.d
	doins src/domogik/examples/default/domogik
	
	# logrotate
	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	doins src/domogik/examples/logrotate/domogik
	fperms 644 /etc/logrotate.d/domogik
	
	# init
	dodir /etc/init.d
	exeinto /etc/init.d
	doexe src/domogik/examples/init/domogik
	newexe ${FILESDIR}/domogik.init domogik
	
	# update_default_config
	# update_user_config
	# update_user_config_db
	
	# copy_tools
	dodir /usr/sbin
	exeinto /usr/sbin
	doexe src/tools/dmg*
	
	# create_log_dir
	dodir /var/log/domogik
	fowners -R domogik /var/log/domogik
	
	# call_app_installer
	dodir /usr/share/doc/${P}
	cp -R install ${D}/usr/share/doc/${P}
	
	# install_plugins
	# modify_hosts

}

pkg_postinst() {
	einfo "You need to have a working Mysql server with a domogik user and database."
	einfo "You can create it using these commands (as mysql admin user) :"
	einfo " > CREATE DATABASE domogik;"
	einfo " > GRANT ALL PRIVILEGES ON domogik.* to domogik@127.0.0.1 IDENTIFIED BY 'randompassword';"
	einfo "Then edit /etc/domogik/domogik.cfg with the appropriate infos and run 'sudo -u domogik python /usr/share/doc/${P}/install/installer.py'"
}