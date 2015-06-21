# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="Collections management"
HOMEPAGE="http://www.c-sait.net/gcstar/"
SRC_URI="http://download.gna.org/gcstar/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="nomirror"

S=${WORKDIR}/${PN}
DEPEND=">=dev-perl/gtk2-perl-1.121
	dev-perl/libwww-perl
	dev-perl/Archive-Zip
	virtual/perl-Archive-Tar
	dev-perl/XML-Simple
	dev-perl/MP3-Tag
	dev-perl/MP3-Info
	dev-perl/Ogg-Vorbis-Header-PurePerl
	perl-core/MIME-Base64
	perl-core/Digest-MD5
	perl-core/Compress-Raw-Zlib
	perl-core/Time-Piece"
	

src_install() {
	dodir /usr
	./install --prefix=${D}/usr --nomenu --noclean || die
	fperms 755 /usr/bin/gcstar
	dodir /usr/share/applications /usr/share/pixmaps
	insinto /usr/share/applications
	doins share/applications/gcstar.desktop
	insinto /usr/share/pixmaps
	newins share/gcstar/icons/gcstar_64x64.png gcstar.png
}
