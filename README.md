# xsltproc Windows cross-compile (Docker)

This repository provides a Dockerfile that cross-compiles a **static** `xsltproc.exe`
for Windows using mingw-w64. The `xsltproc` version is determined by the
`LIBXSLT_VERSION` build argument.

## Usage

Build and export the artifacts to `./out`:

```bash
docker build -t xsltproc-win \
  --output type=local,dest=./out .
```

The resulting binaries (from `${OUTPUT_PREFIX}/bin`) will be at:

```text
./out/xsltproc.exe
```

## Build arguments

| ARG                | Default              | Description                                                                                                           |
|--------------------|----------------------|-----------------------------------------------------------------------------------------------------------------------|
| `HOST`             | `x86_64-w64-mingw32` | Target Windows architecture (use `i686-w64-mingw32` for 32-bit).                                                      |
| `OUTPUT_PREFIX`    | `/opt/${HOST}`       | Install/output prefix inside the build container.                                                                     |
| `ZLIB_VERSION`     | `1.3.1`              | zlib version to build.                                                                                                |
| `LIBICONV_VERSION` | `1.18`               | libiconv version to build.                                                                                            |
| `LIBXML2_VERSION`  | `2.15.1`             | libxml2 version to build.                                                                                             |
| `LIBXSLT_VERSION`  | `1.1.45`             | libxslt version to build (defines `xsltproc` version).                                                                |

## Windows test script

A batch test script is included to validate the Windows executable.
Copy the `test/`-directory onto a Windows machine and place the `xsltproc.exe` binary you compiled into that folder.
On the Windows machine you can then run the following script within the `test/` directory:

```bat
test-xsltproc.bat
```

## Notes

- The Dockerfile configures and links everything **statically** (`-static` and
  `--disable-shared`), producing a self-contained `xsltproc.exe`.
- If you need additional tools (like `xmllint.exe`), they can be copied from the
  same prefix at the end of the build stage.
