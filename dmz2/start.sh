#!/bin/bash

service fail2ban start
service apache2 start

route add default gw 10.5.1.1
route del default gw 10.5.1.254

# Iniciar servicios
rsyslogd &
touch /var/log/auth.log
chown syslog:adm /var/log/auth.log 
chmod 640 /var/log/auth.log


exec /usr/sbin/sshd -D -f /etc/ssh/sshd_config
