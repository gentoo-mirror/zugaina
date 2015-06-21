# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# Modified from http://bugs.gentoo.org/show_bug.cgi?id=127026

inherit games toolchain-funcs
MY_PV="Branch_1-20-7-Viewer-r88152"
MY_DATE="2008/05"
DESCRIPTION="A 3D MMORPG virtual world entirely built and owned by its residents"
HOMEPAGE="http://secondlife.com/"
SRC_URI="http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-src-${MY_PV}.tar.gz
	http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-artwork-${MY_PV}.zip
	voice? ( http://secondlife.com/developers/opensource/downloads/${MY_DATE}/slviewer-linux-libs-${MY_PV}.tar.gz )
	http://distfiles.zugaina.org/secondlife-fonts.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="fmod openal voice llmozlib"
RESTRICT="mirror"

RDEPEND=">=x11-libs/gtk+-2
	=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	dev-libs/boost
	net-misc/curl
	dev-libs/openssl
	media-libs/freetype
	media-libs/jpeg
	media-libs/libsdl
	media-libs/mesa
	media-libs/libogg
	media-libs/libvorbis
	x86? ( 
	    fmod? ( =media-libs/fmod-3.75* )
	)
	=sys-libs/db-4.2*
	dev-libs/expat
	sys-libs/zlib
	>=dev-libs/xmlrpc-epi-0.51-r1
	dev-libs/elfio
	>=media-libs/openjpeg-1.3
	media-fonts/kochi-substitute
	dev-util/google-perftools
	openal? (
	    media-libs/freealut
	    media-libs/openal
	    =media-libs/gstreamer-0.10*
	)
	>=net-dns/c-ares-1.5.1
	media-libs/fontconfig
	"

DEPEND="${RDEPEND}
	>=dev-util/scons-0.97
	dev-util/pkgconfig
	sys-devel/flex
	sys-devel/bison
	<sys-devel/gcc-4.2.0"

S="${WORKDIR}/linden"

dir="${GAMES_DATADIR}/${PN}"

pkg_setup() {
    if [ "`gcc-config -c | grep '4.2.0'`" ]; then
	die "Secondlife need gcc < 4.2.0. Use gcc-config to use another version."
    fi
    ewarn "Forcing on xorg-x11..."
    OLD_IMPLEM="$(eselect opengl show)"
    eselect opengl set --impl-headers xorg-x11

}


src_unpack() {
	unpack slviewer-src-${MY_PV}.tar.gz
	unpack slviewer-artwork-${MY_PV}.zip
	unpack secondlife-fonts.tar.gz
	if use voice ; then
	    mkdir ${WORKDIR}/voice
	    cd ${WORKDIR}/voice
	    unpack slviewer-linux-libs-${MY_PV}.tar.gz
	fi
	rm -rf "${S}"/indra/libraries/include/*
	cd "${S}"/indra
		
	epatch ${FILESDIR}/${PV}/${PN}-gentoo.patch
	epatch ${FILESDIR}/${PV}/${PN}-boost.patch
	epatch ${FILESDIR}/${PV}/${PN}-mutelist.patch
	epatch ${FILESDIR}/${PV}/${PN}-faster_wind-7.patch
	epatch ${FILESDIR}/${PV}/${PN}-crashlogger.patch
	epatch ${FILESDIR}/${PV}/${PN}-apr_thread_mutex_nested.patch
	epatch ${FILESDIR}/${PV}/${PN}-channel.patch
	if use openal ; then
	    epatch ${FILESDIR}/${PV}/${PN}-openal.patch
	    epatch ${FILESDIR}/${PV}/${PN}-gstreamer_audio.patch
	fi

	EPATCH_SOURCE="${FILESDIR}/${PV}/svn" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch

	sed -i -e "s/gcc_bin = .*$/gcc_bin = '$(tc-getCXX)'/" SConstruct || die
	#sed -i -e "s/#define LL_DEBUG_GL 1/#define LL_DEBUG_GL 0/" llwindows/llgl.cpp || die
	
#	if use nomozlib ; then
#	    rm -rf linden/indra/newview/app_settings
#	else (
	    dstdir="libraries/`uname -m`-linux/lib_release_client/"
	    cp /usr/share/games/secondlife/lib/llmozlib/* \
	    "${S}/${dstdir}" || die
#	) fi

}

src_compile() {
	local myarch
	local myopts="BUILD=release STANDALONE=yes BTARGET=client DISTCC=no GRID=agni"
	if [ "${ARCH}" == "x86" ] ; then
		myopts="${myopts} ARCH=i686"
	elif [ "${ARCH}" == "amd64" ] ; then
		myopts="${myopts} ARCH=x86_64"
	elif [ "${ARCH}" == "ppc" ] ; then
		myopts="${myopts} ARCH=powerpc"
	fi
	if use openal ; then
	    myopts="${myopts} GSTREAMER=yes"
	else
	    myopts="${myopts} GSTREAMER=no"
	fi
	if use llmozlib ; then
	    myopts="${myopts} MOZLIB2=yes"
	else
	    myopts="${myopts} MOZLIB2=no"
	fi
	# Problems to compile if ELFIO=yes
	myopts="${myopts} ELFIO=no"
	if use fmod && [ "${ARCH}" == "x86" ] ; then
	    myopts="${myopts} FMOD=yes"
	else
	    myopts="${myopts} FMOD=no"
	fi	
	cd "${S}"/indra
	CLIENT_CPPFLAGS="${CXXFLAGS}" TEMP_BUILD_DIR= scons ${myopts} || die
}

src_install() {
	cd "${S}"/indra/newview/

	insinto "${dir}"
	doins featuretable.txt featuretable_mac.txt gpu_table.txt || die
	doins -r app_settings character fonts skins res-sdl || die
	doins ${FILESDIR}/gridargs.dat
	newins res/ll_icon.ico secondlife.ico || die
	newins featuretable.txt featuretable_linux.txt || die
	doins lsl_guide.html releasenotes.txt || die
	newins licenses-linux.txt licenses.txt || die
	newins linux_tools/client-readme.txt README-linux.txt || die

	insinto "${dir}"/app_settings/
	doins "${S}"/scripts/messages/message_template.msg || die
	doins "${S}"/etc/message.xml || die

	exeinto "${dir}"
	doexe linux_tools/launch_url.sh || die
	newexe linux_tools/wrapper.sh secondlife || die
	#newexe ../linux_crash_logger/linux-crash-logger-*-bin* linux-crash-logger.bin || die

	if use voice ; then
	    exeinto "${dir}"
	    doexe ${WORKDIR}/voice/linden/indra/newview/vivox-runtime/i686-linux/SLVoice
	    # For bugs VWR-5708 and VWR-4589
	    sed 's/:$/: /g' /proc/cpuinfo > "${D}"/"${dir}"/lib/cpuinfo
	    sed -i 's/\/proc\/cpuinfo/lib\/cpuinfo\c@\c@/g' ${WORKDIR}/voice/linden/indra/newview/vivox-runtime/i686-linux/libvivoxsdk.so 
	    
	    insinto "${dir}"/lib/
	    doins ${WORKDIR}/voice/linden/indra/newview/vivox-runtime/i686-linux/libvivoxsdk.so
	    doins ${WORKDIR}/voice/linden/indra/newview/vivox-runtime/i686-linux/libopenal.so.1
	    doins ${WORKDIR}/voice/linden/indra/newview/vivox-runtime/i686-linux/libortp.so
	    doins ${WORKDIR}/voice/linden/indra/newview/vivox-runtime/i686-linux/libalut.so
	fi
	
	exeinto "${dir}"/bin/

	if [ "${ARCH}" == "x86" ] ; then
	    newexe secondlife-i686-bin do-not-directly-run-secondlife-bin || die
	elif [ "${ARCH}" == "amd64" ] ; then
	    newexe secondlife-x86_64-bin do-not-directly-run-secondlife-bin || die
	elif [ "${ARCH}" == "ppc" ] ; then
	    newexe secondlife-powerpc-bin do-not-directly-run-secondlife-bin || die
	fi

	exeinto "${dir}"/lib
	doexe ../lib_release_client/*-linux/* || die

	dosym /usr/share/fonts/kochi-substitute/kochi-mincho-subst.ttf /usr/share/games/secondlife/unicode.ttf
        games_make_wrapper secondlife ./secondlife "${dir}"
	newicon res/ll_icon.ico secondlife.ico || die
	make_desktop_entry secondlife "Second Life" secondlife.ico

	dodoc releasenotes.txt
	newdoc licenses-linux.txt licenses.txt
	newdoc linux_tools/client-readme.txt README-linux.txt

	dohtml lsl_guide.html

	prepgamesdirs
}

pkg_postinst() {
        switch_opengl_implem
	einfo "There is no voice in Linux 64 bits version of SecondLife"
	einfo "If you want to enable voice, at least to listen to other"
	einfo "you have to install SL under wine in default directory."
}

switch_opengl_implem() {
        # Switch to the xorg implementation.
        # Use new opengl-update that will not reset user selected
        # OpenGL interface ...
        echo
        #eselect opengl set --use-old ${OPENGL_DIR}
        eselect opengl set ${OLD_IMPLEM}
}
