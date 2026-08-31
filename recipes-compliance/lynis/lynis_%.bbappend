FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LYNIS_PROFILE = "custom.prf"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' file://${LYNIS_PROFILE}', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        install -m 0644 ${UNPACKDIR}/${LYNIS_PROFILE} \
            ${D}${sysconfdir}/lynis/${LYNIS_PROFILE}
    fi
}

FILES:${PN}:append = " ${sysconfdir}/lynis/${LYNIS_PROFILE}"