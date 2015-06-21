# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="Tapioca framework for VOIP and IM"
HOMEPAGE="http://tapioca-voip.sf.net"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/tapioca-voip/tapioca-${PV}.tar.gz"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
S="${WORKDIR}/tapioca-${PV}"
DEPEND=">=media-libs/gstreamer-0.10.4
	>=media-libs/gst-plugins-base-0.10.5
	>=media-libs/gst-plugins-good-0.10.2-r1
	dev-libs/farsight-darcs
	media-plugins/gst-plugins-farsight
	sys-apps/dbus"

pkg_setup()
{
    if ! built_with_use dev-libs/farsight-darcs jingle ; then
	echo
	eerror "In order to use tapioca core and client, you need to have"
	eerror "dev-libs/farsight-darcs emerged with 'jingle' flags. Please"
	eerror "add that flag, re-emerge farsight and then tapioca-core-client"
	die "dev-libs/farsight-darcs is missing jingle"
    fi
    if ! built_with_use media-plugins/gst-plugins-farsight jingle ; then
	echo
	eerror "In order to use tapioca core and client, you need to have"
	eerror "media-plugins/gst-plugins-farsight emerged with 'jingle' flags. Please"
	eerror "add that flag, re-emerge gst-plugins-farsight and then tapioca-core-client"
	die "media-plugins/gst-plugins-farsight is missing jingle"
    fi
}

src_compile() {
    econf || die
    emake || die
}

src_install() {
    make install DESTDIR=${D} || die
}