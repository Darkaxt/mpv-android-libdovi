# Implementation status

Authoritative specification: `docs/NUVIO_LIBRARY_FORK_SPEC.md`

## Stage 1 - Deterministic native build contract

Status: **COMPLETE**

Requirements: R3, R4, R5

Acceptance criteria satisfied:

- Every previously floating native dependency used by CI is pinned to a
  resolved commit.
- Rust 1.98.1, cargo-c 0.10.25, and Meson 1.12.0 are pinned.
- The libdovi build script is executable.
- A fresh ARM64 native build produced an AArch64 `libmpv.so` exporting the mpv
  client/render API, with the two FFmpeg MediaCodec patches applied, libdovi
  linked, and libplacebo commit `3330a515` verified to contain `c93aa134`.

Acceptance criteria remaining: none.

Blockers: none.

Tracked deferrals: none.

## Stage 2 - Nuvio-compatible AAR vertical slice

Status: **COMPLETE**

Requirements: R1, R2

Acceptance criteria satisfied:

- The release AAR contains the `is.xyz.mpv` API classes and only the requested
  ARM64 native payload.
- Every non-platform shared dependency reported by `libplayer.so` and
  `libmpv.so` is packaged in the AAR.
- The packaged `libmpv.so` is AArch64 and contains the libdovi RPU parser.
- A separate consumer module extending `BaseMPVView` and using its inherited
  `mpv` property compiles against the built AAR file.

Acceptance criteria remaining: none.

Blockers: none.

Tracked deferrals: none.

## Stage 3 - Public CI and fork documentation

Status: **COMPLETE**

Requirements: R6, R7

Acceptance criteria satisfied:

- The README documents the personal-fork scope, the two independent playback
  improvements, limitations, provenance, consumption, and deprecation policy.
- Public workflow run
  [34651320046](https://github.com/Darkaxt/mpv-android-libdovi/actions/runs/34651320046)
  passed at commit `0b6a253` and uploaded artifact
  `mpv-android-libdovi-arm64`. That wrapper artifact was superseded by the
  corrected Stage 4 artifact.
- The downloaded public artifact was independently checked for the expected
  API classes, AArch64 `libmpv.so`, and the libdovi RPU parser symbol.

Acceptance criteria remaining: none.

Blockers: none.

Tracked deferrals: none.

## Stage 4 - Published 0.1.12 API correction

Status: **COMPLETE**

Requirements: R1, R2, R6

Acceptance criteria satisfied:

- Maven Central's official `0.1.12` AAR and sources archive were retrieved and
  compared with the first fork artifact.
- The mismatch was isolated to the wrapper API: the native JNI bridge already
  exposes the instance lifecycle required by the published source.
- The corrected wrapper AAR passes the compile-only compatibility consumer.
- Current NuvioMobile Android sources compile against the corrected wrapper
  without player call-site changes.
- Public workflow run
  [34656988140](https://github.com/Darkaxt/mpv-android-libdovi/actions/runs/34656988140)
  passed at corrected source commit
  `a6d4de8b2109347e07dcd2daef258deee9a97e29` and uploaded artifact
  `mpv-android-libdovi-arm64`.
- The downloaded public AAR has SHA-256
  `B266C9F5ED940B761DA572F1496FCF2152FE624CDFD42354B33BA5C9E3FC8721`;
  its wrapper bytecode matches the published `0.1.12` API, its only native ABI
  is ARM64, and its `libmpv.so` is AArch64 and exports `dovi_parse_rpu`.
- The exact public AAR is integrated into NuvioMobile and a full Android debug
  APK builds successfully against it.

Acceptance criteria remaining: none.

Blockers: none.

Tracked deferrals: none.

## Final reconciliation

Requirements R1-R7: satisfied and verified.

Blockers: 0

Tracked deferrals: 0
