FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://ssh_banner"

do_install:append() {
    install -m 0644 ${WORKDIR}/ssh_banner ${D}${sysconfdir}/ssh_banner

    if grep -q '^#Banner' ${D}${sysconfdir}/ssh/sshd_config; then
        sed -i 's|^#Banner.*|Banner /etc/ssh_banner|' ${D}${sysconfdir}/ssh/sshd_config
    elif grep -q '^Banner' ${D}${sysconfdir}/ssh/sshd_config; then
        sed -i 's|^Banner.*|Banner /etc/ssh_banner|' ${D}${sysconfdir}/ssh/sshd_config
    else
        echo 'Banner /etc/ssh_banner' >> ${D}${sysconfdir}/ssh/sshd_config
    fi
}

