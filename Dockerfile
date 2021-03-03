FROM debian:buster-slim@sha256:7f5c2603ccccb7fa4fc934bad5494ee9f47a5708ed0233f5cd9200fe616002ad as xinetd
RUN apt-get update && \
    apt-get install -y --no-install-recommends xinetd

FROM busybox:1.32.1-glibc

RUN adduser -HDu 1000 jail && \
    mkdir -p /srv/dev && \
    mknod -m 666 /srv/dev/null c 1 3 && \
    mknod -m 666 /srv/dev/zero c 1 5 && \
    mknod -m 444 /srv/dev/urandom c 1 9 && \
    echo tcp 6 TCP > /etc/protocols

COPY --from=xinetd /usr/sbin/xinetd /usr/sbin/chroot /jail/
COPY --from=xinetd \
    /lib/x86_64-linux-gnu/libnsl.so.1 \
    /lib/x86_64-linux-gnu/libwrap.so.0 \
    /lib/x86_64-linux-gnu/libselinux.so.1 \
    /lib/x86_64-linux-gnu/libpcre.so.3 \
    /lib/x86_64-linux-gnu/libdl.so.2 \
    /lib/

COPY run.sh /jail
CMD ["/jail/run.sh"]
