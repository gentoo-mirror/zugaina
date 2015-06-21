# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Pascal Fleury <fleury@users.sourceforge.net>
# $Header:$
# This ebuild come from http://svn.sabayonlinuxdev.com/ - The site http://gentoo.zugaina.org/ only host a copy.
# Some modification by Ycarus

DESCRIPTION="This is a program to simply create DVD Video"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=38347"
LICENSE="GPL-2"
SRC_URI="http://ftp.nluug.nl/pub/os/Linux/distr/pardusrepo/sources/${PN}-${PV}src.tar.gz"
RESTRICT="nomirror"
IUSE=""
KEYWORDS="~x86 ~amd64"
SLOT="0"
# Build-time dependencies, such as
#       ssl? ( >=openssl-0.9.6b )
#       >=perl-5.6.1-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.     Then
# other users hopefully won't be caught without the right version of
# a dependency.
DEPEND="=x11-libs/qt-3*
       >=media-libs/xine-lib-0.99.4
       >=media-sound/lame-3.96.1
       >=media-video/dvdauthor-0.6.11
       >=media-video/mjpegtools-1.8.0
       >=media-libs/netpbm-10.29
       >=media-video/transcode-1.0.2
       >=app-cdr/dvd+rw-tools-5.21.4
       >=media-video/dvd-slideshow-0.7.5"
#DEPEND=">=dvd-slideshow-0.7.5 >=lame-3.97"
RDEPEND="$DEPEND"


S=${WORKDIR}

src_compile() {
        addwrite "${QTDIR}/etc/settings"
       cd ${S}/ManDVD-${PV}src
       /usr/qt/3/bin/qmake mandvd.pro
       emake 
}

src_install () {
	exeinto /usr/bin
	doexe ManDVD-${PV}src/mandvd
}
