FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y apache2 openssh-server pkg-config iproute2 iputils-ping net-tools traceroute tcpdump nmap \
    iptables iptables-persistent nano curl hping3 && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Configurar SSH (root:root)
RUN echo "root:root" | chpasswd && \
    mkdir -p /var/run/sshd

RUN a2enmod ssl && \
    a2ensite default-ssl

RUN mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=SICO/CN=localhost"

RUN sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt|g' /etc/apache2/sites-available/default-ssl.conf && \
    sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key|g' /etc/apache2/sites-available/default-ssl.conf

COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

COPY index.html /var/www/html/index.html
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
