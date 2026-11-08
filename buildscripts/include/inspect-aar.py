"""Check the real ARM64 payload and wrapper API of a NuvioDV AAR."""
import argparse
import hashlib
import io
import json
import os
from pathlib import Path
import re
import subprocess
import zipfile

REQUIRED = {
    'libplayer.so', 'libmpv.so', 'libavcodec.so', 'libavdevice.so',
    'libavfilter.so', 'libavformat.so', 'libavutil.so',
    'libswresample.so', 'libswscale.so', 'libc++_shared.so',
}
PLATFORM = {
    'libc.so', 'libdl.so', 'libm.so', 'liblog.so', 'libandroid.so',
    'libEGL.so', 'libGLESv2.so', 'libGLESv3.so', 'libOpenSLES.so',
    'libz.so', 'libjnigraphics.so', 'libaaudio.so', 'libmediandk.so',
    'libnativewindow.so', 'libvulkan.so',
}
CLASSES = {'is/xyz/mpv/MPV.class', 'is/xyz/mpv/MPVNode.class',
           'is/xyz/mpv/BaseMPVView.class'}
SYMBOLS = {'dovi_parse_rpu', 'dovi_parse_rpu_bin_file'}


def inspect(aar, extract_dir, readelf):
    extract_dir.mkdir(parents=True, exist_ok=True)
    report = {'source_commit': os.environ.get('GITHUB_SHA'),
              'aar_sha256': hashlib.sha256(aar.read_bytes()).hexdigest(),
              'libraries': {}}
    with zipfile.ZipFile(aar) as archive:
        native = {name for name in archive.namelist()
                  if name.startswith('jni/') and name.endswith('.so')}
        if not native or any(not name.startswith('jni/arm64-v8a/') for name in native):
            raise RuntimeError('AAR must contain ARM64 native libraries only')
        packaged = {Path(name).name for name in native}
        if REQUIRED - packaged:
            raise RuntimeError(f'Missing native libraries: {sorted(REQUIRED - packaged)}')
        with zipfile.ZipFile(io.BytesIO(archive.read('classes.jar'))) as classes:
            if CLASSES - set(classes.namelist()):
                raise RuntimeError('Nuvio-compatible wrapper classes are missing')
        report['wrapper_classes'] = sorted(CLASSES)
        for entry in sorted(native):
            name = Path(entry).name
            target = extract_dir / name
            target.write_bytes(archive.read(entry))
            result = subprocess.run([readelf, '-h', '-d', '-W', str(target)],
                                    capture_output=True, text=True, check=True)
            if 'ELF64' not in result.stdout or 'AArch64' not in result.stdout:
                raise RuntimeError(f'{name} is not an AArch64 ELF64 library')
            needed = set(re.findall(r'\(NEEDED\).*?\[([^\]]+)\]', result.stdout))
            if needed - packaged - PLATFORM:
                raise RuntimeError(f'{name} has unbundled dependencies: {sorted(needed - packaged - PLATFORM)}')
            report['libraries'][name] = {
                'sha256': hashlib.sha256(target.read_bytes()).hexdigest(),
                'needed': sorted(needed),
            }
            if name == 'libmpv.so':
                symbols = subprocess.run([readelf, '--dyn-syms', '-W', str(target)],
                                         capture_output=True, text=True, check=True)
                exported = set()
                for line in symbols.stdout.splitlines():
                    fields = line.split()
                    if (len(fields) == 8 and fields[4] in ('GLOBAL', 'WEAK')
                            and fields[6] != 'UND'):
                        exported.add(fields[7])
                if SYMBOLS - exported:
                    raise RuntimeError(f'libdovi exports missing: {sorted(SYMBOLS - exported)}')
                report['libdovi_exports'] = sorted(SYMBOLS)
    return report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('aar', type=Path)
    parser.add_argument('--extract-dir', type=Path, required=True)
    parser.add_argument('--readelf', default='readelf')
    args = parser.parse_args()
    print(json.dumps(inspect(args.aar, args.extract_dir, args.readelf), indent=2))
