FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' file://common-password-hardening', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        install -d "${D}${sysconfdir}/pam.d"

        install -m 0644 \
            "${UNPACKDIR}/common-password-hardening" \
            "${D}${sysconfdir}/pam.d/common-password"
    fi
}