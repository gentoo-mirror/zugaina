# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator flag-o-matic

MY_P="${PN}-${PV/_rc/-RC}"

DESCRIPTION="An Open Decentralized Platform for Collaborative Search, Filtering and content Curation"
HOMEPAGE="http://www.seeks-project.info/"
SRC_URI="mirror://sourceforge/${PN}/hippy/${MY_P}.tar.gz"

LICENSE="AGPL3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="net-misc/curl
	>=dev-libs/libevent-2.0
	dev-libs/protobuf
	net-misc/tokyotyrant
	media-libs/opencv
	dev-libs/icu"
DEPEND="${RDEPEND}
	app-text/docbook2X"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup seeks
	enewuser seeks -1 -1 /var/run/seeks seeks
}

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	sed -i s/cxflann.h/cv.h/ src/plugins/img_websearch/ocvsurf.cpp
	sed -i s/docbook2x-man/docbook2man/ ./configure

	econf \
		--sysconfdir=/etc \
		--enable-httpserv-plugin \
		--enable-image-websearch-plugin=yes \
		|| die "econf failed"

	sed -i s/-Wl,--as-needed// config.status
	sed -i s/,--as-needed,/,/ config.status

	emake  || die "emake failed"
}

src_install() {
	cd src
	epatch ${FILESDIR}/logfile.patch
	make DESTDIR=${D} install

	newinitd ${FILESDIR}/seeks.initd seeks
	newconfd ${FILESDIR}/seeks.conf.d seeks
	insinto /etc/logrotate.d
	newins ${FILESDIR}/seeks.logrotate seeks

	dodir /var/log
	touch ${D}/var/log/seeks.log
	chown seeks:seeks ${D}/var/log/seeks.log
}
