# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="A base32/quoted-printable encoder/decoder Perl Modules"
HOMEPAGE="http://search.cpan.org/~danpeder/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DA/DANPEDER/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"

S=${WORKDIR}/${PN}-${PV/a/}