FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y apache2 openssh-server openssh-client pkg-config iproute2 iputils-ping net-tools  \
    iptables iptables-persistent nano curl fail2ban traceroute tcpdump nmap rsyslog && \
    apt clean && rm -rf /var/lib/apt/lists/*

# PARA EL OPENSSH & FAILBAN
RUN useradd -m -s /bin/bash carla && \ 
    echo "carla:carla" | chpasswd && \
    mkdir /var/run/sshd /home/carla/.ssh && chown -R carla:carla /home/carla/.ssh

# Banner de autenticación personalizado
RUN echo "*\n Servidor SSH - DMZ \n*" > /etc/ssh/ssh_banner
RUN echo "*\n CARLA PÉREZ SAMPEDRO \n*" > /etc/ssh/ssh_banner

# Configurar SSH
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#MaxAuthTries.*/MaxAuthTries 2/' /etc/ssh/sshd_config && \
    echo "Banner /etc/ssh/ssh_banner" >> /etc/ssh/sshd_config && \
    echo "AllowUsers carla" >> /etc/ssh/sshd_config

# Módulo SSL de Apache
RUN a2enmod ssl && \
    a2ensite default-ssl

# Certificado SSL
RUN mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=SICO/CN=localhost"

RUN sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt|g' /etc/apache2/sites-available/default-ssl.conf && \
    sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key|g' /etc/apache2/sites-available/default-ssl.conf

RUN sed -i 's/^#?SyslogFacility ./SyslogFacility AUTH/' /etc/ssh/sshd_config && \
    sed -i 's/^#?LogLevel ./LogLevel INFO/' /etc/ssh/sshd_config

# Copiar la clave pública
COPY id_rsa.pub /home/carla/.ssh/authorized_keys
RUN chmod 600 /home/carla/.ssh/authorized_keys && \
    chown carla:carla /home/carla/.ssh/authorized_keys

# Copiar configuración de jail
COPY jail.local /etc/fail2ban/jail.local

COPY index.html /var/www/html/index.html
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

RUN ssh-keygen -A

CMD ["/usr/local/bin/start.sh"]
