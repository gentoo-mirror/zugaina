# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit cmake-utils games toolchain-funcs

MY_PV="viewer-${PV/_rc/}-r110075"
MY_DATE="2009/02"
GLH_V="20080812"
SDL_V="20080818"
VIVOX_V="20080613"
DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-src-${MY_PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-artwork-${MY_PV}.zip
	http://s3.amazonaws.com/viewer-source-downloads/install_pkgs/glh_linear-linux-${GLH_V}.tar.bz2
	http://s3.amazonaws.com/viewer-source-downloads/install_pkgs/SDL-1.2.5-linux-${SDL_V}.tar.bz2
	vivox? ( http://s3.amazonaws.com/viewer-source-downloads/install_pkgs/vivox-linux-${VIVOX_V}.tar.bz2 )
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-linux-libs-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vivox openal fmod nollmozlib"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-2
	=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	dev-libs/boost
	>=net-misc/curl-7.15.4
	dev-libs/openssl
	media-libs/freetype
	media-libs/jpeg
	media-libs/libsdl
	media-libs/mesa
	media-libs/libogg
	media-libs/libvorbis
	fmod? ( x86? ( =media-libs/fmod-3.75* ) )
	openal? ( >=media-libs/openal-1.5.304 
		media-libs/freealut )
	sys-libs/db
	dev-libs/dbus-glib
	dev-libs/expat
	sys-libs/zlib
	>=dev-libs/xmlrpc-epi-0.51-r1
	>=media-libs/openjpeg-1.1.1
	media-libs/libpng
	net-dns/c-ares
	x11-libs/pango
	!nollmozlib? ( net-libs/llmozlib2 )
	gstreamer? ( >=media-libs/gst-plugins-base-0.10 )
	>=dev-util/cmake-2.4.8"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/flex
	sys-devel/bison"

S="${WORKDIR}/linden/indra"

dir="${GAMES_DATADIR}/${PN}"

pkg_setup() {
    if [ "`gcc-config -c | grep '4.2.0'`" ]; then
        die "Secondlife need gcc < 4.2.0. Use gcc-config to use another version."
    fi                                                                           
    ewarn "Forcing on xorg-x11..."                                               
    OLD_IMPLEM="$(eselect opengl show)"                                          
    eselect opengl set --impl-headers xorg-x11                                   

}

pkg_config() {
	if [ "${ARCH}" != "x86" ] ; then
		if use vivox ; then
			ewarn "vivox USE flag is only available on x86."
		fi
		if use fmod ; then
			ewarn "fmod USE flag is only available on x86."
		fi
	fi
}

src_unpack() {
	# unpack font files
	unpack slviewer-linux-libs-${MY_PV}.tar.gz


	unpack slviewer-src-${MY_PV}.tar.gz
	unpack slviewer-artwork-${MY_PV}.zip
	cd "${WORKDIR}"/linden
	unpack glh_linear-linux-${GLH_V}.tar.bz2
	unpack SDL-1.2.5-linux-${SDL_V}.tar.bz2
	use vixox && unpack vivox-linux-${VIVOX_V}.tar.bz2
	cd "${S}"
	rm -rf linden/libraries
	rm -rf linden/indra/newview/app_settings

	epatch "${FILESDIR}"/"${PV}"/${PN}-cmake.patch
	epatch "${FILESDIR}"/"${PV}"/secondlife-llmozlib-svn.patch
	epatch "${FILESDIR}"/"${PV}"/VWR-9256.patch
	epatch "${FILESDIR}"/"${PV}"/fix_keeping_dbus_stuff_together.patch
	epatch "${FILESDIR}"/"${PV}"/secondlife-llcrashloggerlinux.patch
	touch "${S}"/newview/gridargs.dat
	echo '--settings settings_gentoo.xml --channel "Second Life Zugaina Gentoo Release"' > "${S}"/newview/gridargs.dat
}

src_compile() {
	local mycmakeargs="${mycmakeargs} -DSTANDALONE:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=RELEASE -DINSTALL:BOOL=TRUE -DAPP_SHARE_DIR:STRING=${GAMES_DATADIR}/${PN} -DAPP_BINARY_DIR:STRING=${GAMES_DATADIR}/${PN}/bin"
	use openal && mycmakeargs="${mycmakeargs} -DOPENAL:BOOL=TRUE"
	use nollmozlib && mycmakeargs="${mycmakeargs} -DMOZLIB:BOOL=FALSE"
	cmake-utils_src_compile
}

src_install() {
	mkdir -p "${S}"/newview/res-sdl
	cmake-utils_src_install
	cd "${S}"/newview/
	insinto "${dir}"
	doins gridargs.dat
	doins -r fonts || die
	newins licenses-linux.txt licenses.txt || die
	newins linux_tools/client-readme.txt README-linux.txt || die
	newins linux_tools/client-readme-voice.txt README-linux-voice.txt || die
	newins res/ll_icon.png secondlife_icon.png || die

	exeinto "${dir}"
	doexe linux_tools/launch_url.sh || die
	doexe linux_tools/*_secondlifeprotocol.sh || die
	newexe linux_tools/wrapper.sh secondlife || die
	use !nollmozlib && ln -s "/usr/$(get_libdir)/llmozlib2/runtime_release" "${D}/${dir}/app_settings/mozilla-runtime-linux-i686"

#	newexe ../linux_crash_logger/linux-crash-logger linux-crash-logger.bin || die

	if use vivox ; then
		exeinto "${dir}"
		doexe vivox-runtime/i686-linux/SLVoice || die
		exeinto "${dir}/vivox-runtime/i686-linux"
		doexe vivox-runtime/i686-linux/lib* || die
	fi

	games_make_wrapper secondlife ./secondlife "${dir}" "/usr/$(get_libdir)/llmozlib2"
	newicon res/ll_icon.png secondlife_icon.png || die
	make_desktop_entry secondlife "Second Life" secondlife_icon.png

	newdoc licenses-linux.txt licenses.txt
	newdoc linux_tools/client-readme.txt README-linux.txt
	newdoc linux_tools/client-readme-voice.txt README-linux-voice.txt

	prepgamesdirs
}

pkg_postinst() {
        switch_opengl_implem
}

switch_opengl_implem() {
        # Switch to the xorg implementation.
        # Use new opengl-update that will not reset user selected
        # OpenGL interface ...
        echo
        eselect opengl set ${OLD_IMPLEM}
}
