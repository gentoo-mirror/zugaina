# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/crystalspace-ps/crystalspace-ps-1.4-r30564.ebuild,v 1.4 2008/07/30 12:00:00 loux.thefuture Exp $

inherit eutils flag-o-matic

DESCRIPTION="Portable 3D Game Development Kit written in C++"
HOMEPAGE="http://crystal.sourceforge.net/"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${PF}.tar.bz2
	http://loux.thefuture.free.fr/distfiles/${PF}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=" ~x86 ~amd64"
IUSE="3ds alsa cegui mng ode sdl vorbis static maxoptimization doc debug tcmalloc python"
RESTRICT="mirror"

RDEPEND="virtual/opengl
	virtual/glu
	tcmalloc? ( >=dev-util/google-perftools-0.91 )
	cegui? ( >=dev-games/cegui-0.5 )
	ode? (  dev-games/ode )
	sdl? ( media-libs/libsdl )
	vorbis? ( media-libs/libogg
		      media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	mng? ( media-libs/libmng )
	media-libs/jpeg
	x11-libs/libXaw
	x11-libs/libXxf86vm
	media-gfx/nvidia-cg-toolkit
	>=media-libs/cal3d-0.12
	>=media-libs/freetype-2.1
	media-libs/libpng
	media-libs/openal
	media-libs/freealut
"

DEPEND="${RDEPEND}
	3ds? ( media-libs/lib3ds )
	dev-util/ftjam
	python? ( dev-lang/swig )"

S="${WORKDIR}/crystal"
CS_PREFIX="/opt/planeshift/crystalspace"

src_compile() {
	my_conf=""
	if use maxoptimization && ! use debug ; then
		my_conf="--enable-cpu-specific-optimizations=maximum"
	else
		my_conf="--enable-cpu-specific-optimizations=no"
	fi

	if ! use doc ; then
                sed -e 's!SubInclude TOP docs ;!!' -i Jamfile.in
        fi

	if use debug; then
		my_conf="${my_conf} --enable-debug"
		CFLAGS=""
		CXXFLAGS=""
		LDFLAGS=""
        else
                my_conf="${my_conf} --enable-separate-debug-info=no"
	fi

        use tcmalloc && append-flags "-DCS_NO_PTMALLOC"
        use tcmalloc && append-ldflags "-lpthread -ltcmalloc"

	econf --prefix=${CS_PREFIX} \
		--datadir=${CS_PREFIX}/share \
		--sysconfdir=${CS_PREFIX}/etc \
		--infodir=${CS_PREFIX}/share/info \
		--mandir=${CS_PREFIX}/share/man \
		${my_conf} \
		--without-lcms \
		--without-java \
		--without-wx \
		--without-caca \
		--with-png \
		--with-freetype2 \
		--with-cal3d \
		--with-cg \
		--with-jpeg \
		$(use_with python) \
		$(use_with mng) \
		$(use_with vorbis) \
		$(use_with 3ds) \
		$(use_with ode) \
		$(use_with sdl) \
		$(use_with cegui CEGUI) \
		$(use_with alsa asound)

	#remove unwanted CFLAGS added by ./configure
	if ! use debug ; then
		if use maxoptimization ; then
			sed -e 's!-O[s012]!-O3!g' -i Jamconfig
			sed -e 's!COMPILER.CFLAGS += "-march=.*!!' -i Jamconfig
		else
			sed -e '/COMPILER\.CFLAGS\.optimize/d' -i Jamconfig
		fi
	fi

	jam ${MAKEOPTS} || die "compile failed"	
	if use static ; then
		jam ${MAKEOPTS} staticplugins || die "compile staticplugins failed"
	fi
}

src_install() {
	jam -q -s DESTDIR="${D}" install || die "make install failed"
	MY_LIB="lib"
	if use amd64 ; then
		dosym ${CS_PREFIX}/lib64 ${CS_PREFIX}/lib
		MY_LIB="lib64"
	fi
	dosym libcrystalspace-1.4.a ${CS_PREFIX}/${MY_LIB}/libcrystalspace.a
	dosym libcrystalspace_opengl-1.4.a ${CS_PREFIX}/${MY_LIB}/libcrystalspace_opengl.a
	if use static ; then
		sed -i -e 's!Depends install_staticplugins : install_libs ;!!' \
        	        mk/jam/static.jam

	        jam -q -s DESTDIR="${D}" install_staticplugins || die "make install_static_plugins failed"
		dosym libcrystalspace_staticplugins-1.4.a ${CS_PREFIX}/${MY_LIB}/libcrystalspace_staticplugins.a
	fi
	if [[ ! -e cs-config ]]; then
		dosym ${CS_PREFIX}/bin/cs-config-1.4 ${CS_PREFIX}/bin/cs-config
	fi

	change_envd "90crystalspace" "CRYSTAL_CONFIG" "${CS_PREFIX}/etc/crystalspace-1.4"
	change_envd "90crystalspace" "CRYSTAL" "${CS_PREFIX}"

}
change_envd() {
	FILE=$1
	VARI=$2
	TEXT=$3
	echo "Change ${VARI}=${TEXT} in ${FILE}"
	SRC=""
	if [[ -e "${D}/etc/env.d/${FILE}" ]]; then
		SRC="${D}/etc/env.d/${FILE}"
	fi
	if [[ "${SRC}" == "" && -e "/etc/env.d/${FILE}" ]]; then
		SRC="/etc/env.d/${FILE}"
	fi
	if [[ "${SRC}" == "" ]]; then
		touch ${D}/${FILE}
	else
		cp "${SRC}" "${D}/${FILE}"
	fi
	sed -i "/${VARI}=/d" ${D}/${FILE}
	sed -i "/^$/d" ${D}/${FILE}
	echo "${VARI}=${TEXT}" >> ${D}/${FILE}
	doenvd ${D}/${FILE}
	rm ${D}/${FILE}
}
