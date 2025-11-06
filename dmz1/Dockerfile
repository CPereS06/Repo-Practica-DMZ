FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

# Instalación de las aplicaciones y limpieza del apt update
RUN apt update && \
    apt install -y iproute2 iputils-ping net-tools curl nano openssh-server openssh-client apache2 \
    iptables pkg-config traceroute tcpdump nmap hping3 git python3-pip python3-venv libssl-dev \
    build-essential libpython3-dev python3-minimal authbind && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Crear usuario con privilegios para ejecutar COWRIE con directorio personal, 
# con /bin/bash como shell predeterminado y con una contraseña vacía. El
# nombre del usuario es cowrie
RUN useradd -m -s /bin/bash -p "" cowrie
# Cambia el usuario predeterminado a COWRIE
USER cowrie
# Establece el directorio de trabajo actual
WORKDIR /home/cowrie

# Importamos el git clone
RUN git clone http://github.com/cowrie/cowrie
WORKDIR /home/cowrie/cowrie/

# Configuración de los entornos
RUN python3 -m venv cowrie-env && \
    . cowrie-env/bin/activate && \
    python -m pip install --upgrade pip && \
    python -m pip install -e .

# Importación de los ficheros correspondientes
COPY cowrie.cfg /home/cowrie/cowrie/etc/cowrie.cfg
COPY userdb.txt /home/cowrie/cowrie/etc/userdb.txt

# Cambiamos al usuario ROOT
USER root

# Copiamos los ficheros a la máquina virtual
COPY index.html /var/www/html/index.html
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Iniciar 
CMD ["/bin/bash", "-c", "/usr/local/bin/start.sh"]