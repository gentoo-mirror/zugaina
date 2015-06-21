# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mozconfig.eclass,v 1.20 2005/08/02 12:51:09 agriffis Exp $
#
# mozconfig.eclass: the new mozilla.eclass

inherit multilib flag-o-matic

IUSE="debug gnome mozpango ipv6 xinerama xprint thebes mozsvg ldap"

RDEPEND="virtual/x11
	 virtual/xft 
	>=media-libs/fontconfig-2.1
	>=sys-libs/zlib-1.1.4
	>=media-libs/jpeg-6b
	>=media-libs/libmng-1.0.0
	>=media-libs/libpng-1.2.1
	>=sys-apps/portage-2.0.36
	dev-libs/expat
	app-arch/zip
	app-arch/unzip
	>=www-client/mozilla-launcher-1.22
	>=x11-libs/gtk+-2.2.0
	>=dev-libs/glib-2.2.0
	>=x11-libs/pango-1.2.1
	>=dev-libs/libIDL-0.8.0
	gnome? ( >=gnome-base/gnome-vfs-2.3.5 
		 >=gnome-base/libgnomeui-2.2.0 )
	mozpango? ( >=x11-libs/pango-1.10.0 
		    >=x11-libs/gtk+-2.8.3 )
	mozsvg? ( !<=x11-base/xorg-x11-6.7.0-r2
		    >=x11-libs/cairo-1.0.0
		    >=media-libs/glitz-0.4.4)"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

# Set by configure (plus USE_AUTOCONF=1), but useful for NSPR
export MOZILLA_CLIENT=1
export BUILD_OPT=1
export NO_STATIC_LIB=1
#export USE_PTHREADS=1

