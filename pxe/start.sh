#!/bin/sh

set -e

rm -rf /tmp/dnsmasq.d
mkdir /tmp/dnsmasq.d
if [ -n "${PXE}" ] ; then
    if [ "${PXE}" = uefi ] ; then
        pxelinux=syslinux/efi64/syslinux.efi
    else
        pxelinux=syslinux/pxelinux.0
    fi
cat << EOF > /tmp/dnsmasq.d/pxe.conf
enable-tftp=${BIND_INTERFACE}
dhcp-option=66,${SERVER_ADDRESS}
dhcp-option=67,${pxelinux}
tftp-root=/tftpboot
EOF
sed  "s/@SERVER_ADDRESS@/${SERVER_ADDRESS}/g" /opt/syslinux.cfg.in >/tftpboot/syslinux/pxelinux.cfg/default
sed  "s/@HTTP_PORT@/${HTTP_PORT}/g" -i /tftpboot/syslinux/pxelinux.cfg/default
sed  "s/@SERVER_ADDRESS@/${SERVER_ADDRESS}/g" /opt/syslinux_efi.cfg.in > /tftpboot/syslinux/efi64/pxelinux.cfg/default
sed  "s/@HTTP_PORT@/${HTTP_PORT}/g" -i /tftpboot/syslinux/efi64/pxelinux.cfg/default

fi
if [ "${DHCP_NO_IGNORE}" != "yes" ] ; then
    echo "dhcp-ignore=tag:!known" > /tmp/dnsmasq.d/dhcp_ignore.conf
fi

cat << EOF > /tmp/dnsmasq.d/dhcp.conf
dhcp-authoritative
dhcp-range=${DHCP_RANGE_BEGIN},${DHCP_RANGE_END},48h
interface=${BIND_INTERFACE}
log-dhcp
EOF

nginx &
/usr/sbin/dnsmasq --keep-in-foreground --log-facility=-
