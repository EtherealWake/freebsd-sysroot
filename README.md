# FreeBSD sysroot Builder

Downloads the official releases from ftp.freebsd.org, extracts them, and
repackages the headers and libraries for cross-compilation.

Supported Platforms:
- amd64 (`FreeBSD-##.#-RELEASE-amd64-sysroot.tar.xz`)
- ARM64 (`FreeBSD-##.#-RELEASE-arm64-aarch64-sysroot.tar.xz`)
- ARM (`FreeBSD-##.#-RELEASE-arm-armv#-sysroot.tar.xz`)
- i386 (`FreeBSD-##.#-RELEASE-i386-sysroot.tar.xz`)

Support Criteria:
- Tier 1 platforms
- Tier 2 platforms with wide-spread usage

See: https://www.freebsd.org/platforms/index.html
