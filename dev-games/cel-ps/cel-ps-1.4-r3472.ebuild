# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/cel-ps/cel-ps-1.4-r3472.ebuild,v 1.4 2008/06/26 12:00:00 loux.thefuture Exp $

inherit eutils flag-o-matic

DESCRIPTION="Portable 3D Game Development Kit written in C++"
HOMEPAGE="http://crystal.sourceforge.net/"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${PF}.tar.bz2
http://loux.thefuture.free.fr/distfiles/${PF}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=" ~x86 ~amd64 "
IUSE="3ds alsa cegui mng ode sdl vorbis static maxoptimization doc debug tcmalloc"
RESTRICT="mirror"

RDEPEND="virtual/opengl
	virtual/glu
	cegui? ( dev-games/cegui )
	ode? (  dev-games/ode )
	sdl? ( media-libs/libsdl )
	vorbis? ( media-libs/libogg
		      media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	mng? ( media-libs/libmng )
	media-libs/jpeg
	>=media-libs/cal3d-0.11
	media-libs/libpng
	>=media-libs/freetype-2.1
	media-gfx/nvidia-cg-toolkit
	x11-libs/libXaw
	x11-libs/libXxf86vm
	media-libs/openal
	media-libs/freealut
	>=dev-games/crystalspace-ps-1.4"

DEPEND="${RDEPEND}
	3ds? ( media-libs/lib3ds )
	dev-util/ftjam
	dev-lang/swig"

S="${WORKDIR}/cel"
DEST="/opt/planeshift/cel"
CS_PREFIX="/opt/planeshift/crystalspace"

src_compile() {
	my_conf="--enable-optimize-mode-debug-info=no"
        if use maxoptimization && ! use doc ; then
                my_conf="${my_conf} --enable-cpu-specific-optimizations=maximum"
        else
                my_conf="${my_conf} --enable-cpu-specific-optimizations=no"
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

	export CRYSTAL=${CS_PREFIX}
	econf --prefix=${DEST} \
		--datadir=${DEST}/share \
		--sysconfdir=${DEST}/etc \
		--infodir=${DEST}/share/info \
		--mandir=${DEST}/share/man \
		--without-lcms \
		--with-cs-prefix=${CS_PREFIX} \
		${my_conf} \
		--without-perl \
		--without-python \
		--without-java \
		--with-png \
		--with-freetype2 \
		--with-cal3d \
		--with-cg \
		--with-jpeg \
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
		jam staticplugins || die "compile staticplugins failed"
	fi
}

src_install() {
	jam -q -s DESTDIR="${D}" install || die "make install failed"
	MY_LIB="lib"
	if use amd64 ; then
		dosym ${DEST}/lib64 ${DEST}/lib
		MY_LIB="lib64"
	fi
	dosym libceltool-1.4.a ${DEST}/${MY_LIB}/libceltool.a
	if use static ; then
		sed -i -e 's!Depends install_staticplugins : install_libs ;!!' \
        	        mk/jam/static.jam

		jam -q -s DESTDIR="${D}" install_staticplugins || die "jam install staticplugins failed"
		dosym libcel_staticplugins-1.4.a ${DEST}/${MY_LIB}/libcel_staticplugins.a
	fi

        if [[ ! -e cel-config ]]; then
                dosym ${DEST}/bin/cel-config-1.4 ${DEST}/bin/cel-config
        fi

	change_envd "91cel" "CEL" "/opt/planeshift/cel/lib/cel-1.4"
}

fix_vfs_cfg()
{
        CS_PREFIX_ETC=${CS_PREFIX}/etc/crystalspace-1.4
        dodir ${CS_PREFIX_ETC}
        CS_PREFIX_CFG=${CS_PREFIX_ETC}/vfs.cfg
        if [[ ! -e "${CS_PREFIX_CFG}.old" ]]; then
                cp ${CS_PREFIX_CFG} ${D}/${CS_PREFIX_CFG}.old
        else
                cp ${CS_PREFIX_CFG}.old ${D}/${CS_PREFIX_CFG}.old
        fi
        cp ${D}/${CS_PREFIX_CFG}.old ${D}/${CS_PREFIX_CFG}
        cat ${D}/${DEST}/etc/cel/vfs.cfg >> ${D}/${CS_PREFIX_CFG}

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
