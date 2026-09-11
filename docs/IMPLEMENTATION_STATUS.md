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

Status: **ACTIVE**

Requirements: R6, R7

Required evidence: successful public workflow run and README reconciliation.

## Final reconciliation

Blockers: 0
Tracked deferrals: 0
