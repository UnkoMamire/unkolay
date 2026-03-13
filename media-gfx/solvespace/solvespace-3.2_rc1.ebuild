# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs xdg

MY_PN=${PN}
MY_PV=$(ver_rs 2 '-')
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Parametric 2d/3d CAD"
HOMEPAGE="https://solvespace.com"
SRC_URI="https://github.com/solvespace/solvespace/releases/download/v${MY_PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

# licenses
# + SolveSpace (GPL-3+)
# |- Bitstream Vera (BitstreamVera)
# + libdxfrw (GPL-2+)
# + mimalloc (MIT)

LICENSE="GPL-3+ GPL-2+ MIT BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+gui openmp lto"

RDEPEND="
	media-libs/freetype
	media-libs/libpng
	sys-libs/zlib
	x11-libs/cairo
	gui? (
		>=dev-cpp/gtkmm-3.16:3.0=
		dev-cpp/pangomm:1.4
		dev-libs/libspnav[X]
		media-libs/fontconfig
		dev-libs/json-c
		virtual/opengl
	)
"

DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
"

BDEPEND="virtual/pkgconfig"

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_GUI=$(usex gui)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_LTO=$(usex lto)
	)

	cmake_src_configure
}
