SUMMARY = "Runtime packages for embedded Linux hardening. The DISTRO_FEATURE = ' hardening' package group"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = "\
    hardening-sysctl \
    libpwquality \
    pam-plugin-faillock \
"