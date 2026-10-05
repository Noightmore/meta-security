# is either going to be removed or kept
do_install:append:harden () {
	# to hardend
	sed -i -e 's:UMASK.*:UMASK 027:' ${D}${sysconfdir}/login.defs
	sed -i -e 's:PASS_MAX_DAYS.*:PASS_MAX_DAYS 365:' ${D}${sysconfdir}/login.defs
	sed -i -e 's:PASS_MIN_DAYS.*:PASS_MIN_DAYS 1:' ${D}${sysconfdir}/login.defs
	sed -i -e 's:#PASS_MIN_LEN.*:PASS_MIN_LEN 11:' ${D}${sysconfdir}/login.defs
	sed -i -e 's:PASS_WARN_AGE.*:PASS_WARN_AGE 14:' ${D}${sysconfdir}/login.defs
	sed -i -e 's:LOGIN_RETRIES.*:LOGIN_RETRIES 3:' ${D}${sysconfdir}/login.defs
	sed -i -e 's:LOGIN_TIMEOUT.*:LOGIN_TIMEOUT 30:' ${D}${sysconfdir}/login.defs
}

# again reconfigure for the hardening feature while keeping the original harden distro part
# but password expiraton and just 3 login retries is archaic approach
# I give reasonable amount of password retries but if a serious attack happens then the lock out is long enough an
# admin has time to react and investigate
# and moved other configuration to seperate recipes in recipes-extended -- pam and libpwquality
do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'hardening', 'true', 'false', d)}; then
        sed -i -E \
            's/^[[:space:]]*#?[[:space:]]*UMASK[[:space:]]+.*/UMASK 027/' \
            ${D}${sysconfdir}/login.defs
    fi
}