# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module

DESCRIPTION="Interface to Sun's Network Information Service"
SRC_URI="mirror://cpan/authors/id/E/ES/ESM/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~esm/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

mydoc="TODO"

DEPEND="dev-lang/perl"
