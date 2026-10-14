IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' packagegroup-hardening', '', d)}"
IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' hardening-sysctl', '', d)}"

# Install hardening packages
IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' packagegroup-hardening', '', d)}"

harden_home_directories() {
    if [ -d "${IMAGE_ROOTFS}/home" ]; then
        find "${IMAGE_ROOTFS}/home" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
            -exec chmod ${HARDENING_HOME_MODE} {} +
    fi
}

# Run only when both conditions are satisfied:
# 1. hardening DISTRO_FEATURE is enabled
# 2. HARDENING_HOME_PERMISSIONS is set to "1"
ROOTFS_POSTPROCESS_COMMAND:append = "${@' harden_home_directories;' if bb.utils.contains('DISTRO_FEATURES', 'hardening', True, False, d) and d.getVar('HARDENING_HOME_PERMISSIONS') == '1' else ''}"