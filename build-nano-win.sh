#!/bin/bash

set -e

_host="x86_64-w64-mingw32"
_prefix="$(pwd)/$_host"

export CPPFLAGS="-D__USE_MINGW_ANSI_STDIO -I$_prefix/include"
export CFLAGS="-O3"
export LDFLAGS="-O3 -L$_prefix/lib"
export LIBS=""

(tar -xJvf mingw-libgnurx-2.5.1.tar.xz && cd mingw-libgnurx-2.5.1 &&
	./configure --host="$_host" --prefix="$_prefix"	\
		&&
	make -j8 &&
	make install)

(tar -xJvf ncurses-6.0.tar.xz && cd ncurses-6.0 &&
	./configure --host="$_host" --prefix="$_prefix"	\
		--without-cxx-binding --without-ada --enable-warnings --disable-debug --enable-assertions	\
		--with-normal --disable-home-terminfo --enable-term-driver --enable-termcap --enable-interop --enable-reentrant	\
		--without-pthread --disable-rpath --enable-colorfgbg --enable-ext-colors --enable-ext-mouse --enable-widec	\
		--enable-static --disable-shared &&
	make -j8 &&
	make install)

(./autogen.sh &&
	LDFLAGS+=" -static -Wl,-s"	\
	LIBS+=" -lgnurx"	\
	NCURSESW_CFLAGS="-I$_prefix/include/ncursestw"	\
	NCURSESW_LIBS="-lncursestw"	\
	./configure --host="$_host" --prefix="$_prefix"	\
		--enable-mouse --enable-nanorc --enable-color --disable-justify --enable-utf8 --disable-speller --disable-nls	\
		--with-wordbounds --disable-threads --without-included-regex --enable-libmagic &&
	make -j8 &&
	make install)
