FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:hardening-enforced = " \
    file://common-password-hardening \
    file://common-auth-hardening \
    file://faillock-hardening.conf \
"

RDEPENDS:${PN}:append:hardening-enforced = " pam-plugin-faillock"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)} && [ "${HARDENING_DEVEL}" != "1" ]; then
        install -d "${D}${sysconfdir}/pam.d"
        install -d "${D}${sysconfdir}/security"

        install -m 0644 \
            "${UNPACKDIR}/common-password-hardening" \
            "${D}${sysconfdir}/pam.d/common-password"

        install -m 0644 \
            "${UNPACKDIR}/common-auth-hardening" \
            "${D}${sysconfdir}/pam.d/common-auth"

        install -m 0644 \
            "${UNPACKDIR}/faillock-hardening.conf" \
            "${D}${sysconfdir}/security/faillock.conf"
    fi
}

FILES:${PN}:append:hardening-enforced = " \
    ${sysconfdir}/pam.d/common-password \
    ${sysconfdir}/pam.d/common-auth \
    ${sysconfdir}/security/faillock.conf \
"

CONFFILES:${PN}:append:hardening-enforced = " \
    ${sysconfdir}/pam.d/common-password \
    ${sysconfdir}/pam.d/common-auth \
    ${sysconfdir}/security/faillock.conf \
"