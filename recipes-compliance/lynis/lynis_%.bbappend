FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LYNIS_PROFILE ?= "embedded.prf"
LYNIS_CUSTOM_TEST_DIR ?= "custom-tests"

LYNIS_PASSWORD_MIN_LENGTH ?= "12"
LYNIS_PASSWORD_HISTORY ?= "5"
LYNIS_PASSWORD_RETRY ?= "3"
LYNIS_FAILLOCK_DENY ?= "30"

SRC_URI:append = " \
    file://${LYNIS_PROFILE} \
    file://${LYNIS_CUSTOM_TEST_DIR} \
"

# grep and gzip are used by Lynis tests.
RDEPENDS:${PN}:append = " grep gzip"

do_install:append() {
    install -d "${D}${sysconfdir}/lynis"
    install -d "${D}${datadir}/lynis/include"

    install -m 0644 \
        "${UNPACKDIR}/${LYNIS_PROFILE}" \
        "${D}${sysconfdir}/lynis/${LYNIS_PROFILE}"

    custom_tests="${D}${datadir}/lynis/include/tests_custom"

    touch "${custom_tests}"
    printf '\n' >> "${custom_tests}"

    for test_file in "${UNPACKDIR}/${LYNIS_CUSTOM_TEST_DIR}/"*; do
        [ -f "${test_file}" ] || continue

        sed \
            -e "s|@LYNIS_PASSWORD_MIN_LENGTH@|${LYNIS_PASSWORD_MIN_LENGTH}|g" \
            -e "s|@LYNIS_PASSWORD_HISTORY@|${LYNIS_PASSWORD_HISTORY}|g" \
            -e "s|@LYNIS_PASSWORD_RETRY@|${LYNIS_PASSWORD_RETRY}|g" \
            -e "s|@LYNIS_FAILLOCK_DENY@|${LYNIS_FAILLOCK_DENY}|g" \
            "${test_file}" >> "${custom_tests}"

        printf '\n' >> "${custom_tests}"
    done

    chmod 0644 "${custom_tests}"
}

FILES:${PN}:append = " \
    ${sysconfdir}/lynis/${LYNIS_PROFILE} \
    ${datadir}/lynis/include/tests_custom \
"