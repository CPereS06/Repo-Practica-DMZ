# Imagen base
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y openssh-server pkg-config iproute2 iputils-ping net-tools traceroute tcpdump nmap \
    iptables iptables-persistent nano curl && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Configurar SSH (root:root)
RUN echo "root:root" | chpasswd && \
    mkdir -p /var/run/sshd

# Copiar la clave privada
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Copiar scripts
COPY start.sh /usr/local/bin/start.sh
COPY iptables.sh /usr/local/bin/iptables.sh

# Dar permisos de ejecución
RUN chmod +x /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/iptables.sh

# RUN /usr/local/bin/iptables.sh

# Ejecutar script de arranque
CMD ["/bin/bash", "-c", "/usr/local/bin/iptables.sh && /usr/local/bin/start.sh"]
