# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
ESVN_REPO_URI="https://fuware.net/svn/pymusique/trunk"

inherit eutils subversion

DESCRIPTION="The fair interface to the iTunes Music Store"
DESCRIPTION_FR="Une interface a iTunes d'Apple sans DRM"
HOMEPAGE="http://fuware.nanocrew.net/pymusique/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="nomirror"

IUSE="gstreamer"

DEPEND=">=dev-lang/python-2.3
	dev-python/gnome-python
	gstreamer? ( dev-python/gst-python
		     media-libs/faad2 
		     media-plugins/gst-plugins-faad )
	dev-python/pygtk
	dev-python/twisted
	dev-python/python-mcrypt"

src_install() {
    python setup.py install --prefix=${D}/usr/
}
