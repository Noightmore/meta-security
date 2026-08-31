FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' file://embedded.prf', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        install -m 0644 ${UNPACKDIR}/embedded.prf \
            ${D}${sysconfdir}/lynis/embedded.prf
    fi
}

FILES:${PN}:append = " ${sysconfdir}/lynis/embedded.prf"