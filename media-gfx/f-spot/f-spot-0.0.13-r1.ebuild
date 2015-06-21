# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils mono gnome2

DESCRIPTION="An application designed to provide personal photo management to the GNOME desktop. Features include import, export, printing and advanced sorting of digital images."
HOMEPAGE="http://gnome.org/projects/f-spot/"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${PN}/0.0/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="nomirror"

IUSE=""

DEPEND=">=dev-lang/mono-1.0.6
	>=dev-dotnet/gtk-sharp-1.9.2
	media-libs/libexif
	=dev-db/sqlite-2.8*
	media-libs/lcms
	>=media-libs/libgphoto2-2.1.4
	gnome-base/libgnomeui"
