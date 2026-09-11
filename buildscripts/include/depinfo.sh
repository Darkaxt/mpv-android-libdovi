#!/bin/bash -e

## Dependency versions
# Make sure to keep v_ndk and v_ndk_n in sync, both are listed on the NDK download page

v_sdk=11076708_latest
v_ndk=r29
v_ndk_n=29.0.14206865
v_sdk_platform=36
v_sdk_build_tools=36.0.0

v_lua=5.2.4
v_unibreak=7.0
v_harfbuzz=14.2.0
v_fribidi=1.0.16
v_freetype=2.14.3
v_mbedtls=3.6.5
v_libxml2=2.15.3
v_fontconfig=2.17.1
# Dolby Vision RPU decoder (Rust crate). Bumped together with libplacebo —
# the relevant API is pl_hdr_metadata_from_dovi_rpu / pl_shader_dovi_reshape
# which has been stable since libplacebo 6.x and libdovi 3.x.
v_libdovi=3.3.2

# Git dependencies are pinned to immutable commits. Keep the human-readable
# release/tag next to the verified commit where one exists.
v_dav1d=1.5.4
r_dav1d=54706fc6bc0cdecab7e9593974a4039cc038fca7
v_ffmpeg=n8.1.1
r_ffmpeg=239f2c733de417201d7ad3b3b8b0d9b63285b2b1
v_libass=0.17.5
r_libass=4a05d8127f525943ebf45fdc6497c9e665947f0d
r_libplacebo=3330a515d62139259c26239014f286e233bd3a5c
r_libplacebo_pink_fix=c93aa134ab62365ce1177efff99b8e1e66a818e7
r_mpv=14f2d48cbc7dda61adb4bd181e107a1f3f76e533

# Host build tools required by the libdovi and current Meson projects.
v_rust=1.98.1
v_cargo_c=0.10.25
v_meson=1.12.0


## Dependency tree

dep_mbedtls=()
dep_dav1d=()
dep_libxml2=()
dep_libdovi=()
dep_ffmpeg=(mbedtls dav1d libxml2 libdovi)
dep_freetype2=()
dep_fontconfig=(libxml2 freetype2)
dep_fribidi=()
dep_harfbuzz=()
dep_unibreak=()
dep_libass=(freetype2 fontconfig fribidi harfbuzz unibreak)
dep_lua=()
dep_libplacebo=(libdovi)
dep_mpv=(ffmpeg libass lua libplacebo)
dep_mpv_android=(mpv)


## for CI workflow

# filename used to uniquely identify a build prefix
ci_tarball="prefix-arm64-sdk-${v_sdk_platform}-build-tools-${v_sdk_build_tools}-ndk-${v_ndk}-rust-${v_rust}-cargo-c-${v_cargo_c}-meson-${v_meson}-lua-${v_lua}-unibreak-${v_unibreak}-harfbuzz-${v_harfbuzz}-fribidi-${v_fribidi}-freetype-${v_freetype}-libxml2-${v_libxml2}-fontconfig-${v_fontconfig}-mbedtls-${v_mbedtls}-libdovi-${v_libdovi}-dav1d-${r_dav1d}-ffmpeg-${r_ffmpeg}-libass-${r_libass}-libplacebo-${r_libplacebo}-pink-fix-${r_libplacebo_pink_fix}-mpv-${r_mpv}.tgz"
