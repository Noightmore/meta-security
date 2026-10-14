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

# a small validation function to check if any insecure image features are enabled when hardening is enabled,
# migrated from old meta-hardening layer
python hardening_validate_image_features() {
    if d.getVar("HARDENING_DEVEL") == "1":
        return

    if d.getVar("HARDENING_RESTRICT_IMAGE_FEATURES") != "1":
        return

    insecure = {
        "allow-empty-password",
        "empty-root-password",
        "allow-root-login",
    }

    enabled = set((d.getVar("IMAGE_FEATURES") or "").split())
    enabled.update((d.getVar("EXTRA_IMAGE_FEATURES") or "").split())

    forbidden = insecure.intersection(enabled)

    if forbidden:
        bb.fatal(
            "Hardening: insecure image features enabled: %s"
            % ", ".join(sorted(forbidden))
        )
}

ROOTFS_POSTPROCESS_COMMAND:append = "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' hardening_validate_image_features;', '', d)}"