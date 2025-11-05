# REGLAS DE ENRUTADO - IPTABLES

# Activar reenvío de paquetes IP (necesario para NAT y forwarding)
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# VARIABLES 
EXT_IF=$(ip -o -4 addr show | awk '/10\.5\.0\.1/{print $2}')
DMZ_IF=$(ip -o -4 addr show | awk '/10\.5\.1\.1/{print $2}')
INT_IF=$(ip -o -4 addr show | awk '/10\.5\.2\.1/{print $2}')

# POLITICAS BASE
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# PERMITIR LOOPBACK
iptables -A INPUT -i lo -j ACCEPT

# PERMITIR ICMP
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 10/min --limit-burst 10 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 10/min --limit-burst 10 -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -j DROP


# Permitir tráfico local y respuestas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Conexiones de INT1 e INT2
iptables -A FORWARD -i $INT_IF -o $EXT_IF -s 10.5.2.0/24 -d 10.5.0.0/24 -p tcp -j ACCEPT
iptables -A FORWARD -i $INT_IF -o $EXT_IF -s 10.5.2.0/24 -d 10.5.0.0/24 -p udp -j ACCEPT
iptables -A FORWARD -i $INT_IF -o $EXT_IF -s 10.5.2.0/24 -d 10.5.0.0/24 -p icmp -j ACCEPT

# Para ocultar la estructura interna de la red interna, SNAT
iptables -t nat -A POSTROUTING -s 10.5.2.0/24 -o $EXT_IF -j SNAT --to-source 10.5.0.1

# Permitir SSH hacia DMZ
iptables -A FORWARD -i $INT_IF -o $DMZ_IF -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -i $EXT_IF -o $DMZ_IF -p tcp --dport 22 -j ACCEPT

# Permitir SSH solo desde INT1 hacia DMZ
iptables -A FORWARD -i $INT_IF -o $DMZ_IF -p tcp --dport 80 -j ACCEPT

# 