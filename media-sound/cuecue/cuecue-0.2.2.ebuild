# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=87000 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit eutils

DESCRIPTION="Cuecue is a suite to convert .cue + [.ogg|.flac|.wav|.mp3] to .cue + .bin."
HOMEPAGE="http://cuecue.berlios.de/"
SRC_URI="http://download.berlios.de/cuecue/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mad oggvorbis flac"
DEPEND=""
RDEPEND="mad? ( media-libs/libmad )
	 flac? ( media-libs/flac )
	 oggvorbis? ( media-libs/libogg media-libs/libvorbis )"

src_compile() {

	local myconf=""
	if use mad; then
		myconf="${myconf} --enable-mp3"
	else
		myconf="${myconf} --disable-mp3"
	fi
	if use oggvorbis; then
		myconf="${myconf} --enable-ogg"
	else
		myconf="${myconf} --disable-ogg"
	fi
	if use flac; then
		myconf="${myconf} --enable-flac"
	else
		myconf="${myconf} --disable-flac"
	fi
	econf ${myconf} || die

	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc CHANGES COPYING COPYRIGHT README TODO
}
