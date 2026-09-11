# mpv-android-libdovi for Nuvio

[![Build ARM64 AAR](https://github.com/Darkaxt/mpv-android-libdovi/actions/workflows/build.yml/badge.svg?branch=libdovi)](https://github.com/Darkaxt/mpv-android-libdovi/actions/workflows/build.yml)

This is a small personal fork that builds an ARM64 Android library for a later
[Nuvio](https://github.com/NuvioMedia/NuvioTV) integration. It is deliberately not
a general mpv-android distribution.

## What this fork covers

It combines two independent player improvements:

1. **Better Dolby Vision handling.** libdovi 3.3.2 is linked into libplacebo
   and FFmpeg, with MediaCodec patches that preserve Dolby Vision RPU metadata
   and support P010 byte-buffer output.
2. **The long-play pink/purple video failure.** The pinned libplacebo revision
   contains upstream fix `c93aa134`, which closes leaked OpenGL sync objects.
   This issue is not Dolby Vision-specific.

The AAR exposes the `is.xyz.mpv.MPV`, `MPVNode`, and `BaseMPVView` API used by
`io.github.abdallahmehiz:mpv-android-lib:0.1.12`, so Nuvio can be evaluated
against it without replacing its libmpv player architecture.

## Status and limitations

- Experimental and ARM64-only.
- Compile compatibility is checked in CI; device playback is intentionally
  deferred until the later Nuvio integration.
- Dolby Vision profile 7 FEL enhancement-layer decoding is not implemented.
  The work here improves metadata preservation and rendering; it does not
  promise full dual-layer FEL reconstruction.
- mpvEx features and broader player expansion are outside the current scope.

## Download and consumption

Every successful [Build ARM64 AAR workflow](https://github.com/Darkaxt/mpv-android-libdovi/actions/workflows/build.yml)
uploads `mpv-android-libdovi-arm64.aar` as a workflow artifact. This fork does
not publish Maven packages or GitHub Releases.

Copy the downloaded AAR into the consuming app's `libs/` directory and use a
local file dependency:

```kotlin
dependencies {
    implementation(files("libs/mpv-android-libdovi-arm64.aar"))
}
```

Nuvio itself is not modified in this repository. Its dependency swap and
playback evaluation are the next, separate step.

## Provenance

- Native build and Dolby Vision work: [FortunasXP/mpv-android-libdovi](https://github.com/FortunasXP/mpv-android-libdovi)
- Original Android player: [mpv-android/mpv-android](https://github.com/mpv-android/mpv-android)
- Nuvio-compatible library wrapper: [abdallahmehiz/mpv-android](https://github.com/abdallahmehiz/mpv-android), commit `18e41158e1ad24c1819598be15f51c898397e04f`
- libdovi: [quietvoid/dovi_tool](https://github.com/quietvoid/dovi_tool)

Exact native revisions and host-tool versions are recorded in
[`buildscripts/include/depinfo.sh`](buildscripts/include/depinfo.sh). The
implementation contract is in
[`docs/NUVIO_LIBRARY_FORK_SPEC.md`](docs/NUVIO_LIBRARY_FORK_SPEC.md).

## Deprecation policy

This fork should be deprecated as soon as the relevant upstream Nuvio and/or
mpv Android library branches cover both improvements. It may continue only if
I later choose to expand the player, but that is explicitly outside this
fork's current scope.

## Building

On Ubuntu, install the host tools pinned in `depinfo.sh`, then run:

```sh
cd buildscripts
IN_CI=1 ./download.sh
./buildall.sh --arch arm64 mpv
./buildall.sh --arch arm64 -n mpv-android
```

The release library is written to `lib/build/outputs/aar/lib-release.aar`.
