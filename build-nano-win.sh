#!/bin/bash

set -e

./autogen.sh

tar -xzvf ncurses-6.0.tar.gz
git apply ncurses-6.0.patch

function Build(){
	_pwd="$(pwd)"
	_nproc="$(nproc)"
	_host="${1}-w64-mingw32"
	_prefix="${_pwd}/${_host}"

	export CPPFLAGS="-D__USE_MINGW_ANSI_STDIO -I\"${_prefix}/include\""
	export CFLAGS="-O3"
	export LDFLAGS="-O3 -L\"${_prefix}/lib\" -static -Wl,-s"

	mkdir -p "${_pwd}/${_host}"
	mkdir -p "${_pwd}/build_${_host}"
	pushd "${_pwd}/build_${_host}"

	mkdir -p "ncurses"
	pushd "ncurses"
	../../ncurses-6.0/configure --host="${_host}" --build="${_host}" --prefix="${_prefix}"	\
		--without-ada --without-cxx-binding --disable-db-install --without-manpages --without-pthread --enable-widec	\
		--disable-database --disable-rpath --enable-termcap --disable-home-terminfo --enable-sp-funcs --enable-term-driver	\
		--enable-static --disable-shared
	make -j"${_nproc}"
	make install
	popd

	mkdir -p "nano"
	pushd "nano"
	mkdir --parents .git # lie to configure.ac
	NCURSESW_CFLAGS="-I\"${_prefix}/include/ncursesw\"" ../../configure --host="${_host}" --build="${_host}" --prefix="${_prefix}"	\
		--enable-mouse --enable-nanorc --enable-color --disable-justify --enable-utf8 --disable-speller --disable-nls
	make -j"${_nproc}"
	make install
	rmdir --ignore-fail-on-non-empty .git
	popd

	popd
}

Build i686
Build x86_64
