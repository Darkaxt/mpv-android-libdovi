# Dolby Vision implementation notes

This fork builds libdovi as a static library and enables it in both libplacebo
and FFmpeg. The FFmpeg MediaCodec patches preserve Dolby Vision RPU metadata
and add P010 byte-buffer output handling.

This is not a claim of complete Dolby Vision profile 7 FEL decoding. It is the
native foundation for evaluating profiles supported by Android hardware and
mpv's current rendering path.

The separate long-play pink/purple failure is covered by pinning a libplacebo
revision that contains `c93aa134`; it is not caused by Dolby Vision.

See the top-level [README](README.md) for artifact consumption and scope, and
[`docs/NUVIO_LIBRARY_FORK_SPEC.md`](docs/NUVIO_LIBRARY_FORK_SPEC.md) for the
authoritative acceptance criteria.
