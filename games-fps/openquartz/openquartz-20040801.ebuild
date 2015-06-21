# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=43867 - The site http://gentoo.zugaina.org/ only host a copy.

inherit games

DESCRIPTION="Open Source PAK Files for Quake based games"
HOMEPAGE="http://openquartz.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/OpenQuartzLinux2004.08.01.tar.gz"
#	http://www.squawkrpg.net/openquartz/free_wad.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="games-util/openquartz-utils
	>=app-text/tetex-2"
RDEPEND=">=sys-apps/sed-4"
S=${WORKDIR}/${PN}/id1

src_unpack() {
	unpack OpenQuartzLinux2004.08.01.tar.gz || die "unpacking files failed"
	#cd ${S}
	#rm -rf gfx.w
	#mkdir maps/gfx
    #cd maps/gfx
    #unpack free_wad.zip || die "unpacking wad-file failed"
    #mv free.wad QuArK.wad
}

src_compile() {
	#sed -i "s/..\/utils\/qutils\/bin\//\${GAMES_BINDIR}\/qutils\//g" makefile || die "sed failed"
	# BAD, BAD, BAD, BAD HACK!!!!!
	# make crashes during map-creation, because one file does not support light-rendering
	# but it doesn't matter, since you can still use is without light, so the second make
	# will find a .bsp (compiled map file) and will not try to recompile it
	#die "make failed"
	einfo "This is a binary only package (but the binaries seem to be useless)"
}

src_install() {
	dodir ${GAMES_DATADIR}/quake-data/openquartz
	echo "map void1" > autoexec.cfg
	mv * ${D}/${GAMES_DATADIR}/quake-data/openquartz
	cd ..
	dodoc docs/*
	#dogamesbin openquartz-glx openquartz-dedicated
	#mv openquartz-glx openquartz-dedicated ${D}/${GAMES_BINDIR}
	#prepgamesdir
	einfo "To play this game, make a symbolic link from"
	ewarn " ${GAMES_DATADIR}/quake-data/openquartz"
	einfo "to"
	ewarn " ${GAMES_DATADIR}/quake-data/id1"
	einfo "and run quakeforge"
	einfo "This is not done by default, to support more than one game content"
}
