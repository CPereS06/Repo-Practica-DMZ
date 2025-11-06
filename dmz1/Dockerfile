FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
      iproute2 iputils-ping net-tools curl vim nano \
      openssh-server openssh-client apache2 \
      iptables pkg-config traceroute tcpdump nmap hping3 \
      git python3-pip python3-venv libssl-dev libffi-dev build-essential libpython3-dev python3-minimal authbind && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Usuario con privilegios para ejecutar COWRIE
RUN useradd -m -s /bin/bash -p "" cowrie

USER cowrie
WORKDIR /home/cowrie

RUN git clone http://github.com/cowrie/cowrie
WORKDIR /home/cowrie/cowrie

RUN python3 -m venv cowrie-env && \
    . cowrie-env/bin/activate && \
    python -m pip install --upgrade pip && \
    python -m pip install -e .

# Configurar cowrie.cfg personalizado
RUN mkdir -p /home/cowrie/cowrie/etc && \
    echo "[ssh]" > /home/cowrie/cowrie/etc/cowrie.cfg && \
    echo "listen_endpoints = tcp:2222:interface=0.0.0.0" >> /home/cowrie/cowrie/etc/cowrie.cfg && \
    echo "auth_class = AuthRandom" >> /home/cowrie/cowrie/etc/cowrie.cfg && \
    echo "" >> /home/cowrie/cowrie/etc/cowrie.cfg && \
    echo "[shell]" >> /home/cowrie/cowrie/etc/cowrie.cfg && \
    echo "hostname = CARLA" >> /home/cowrie/cowrie/etc/cowrie.cfg

RUN echo "cowrie:1001:*" > /home/cowrie/cowrie/etc/userdb.txt

USER root

COPY index.html /var/www/html/index.html
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 2222

CMD ["/usr/local/bin/start.sh"]
