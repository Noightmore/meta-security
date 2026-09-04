FILES:${PN}:append = " ${sysconfdir}/lynis/${LYNIS_PROFILE}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LYNIS_PROFILE = "custom.prf"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' file://${LYNIS_PROFILE}', '', d)}"

# Lynis requires GNU grep for some tests. The OE grep package provides
# /bin/grep, while Lynis expects GNU grep at /usr/bin/grep. Fixed it with creating a symlink
# grep is installed but a faulty lynis test tries to use zgrep which is not installed but reports /usr/bin/grep as not found
# zgrep is part of the gzip package
RDEPENDS:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' grep', '', d)}"
RDEPENDS:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' gzip', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        install -m 0644 ${UNPACKDIR}/${LYNIS_PROFILE} \
            ${D}${sysconfdir}/lynis/${LYNIS_PROFILE}
    fi
}

FILES:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' ${sysconfdir}/lynis/${LYNIS_PROFILE} ${bindir}/grep', '', d)}"