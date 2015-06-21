# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=93982 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

inherit eutils
INSTALL_PATH="/usr/share/peerguardian/"

MY_PN="${PN}-${PV/_/}"

DESCRIPTION="A lightweight IP blocker to stop rogue connections"
HOMEPAGE="http://methlabs.org/"
SRC_URI="mirror://sourceforge/peerguardian/${MY_PN}.tar.gz"

DEPEND=">=net-firewall/iptables-1.2.11-r3"
LICENCE="as-is"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_PN}

pkg_setup() {
    if [ ! -f /usr/share/peerguardian/PG.conf ]; then
	ewarn "Package isn't installed"
    else 
	ewarn "Checking status of Peerguardian"
	if /etc/init.d/peerguardian status | grep -q "stopped"; then
  	    echo "....Stopped"
	else
	    echo "....Started, Stopping"
	    /etc/init.d/peerguardian stop	  
	fi
    fi 
}

src_compile() {
    einfo "Patching files to newer versions"
    epatch ${FILESDIR}/pglinux-gentoo.patch
    emake || die "Error: emake failed!"
}

src_install() {
    dodir ${INSTALL_PATH}
    cp ${FILESDIR}/pgupdate ./
    cp ${FILESDIR}/peerguardianrc ./
    into /usr
    dobin pgupdate
    dobin peerguardnf
    dobin pgtext
    insinto /etc/init.d
    newins peerguardianrc peerguardian
    insinto ${INSTALL_PATH}
    doins PG.conf
    dodoc AUTHORS ChangeLog
}

pkg_postinst() {
    chmod +rx /etc/init.d/peerguardian
    einfo ""
    einfo " This is a Gentoo adapted version of Peerguardian"
    einfo " Full credit goes to the guys at methlabs for making such a brilliant system"
    einfo ""
    ewarn " Please run the command 'pgupdate' to update to the latest blocklist"
    ewarn ""
    ewarn " REMEMBER TO ADD PEERGUARDIAN TO BOOT!" 
    ewarn ""
    ewarn " rc-update add peerguardian default" 
    ewarn ""
}
