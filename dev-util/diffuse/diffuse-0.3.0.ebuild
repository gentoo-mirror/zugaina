# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Diffuse is a graphical tool for merging and comparing text files."
HOMEPAGE="http://diffuse.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.10.6"

src_install() {
    insinto /usr/share/diffuse/syntax
    doins ${S}/src/usr/share/diffuse/syntax/*
    exeinto /usr/bin
    doexe ${S}/src/usr/bin/diffuse
    insinto /usr/share/pixmaps
    doins ${S}/src/usr/share/pixmaps/*
    insinto /usr/share/gnome/help/diffuse/C
    doins ${S}/src/usr/share/gnome/help/diffuse/C/*
    insinto /usr/share/omf/diffuse
    doins ${S}/src/usr/share/omf/diffuse/*
    dodoc AUTHORS COPYING ChangeLog README TODO
}