# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://bugs.gentoo.org/show_bug.cgi?id=63785 - The site http://gentoo.zugaina.org/ only host a copy.
# Small modifications by Ycarus

KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64"
DESCRIPTION="GmailFS provides a mountable Linux filesystem which uses your Gmail account as its storage medium."
HOMEPAGE="http://richard.jones.name/google-hacks/gmail-filesystem/gmail-filesystem.html"
SRC_URI="http://richard.jones.name/google-hacks/gmail-filesystem/gmailfs-0.4.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=dev-lang/python-2.3
	>=sys-fs/fuse-python-0.1
	>=sys-fs/fuse-1.3
	>=net-libs/libgmail-0.0.8
	sys-fs/fuse-python"

src_install() {
	dobin ${WORKDIR}/gmailfs-0.4/gmailfs.py || die "Can't dobin"
	insinto /sbin
	doins ${WORKDIR}/gmailfs-0.4/mount.gmailfs || die "Can't write to /sbin"
	insinto /etc
	doins ${WORKDIR}/gmailfs-0.4/gmailfs.conf || die "Can't write to /etc"
}

pkg_postinst() {
	einfo "You should now be able to mount gmailfs."
	einfo "To mount from the command line, do:"
	einfo "mount -t gmailfs /usr/bin/gmailfs.py /path/of/mount/point -o username=gmailuser,password=gmailpass,fsname=zOlRRa"
	einfo "To use fstab, create an entry /etc/fstab that looks something like:"
	einfo "/usr/bin/gmailfs.py /path/of/mount/point gmailfs noauto,username=gmailuser,password=gmailpass,fsname=zOlRRa"
	einfo " "
	ewarn "Remember to choose a very creative, unguessable fsname, else someone"
	ewarn "could manipulate your filesystem. Also remember that gmailfs is a"
	ewarn "cruel hack. So don't expect things like good performance"
	einfo " "
	einfo "You actually need to use libgmail from CVS. So do this:"
	einfo "cvs -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/libgmail login"
	einfo "cvs -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/libgmail co libgmail"
	einfo "then copy constants.py and libgmail.py to your"
	einfo "/usr/lib/python-<ver>/site-packages directory"
	chmod a+x /sbin/mount.gmailfs
	ln -s /sbin/mount.gmailfs /sbin/mount.fuse
}
