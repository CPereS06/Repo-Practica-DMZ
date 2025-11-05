#!/bin/bash

# Aplicar las reglas desde el script
bash /usr/local/bin/iptables.sh

# COWRIE
runuser -u cowrie -- bash -lc 'cd /home/cowrie/cowrie && source cowrie-env/bin/activate && cowrie start'

# Mantener contenedor activo
exec /usr/sbin/sshd -D
