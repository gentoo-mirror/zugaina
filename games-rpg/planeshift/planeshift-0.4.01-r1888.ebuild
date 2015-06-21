# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/planeshift/planeshift-0.4.01-r1839.ebuild,v 1.3 2008/06/30 12:00:00 loux.thefuture Exp $

inherit eutils games flag-o-matic

DESCRIPTION="Virtual fantasy world MMORPG"
HOMEPAGE="http://www.planeshift.it/"
SRC_URI="http://dev.gentooexperimental.org/~loux/distfiles/${PF}.tar.bz2
http://loux.thefuture.free.fr/distfiles/${PF}.tar.bz2"

LICENSE="|| ( GPL-2 Planeshift )"
SLOT="0"
KEYWORDS="~x86 ~amd64 "
IUSE="server static debug maxoptimization debug tcmalloc"
RESTRICT="mirror"

RDEPEND="net-misc/curl
	>=media-libs/cal3d-0.12
	>=dev-games/crystalspace-ps-1.4
	server? ( virtual/mysql >=dev-games/cel-ps-1.4 )
        tcmalloc? ( >=dev-util/google-perftools-0.91 )"

S=${WORKDIR}/${PN}

PS_PREFIX=/opt/planeshift
CS_PREFIX=${PS_PREFIX}/crystalspace
CEL_PREFIX=${PS_PREFIX}/cel

src_compile() {
	./autogen.sh
	my_conf=""

	if use debug ; then
		my_conf="${my_conf}"
                CFLAGS=""
                CXXFLAGS=""
                LDFLAGS=""
	else
		my_conf="${my_conf} --enable-optimize-mode-debug-info=no"
	        my_conf="${my_conf} --enable-separate-debug-info=no"
        	my_conf="${my_conf} --with-optimize-debug-info=no"

        	if use maxoptimization ; then
                	my_conf="${my_conf} --enable-cpu-specific-optimizations=maximum"
	        else
        	        my_conf="${my_conf} --enable-cpu-specific-optimizations=no"
	        fi
	
	fi
	if ! use server ; then
		my_conf="${my_conf} --with-cel=no"
	fi	
	
	use tcmalloc && append-flags "-DCS_NO_PTMALLOC"
        use tcmalloc && append-ldflags "-lpthread -ltcmalloc"
	
	#for cs-config to find cs-config-1.4
	export CRYSTAL=${CS_PREFIX}
	export CEL=${CEL_PREFIX}
	econf --prefix=${PS_PREFIX} ${my_conf} \
		--with-cs-prefix=${CS_PREFIX} \
		--with-cel-prefix=${CEL_PREFIX} \
		$(use_enable debug) \
		--without-python \
		|| die "Error : econf failed"

	#Clear out the npcclient stuff.. it fails to build properly
	if ! use server ; then 
		sed 's/SubInclude TOP src npcclient ;//' -i src/Jamfile
		sed 's/SubInclude TOP src server ;//' -i src/Jamfile
	fi

	if use tcmalloc ; then
		sed 's/SubInclude TOP src tools ase2spr ;//' -i src/tools/Jamfile
	fi

	if ! use debug ; then
		sed -e 's!COMPILER.*debug += "-g3" ;!!g' -i Jamconfig
		sed -e 's!LINK.DEBUG.INFO.SEPARATE ?= "yes" ;!!g' -i Jamconfig
        	if use maxoptimization ; then
                	sed -e 's!-O[s012]!-O3!g' -i Jamconfig
			sed -e 's!COMPILER.CFLAGS += "-march=.*!!' -i Jamconfig
        	else
                	sed -e '/COMPILER\.CFLAGS\.optimize/d' -i Jamconfig
        	fi
	fi

	jam -aq ${MAKEOPTS} || die "failed to compile"
	if use server ; then
		jam -aq ${MAKEOPTS} server || die "failed to compile server_static"
	fi
	if use static ; then
		jam -aq ${MAKEOPTS} client_static || die "failed to compile client_static"
		if use server ; then
			jam -aq ${MAKEOPTS} server_static || die "failed to compile server_static"
		fi
	fi
}

src_install() {
	jam -q -s DESTDIR="${D}" install || die "installation failed"

	if use static ; then
		cp *_static "${D}/${PS_PREFIX}/bin"
	fi

	echo "Update.Platform = false" >> "psupdater.cfg"

	cp *.{xml,cfg} "${D}/${PS_PREFIX}/bin"
	cp -R data docs "${D}/${PS_PREFIX}/bin"

	if use server ; then
		cp dbmysql.so ${D}/${CS_PREFIX}/lib/${CRYSTAL_VER}/.
		cp -R ./src/server/database/mysql "${D}/${PLANESHIFT_PREFIX}/bin"
	fi
	
	cp ${CS_PREFIX}/etc/${CRYSTAL_VER}/* "${D}/${PS_PREFIX}/bin/data/config"
	cp -R ${CS_PREFIX}/share/${CRYSTAL_VER}/data/shader ${D}/${PS_PREFIX}/bin/data/.
	dodir /usr/games/bin
	dogamesbin /usr/games/bin
	dogamesbin psupdater.sh
	dogamesbin pssetup.sh
	dogamesbin psclient.sh

	dogamesbin ${D}/${PS_PREFIX}/bin
	prepgamesdirs

	chgrp -R games "${D}/${PS_PREFIX}"
	chmod -R g+rw "${D}/${PS_PREFIX}"

	# Make sure new files stay in games group
	find "${D}/${PS_PREFIX}" -type d -exec chmod g+sx {} \;
}

pkg_postinst() {
	games_pkg_postinst
	echo
	ewarn "Before you can use Planeshift, you need to download the art"
	ewarn "do: psupdater.sh CheckIntegrity"
	ewarn

	einfo "Configure your client by running 'pssetup.sh'"
	einfo
	einfo "Type 'psclient.sh' to start the Planeshift client"
	einfo "Keep in mind, you will need to be in the games group"
}
