# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="SING stands for 'Send ICMP Nasty Garbage'. It is a tool that sends ICMP packets fully customized from command line"
HOMEPAGE="http://sourceforge.net/projects/sing/"
SRC_URI="mirror://sourceforge/${PN}/SING-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""

S=${WORKDIR}/SING-${PV}

src_compile() {
    ./configure || die
    make || die
}

src_install() {
    dobin sing
}