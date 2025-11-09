# REGLAS DE ENRUTADO - IPTABLES

# Activar reenvío de paquetes IP (necesario para NAT y forwarding)
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# VARIABLES 
EXT=$(ip -o -4 addr show | awk '/10\.5\.0\.1/{print $2}')
DMZ=$(ip -o -4 addr show | awk '/10\.5\.1\.1/{print $2}')
INT=$(ip -o -4 addr show | awk '/10\.5\.2\.1/{print $2}')

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
iptables -A FORWARD -i $INT -o $EXT -p tcp -j ACCEPT
iptables -A FORWARD -i $INT -o $EXT -p udp -j ACCEPT
iptables -A FORWARD -i $INT -o $EXT -p icmp -j ACCEPT

#Permitir trafico desde cualquier sitio a la DMZ - HTTP
iptables -A FORWARD -p tcp -o $DMZ --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -o $DMZ --dport 443 -j ACCEPT

# DESDE INT1 A DMZ
iptables -A FORWARD -s 10.5.2.20 -o $DMZ -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -s 10.5.2.20 -o $DMZ -p tcp --dport 2222 -j ACCEPT

# DNAT: todo tráfico TCP desde red externa en puerto 22 hacia dmz1 en puerto 2222
iptables -t nat -A PREROUTING -s 10.5.0.0/24 -p tcp -d 10.5.1.20 --dport 22 -j DNAT --to-destination 10.5.1.20:2222

iptables -t mangle -A PREROUTING -s 10.5.0.0/24 -p tcp -d 10.5.1.20 --dport 22 -j MARK --set-mark 1

#iptables -A FORWARD -s 10.5.0.0/24 -p tcp -d 10.5.1.20 --dport 22 -j ACCEPT

#Permitir el acceso al honeypot desde la extranet
iptables -A FORWARD -p tcp -s 10.5.0.0/24 -d 10.5.1.20 --dport 2222 -m mark --mark 1 -j ACCEPT

# Para ocultar la estructura interna de la red interna, SNAT
iptables -t nat -A POSTROUTING -s 10.5.2.0/24 -d 10.5.0.0/24 -j SNAT --to-source 10.5.0.1