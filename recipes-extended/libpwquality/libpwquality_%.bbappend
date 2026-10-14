FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:hardening-enforced = " file://pwquality-hardening.conf"

RDEPENDS:${PN}:append:hardening-enforced = " pam-plugin-pwhistory"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)} && [ "${HARDENING_DEVEL}" != "1" ]; then
        install -d "${D}${sysconfdir}/security"

        install -m 0644 \
            "${UNPACKDIR}/pwquality-hardening.conf" \
            "${D}${sysconfdir}/security/pwquality.conf"
    fi
}