# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=TJMATHER
inherit perl-module

DESCRIPTION="Crypt::OpenSSL::DSA module for perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="dev-libs/openssl
	dev-lang/perl"
DEPEND="${RDEPEND}"

SRC_TEST="do"

mydoc="rfc*.txt"
