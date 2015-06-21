# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://www.panhorst/glcu/ - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

DESCRIPTION="gentoo linux cron update. Full featured semi-automatic updates for your gentoo box."
HOMEPAGE="http://glcu.sourceforge.net/"
SRC_URI="mirror://sourceforge/glcu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc"

RDEPEND=">=dev-lang/python-2.2
         >=sys-apps/portage-2.1.4.4
         >=app-portage/gentoolkit-0.2.3-r1
	 >=sys-apps/baselayout-1.12.11.1
         mail-client/mailx"

src_install() {
	dodir /usr/sbin/
	dodir /etc/cron.daily/

	exeinto /usr/lib/glcu
	doexe glcu.py || die "doexe failed"

	dosym /usr/lib/glcu/glcu.py /etc/cron.daily/glcu
	dosym /usr/lib/glcu/glcu.py /usr/sbin/glcu

	insinto /etc/conf.d
	doins glcu.conf



}

pkg_postinst() {
    einfo ""
    einfo " Before you can use glcu, you must edit the config file:"
    einfo "   /etc/conf.d/glcu.conf"
    einfo ""
    use esearch && einfo " For esearch support set 'eupdatedb: yes' in the config file"
    use eix && einfo " For eix support set 'updateix: yes' in the config file"
}
