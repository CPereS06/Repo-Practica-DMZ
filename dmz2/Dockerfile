FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    # Obligatorios: SSH, Iptables, pkg-config, net-tools, iputils-ping, traceroute, iproute2, tcdump, nmap
    apt install -y apache2 openssh-server openssh-client pkg-config iproute2 iputils-ping net-tools traceroute tcpdump nmap rsyslog \
    iptables iptables-persistent nano curl fail2ban && \
    apt clean && rm -rf /var/lib/apt/lists/*

# PARA EL OPENSSH & FAILBAN
RUN useradd -m -s /bin/bash aaa && \ 
    echo "aaa:aaa" | chpasswd && \
    mkdir /var/run/sshd

# Banner de autenticación personalizado
RUN echo "*\n  Servidor SSH - DMZ\n*" > /etc/ssh/ssh_banner

# Configurar SSH
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#MaxAuthTries.*/MaxAuthTries 2/' /etc/ssh/sshd_config && \
    echo "Banner /etc/ssh/ssh_banner" >> /etc/ssh/sshd_config

# Copiar configuración de jail
COPY jail.local /etc/fail2ban/jail.local

EXPOSE 2222

COPY index.html /var/www/html/index.html
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

RUN ssh-keygen -A

RUN sed -i 's/^#?SyslogFacility ./SyslogFacility AUTH/' /etc/ssh/sshd_config && \
    sed -i 's/^#?LogLevel ./LogLevel INFO/' /etc/ssh/sshd_config

CMD ["/usr/local/bin/start.sh"]
