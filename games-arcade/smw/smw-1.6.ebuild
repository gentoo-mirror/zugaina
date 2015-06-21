# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from https://forums.gentoo.org/viewtopic-t-452242-postdays-0-postorder-asc-start-25.html - The site http://gentoo.zugaina.org/ only host a copy.

ECVS_SERVER="metascape.afraid.org:/cvsroot"
ECVS_MODULE="smw"
ECVS_USER="anonymous"
ECVS_LOCALNAME="smw"
ECVS_BRANCH="smw_1_6_1_0"

inherit cvs flag-o-matic games

DESCRIPTION="Super Mario deathmatch game"
HOMEPAGE="http://smw.72dpiarmy.com/"

LICENSE="unknown"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND="media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/sdl-net"

S=${WORKDIR}/${ECVS_MODULE}

src_compile() {
	epatch ${FILESDIR}/gentoo-smw-1.6-data-dir.patch.gz

	append-flags -Dstricmp=strcasecmp -DSleep=SDL_Delay
	mkdir -p build

	egamesconf || die "configure failed"
	emake || die "make failed"
}

function smw_recursive_rm_dir() {
	if [[ $# -ne 2 ]]; then
		echo '
This function take exactly 2 parameters :
 $1 : Starting directory, which will be scanned recursively.
 $2 : Name of directories to remove.
'
	else
		local directory
		if [[ -d "$1" ]]; then
			local this_dir=$(basename "$1")
			if [[ "${this_dir}" == "$2" ]]; then
				# want to check ? :-)
				#echo "rm -rf \"$1\""
				rm -rf "$1"
			else
				for directory in "$1"/*; do
					smw_recursive_rm_dir "$directory" "$2"
				done
			fi
		fi
	fi
}

src_install() {
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r "${S}/gfx"
	doins -r "${S}/maps"
	doins -r "${S}/music"
	doins -r "${S}/sfx"

	einfo "Removing CVS directories from image ..."
	smw_recursive_rm_dir "${D}" 'CVS' &> /dev/null

	dogamesbin smw || die
	newgamesbin leveledit smw-leveleditor || die "newgamesbin failed"

	dodoc README.txt todo.txt WHATSNEW.txt

	newicon ${FILESDIR}/smw.png smw.png
	newicon ${FILESDIR}/leveleditor.png smw-leveleditor.png

	make_desktop_entry smw 'Super Mario War' smw.png
	make_desktop_entry smw-leveleditor 'Super Mario War Level Editor' \
	smw-leveleditor.png

	prepgamesdirs
} 
