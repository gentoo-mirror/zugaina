# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
MODULE_AUTHOR=KHAMPTON
inherit perl-module

DESCRIPTION="Perl extension to generate and test check digits"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
DEPEND="
	${COMMON_DEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.01
	)
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"