mozconfig_init() {
	declare enable_optimize pango_version myext x
	declare MOZ=$([[ ${PN} == mozilla ]] && echo true || echo false)
	declare FF=$([[ ${PN} == *firefox ]] && echo true || echo false)
	declare DP=$([[ ${PN} == *deerpark ]] && echo true || echo false)	
	declare FC=$([[ ${PN} == *firefox-cvs ]] && echo true || echo false)		
	declare TB=$([[ ${PN} == *thunderbird ]] && echo true || echo false)
	declare SB=$([[ ${PN} == *sunbird ]] && echo true || echo false)

	####################################
	#
	# Setup the initial .mozconfig
	# See http://www.mozilla.org/build/configure-build.html
	#
	####################################

	case ${PN} in
		mozilla)
			# The other builds have an initial --enable-extensions in their
			# .mozconfig.  The "default" set in configure applies to mozilla
			# specifically.
			: >.mozconfig || die "initial mozconfig creation failed"
			mozconfig_annotate "" --enable-extensions=default ;;
		*firefox)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		*firefox-cvs)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		*deerpark)
			cp browser/config/mozconfig .mozconfig \
				|| die "cp browser/config/mozconfig failed" ;;
		*thunderbird)
			cp mail/config/mozconfig .mozconfig \
				|| die "cp mail/config/mozconfig failed" ;;
		*sunbird)
			cp calendar/sunbird/config/mozconfig .mozconfig \
				|| die "cp calendar/sunbird/config/mozconfig failed" ;;
	esac

	####################################
	#
	# CFLAGS setup and ARCH support
	#
	####################################

	# Set optimization level based on CFLAGS
	if is-flag -O0; then
		mozconfig_annotate "from CFLAGS" --enable-optimize=-O0
	elif [[ ${ARCH} == hppa ]]; then
		mozconfig_annotate "more than -O0 causes segfaults on hppa" --enable-optimize=-O0
	elif [[ ${ARCH} == alpha || ${ARCH} == amd64 || ${ARCH} == ia64 || ${ARCH} == ppc64 ]]; then
		mozconfig_annotate "more than -O1 causes segfaults on 64-bit (bug 33767)" \
			--enable-optimize=-O1
	elif is-flag -O1; then
		mozconfig_annotate "from CFLAGS" --enable-optimize=-O1
	else
		mozconfig_annotate "mozilla fallback" --enable-optimize=-O2
	fi

	# Now strip optimization from CFLAGS so it doesn't end up in the
	# compile string
	filter-flags '-O*'

	# Strip over-aggressive CFLAGS - Mozilla supplies its own
	# fine-tuned CFLAGS and shouldn't be interfered with..  Do this
	# AFTER setting optimization above since strip-flags only allows
	# -O -O1 and -O2
	strip-flags

	# -fstack-protector is in ALLOWED_FLAGS but breaks moz #83511
	filter-flags -fstack-protector

	# Additional ARCH support
	case "${ARCH}" in
	alpha)
		# Historically we have needed to add -fPIC manually for 64-bit.
		# Additionally, alpha should *always* build with -mieee for correct math
		# operation
		append-flags -fPIC -mieee
		;;

	amd64|ia64)
		# Historically we have needed to add this manually for 64-bit
		append-flags -fPIC
		;;

	ppc64)
		append-flags -fPIC -mminimal-toc
		;;

	ppc)
		# Fix to avoid gcc-3.3.x micompilation issues.
		if [[ $(gcc-major-version).$(gcc-minor-version) == 3.3 ]]; then
			append-flags -fno-strict-aliasing
		fi
		;;

	sparc)
		# Sparc support ...
		replace-sparc64-flags
		;;

	x86)
		if [[ $(gcc-major-version) -eq 3 ]]; then
			# gcc-3 prior to 3.2.3 doesn't work well for pentium4
			# see bug 25332
			if [[ $(gcc-minor-version) -lt 2 ||
				( $(gcc-minor-version) -eq 2 && $(gcc-micro-version) -lt 3 ) ]]
			then
				replace-flags -march=pentium4 -march=pentium3
				filter-flags -msse2
			fi
		fi
		;;
	esac

	if [[ $(gcc-major-version) -eq 3 ]]; then
		# Enable us to use flash, etc plugins compiled with gcc-2.95.3
		mozconfig_annotate "building with >=gcc-3" --enable-old-abi-compat-wrappers

		# Needed to build without warnings on gcc-3
		CXXFLAGS="${CXXFLAGS} -Wno-deprecated"
	fi

	# Go a little faster; use less RAM
	append-flags "$MAKEEDIT_FLAGS"

	# Define our plugin dirs for nsplugins-v2.patch
	#
	# This is the way we would *like* to do things.  However ./configure chokes
	# on these definitions, so the real definitions happen in the ebuilds, just
	# before emake.
	#
	#append-flags "-DGENTOO_NSPLUGINS_DIR=\\\"/usr/$(get_libdir)/nsplugins\\\""
	#append-flags "-DGENTOO_NSBROWSER_PLUGINS_DIR=\\\"/usr/$(get_libdir)/nsbrowser/plugins\\\""

	####################################
	#
	# mozconfig setup
	#
	####################################

	mozconfig_annotate gentoo \
		--with-pthreads \
		--disable-installer \
		--disable-updater \
		--enable-single-profile \
		--disable-profilesharing \
		--disable-profilelocking \
		--disable-pedantic \
		--enable-crypto \
		--with-system-jpeg \
		--with-system-png \
		--with-system-zlib \
		--without-system-nspr \
	
	if use thebes && ${FC}; then
	    mozconfig_annotate thebes --enable-default-toolkit=cairo-gtk2
	else
	    mozconfig_annotate -thebes --enable-default-toolkit=gtk2
	fi
	mozconfig_use_enable ipv6
	mozconfig_use_enable xinerama
	mozconfig_use_enable xprint

        mozconfig_use_enable ldap
	mozconfig_use_enable ldap ldap-experimental
	
	#xft is the default font rendering kit freetype is obsolete
	mozconfig_annotate gentoo --disable-freetype2
	mozconfig_annotate gentoo --enable-xft
	
	#disable gnomevfs and gnomeui if -gnome
	#they will be automatically enabled if the dependancies exist and +gnome
	if ! use gnome; then
		mozconfig_annotate -gnome --disable-gnomevfs
		mozconfig_annotate -gnome --disable-gnomeui
	fi
	
	#the mozsvg selects system-cairo, cairo-canvas and glitz (uses cairo)
	if use mozsvg; then
	    if ! use thebes || ! ${FC}; then
		mozconfig_annotate mozsvg --enable-system-cairo
	    fi
		mozconfig_annotate mozsvg --enable-svg
		mozconfig_annotate mozsvg --enable-canvas
		mozconfig_annotate mozsvg --enable-svg-renderer=cairo
		mozconfig_annotate mozsvg --enable-glitz
	fi
	
	#enable pango
	if use mozpango; then
		mozconfig_annotate mozpango --enable-pango
	fi
	
	if use debug; then
		mozconfig_annotate +debug \
			--enable-debug \
			--enable-tests \
			--disable-reorder \
			--disable-strip \
			--disable-strip-libs \
			--enable-debugger-info-modules=ALL_MODULES
	else
		mozconfig_annotate -debug \
			--disable-debug \
			--disable-tests \
			--enable-reorder \
			--enable-strip \
			--enable-strip-libs

		# Currently --enable-elf-dynstr-gc only works for x86 and ppc,
		# thanks to Jason Wever <weeve@gentoo.org> for the fix.
		if use x86 || use ppc && [[ ${enable_optimize} != -O0 ]]; then
			mozconfig_annotate "${ARCH} optimized build" --enable-elf-dynstr-gc
		fi
	fi

	# Here is a strange one...
	if is-flag '-mcpu=ultrasparc*' || is-flag '-mtune=ultrasparc*'; then
		mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
	fi

}

