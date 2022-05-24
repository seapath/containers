#!/bin/sh

set -e

rm -rf /tmp/dnsmasq.d
mkdir /tmp/dnsmasq.d

if [ -n "${PXE}" ] ; then
    if [ "${PXE}" = dual ] ; then
        cat << EOF > /tmp/dnsmasq.d/pxe.conf
enable-tftp=${BIND_INTERFACE}
tftp-root=/tftpboot
dhcp-match=set:x86PC, option:client-arch, 0 #BIOS
dhcp-match=set:UEFI64, option:client-arch, 7 #UEFI64
dhcp-match=set:UEFI64, option:client-arch, 9 #EBC

dhcp-boot=tag:x86PC, syslinux/pxelinux.0
dhcp-boot=tag:UEFI64, syslinux/efi64/syslinux.efi
EOF
    else
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
    fi
    sed  "s/@SERVER_ADDRESS@/${SERVER_ADDRESS}/g" \
        /opt/syslinux.cfg.in >/tftpboot/syslinux/pxelinux.cfg/default
    sed  "s/@HTTP_PORT@/${HTTP_PORT}/g" \
        -i /tftpboot/syslinux/pxelinux.cfg/default
    sed  "s/@SERVER_ADDRESS@/${SERVER_ADDRESS}/g" \
        /opt/syslinux_efi.cfg.in > /tftpboot/syslinux/efi64/pxelinux.cfg/default
    sed  "s/@HTTP_PORT@/${HTTP_PORT}/g" \
        -i /tftpboot/syslinux/efi64/pxelinux.cfg/default
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

cp /etc/nginx/nginx.conf.in /etc/nginx/nginx.conf
sed "s/@SERVER_ADDRESS@/${SERVER_ADDRESS}/" -i /etc/nginx/nginx.conf

nginx &
/usr/sbin/dnsmasq --keep-in-foreground --log-facility=-
