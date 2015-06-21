# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

MY_P="${PN}_${PV/./_}"

DESCRIPTION="NapShare is a fully automated MUTE P2P client made to run 24/7 unattended"
DESCRIPTION_FR="NapShare est un client automatique pour le reseau P2P MUTE prevu pour etre lance 24h/24"
SRC_URI="mirror://sourceforge/napshare/${MY_P}.tar.gz"
HOMEPAGE="http://napshare.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/wxGTK-2.4.2"

S=${WORKDIR}/NapShare_${PV/./_}_Source

src_compile() {
    cp ${FILESDIR}/napshareconf-gentoo ${S}/MUTE/configure
    chmod u+x MUTE/configure
    ./developer-runToBuild
}

src_install() {
    dodir /usr/share/napshare /usr/bin
    cp -r MUTE_GUI_fileSharing/* ${D}/usr/share/napshare/
    cat << EOF > ${D}/usr/bin/napshare
#!/bin/sh
cd /usr/share/napshare
./fileSharingMUTE
EOF
    chmod go+rx ${D}/usr/bin/napshare
}
