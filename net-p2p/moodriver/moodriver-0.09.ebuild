# Copyright 2005 Only copyleft
# Distributed under the terms of GNU v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="MooDriver to use Mooseekd or museekd"
SRC_URI="http://files.beep-media-player.org/releases/moodriver/${P}.tar.gz"
HOMEPAGE="http://bmpx.beep-media-player.org"
KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
DEPEND=""
RESTRICT="nomirror"
RDEPEND=""
SLOT="0"
src_install() {
    make DESTDIR=${D} install
}