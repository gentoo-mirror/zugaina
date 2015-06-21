# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=278576

EAPI="2"

inherit autotools eutils

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="debug"
SLOT="0"
LICENSE="BSD"

RDEPEND=">=dev-libs/botan-1.8.5[threads]
	>=dev-db/sqlite-3.4.2"

DEPEND="${RDEPEND}"

src_prepare() {
	local patches="r2797 r2798"
	for patch in $patches; do
		epatch "${FILESDIR}"/"${P}"-$patch.patch || die "epatch failed for $patch"
	done
	eautoreconf
}

src_configure() {
	local myconf
	use debug && myconf="--with-loglevel=4"

	econf \
	$(use_enable amd64 64bit) \
	$myconf
}

src_compile() {
	emake || die "emake failed"
}

src_test() {
	emake check || die "emake check failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README || die "dodoc failed"
}
