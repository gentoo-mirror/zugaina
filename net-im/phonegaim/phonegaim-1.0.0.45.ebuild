# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit flag-o-matic eutils
use debug && inherit debug

IUSE="nls perl spell nas debug crypt cjk gnutls silc evo krb4"

MY_P="gaim_0.79-1.0.0.45.lindows0.5"
DESCRIPTION="GTK All-In-One Instant Messenging and Internet Calling solution"
DESCRIPTION_FR="Client de messagerie instantanée avec une solution d'appel par Internet"
HOMEPAGE="http://www.phonegaim.com"
SRC_URI="http://software.linspire.com/emptypool//lindowsos/pool/main/g/gaim/${MY_P}.tar.gz
	http://simon.morlat.free.fr/download/0.12.2/source/linphone-0.12.2.tar.gz"

S="${WORKDIR}/gaim-0.79"
RESTRICT="nomirror"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND=">=x11-libs/gtk+-2.0
	>=dev-libs/glib-2.0
	nas? ( >=media-libs/nas-1.4.1-r1 )
	sys-devel/gettext
	media-libs/libao
	>=media-libs/audiofile-0.2.0
	perl? ( >=dev-lang/perl-5.8.2-r1
			!<dev-perl/ExtUtils-MakeMaker-6.17 )
	spell? ( >=app-text/gtkspell-2.0.2 )
	dev-libs/nss
	=net-im/linphone-0.12.2
	>=media-libs/libj2k-0.0.8
	gnutls? ( net-libs/gnutls )
	krb4? ( app-crypt/mit-krb5 )
	!mips? (
		!ia64? ( evo? ( mail-client/evolution ) )
		silc? ( >=net-im/silc-toolkit-0.9.12-r2 )
	)"
PDEPEND="crypt? ( >=x11-plugins/gaim-encryption-2.27 )"

pkg_setup() {
	ewarn
	ewarn "If you are merging ${P} from an earlier version, you will need"
	ewarn "to re-merge any plugins like gaim-encryption or gaim-snpp."
	ewarn
	for TICKER in 1 2 3 4 5; do
		# Double beep here.
		echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
		echo -ne "\a" ; sleep 1
	done
	sleep 8
}

src_unpack() {
	unpack ${A}
	unpack linphone-0.12.2.tar.gz
	cd ${S}
	mkdir osipua
	mkdir oRTP
	mkdir mediastreamer
	cd osipua
	mkdir src
	cd ${S}/oRTP
	mkdir src
	cp ${WORKDIR}/linphone-0.12.2/osipua/src/osipua.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/osipua/src/osipdialog.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/osipua/src/osipmanager.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/osipua/src/bodyhandler.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/osipua/src/bodycontext.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/osipua/src/regctxt.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/osipua/osipua-config.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/ortp.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/rtpsession.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/rtpport.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/rtp.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/payloadtype.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/sessionset.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/str_utils.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/rtpsignaltable.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/scheduler.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/rtptimer.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/src/port_fct.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/oRTP/ortp-config.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/mediastreamer/sndcard.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/coreapi/linphonecore.h ${S}
	cp ${WORKDIR}/linphone-0.12.2/mediastreamer/sndcard.h ${S}
	
	cd ${S}
	aclocal
	automake
}

src_compile() {
	einfo "Replacing -Os CFLAG with -O2"
	replace-flags -Os -O2

	# -msse2 doesn't play nice on gcc 3.2
	[ "`gcc-version`" == "3.2" ] && filter-flags -msse2

	local myconf
	myconf="${myconf} --prefix=/usr"
	use perl || myconf="${myconf} --disable-perl"
	use spell || myconf="${myconf} --disable-gtkspell"
	use nls  || myconf="${myconf} --disable-nls"
	use nas && myconf="${myconf} --enable-nas" || myconf="${myconf} --disable-nas"
	use evo || myconf="${myconf} --disable-gevolution"
	use krb4 && myconf="${myconf} --with-krb4=/usr"
	
	if use gnutls ; then
		myconf="${myconf} --with-gnutls-includes=/usr/include/gnutls"
		myconf="${myconf} --with-gnutls-libs=/usr/lib"
	else
		myconf="${myconf} --enable-gnutls=no"
	fi

	if ! use mips ; then
		if use silc ; then
			myconf="${myconf} --with-silc-includes=/usr/include/silc-toolkit"
			myconf="${myconf} --with-silc-libs=/usr/lib"
		fi
	fi

	myconf="${myconf} --with-nspr-includes=/usr/include/nspr"
	myconf="${myconf} --with-nss-includes=/usr/include/nss"
	myconf="${myconf} --with-nspr-libs=/usr/lib"
	myconf="${myconf} --with-nss-libs=/usr/lib"
	
	econf ${myconf} || die "Configuration failed"

	emake || MAKEOPTS="${MAKEOPTS} -j1" emake || die "Make failed"
}

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	dodoc ABOUT-NLS AUTHORS COPYING HACKING INSTALL NEWS PROGRAMMING_NOTES README ChangeLog VERSION
}

pkg_postinst() {
	ewarn
	ewarn "If you are merging ${P} from an earlier version, you will need"
	ewarn "to re-merge any plugins like gaim-encryption or gaim-snpp."
	ewarn
	for TICKER in 1 2 3 4 5; do
		# Double beep here.
		echo -ne "\a" ; sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
		echo -ne "\a" ; sleep 1
	done
	sleep 8
}
