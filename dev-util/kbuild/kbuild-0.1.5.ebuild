# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from jokey overlay

EAPI=2

WANT_AUTOMAKE=1.9

inherit eutils autotools

MY_P=kBuild-${PV}-src
DESCRIPTION="A makefile framework for writing simple makefiles for complex tasks"
HOMEPAGE="http://svn.netlabs.org/kbuild/wiki"
SRC_URI="ftp://ftp.netlabs.org/pub/kbuild/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/cvs
	sys-devel/gettext"
RDEPEND=""

S=${WORKDIR}/${MY_P/-src}

src_prepare() {
		rm -rf "${S}/kBuild/bin"

		cd "${S}/src/kmk"
		eautoreconf
		cd "${S}/src/sed"
		eautoreconf
}

src_compile() {
		kBuild/env.sh --full \
		make -f bootstrap.gmk AUTORECONF=true \
		|| die "bootstrap failed"
}

src_install() {
		kBuild/env.sh kmk \
		NIX_INSTALL_DIR=/usr \
		PATH_INS="${D}" \
		install || die "install failed"
}
