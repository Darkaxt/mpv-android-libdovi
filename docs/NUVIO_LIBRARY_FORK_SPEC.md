# Nuvio library fork specification

Status: authoritative
Authorization: already authorized by the user on 2026-09-11

## Purpose

Maintain a small public fork of `FortunasXP/mpv-android-libdovi` that produces
an Android library suitable for a later Nuvio integration assessment. The fork
exists only to cover the native-player gaps described below and should be
retired when the relevant upstream projects cover them.

## Requirements

- **R1 - Compatible library API:** Produce an AAR exposing the same
  `is.xyz.mpv.MPV`, `is.xyz.mpv.MPVNode`, and `is.xyz.mpv.BaseMPVView` API used
  by `io.github.abdallahmehiz:mpv-android-lib:0.1.12`. The compatible wrapper
  source comes from `abdallahmehiz/mpv-android` commit
  `18e41158e1ad24c1819598be15f51c898397e04f`.
- **R2 - ARM64 native payload:** The AAR must contain the ARM64 libmpv JNI
  bridge and every non-platform shared library required by that bridge.
- **R3 - Dolby Vision path:** The native stack must build libdovi 3.3.2,
  enable libdovi in libplacebo, and compile the fork's FFmpeg MediaCodec Dolby
  Vision RPU and P010 patches.
- **R4 - Pink-screen fix:** The pinned libplacebo revision must contain
  upstream commit `c93aa134`, which fixes the long-play OpenGL sync-object
  leak associated with the reported pink/purple output failure.
- **R5 - Reproducible build inputs:** CI-relevant source revisions and host
  tool versions must be explicit. A fresh Ubuntu CI job must not depend on
  floating mpv, FFmpeg, libplacebo, libass, or dav1d branches.
- **R6 - Public CI artifact:** GitHub Actions must build the ARM64 release AAR
  and upload it as a workflow artifact without publishing a Maven release.
- **R7 - Fork documentation:** The README must state the personal-fork scope,
  the two independent playback improvements, current limitations, artifact
  consumption instructions, source provenance, and deprecation policy.

## Out of scope

- Changes to Nuvio itself.
- Maven Central, GitHub Release, Play Store, or APK publication.
- Device playback validation; the user will report files that fail in normal
  use after later Nuvio integration.
- Full Dolby Vision profile 7 FEL enhancement-layer decoding.
- mpvEx-derived features or broader player expansion.
- ABIs other than ARM64 for the initial personal-fork artifact.

## Acceptance criteria

1. A clean ARM64 native build produces `libmpv.so` and its FFmpeg libraries.
2. Artifact inspection confirms AArch64 ELF files, libdovi symbols, the two
   FFmpeg patch changes, and libplacebo ancestry containing `c93aa134`.
3. The release AAR contains the expected `is.xyz.mpv` classes, `libplayer.so`,
   `libmpv.so`, FFmpeg shared libraries, and `libc++_shared.so` under
   `jni/arm64-v8a/`.
4. A compile-only compatibility consumer extending `BaseMPVView` and using its
   `mpv` property builds against the produced AAR.
5. The public fork's workflow succeeds at the committed revision and exposes
   the AAR as a downloadable artifact.
6. No required blocker or tracked deferral remains within this specification.
