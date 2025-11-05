#!/bin/bash

route add default gw 10.5.2.1
route del default gw 10.5.2.254

# Configurar SSH (root:root)
echo "root:root" | chpasswd
mkdir -p /var/run/sshd

sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Mantener contenedor activo
tail -f /dev/null
exec /usr/sbin/sshd -D 