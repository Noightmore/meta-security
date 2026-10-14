# hardening.inc

python __anonymous() {
    features = set((d.getVar("DISTRO_FEATURES") or "").split())

    if "hardening" in features:
        d.appendVar("DISTRO_FEATURES", " pam security")
}