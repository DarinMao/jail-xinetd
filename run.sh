#!/bin/sh

set -eu

xinetd_cfg=/tmp/xinetd.conf

cat << EOF > $xinetd_cfg
service ctf
{
  disable = no
  socket_type = stream
  protocol = tcp
  wait  = no
  user = root
  type = UNLISTED
  port = 5000
  bind = 0.0.0.0
  server = /bin/timeout
  server_args = -s 9 ${JAIL_TIME:-30} /jail/chroot
  per_source = ${JAIL_CONNS_PER_IP:-UNLIMITED}
  instances = ${JAIL_CONNS:-UNLIMITED}
  rlimit_as = ${JAIL_MEM:-5242880}
  rlimit_files = ${JAIL_FILES:-100}
  rlimit_cpu = ${JAIL_CPU:-20}
}
EOF

[ -e /jail/hook.sh ] && . /jail/hook.sh

exec /jail/xinetd -f $xinetd_cfg -dontfork
