#
# Copyright (c) 2019 Jonathan McGee <broken.source@etherealwake.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

DIRS = lib libexec usr/include usr/lib
URLBASE = http://ftp.freebsd.org/pub/FreeBSD/releases/

VERSION = 11.2
RELEASE = ${VERSION}-RELEASE

TAR_FLAGS = --uid 0 --gid 0 --exclude usr/lib/debug

#
# ARM64
#

PKG_ARM64 = FreeBSD-${RELEASE}-arm64-aarch64-sysroot.tar.xz
WRK_ARM64 = FreeBSD-${RELEASE}-arm64-aarch64
URL_ARM64 = ${URLBASE}arm64/aarch64/${RELEASE}/base.txz
SRC_ARM64 = ${WRK_ARM64}/base.txz
DIR_ARM64 = ${WRK_ARM64}/root
SHA_ARM64 = 265c0a25fa162489c95a325d79e99063fb83035706a2db9c0695d23ca38e171f

${SRC_ARM64}:
	mkdir -p ${WRK_ARM64}
	fetch -o ${.TARGET} ${URL_ARM64}

${WRK_ARM64}/.done.root: ${SRC_ARM64}
	test `sha256 -q ${SRC_ARM64}` == ${SHA_ARM64}
	mkdir -p ${DIR_ARM64}
	tar xJf ${SRC_ARM64} -C ${DIR_ARM64} ${DIRS}
	touch ${.TARGET}

${PKG_ARM64}: ${WRK_ARM64}/.done.root
	tar cJf ${.TARGET} -C ${DIR_ARM64} ${TAR_FLAGS} ${DIRS}

arm64 aarch64: ${PKG_ARM64}

.PHONY: arm64 aarch64

#
# ARMv6
#

PKG_ARMV6 = FreeBSD-${RELEASE}-arm-armv6-sysroot.tar.xz
WRK_ARMV6 = FreeBSD-${RELEASE}-arm-armv6
URL_ARMV6 = ${URLBASE}arm/armv6/ISO-IMAGES/${VERSION}/FreeBSD-${RELEASE}-arm-armv6-BEAGLEBONE.img.xz
SRC_ARMV6 = ${WRK_ARMV6}/FreeBSD-${RELEASE}-arm-armv6-BEAGLEBONE.img.xz
IMG_ARMV6 = ${WRK_ARMV6}/FreeBSD-${RELEASE}-arm-armv6-BEAGLEBONE.img
DIR_ARMV6 = ${WRK_ARMV6}/root
SHA_ARMV6 = e1d7c94ed8d442b0986d261f10b93a4bd14757562e339ba0d1c3737d390963dd

${SRC_ARMV6}:
	mkdir -p ${WRK_ARMV6}
	fetch -o ${.TARGET} ${URL_ARMV6}

${IMG_ARMV6}: ${SRC_ARMV6}
	test `sha256 -q ${SRC_ARMV6}` == ${SHA_ARMV6}
	unxz -k ${SRC_ARMV6}

${PKG_ARMV6}: ${IMG_ARMV6}
	mkdir -p ${DIR_ARMV6}
	sudo mdconfig -a -t vnode -f ${IMG_ARMV6} -o readonly -u md7
	sudo mount -o ro,noexec,nosuid /dev/md7s2a ${DIR_ARMV6}
	tar cJf ${.TARGET} -C ${DIR_ARMV6} ${TAR_FLAGS} ${DIRS}
	sudo umount ${DIR_ARMV6}
	sudo mdconfig -d -u md7

arm armv6: ${PKG_ARMV6}

.PHONY: arm armv6

#
# AMD64 (x86-64)
#

PKG_AMD64 = FreeBSD-${RELEASE}-amd64-sysroot.tar.xz
WRK_AMD64 = FreeBSD-${RELEASE}-amd64
URL_AMD64 = ${URLBASE}amd64/amd64/${RELEASE}/base.txz
SRC_AMD64 = ${WRK_AMD64}/base.txz
DIR_AMD64 = ${WRK_AMD64}/root
SHA_AMD64 = a002be690462ad4f5f2ada6d01784836946894ed9449de6289b3e67d8496fd19

${SRC_AMD64}:
	mkdir -p ${WRK_AMD64}
	fetch -o ${.TARGET} ${URL_AMD64}

${WRK_AMD64}/.done.root: ${SRC_AMD64}
	test `sha256 -q ${SRC_AMD64}` == ${SHA_AMD64}
	mkdir -p ${DIR_AMD64}
	tar xJf ${SRC_AMD64} -C ${DIR_AMD64} ${DIRS}
	touch ${.TARGET}

${PKG_AMD64}: ${WRK_AMD64}/.done.root
	tar cJf ${.TARGET} -C ${DIR_AMD64} ${TAR_FLAGS} ${DIRS}

amd64: ${PKG_AMD64}

.PHONY: amd64

#
# i386 (x86-32)
#

PKG_I386  = FreeBSD-${RELEASE}-i386-sysroot.tar.xz
WRK_I386  = FreeBSD-${RELEASE}-i386
URL_I386  = ${URLBASE}i386/i386/${RELEASE}/base.txz
SRC_I386  = ${WRK_I386}/base.txz
DIR_I386  = ${WRK_I386}/root
SHA_I386  = 9c8be09d549f6365a43f8a86529110c1ebac4263ac357c8aa25b753d65b1460c

${SRC_I386}:
	mkdir -p ${WRK_I386}
	fetch -o ${.TARGET} ${URL_I386}

${WRK_I386}/.done.root: ${SRC_I386}
	test `sha256 -q ${SRC_I386}` == ${SHA_I386}
	mkdir -p ${DIR_I386}
	tar xJf ${SRC_I386} -C ${DIR_I386} ${DIRS}
	touch ${.TARGET}

${PKG_I386}: ${WRK_I386}/.done.root
	tar cJf ${.TARGET} -C ${DIR_I386} ${TAR_FLAGS} ${DIRS}

i386: ${PKG_I386}

.PHONY: i386

#
# Common
#

PKGS = ${PKG_ARM64} ${PKG_ARMV6} ${PKG_AMD64} ${PKG_I386}
WORK = ${WRK_ARM64} ${WRK_ARMV6} ${WRK_AMD64} ${WRK_I386}

all: ${PKGS}
	@sha256 ${.ALLSRC}

clean:
	rm -rf ${PKGS} ${WORK:S|$|/root|} ${WORK:S|$|/.done.*|}

distclean:
	rm -rf ${PKGS} ${WORK}

fetch:

.MAIN: all
.PHONY: all clean distclean fetch
