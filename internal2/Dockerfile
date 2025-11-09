FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y openssh-server pkg-config iproute2 iputils-ping net-tools traceroute tcpdump nmap \
    iptables iptables-persistent nano curl && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN echo "root:root" | chpasswd && \
    mkdir -p /var/run/sshd

COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
