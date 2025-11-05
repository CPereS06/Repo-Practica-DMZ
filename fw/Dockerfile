# Imagen base
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    # Obligatorios: SSH, Iptables, pkg-config, net-tools, iputils-ping, traceroute, iproute2, tcdump, nmap
    apt install -y openssh-server pkg-config iproute2 iputils-ping net-tools traceroute tcpdump nmap \
    iptables iptables-persistent nano curl && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copiar scripts
COPY start.sh /usr/local/bin/start.sh
COPY iptables.sh /usr/local/bin/iptables.sh

# Dar permisos de ejecución
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/iptables.sh

# Ejecutar script de arranque
CMD ["/usr/local/bin/start.sh"]
