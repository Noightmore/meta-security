FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' file://pwquality-hardening.conf', '', d)}"

#RDEPENDS:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', \
#    'hardening', ' libpwquality', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        install -d "${D}${sysconfdir}/security"

        install -m 0644 \
            "${UNPACKDIR}/pwquality-hardening.conf" \
            "${D}${sysconfdir}/security/pwquality.conf"
    fi
}