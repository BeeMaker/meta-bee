SUMMARY = "Bee image"
IMAGE_LINGUAS = " "
LICENCE = "MIT"

REQUIRED_DISTRO_FEATURES += " systemd"

IMAGE_INSTALL = "package-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"