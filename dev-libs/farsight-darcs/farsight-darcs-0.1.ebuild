# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# Need to add msn and yahoo support to the ebuild

EDARCS_REPO_URI="http://projects.collabora.co.uk/darcs/farsight/farsight"

inherit eutils darcs

DESCRIPTION="FarSight is an audio/video conferencing framework specifically designed for Instant Messengers."
HOMEPAGE="http://farsight.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE="sofia-sip gnet jingle"
SLOT="0"

DEPEND="=media-libs/gstreamer-0.10*
	=media-plugins/gst-plugins-farsight-0.10*
	>=sys-devel/autoconf-2.59
	>=sys-devel/automake-1.5
	>=dev-libs/glib-2.0
	sofia-sip? ( net-libs/sofia-sip )
	gnet? ( net-libs/gnet )
	jingle? ( dev-libs/libjingle-tapioca-svn )"
	
src_compile() {
    ./autogen.sh
    myconf="--disable-debug \
	--disable-gtk-doc \
	--disable-sequence-diagrams \
	--disable-msnwebcam \
	--disable-msnavconf \
	--disable-yahoowebcam \
	--enable-rtp"
    
    econf ${myconf} `use_enable sofia-sip` `use_enable gnet` `use_enable jingle jingle-p2p` || die
    emake || die
}

src_install() {
	make install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}

