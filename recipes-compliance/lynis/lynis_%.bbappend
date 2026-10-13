FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LYNIS_CUSTOM_POLICY_DIR ?= "custom-policies"

LYNIS_PASSWORD_MIN_LENGTH ?= "12"
LYNIS_PASSWORD_HISTORY ?= "5"
LYNIS_PASSWORD_RETRY ?= "3"
LYNIS_FAILLOCK_DENY ?= "30"
LYNIS_PROFILE_SOURCE ?= "embedded.prf"
LYNIS_PROFILE_NAME ?= "embedded.prf"

SRC_URI:append = " \
    file://${LYNIS_PROFILE_SOURCE} \
    file://${LYNIS_CUSTOM_POLICY_DIR} \
"

do_install:append() {
    install -d "${D}${sysconfdir}/lynis"
    install -d "${D}${datadir}/lynis/include"

    install -m 0644 \
          "${UNPACKDIR}/${LYNIS_PROFILE_SOURCE}" \
          "${D}${sysconfdir}/lynis/${LYNIS_PROFILE_NAME}"

    custom_policies="${D}${datadir}/lynis/include/tests_custom"

    # Preserve the existing Lynis custom-test file, if installed.
    # Avoid duplicate content when rebuilding.
    if [ ! -f "${custom_policies}" ]; then
        touch "${custom_policies}"
    fi

    for policy_file in "${UNPACKDIR}/${LYNIS_CUSTOM_POLICY_DIR}/"*; do
        [ -f "${policy_file}" ] || continue

        printf '\n' >> "${custom_policies}"

        sed \
            -e "s|@LYNIS_PASSWORD_MIN_LENGTH@|${LYNIS_PASSWORD_MIN_LENGTH}|g" \
            -e "s|@LYNIS_PASSWORD_HISTORY@|${LYNIS_PASSWORD_HISTORY}|g" \
            -e "s|@LYNIS_PASSWORD_RETRY@|${LYNIS_PASSWORD_RETRY}|g" \
            -e "s|@LYNIS_FAILLOCK_DENY@|${LYNIS_FAILLOCK_DENY}|g" \
            "${policy_file}" >> "${custom_policies}"

        printf '\n' >> "${custom_policies}"
    done

    chmod 0644 "${custom_policies}"
}

FILES:${PN}:append = " \
    ${sysconfdir}/lynis/${LYNIS_PROFILE} \
    ${datadir}/lynis/include/tests_custom \
"

# lynis audit system --profile /etc/lynis/embedded.prf