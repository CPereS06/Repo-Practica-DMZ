#!/bin/bash

route add default gw 10.5.1.1
route del default gw 10.5.1.254

# Configurar SSH (root:root)
echo "root:root" | chpasswd
mkdir -p /var/run/sshd

sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Iniciar servicios
service apache2 start

runuser -u cowrie -- bash -lc 'cd /home/cowrie/cowrie && source cowrie-env/bin/activate && cowrie start'

exec /usr/sbin/sshd -D 
