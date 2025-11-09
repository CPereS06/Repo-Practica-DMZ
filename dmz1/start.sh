START.SH CARLA DMZ1

#!/bin/bash

# Añadir las rutas del gateway
route add default gw 10.5.1.1
route del default gw 10.5.1.254

# Mantenemos el COWRIE abierto
runuser -u cowrie -- bash -lc 'cd /home/cowrie/cowrie && source cowrie-env/bin/activate && cowrie start'

# En caso de no existir, crea /var/run/sshd
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Inicialización de servicios
service apache2 start

exec /usr/sbin/sshd -D