#!/bin/bash

set -e

_pkgversion=$(printf "0.%u.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)")
# tar -cJvf "nano-${_pkgversion}.tar.xz" {i686,x86_64}-w64-mingw32/{bin/nano.exe,share/{nano,doc}/}
7z a -aoa -mmt"$(nproc)" -- "nano-${_pkgversion}.7z" {i686,x86_64}-w64-mingw32/{bin/nano.exe,share/{nano,doc}/}
