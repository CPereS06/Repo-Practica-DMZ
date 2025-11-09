#!/bin/bash

route add default gw 10.5.0.1
route del default gw 10.5.0.254

sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Iniciar servicios
service apache2 start

exec /usr/sbin/sshd -D