# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="convert digital photos (and any other images) into MPEG video streams with transitions between the images"
HOMEPAGE="http://www.gromeck.de/index.php?image2mpeg"
SRC_URI="http://www.gromeck.de/uploads/media/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc-macos ~ppc64 ~sparc x86"
IUSE=""

DEPEND="media-libs/libpng 
        >=media-gfx/imagemagick-6.1.8
	media-video/ffmpeg 
	>=media-video/mjpegtools-1.6
	>=media-sound/toolame-0.2l
	media-libs/libmad"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
