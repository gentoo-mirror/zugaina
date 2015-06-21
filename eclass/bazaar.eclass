# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial eclass by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This is a modified version of the subversion eclass

## --------------------------------------------------------------------------- #
# Author: Ycarus <ycarus@zugaina.org>
# 
# The bazaar eclass is written to fetch the software sources from
# bazaar repositories like the cvs eclass.
#
#
# Description:
#   If you use this eclass, the ${S} is ${WORKDIR}/${P}.
#   It is necessary to define the EBAZAAR_REPO_URI variables at least.
#
## --------------------------------------------------------------------------- #

inherit eutils

ECLASS="bazaar"
INHERITED="${INHERITED} ${ECLASS}"
EBAZAAR="bazaar.eclass"

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://bazaar.canonical.com/"
DESCRIPTION="BAZAAR eclass"


## -- add bazaar in DEPEND
#
DEPEND="dev-util/bazaar"


## -- EBAZAAR_STORE_DIR:  Bazaar sources store directory
#
EBAZAAR_STORE_DIR="${DISTDIR}/bazaar-src"


## -- EBAZAAR_FETCH_CMD:  bazaar fetch command
#
# default: bazaar checkout
#
[ -z "${EBAZAAR_FETCH_CMD}" ]  && EBAZAAR_FETCH_CMD="baz get"
[ -z "${EBAZAAR_REGISTER_CMD}" ]  && EBAZAAR_REGISTER_CMD="baz register-archive"
[ -z "${EBAZAAR_UPDATE_CMD}" ]  && EBAZAAR_UPDATE_CMD="baz update"


## -- EBAZAAR_REPO_URI:  repository uri
#
[ -z "${EBAZAAR_REPO_URI}" ]  && EBAZAAR_REPO_URI=""

## -- EBAZAAR_REGISTER_URI:  register-archive uri
#
[ -z "${EBAZAAR_REGISTER_URI}" ]  && EBAZAAR_REGISTER_URI=""


## -- EBAZAAR_PROJECT:  project name of your ebuild
#
# bazaar eclass will check out the bazaar repository like:
#
#   ${EBAZAAR_STORE_DIR}/${EBAZAAR_PROJECT}/${EBAZAAR_REPO_URI##*/}
#
#
# default: ${PN/-bazaar}.
#
[ -z "${EBAZAAR_PROJECT}" ] && EBAZAAR_PROJECT="${PN/-bazaar}"


## -- bazaar_fetch() ------------------------------------------------- #

function bazaar_fetch() {
	# EBAZAAR_REPO_URI is empty.
	[ -z "${EBAZAAR_REPO_URI}" ] && die "${EBAZAAR}: EBAZAAR_REPO_URI is empty."
	EBAZAAR_REPO_URI="${EBAZAAR_REPO_URI} ${EBAZAAR_PROJECT}"
	# check for the protocol.
#	case ${EBAZAAR_REPO_URI%%:*} in
#		httprsync)	;;
#		ssh)	;;
#		*)
#			die "${EBAZAARN}: fetch from "${EBAZAAR_REPO_URI%:*}" is not yet implemented."
#			;;
#	esac

	if [ ! -d "${EBAZAAR_STORE_DIR}" ]; then
		debug-print "${FUNCNAME}: initial checkout. creating bazaar directory"

		addwrite /
		mkdir -p "${EBAZAAR_STORE_DIR}"      || die "${EBAZAAR}: can't mkdir ${EBAZAAR_STORE_DIR}."
		chmod -f o+rw "${EBAZAAR_STORE_DIR}" || die "${EBAZAAR}: can't chmod ${EBAZAAR_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi

	cd -P "${EBAZAAR_STORE_DIR}" || die "${EBAZAAR}: can't chdir to ${EBAZAAR_STORE_DIR}"
	EBAZAAR_STORE_DIR=${PWD}

	# every time
	addwrite "${EBAZAAR_STORE_DIR}"

	[ -z "${EBAZAAR_REPO_URI##*/}" ] && EBAZAAR_REPO_URI="${EBAZAAR_REPO_URI%/}"
	EBAZAAR_CO_DIR="${EBAZAAR_PROJECT}/${EBAZAAR_PROJECT}"
	if [ ! -d "${EBAZAAR_CO_DIR}" ]; then
		# first check out
		einfo "bazaar check out start -->"
		einfo "   checkout from: ${EBAZAAR_REPO_URI}"

		mkdir -p "${EBAZAAR_PROJECT}"      || die "${EBAZAAR}: can't mkdir ${EBAZAAR_PROJECT}."
		chmod -f o+rw "${EBAZAAR_PROJECT}" || die "${EBAZAAR}: can't chmod ${EBAZAAR_PROJECT}."
		cd "${EBAZAAR_PROJECT}"
		${EBAZAAR_REGISTER_CMD} ${EBAZAAR_REGISTER_URI} || die "${EBAZAAR}: can't register ${EBAZAAR_REGISTER_URI}."
		${EBAZAAR_FETCH_CMD} ${EBAZAAR_REPO_URI} || die "${EBAZAAR}: can't fetch from ${EBAZAAR_REPO_URI}."

		einfo "   checkouted in: ${EBAZAAR_STORE_DIR}/${EBAZAAR_CO_DIR}"

	else
		# update working copy
		einfo "bazaar update start -->"
		einfo "   update from: ${EBAZAAR_REPO_URI}"
		cd "${EBAZAAR_CO_DIR}"
		${EBAZAAR_REGISTER_CMD} ${EBAZAAR_REGISTER_URI} || die "${EBAZAAR}: can't register ${EBAZAAR_REGISTER_URI}."
		${EBAZAAR_UPDATE_CMD} || die "${EBAZAAR}: can't update from ${EBAZAAR_REPO_URI}."
		einfo "    updated in: ${EBAZAAR_STORE_DIR}/${EBAZAAR_CO_DIR}"

	fi

	# copy to the ${WORKDIR}
	cp -Rf "${EBAZAAR_STORE_DIR}/${EBAZAAR_CO_DIR}" "${S}" || die "${EBAZAAR}: can't copy to ${S}."
	einfo "     copied to: ${S}"
	echo

}

## -- bazaar_src_unpack() ------------------------------------------------ #

function bazaar_src_unpack() {

	if [ "${A}" != "" ]; then
		unpack ${A}
	fi
	bazaar_fetch || die "${EBAZAAR}: unknown problem in bazaar_fetch()."
}
