FROM ubuntu:24.04 AS build

ARG HOST=x86_64-w64-mingw32
ARG OUTPUT_PREFIX=/opt/${HOST}
# Latest version sources:
# zlib: https://zlib.net/
# libiconv: https://ftp.gnu.org/gnu/libiconv/
# libxml2: https://download.gnome.org/sources/libxml2/
# libxslt: https://download.gnome.org/sources/libxslt/
ARG ZLIB_VERSION=1.3.2
ARG LIBICONV_VERSION=1.18
ARG LIBXML2_VERSION=2.15.1
ARG LIBXSLT_VERSION=1.1.45

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    mingw-w64 \
    pkg-config \
    autoconf \
    automake \
    libtool \
    make \
    xz-utils; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN set -eux; \
  curl -fsSL "https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz" | tar -xz; \
  cd "zlib-${ZLIB_VERSION}"; \
  CC="${HOST}-gcc" AR="${HOST}-ar" RANLIB="${HOST}-ranlib" \
    ./configure --static --prefix="${OUTPUT_PREFIX}"; \
  make -j"$(nproc)"; \
  make install

RUN set -eux; \
  curl -fsSL "https://ftp.gnu.org/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz" | tar -xz; \
  cd "libiconv-${LIBICONV_VERSION}"; \
  ./configure --host="${HOST}" --prefix="${OUTPUT_PREFIX}" --enable-static --disable-shared; \
  make -j"$(nproc)"; \
  make install

RUN set -eux; \
  curl -fsSL "https://download.gnome.org/sources/libxml2/${LIBXML2_VERSION%.*}/libxml2-${LIBXML2_VERSION}.tar.xz" | tar -xJ; \
  cd "libxml2-${LIBXML2_VERSION}"; \
  PKG_CONFIG="${HOST}-pkg-config" \
  CC="${HOST}-gcc" AR="${HOST}-ar" RANLIB="${HOST}-ranlib" \
  CFLAGS="-O2" \
  LDFLAGS="-static" \
  ./configure \
    --host="${HOST}" \
    --prefix="${OUTPUT_PREFIX}" \
    --with-zlib="${OUTPUT_PREFIX}" \
    --with-iconv="${OUTPUT_PREFIX}" \
    --without-python \
    --disable-shared \
    --enable-static; \
  make -j"$(nproc)"; \
  make install

RUN set -eux; \
  curl -fsSL "https://download.gnome.org/sources/libxslt/${LIBXSLT_VERSION%.*}/libxslt-${LIBXSLT_VERSION}.tar.xz" | tar -xJ; \
  cd "libxslt-${LIBXSLT_VERSION}"; \
  PKG_CONFIG="${HOST}-pkg-config" \
  CC="${HOST}-gcc" AR="${HOST}-ar" RANLIB="${HOST}-ranlib" \
  CFLAGS="-O2" \
  LDFLAGS="-static" \
  ./configure \
    --host="${HOST}" \
    --prefix="${OUTPUT_PREFIX}" \
    --with-libxml-prefix="${OUTPUT_PREFIX}" \
    --without-python \
    --disable-shared \
    --enable-static; \
  make -j"$(nproc)"; \
  make install

RUN set -eux; \
  mkdir -p /out; \
  cp -a "${OUTPUT_PREFIX}/bin/." /out/

FROM scratch AS artifacts
COPY --from=build /out/ /
