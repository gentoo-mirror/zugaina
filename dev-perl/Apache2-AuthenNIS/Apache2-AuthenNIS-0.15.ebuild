# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module

DESCRIPTION="mod_perl NIS Authentication module"
HOMEPAGE="http://search.cpan.org/~speeves/Apache2-AuthenNIS-${PV}/"
SRC_URI="mirror://cpan/authors/id/I/IT/ITEAHAUS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	virtual/perl-MIME-Base64
	>=www-apache/mod_perl-2
	dev-perl/Net-NIS"
