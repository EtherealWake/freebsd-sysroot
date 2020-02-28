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

VERSION = 12.1
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
SHA_ARM64 = daffac169a2ab46adb4c4df69d20ff2e479e8054d9fcb2697385e81a359e0965

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
URL_ARMV6 = ${URLBASE}arm/armv6/ISO-IMAGES/${VERSION}/FreeBSD-${RELEASE}-arm-armv6-RPI-B.img.xz
SRC_ARMV6 = ${WRK_ARMV6}/FreeBSD-${RELEASE}-arm-armv6-RPI-B.img.xz
IMG_ARMV6 = ${WRK_ARMV6}/FreeBSD-${RELEASE}-arm-armv6-RPI-B.img
DIR_ARMV6 = ${WRK_ARMV6}/root
SHA_ARMV6 = 34df65dcd50713736379a936e45aea82a7c20d638ef0cef2cff853db1e6f8524

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
# ARMv7-A
#

PKG_ARMV7 = FreeBSD-${RELEASE}-arm-armv7-sysroot.tar.xz
WRK_ARMV7 = FreeBSD-${RELEASE}-arm-armv7
URL_ARMV7 = ${URLBASE}arm/armv7/ISO-IMAGES/${VERSION}/FreeBSD-${RELEASE}-arm-armv7-GENERICSD.img.xz
SRC_ARMV7 = ${WRK_ARMV7}/FreeBSD-${RELEASE}-arm-armv7-GENERICSD.img.xz
IMG_ARMV7 = ${WRK_ARMV7}/FreeBSD-${RELEASE}-arm-armv7-GENERICSD.img
DIR_ARMV7 = ${WRK_ARMV7}/root
SHA_ARMV7 = d5bd4ead96f64a1f62ab097df8bdbfd0de99aace76799b7aa66a0695e2fd9900

${SRC_ARMV7}:
	mkdir -p ${WRK_ARMV7}
	fetch -o ${.TARGET} ${URL_ARMV7}

${IMG_ARMV7}: ${SRC_ARMV7}
	test `sha256 -q ${SRC_ARMV7}` == ${SHA_ARMV7}
	unxz -k ${SRC_ARMV7}

${PKG_ARMV7}: ${IMG_ARMV7}
	mkdir -p ${DIR_ARMV7}
	sudo mdconfig -a -t vnode -f ${IMG_ARMV7} -o readonly -u md7
	sudo mount -o ro,noexec,nosuid /dev/md7s2a ${DIR_ARMV7}
	tar cJf ${.TARGET} -C ${DIR_ARMV7} ${TAR_FLAGS} ${DIRS}
	sudo umount ${DIR_ARMV7}
	sudo mdconfig -d -u md7

arm armv7: ${PKG_ARMV7}

.PHONY: arm armv7

#
# AMD64 (x86-64)
#

PKG_AMD64 = FreeBSD-${RELEASE}-amd64-sysroot.tar.xz
WRK_AMD64 = FreeBSD-${RELEASE}-amd64
URL_AMD64 = ${URLBASE}amd64/amd64/${RELEASE}/base.txz
SRC_AMD64 = ${WRK_AMD64}/base.txz
DIR_AMD64 = ${WRK_AMD64}/root
SHA_AMD64 = 7a0de3237547315fe6404c651c44b356ee7b9a4bfa6ab022c2734237c3d66ded

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
SHA_I386  = 4c978fb0d9c4f65e0089718f0e905fd5a8c2651582de050df6b7f49a8481a169

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

PKGS = ${PKG_ARM64} ${PKG_ARMV6} ${PKG_ARMV7} ${PKG_AMD64} ${PKG_I386}
SRCS = ${SRC_ARM64} ${SRC_ARMV6} ${SRC_ARMV7} ${SRC_AMD64} ${SRC_I386}
WORK = ${WRK_ARM64} ${WRK_ARMV6} ${WRK_ARMV7} ${WRK_AMD64} ${WRK_I386}

all: ${PKGS}
	@sha256 ${.ALLSRC}

clean:
	rm -rf ${PKGS} ${WORK:S|$|/root|} ${WORK:S|$|/.done.*|}

distclean:
	rm -rf ${PKGS} ${WORK}

fetch: ${SRCS}

.MAIN: all
.PHONY: all clean distclean fetch
