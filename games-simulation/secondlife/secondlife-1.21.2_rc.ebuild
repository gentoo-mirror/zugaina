# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games toolchain-funcs

MY_PV="viewer_1-21-2-r96080"
MY_BIN_PV="1.21.2.96080"
MY_DATE="2008/09"
DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-src-${MY_PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-artwork-${MY_PV}.zip
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-linux-libs-${MY_PV}.tar.gz
	http://s3.amazonaws.com/viewer-source-downloads/install_pkgs/glh_linear-linux-20080613.tar.bz2
	http://release-candidate-secondlife-com.s3.amazonaws.com/SecondLife-i686-${MY_BIN_PV}_RELEASECANDIDATE.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vivox"
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
	=sys-libs/db-4.2*
	dev-libs/expat
	sys-libs/zlib
	>=dev-libs/xmlrpc-epi-0.51-r1
	elfio? ( dev-libs/elfio )
	>=media-libs/openjpeg-1.1.1
	net-dns/c-ares
	x11-libs/pango
	net-libs/llmozlib2
	gstreamer? ( >=media-libs/gst-plugins-base-0.10 )
	>=dev-util/cmake-2.4.8"

DEPEND="${RDEPEND}
	>=dev-util/scons-0.97
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
	fi
}

src_unpack() {
	# unpack font files
	unpack slviewer-linux-libs-${MY_PV}.tar.gz

#	if use kdu ; then
#		find linden/libraries -type f -a ! -name '*kdu*' | xargs rm -f || die
#	else
	rm -rf linden/libraries
#	fi

	rm -rf linden/indra/newview/app_settings

	unpack slviewer-src-${MY_PV}.tar.gz
	unpack slviewer-artwork-${MY_PV}.zip
	unpack SecondLife-i686-${MY_BIN_PV}_RELEASECANDIDATE.tar.bz2
	cd "${WORKDIR}"/linden
	unpack glh_linear-linux-20080613.tar.bz2

	cd "${S}"

	epatch "${FILESDIR}"/"${PV}"/${PN}-cmake.patch
	epatch "${FILESDIR}"/"${PV}"/${PN}-llrender.patch
	epatch "${FILESDIR}"/"${PV}"/rename_binary_cmake.patch
	epatch "${FILESDIR}"/"${PV}"/secondlife-llmozlib-svn.patch
	touch "${S}"/newview/gridargs.dat
	echo '--settings settings_gentoo.xml --channel "Second Life Zugaina Gentoo Release"'
}

src_compile() {
	./develop.py --standalone --type=Release configure \
	-DINSTALL:BOOL=TRUE -DAPP_SHARE_DIR:STRING=${GAMES_DATADIR}/${PN} -DAPP_BINARY_DIR:STRING=${GAMES_DATADIR}/${PN}/bin \
	-DBINARY_NAME:STRING=do-not-directly-run-secondlife-bin
	case ${ARCH} in
		x86)
			cd "${S}"/viewer-linux-i686/
			make || die
    			;;	
		amd64)
			cd "${S}"/viewer-linux-x86_64/
			make || die
			;;
		ppc|ppc64)
			;;
		*)
			cd "${S}"/viewer-linux-i686/
			make || die
    			;;	
	esac
}

src_install() {
	mkdir -p "${S}"/newview/res-sdl
	cp -r "${S}"/newview/res/* ${S}/newview/res-sdl || die     
        # Not all cursors are in artwork package...                     
        cp -r "${WORKDIR}"/SecondLife-i686-${MY_BIN_PV}/res-sdl/* ${S}/newview/res-sdl
	case ${ARCH} in
		x86)
			cd "${S}"/viewer-linux-i686/
			make DESTDIR=${D} install || die
    			;;	
		amd64)
			cd "${S}"/viewer-linux-x86_64/
			make DESTDIR=${D} install || die
			;;
		ppc|ppc64)
			;;
		*)
			cd "${S}"/viewer-linux-i686/
			make DESTDIR=${D} install || die
    			;;	
	esac
	cd "${S}"/newview/
#
	insinto "${dir}"
	doins gridargs.dat
	doins -r fonts || die
	doins lsl_guide.html releasenotes.txt || die
	newins licenses-linux.txt licenses.txt || die
	newins linux_tools/client-readme.txt README-linux.txt || die
	newins linux_tools/client-readme-voice.txt README-linux-voice.txt || die
	newins res/ll_icon.png secondlife_icon.png || die

	exeinto "${dir}"
	doexe linux_tools/launch_url.sh || die
	doexe linux_tools/*_secondlifeprotocol.sh || die
	newexe linux_tools/wrapper.sh secondlife || die
	ln -s "/usr/$(get_libdir)/llmozlib2/runtime_release" "${D}/${dir}/app_settings/mozilla-runtime-linux-i686"

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

	dodoc releasenotes.txt
	newdoc licenses-linux.txt licenses.txt
	newdoc linux_tools/client-readme.txt README-linux.txt
	newdoc linux_tools/client-readme-voice.txt README-linux-voice.txt
	dohtml lsl_guide.html

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
