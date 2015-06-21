# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit flag-o-matic eutils

DESCRIPTION="ICQ transport for wpjabber / jabberd"
DESCRIPTION_FR="ICQ transport pour wpjabber / jabberd"
HOMEPAGE="http://jit.jabberstudio.org/"
SRC_URI="http://www.jabberstudio.org/files/jit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

IUSE=""

KEYWORDS="x86 ~sparc ~ppc hppa"

DEPEND=""
RDEPEND=">=net-im/jabberd-1.4.3-r3"


src_compile() {
	epatch ${FILESDIR}/jit-1.1.6-ttn.patch
	use sparc && epatch ${FILESDIR}/jit-sparc.patch
	./configure
	emake || die
	cp ${S}/jabberd/jabberd ${S}/jabberd/jit-wpjabber
	cd xdb_file
	make
}

src_install() {
	dodir /etc/jabber /usr/sbin /usr/lib/wpjabber /var/spool/jit
	keepdir /var/spool/jit
	insinto /usr/lib/wpjabber
	doins jit/jit.so
	doins xdb_file/xdb_file.so
	exeinto /usr/sbin
	doexe jabberd/jit-wpjabber
	insinto /etc/jabberd
	doins ${FILESDIR}/jit.xml
	fowners jabber:jabber /usr/sbin/jit-wpjabber
	fperms o-rwx /etc/jabber
	fperms u+xs /usr/sbin/jit-wpjabber
	fperms g-x /var/spool/jit
	fperms g+rw /var/spool/jit
	exeinto /etc/init.d
	newexe ${FILESDIR}/jit-transport.init jit-transport
	dodoc ${FILESDIR}/README.Gentoo
}

pkg_postinst() {

	einfo
	einfo "Please edit /etc/jabberd/jit.xml"
	einfo "And please notice that now jit-transport comes with a init.d script"
	einfo "dont forget to add it to your runlevel."
	einfo
}
