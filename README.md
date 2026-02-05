# xsltproc Windows cross-compile (Docker)

This repository provides a Dockerfile that cross-compiles a **static** `xsltproc.exe`
for Windows using mingw-w64. The `xsltproc` version is determined by the
`LIBXSLT_VERSION` build argument.

## Usage

Build and export the artifacts to `./out`:

```bash
docker build -t xsltproc-win \
  --build-arg LIBXSLT_VERSION=1.1.45 \
  --output type=local,dest=./out .
```

The resulting binaries (from `${PREFIX}/bin`) will be at:

```text
./out/xsltproc.exe
```

## Build arguments

- `HOST` (default `x86_64-w64-mingw32`) - target Windows architecture (64-bit x86).
  - Example 32-bit: `HOST=i686-w64-mingw32`
- `LIBXSLT_VERSION` - libxslt version to build (defines `xsltproc` version).
- `LIBXML2_VERSION`, `LIBICONV_VERSION`, `ZLIB_VERSION` - dependency versions.

## Windows test script

A batch test script is included to validate the Windows executable.
Copy `./out/xsltproc.exe`, `test-xsltproc.bat`, and `tests/windows/` to a Windows machine,
then run:

```bat
test-xsltproc.bat .\xsltproc.exe
```

## Notes

- The Dockerfile configures and links everything **statically** (`-static` and
  `--disable-shared`), producing a self-contained `xsltproc.exe`.
- If you need additional tools (like `xmllint.exe`), they can be copied from the
  same prefix at the end of the build stage.
