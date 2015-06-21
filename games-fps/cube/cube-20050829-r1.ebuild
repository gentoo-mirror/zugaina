# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=104292 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit eutils games

MY_PV="2005_08_29"
MY_P=${PN}_${MY_PV}
DESCRIPTION="Landscape-style engine that pretends to be an indoor first person shooter engine"
HOMEPAGE="http://wouter.fov120.com/cube/"
SRC_URI="mirror://sourceforge/cube/${MY_P}_unix.tar.gz
		mirror://sourceforge/cube/${MY_P}_src.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="hppa ppc x86 ~amd64"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	sys-libs/zlib
	media-libs/libpng"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=sys-apps/sed-4"

S="${WORKDIR}/${PN}_source"

src_unpack() {
	unpack cube_2005_08_29_unix.tar.gz cube_2005_08_29_src.zip

	cd ${S}/src
	epatch ${FILESDIR}/${PV}-gentoo-paths.patch
	echo "#define GAMES_DATADIR \"${GAMES_DATADIR}/${PN}/\"" >> tools.h
	echo "#define GAMES_DATADIR_LEN $((${#GAMES_DATADIR} + ${#PN} + 2))" >> tools.h
	sed -i \
		-e "s:packages/:${GAMES_DATADIR}/${PN}/packages/:" \
		renderextras.cpp rendermd2.cpp sound.cpp worldio.cpp \
		|| die "fixing data path failed"
	# enable parallel make
	sed -i \
		-e 's/make -C/$(MAKE) -C/' \
		Makefile \
		|| die "sed Makefile failed"
	edos2unix *.cpp
	chmod a+x ${S}/enet/configure
}

src_compile() {
	cd enet
	egamesconf || die "egamesconf failed"
	emake || die "emake failed"
	cd ../src
	einfo "Compiling in $(pwd)"
	emake CXXOPTFLAGS="-DHAS_SOCKLEN_T=1 -fpermissive ${CXXFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dogamesbin src/cube_{client,server} || die "dogamesbin failed"
	exeinto "${GAMES_LIBDIR}"/${PN}
	cd "${WORKDIR}"/cube
	if [ "${ARCH}" == "x86" ] ; then
		newexe bin_unix/linux_client cube_client-bin || die "newexe failed"
		newexe bin_unix/linux_server cube_server-bin || die "newexe failed"
		games_make_wrapper cube_client-bin "${GAMES_LIBDIR}"/$PN/cube_client-bin \
			"$GAMES_DATADIR"/$PN || die "games_make_wrapper failed (client)"
		games_make_wrapper cube_server-bin "${GAMES_LIBDIR}"/$PN/cube_server-bin \
			"$GAMES_DATADIR"/$PN || die "games_make_wrapper failed (server)"
	fi

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r *.cfg data packages || die "failed installing data"

	dodoc ${S}/src/CUBE_TODO.txt || die "failed installing CUBE_TODO.txt"
	dohtml -r docs readme.html || die "failed installing docs"

	make_desktop_entry cube_client "cube_client" \
	|| die "failed creating desktop entry"
	if [ "${ARCH}" == "x86" ] ; then
		make_desktop_entry cube_client-bin "cube_client-bin" \
		|| die "failed creating desktop entry (bin)"
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if [ "${ARCH}" == "x86" ] ; then
		einfo "You now have 2 clients and 2 servers:"
		einfo "cube_client-bin      prebuilt version (needed to play on public multiplayer servers)"
		einfo "cube_client          custom client built from source"
		einfo "Parallel versions of the server have been installed"
	elif [ "${ARCH}" == "ppc" ] ; then
		einfo "This version don't provide prebuilt version for ppc (needed to play on public multiplayer servers)"
	fi
}
