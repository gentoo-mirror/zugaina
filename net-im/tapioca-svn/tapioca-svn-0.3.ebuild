# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="Tapioca VOIP and IM framework and UI (SVN version)"
HOMEPAGE="http://tapioca-voip.sf.net"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
DEPEND="net-im/tapioca-coreclient-svn
	net-im/tapioca-xmpp-svn
	net-im/tapiocaui-svn"

