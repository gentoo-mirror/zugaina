# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

EAPI="3"
PYTHON_DEPEND="2"
inherit eutils

DESCRIPTION="Halberd is a tool aimed at discovering real servers behind virtual IPs."
HOMEPAGE="http://halberd.superadditive.com/"
SRC_URI="http://halberd.superadditive.com/dist/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=""
RDEPEND="${DEPEND}
       >=dev-lang/python-2.4"

DOCS="AUTHORS ChangeLog INSTALL LICENSE NEWS README THANKS"