# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from Funtoo

EAPI="2"

DESCRIPTION="release metatool used for creating Gentoo and Funtoo releases"
HOMEPAGE="http://www.github.com/funtoo/metro"
SRC_URI="http://www.funtoo.org/archive/metro/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+ccache +git threads"

DEPEND=""
RDEPEND="dev-lang/python
	threads? ( app-arch/pbzip2 )
	ccache? ( dev-util/ccache )
	git? ( dev-vcs/git )"

src_install() {
	insinto /usr/lib/metro
	doins -r .
	fperms 0755 /usr/lib/metro/metro
	dosym /usr/lib/metro/metro /usr/bin/metro
}
