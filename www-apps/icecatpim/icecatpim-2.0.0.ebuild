# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild is made by Ycarus <ycarus@zugaina.org> - http://gpo.zugaina.org/Overlays/zugaina

EAPI="2"

inherit webapp depend.apache versionator eutils

MY_PB=$(get_version_component_range 1-2)

DESCRIPTION="Product Information Management (PIM) system"
SRC_URI="mirror://sourceforge/icecatpim/IcecatPIM%20v.2/Gentoo/PIMinstall-${PV}-gentoo.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/icecatpim/"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	virtual/httpd-cgi
	>=dev-lang/perl-5.8.8
	www-apache/mod_perl
	dev-perl/Algorithm-CheckDigits
	perl-core/Compress-Raw-Bzip2
	perl-core/Compress-Raw-Zlib
	dev-perl/Data-Serializer
	dev-perl/File-Stat
	dev-perl/GD
	dev-perl/GD-Graph3d
	dev-perl/HTML-FromText
	dev-perl/HTML-Parser
	virtual/perl-IO
	virtual/perl-IO-Compress
	dev-perl/log-dispatch
	virtual/perl-MIME-Base64
	dev-perl/MIME-Types
	dev-perl/SOAP-Lite
	dev-perl/Search-Tools
	dev-perl/Spreadsheet-ParseExcel
	dev-perl/Spreadsheet-WriteExcel
	dev-perl/Spreadsheet-XLSX
	dev-perl/String-Escape
	dev-perl/Text-CSV
	dev-perl/Text-Diff
	dev-perl/Text-Levenshtein
	virtual/perl-Time-HiRes
	virtual/perl-Time-Piece
	dev-perl/Unicode-Map8
	dev-perl/Unicode-String
	dev-perl/WebService-Validator-HTML-W3C
	dev-perl/XML-LibXML
	dev-perl/XML-SAX
	dev-perl/XML-Simple
	dev-perl/XML-XPath
	dev-perl/libwww-perl
"

S=${WORKDIR}/PIMinstall

pkg_setup() {
	depend.apache_pkg_setup modperl
	webapp_pkg_setup
}

src_prepare() {
	rm -rf "${S}"/modules.tar.gz || die
	mkdir "${S}"/install
	cd "${S}"/install
	tar xzf ../ICECatPIM-2.0.tar.gz
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r install/.
	insinto "${MY_HTDOCSDIR}"/sql
	doins pim.sql
	insinto "${MY_HTDOCSDIR}"/data_source/IcecatToPIMImport/
	newins files/PIMConfiguration.pm PIMImportConfiguration.pm
	insinto "${MY_HTDOCSDIR}"/conf
	doins "${FILESDIR}"/pim_vhost.conf
	doins crontab
	insinto "${MY_HTDOCSDIR}"/lib
	doins files/atomcfg.pm

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install

	chmod -R +x "${D}${MY_HTDOCSDIR}"/www
	chmod -R +x "${D}${MY_HTDOCSDIR}"/lib
	chmod -R +x "${D}${MY_HTDOCSDIR}"/bin
}
