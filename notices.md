# Notices

## Build outputs and licenses

The release artifacts on the GitHub [release page](https://github.com/moritzfl/xsltproc-win-compile/releases)
are licensed as follows:

| Artifact         | License (components)                   | Source                                 |
|------------------|----------------------------------------|----------------------------------------|
| `xsltproc.exe`   | MIT + LGPL (statically links libiconv) | https://gitlab.gnome.org/GNOME/libxslt |
| `xslt-config`    | MIT                                    | https://gitlab.gnome.org/GNOME/libxslt |
| `xmllint.exe`    | MIT + LGPL (statically links libiconv) | https://gitlab.gnome.org/GNOME/libxml2 |
| `xmlcatalog.exe` | MIT + LGPL (statically links libiconv) | https://gitlab.gnome.org/GNOME/libxml2 |
| `xml2-config`    | MIT                                    | https://gitlab.gnome.org/GNOME/libxml2 |
| `iconv.exe`      | LGPL                                   | https://www.gnu.org/software/libiconv/ |

## LGPL notice for static linking

This build links `libiconv` statically into the Windows executables above.
Distributions of those executables must comply with the LGPL requirements that
apply to `libiconv`.

## Build scripts in this repo

The build scripts and test assets in this repository (Dockerfile, batch test
script, tests, and docs) are MIT.

## License texts

- MIT: https://opensource.org/license/mit/
- LGPL: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html
