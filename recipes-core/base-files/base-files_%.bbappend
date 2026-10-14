do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        profile="${D}${sysconfdir}/profile"

        if [ -f "$profile" ]; then
            sed -i '/^[[:space:]]*umask[[:space:]]/d' "$profile"
            printf '\numask ${HARDENING_UMASK}\n' >> "$profile"
        fi
    fi
}