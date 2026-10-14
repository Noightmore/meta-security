# hardening.inc

# Additional distro features required by hardening (has to be added like that to prevent circular dependency)
HARDENING_REQUIRED_FEATURES := "${@bb.utils.contains('DISTRO_FEATURES', 'hardening', ' pam', '', d)}"
DISTRO_FEATURES:append = "${HARDENING_REQUIRED_FEATURES}"

# Default permissions for newly created files and directories
HARDENING_UMASK ?= "027"
# Default permissions for user home directories
HARDENING_HOME_MODE ?= "0750"
# Enable automatic home-directory permission hardening
HARDENING_HOME_PERMISSIONS ?= "1"

## LYNIS hardening settings

# PAM password policy (pam_unix)
LYNIS_PASSWORD_MIN_LENGTH ?= "12"
LYNIS_PASSWORD_HISTORY ?= "5"
LYNIS_PASSWORD_RETRY ?= "3"
LYNIS_FAILLOCK_DENY ?= "30"
LYNIS_FAILLOCK_INTERVAL ?= "900"
LYNIS_FAILLOCK_UNLOCK_TIME ?= "900"
LYNIS_FAILLOCK_SILENT ?= "1"
LYNIS_FAILLOCK_EVEN_DENY_ROOT ?= "0"

# PAM password quality policy (pam_pwquality)
LYNIS_PASSWORD_DCREDIT ?= "0"
LYNIS_PASSWORD_UCREDIT ?= "0"
LYNIS_PASSWORD_LCREDIT ?= "0"
LYNIS_PASSWORD_OCREDIT ?= "0"

LYNIS_PASSWORD_DIFOK ?= "4"
LYNIS_PASSWORD_MAXREPEAT ?= "3"
LYNIS_PASSWORD_MAXSEQUENCE ?= "3"

LYNIS_PASSWORD_DICTCHECK ?= "1"
LYNIS_PASSWORD_USERCHECK ?= "1"
LYNIS_PASSWORD_USERSUBSTR ?= "4"

LYNIS_PASSWORD_ENFORCING ?= "1"
LYNIS_PASSWORD_ENFORCE_FOR_ROOT ?= "1"

