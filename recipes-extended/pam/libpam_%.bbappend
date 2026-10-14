FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', \
    ' file://common-password-hardening file://common-auth-hardening file://faillock-hardening.conf', \
    '', d)}"

RDEPENDS:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', \
    'hardening', ' pam-plugin-faillock', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
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

FILES:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', \
    ' ${sysconfdir}/pam.d/common-password \
      ${sysconfdir}/pam.d/common-auth \
      ${sysconfdir}/security/faillock.conf', \
    '', d)}"

CONFFILES:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', \
    ' ${sysconfdir}/pam.d/common-password \
      ${sysconfdir}/pam.d/common-auth \
      ${sysconfdir}/security/faillock.conf', \
    '', d)}"