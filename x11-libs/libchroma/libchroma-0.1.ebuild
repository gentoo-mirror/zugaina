# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit gnome2 autotools

MY_PV="${PV}-1"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Chroma is a set of widgets based on GTK+2"
HOMEPAGE="http://bmpx.beep-media-player.org/site/Chroma"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/beepmp/${MY_P}.tar.gz"
RESTRICT="nomirror"
SLOT="0"
IUSE="doc"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-0.10 )
	>=dev-util/pkgconfig-0.9.0"
	
S=${WORKDIR}/${MY_P}

DOCS="AUTHORS COPYING* ChangeLog* INSTALL NEWS README*"
