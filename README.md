# FreeBSD sysroot Builder

Downloads the official releases from ftp.freebsd.org, extracts them, and
repackages the headers and libraries for cross-compilation.

Supported Platforms:
- amd64 (`FreeBSD-12.2-RELEASE-amd64-sysroot.tar.xz`)
  - Clang Target: `x86_64-unknown-freebsd12.2`
- ARM64 (`FreeBSD-12.2-RELEASE-arm64-aarch64-sysroot.tar.xz`)
  - Clang Target: `aarch64-unknown-freebsd12.2`
- ARMv6 (`FreeBSD-12.2-RELEASE-arm-armv6-sysroot.tar.xz`)
  - Clang Target: `armv6-unknown-freebsd12.2-gnueabihf`
- ARMv7-A (`FreeBSD-12.2-RELEASE-arm-armv7-sysroot.tar.xz`)
  - Clang Target: `armv7a-unknown-freebsd12.2-gnueabihf`
- i386 (`FreeBSD-12.2-RELEASE-i386-sysroot.tar.xz`)
  - Clang Target: `i386-unknown-freebsd12.2`

Support Criteria:
- Tier 1 platforms
- Tier 2 platforms with wide-spread usage (e.g. ARM)

See: https://www.freebsd.org/platforms/index.html
