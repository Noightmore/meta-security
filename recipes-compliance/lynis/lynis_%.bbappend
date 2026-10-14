FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LYNIS_CUSTOM_POLICY_DIR ?= "custom-policies"

LYNIS_PROFILE_SOURCE ?= "embedded.prf"
LYNIS_PROFILE_NAME ?= "embedded.prf"

SRC_URI:append = " file://${LYNIS_PROFILE_SOURCE}"
SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' file://${LYNIS_CUSTOM_POLICY_DIR}', '', d)}"

do_install:append() {
    # Always install the generic embedded audit profile.
    install -d "${D}${sysconfdir}/lynis"

    install -m 0644 \
        "${UNPACKDIR}/${LYNIS_PROFILE_SOURCE}" \
        "${D}${sysconfdir}/lynis/${LYNIS_PROFILE_NAME}"

    # Custom hardening tests are optional.
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then

        install -d "${D}${datadir}/lynis/include"

        custom_policies="${D}${datadir}/lynis/include/tests_custom"

        # Preserve an existing tests_custom file.
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
                -e "s|@LYNIS_PASSWORD_DCREDIT@|${LYNIS_PASSWORD_DCREDIT}|g" \
                -e "s|@LYNIS_PASSWORD_UCREDIT@|${LYNIS_PASSWORD_UCREDIT}|g" \
                -e "s|@LYNIS_PASSWORD_LCREDIT@|${LYNIS_PASSWORD_LCREDIT}|g" \
                -e "s|@LYNIS_PASSWORD_OCREDIT@|${LYNIS_PASSWORD_OCREDIT}|g" \
                -e "s|@LYNIS_PASSWORD_DIFOK@|${LYNIS_PASSWORD_DIFOK}|g" \
                -e "s|@LYNIS_PASSWORD_MAXREPEAT@|${LYNIS_PASSWORD_MAXREPEAT}|g" \
                -e "s|@LYNIS_PASSWORD_MAXSEQUENCE@|${LYNIS_PASSWORD_MAXSEQUENCE}|g" \
                -e "s|@LYNIS_PASSWORD_DICTCHECK@|${LYNIS_PASSWORD_DICTCHECK}|g" \
                -e "s|@LYNIS_PASSWORD_USERCHECK@|${LYNIS_PASSWORD_USERCHECK}|g" \
                -e "s|@LYNIS_PASSWORD_USERSUBSTR@|${LYNIS_PASSWORD_USERSUBSTR}|g" \
                -e "s|@LYNIS_PASSWORD_ENFORCING@|${LYNIS_PASSWORD_ENFORCING}|g" \
                -e "s|@LYNIS_PASSWORD_ENFORCE_FOR_ROOT@|${LYNIS_PASSWORD_ENFORCE_FOR_ROOT}|g" \
                -e "s|@LYNIS_FAILLOCK_DENY@|${LYNIS_FAILLOCK_DENY}|g" \
                -e "s|@LYNIS_FAILLOCK_INTERVAL@|${LYNIS_FAILLOCK_INTERVAL}|g" \
                -e "s|@LYNIS_FAILLOCK_UNLOCK_TIME@|${LYNIS_FAILLOCK_UNLOCK_TIME}|g" \
                -e "s|@LYNIS_FAILLOCK_SILENT@|${LYNIS_FAILLOCK_SILENT}|g" \
                -e "s|@LYNIS_FAILLOCK_EVEN_DENY_ROOT@|${LYNIS_FAILLOCK_EVEN_DENY_ROOT}|g" \
                "${policy_file}" >> "${custom_policies}"

            printf '\n' >> "${custom_policies}"
        done

        chmod 0644 "${custom_policies}"
    fi
}

FILES:${PN}:append = " ${sysconfdir}/lynis/${LYNIS_PROFILE_NAME}"
FILES:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' ${datadir}/lynis/include/tests_custom', '', d)}"

# lynis audit system --profile /etc/lynis/embedded.prf