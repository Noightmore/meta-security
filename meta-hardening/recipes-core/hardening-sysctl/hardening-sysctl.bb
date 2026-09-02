SUMMARY = "Runtime sysctl settings for the hardening distro feature"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

HARDENING_SYSCTL_FILES = " \
    10-hardening-general.conf \
    10-hardening-bpf.conf \
"

SRC_URI = "${@' '.join('file://' + f for f in d.getVar('HARDENING_SYSCTL_FILES').split())}"

S = "${UNPACKDIR}"

inherit allarch features_check

REQUIRED_DISTRO_FEATURES = "hardening"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${sysconfdir}/sysctl.d

    for file in ${HARDENING_SYSCTL_FILES}; do
        install -m 0644 ${UNPACKDIR}/$file \
            ${D}${sysconfdir}/sysctl.d/$file
    done
}

FILES:${PN} += "${sysconfdir}/sysctl.d"