SUMMARY = "Target packages for Utils"
LICENCE = "MIT"
PR = "r1"

inherit packagegroup

RDEPENDS_${PN} = "\
    libgcc \
    libgcc-dev \
    libatomic \
    libatomic-dev \
    libstdc++ \
    libstdc++-dev \
    autossh \
    ssh-keys \
    networkmanager \
    networkmanager \
    docker \
    docker-contrib \
    systemd \
    ${LIBC_DEPENDENCIES} \
    "

RRECOMMENDS_${PN} = "\
    libssp \
    libssp-dev \
"
