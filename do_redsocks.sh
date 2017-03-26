iptables-restore < /etc/iptables.ipv4.nat
service hostapd start
service isc-dhcp-server start
hostapd /etc/hostapd/hostapd.conf &
/johnyang/ChinaDNS/src/chinadns &
sudo sslocal -c /johnyang/ss_config.json -d start

SS_SERVER_IP=47.90.91.238
SS_SERVER_IP1=47.90.83.119
iptables -t nat -N REDSOCKS  # Create a new chain called REDSOCKS
 
# Do not redirect to shadowsocks server
iptables -t nat -A REDSOCKS -d $SS_SERVER_IP -j RETURN
iptables -t nat -A REDSOCKS -d $SS_SERVER_IP1 -j RETURN
 
# Do not redirect local traffic
iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
 
# Redirect all TCP traffic to redsocks, which listens on port 12345
iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
# This for work vpn
iptables -t nat -A REDSOCKS -p udp --dport 443 -j REDIRECT --to-ports 12345

# These traffic go to REDSOCKS chain first
iptables -t nat -A PREROUTING -p tcp -j REDSOCKS
