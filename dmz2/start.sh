#!/bin/bash

route add default gw 10.5.1.1
route del default gw 10.5.1.254

# Configurar SSH (root:root)
echo "root:root" | chpasswd
mkdir -p /var/run/sshd

# Iniciar servicios
rsyslogd &
touch /var/log/auth.log
chown syslog:adm /var/log/auth.log 
chmod 640 /var/log/auth.log

# Iniciar Fail2Ban
service fail2ban start

service apache2 start

exec /usr/sbin/sshd -D -f /etc/ssh/sshd_config
