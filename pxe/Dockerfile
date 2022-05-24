# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FROM alpine:3.13

RUN apk --no-cache add dnsmasq syslinux nginx && \
    mkdir /tftpboot && \
    cp -r /usr/share/syslinux /tftpboot/ && \
    chown -R nobody:nogroup /tftpboot && \
    mkdir /tftpboot/syslinux/pxelinux.cfg \
        /tftpboot/syslinux/efi64/pxelinux.cfg && \
    ln -sf /images /tftpboot/syslinux/images && \
    ln -sf /images /tftpboot/syslinux/efi64/images
COPY nginx.conf.in /etc/nginx/nginx.conf.in
COPY syslinux.cfg.in /opt/syslinux.cfg.in
COPY syslinux_efi.cfg.in /opt/syslinux_efi.cfg.in
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY start.sh /usr/bin/start.sh
VOLUME /images
CMD ["start.sh"]
