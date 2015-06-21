# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

DESCRIPTION="The carwhisperer project intends to sensibilise manufacturers of carkits for the possible security threat evolving from the use of standard passkeys."
HOMEPAGE="http://trifinite.org/trifinite_stuff_carwhisperer.html"
SRC_URI="http://trifinite.org/Downloads/${P}.tar.gz"
LICENSE="GPL-2"
DEPEND=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
RESTRICT="nomirror"

src_install() {
    dobin carwhisperer cw_pin.pl cw_scanner
    insinto /etc/bluetooth
    doins hcid.conf
}
