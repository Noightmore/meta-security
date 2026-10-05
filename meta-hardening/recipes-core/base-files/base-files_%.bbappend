
# keep original harden distro feature functionality for now
do_install:append:harden () {
    sed -i 's/umask.*/umask 027/g' ${D}/${sysconfdir}/profile
}

# my suggestion would be to completely remove the harden feature and unify the recipes from meta-hardening under the
# whole hardening feature set im developing as to unify the usage
do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        sed -i 's/umask.*/umask 027/g' \
            ${D}${sysconfdir}/profile
    fi
}