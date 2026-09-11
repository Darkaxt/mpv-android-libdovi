#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$IN_CI" ] && IN_CI=0
[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

clone_revision() {
	local url="$1"
	local directory="$2"
	local revision="$3"
	local expected="$4"

	if [ -d "$directory" ]; then
		local actual
		actual=$(git -C "$directory" rev-parse HEAD 2>/dev/null || true)
		if [ "$actual" != "$expected" ]; then
			echo "Existing $directory is at $actual, expected $expected; remove it before rebuilding." >&2
			exit 1
		fi
		return
	fi

	git init --quiet "$directory"
	git -C "$directory" remote add origin "$url"
	git -C "$directory" fetch --quiet --depth=1 origin "$revision"
	local actual
	actual=$(git -C "$directory" rev-parse 'FETCH_HEAD^{commit}')
	if [ "$actual" != "$expected" ]; then
		echo "Fetched $directory revision $actual, expected $expected." >&2
		exit 1
	fi
	git -C "$directory" checkout --quiet --detach FETCH_HEAD
	git -C "$directory" submodule update --init --recursive --depth=1
}

# mbedtls
if [ ! -d mbedtls ]; then
	mkdir mbedtls
	$WGET https://github.com/Mbed-TLS/mbedtls/releases/download/mbedtls-$v_mbedtls/mbedtls-$v_mbedtls.tar.bz2 -O - | \
		tar -xj -C mbedtls --strip-components=1
fi

# dav1d
clone_revision https://github.com/videolan/dav1d dav1d "$v_dav1d" "$r_dav1d"

# ffmpeg
clone_revision https://github.com/FFmpeg/FFmpeg ffmpeg "$v_ffmpeg" "$r_ffmpeg"

# freetype2
[ ! -d freetype2 ] && git clone --recurse-submodules https://gitlab.freedesktop.org/freetype/freetype.git freetype2 -b VER-${v_freetype//./-}

# fribidi
if [ ! -d fribidi ]; then
	mkdir fribidi
	$WGET https://github.com/fribidi/fribidi/releases/download/v$v_fribidi/fribidi-$v_fribidi.tar.xz -O - | \
		tar -xJ -C fribidi --strip-components=1
fi

# harfbuzz
if [ ! -d harfbuzz ]; then
	mkdir harfbuzz
	$WGET https://github.com/harfbuzz/harfbuzz/releases/download/$v_harfbuzz/harfbuzz-$v_harfbuzz.tar.xz -O - | \
		tar -xJ -C harfbuzz --strip-components=1
fi

# unibreak
if [ ! -d unibreak ]; then
	mkdir unibreak
	$WGET https://github.com/adah1972/libunibreak/releases/download/libunibreak_${v_unibreak//./_}/libunibreak-${v_unibreak}.tar.gz -O - | \
		tar -xz -C unibreak --strip-components=1
fi

# libxml2
if [ ! -d libxml2 ]; then
	mkdir libxml2
	$WGET https://gitlab.gnome.org/GNOME/libxml2/-/archive/v${v_libxml2}/libxml2-v${v_libxml2}.tar.gz -O - | \
		tar -xz -C libxml2 --strip-components=1
fi

# fontconfig
if [ ! -d fontconfig ]; then
	mkdir fontconfig
	$WGET https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/${v_fontconfig}/fontconfig-${v_fontconfig}.tar.gz -O - | \
		tar -xz -C fontconfig --strip-components=1
fi

# libass
clone_revision https://github.com/libass/libass libass "$v_libass" "$r_libass"

# lua
if [ ! -d lua ]; then
	mkdir lua
	$WGET https://www.lua.org/ftp/lua-$v_lua.tar.gz -O - | \
		tar -xz -C lua --strip-components=1
fi

# libdovi (Dolby Vision RPU decoder, Rust). The crate lives inside the
# dovi_tool monorepo under dolby_vision/. We pin to the tag so the
# tarball checksum is stable across builds.
if [ ! -d libdovi ]; then
	mkdir libdovi
	$WGET https://github.com/quietvoid/dovi_tool/archive/refs/tags/libdovi-${v_libdovi}.tar.gz -O - | \
		tar -xz -C libdovi --strip-components=1
fi

# libplacebo
clone_revision https://github.com/haasn/libplacebo libplacebo "$r_libplacebo" "$r_libplacebo"
git -C libplacebo fetch --quiet --depth=256 origin "$r_libplacebo"
if ! git -C libplacebo merge-base --is-ancestor \
	"$r_libplacebo_pink_fix" "$r_libplacebo"; then
	echo "Pinned libplacebo revision does not contain the required pink-screen fix" >&2
	exit 1
fi

# mpv
clone_revision https://github.com/mpv-player/mpv mpv "$r_mpv" "$r_mpv"

cd ..
