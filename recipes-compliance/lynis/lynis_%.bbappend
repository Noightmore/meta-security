FILES:${PN}:append = " ${sysconfdir}/lynis/${LYNIS_PROFILE}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LYNIS_PROFILE = "custom.prf"
LYNIS_CUSTOM_TEST_0010 = "tests_custom_0010"
LYNIS_CUSTOM_TEST_0011 = "tests_custom_0011"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', \
    ' file://${LYNIS_PROFILE} file://${LYNIS_CUSTOM_TEST_0010} file://${LYNIS_CUSTOM_TEST_0011}', \
    '', d)}"

RDEPENDS:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', \
    'hardening', ' grep gzip', '', d)}"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        install -d "${D}${sysconfdir}/lynis"
        install -d "${D}${datadir}/lynis/include"

        install -m 0644 \
            "${UNPACKDIR}/${LYNIS_PROFILE}" \
            "${D}${sysconfdir}/lynis/${LYNIS_PROFILE}"

        custom_tests="${D}${datadir}/lynis/include/tests_custom"

        # Create the file if it was not supplied by the original recipe.
        touch "${custom_tests}"

        printf '\n' >> "${custom_tests}"
        cat "${UNPACKDIR}/${LYNIS_CUSTOM_TEST_0010}" >> "${custom_tests}"

        printf '\n' >> "${custom_tests}"
        cat "${UNPACKDIR}/${LYNIS_CUSTOM_TEST_0011}" >> "${custom_tests}"

        printf '\n' >> "${custom_tests}"
        chmod 0644 "${custom_tests}"
    fi
}

FILES:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', \
    ' ${sysconfdir}/lynis/${LYNIS_PROFILE} ${datadir}/lynis/include/tests_custom', \
    '', d)}"