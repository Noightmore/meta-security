do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        login_defs="${D}${sysconfdir}/login.defs"

        if [ -f "$login_defs" ]; then
            sed -i \
                -e '/^[[:space:]]*UMASK[[:space:]]/d' \
                -e '/^[[:space:]]*HOME_MODE[[:space:]]/d' \
                "$login_defs"

            printf '\nUMASK ${HARDENING_UMASK}\n' >> "$login_defs"
            printf 'HOME_MODE ${HARDENING_HOME_MODE}\n' >> "$login_defs"
        fi
    fi
}