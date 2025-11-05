FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    # Obligatorios: SSH, Iptables, pkg-config, net-tools, iputils-ping, traceroute, iproute2, tcdump, nmap
    apt install -y openssh-server pkg-config iproute2 iputils-ping net-tools traceroute tcpdump nmap \
    iptables iptables-persistent nano curl && \
    apt clean && rm -rf /var/lib/apt/lists/*
    
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