# Simulate the silly csh makemake script
makemake() {
	typeset m topdir
	for m in $(find . -name Makefile.in); do
		topdir=$(echo "$m" | sed -r 's:[^/]+:..:g')
		sed -e "s:@srcdir@:.:g" -e "s:@top_srcdir@:${topdir}:g" \
			< ${m} > ${m%.in} || die "sed ${m} failed"
	done
}

#
# The following functions are for manipulating mozconfig
#

# mozconfig_annotate: add an annotated line to .mozconfig
#
# Example:
# mozconfig_annotate "building on ultrasparc" --enable-js-ultrasparc
# => ac_add_options --enable-js-ultrasparc # building on ultrasparc
mozconfig_annotate() {
	declare reason=$1 x ; shift
	[[ $# -gt 0 ]] || die "mozconfig_annotate missing flags for ${reason}\!"
	for x in ${*}; do
		echo "ac_add_options ${x} # ${reason}" >>.mozconfig
	done
}

# mozconfig_use_enable: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_enable truetype freetype2
# => ac_add_options --enable-freetype2 # +truetype
mozconfig_use_enable() {
	declare flag=$(use_enable "$@")
	mozconfig_annotate "$(useq $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_with: add a line to .mozconfig based on a USE-flag
#
# Example:
# mozconfig_use_with kerberos gss-api /usr/$(get_libdir)
# => ac_add_options --with-gss-api=/usr/lib # +kerberos
mozconfig_use_with() {
	declare flag=$(use_with "$@")
	mozconfig_annotate "$(useq $1 && echo +$1 || echo -$1)" "${flag}"
}

# mozconfig_use_extension: enable or disable an extension based on a USE-flag
#
# Example:
# mozconfig_use_extension gnome gnomevfs
# => ac_add_options --enable-extensions=gnomevfs
mozconfig_use_extension() {
	declare minus=$(useq $1 || echo -)
	mozconfig_annotate "${minus:-+}$1" --enable-extensions=${minus}${2}
}

# mozconfig_final: display a table describing all configuration options paired
# with reasons, then clean up extensions list
mozconfig_final() {
	declare ac opt hash reason
	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options .mozconfig | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	# Resolve multiple --enable-extensions down to one
	declare exts=$(sed -n 's/^ac_add_options --enable-extensions=\([^ ]*\).*/\1/p' \
		.mozconfig | xargs)
	sed -i '/^ac_add_options --enable-extensions/d' .mozconfig
	echo "ac_add_options --enable-extensions=${exts// /,}" >> .mozconfig
}
