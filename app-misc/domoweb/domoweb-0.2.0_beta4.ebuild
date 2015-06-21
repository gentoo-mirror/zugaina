# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"
#SUPPORT_PYTHON_ABIS="1"

inherit distutils-r1 python-r1 eutils

DESCRIPTION="A free home automation solution. Web interface of Domogik."
HOMEPAGE="http://www/domogik.org/"
SRC_URI="http://repo.domogik.org/${PN}-${PV/_/-}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/setuptools
	>=dev-python/simplejson-1.9.2
	>=dev-python/httplib2-0.6.0
	dev-python/Distutils2
	=dev-python/django-1.3.2
	>=dev-python/django-tastypie-0.9.9
	>=dev-python/cherrypy-3.2.2
	"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${PV/_/-}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
	    -e '/ez_setup.use_setuptools()/d' \
	    -e '/install_requires=\[.*\],/d' \
	    -e 's/django == 1.3.1/django/g' \
	    setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile
}

pkg_preinst() {
	enewgroup domogik
	enewuser domoweb -1 -1 /var/lib/domoweb "domogik"
}

src_install() {
	distutils_src_install
	
	# copy_sample_file
	dodir /etc/domoweb
	fowners -R domoweb /etc/domoweb
	fperms 755 /etc/domoweb
	dodir /var/lib/domoweb
	fowners -R domoweb /var/lib/domoweb
	dodir /var/run/domoweb
	fowners -R domoweb /var/run/domoweb
	
	insinto /etc/domoweb
	doins src/examples/config/domoweb.cfg
	fowners domoweb /etc/domoweb/domoweb.cfg

	# system-wide config
#	dodir /etc/default
#	insinto /etc/default
#	doins src/examples/default/domoweb
	dodir /etc/conf.d
	insinto /etc/conf.d
	doins src/examples/default/domoweb
	
	# logrotate
	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	doins src/examples/logrotate/domoweb
	fperms 644 /etc/logrotate.d/domoweb
	
	# init
	dodir /etc/init.d
	exeinto /etc/init.d
	#doexe src/examples/init/domoweb
	newexe ${FILESDIR}/domoweb.init domoweb
	
	# init_django_db
	
	
	# create_log_dir
	dodir /var/log/domoweb
	fowners -R domoweb /var/log/domoweb

	sed -i "s:/var/lib/domoweb/domoweb.dat:${D}/var/lib/domoweb/domoweb.dat:g" generate_revision.py
	python generate_revision.py
}

pkg_postinst() {
	ewarn "You have to init the django db :"
	ewarn "sudo -u domoweb python /usr/lib/python2.*/site-packages/domoweb/manage.py syncdb --noinput && chown domoweb: /var/lib/domoweb/domoweb.db"
	#sudo -u domoweb python /usr/lib/python2.7/site-packages/domoweb/manage.py syncdb --noinput && chown domoweb: /var/lib/domoweb/domoweb.db
	einfo "You can access UI on url : http://127.0.0.1:40404/ login: admin password: 123"
}
