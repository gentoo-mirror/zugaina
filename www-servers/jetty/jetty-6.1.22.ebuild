# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from bangert overlay
inherit eutils

DESCRIPTION="Jetty is an full-featured web and applicaction server implemented entirely in Java."
HOMEPAGE="http://www.mortbay.org/jetty-6/"
SRC_URI="http://dist.codehaus.org/jetty/${P}/${P}.zip"
LICENSE="Apache-2.0"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	dev-java/java-config"
RDEPEND=">=virtual/jdk-1.5"

JETTY_HOME="/opt/jetty"

pkg_setup() {
	enewgroup jetty
	enewuser jetty -1 /bin/bash ${JETTY_HOME} jetty
}

src_compile() {
	return
}

src_install() {
	newinitd "${FILESDIR}"/jetty.initd jetty
	newconfd "${FILESDIR}"/jetty.confd jetty

	insinto /etc/jetty
	doins "${FILESDIR}"/jetty.xml
	doins "${FILESDIR}"/jetty.conf
	keepdir /etc/jetty/contexts

	dodir ${JETTY_HOME}
	dosym /etc/jetty ${JETTY_HOME}/etc

	insinto ${JETTY_HOME}
	doins start.jar
	doins -r lib
	doins -r resources

	exeinto ${JETTY_HOME}/bin
	doexe bin/jetty.sh

	fowners -R jetty:jetty ${JETTY_HOME}

	keepdir /var/log/jetty
	fowners jetty:jetty /var/log/jetty

	keepdir /var/run/jetty
	fowners jetty:jetty /var/run/jetty
}
