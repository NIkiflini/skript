#!/bin/bash

readonly NETWORK_CONFIG_DIR="/etc/network/interfaces"
readonly CURRENT_IP=$(ip a)

echo "Текушие настройки:"
echo "$CURRENT_IP" | awk '/^[0-9]/{interface=$2} /inet / {printf "Interface: %s, IP Address: %s\n", interface, $2}'

read -p "Выбери что менять (e.g. eth0, wlan0, etc.): " INTERFACE
read -p "Новый IP намаляй: " NEW_IP_ADDRESS

read -p "тебе оно надо? - $INTERFACE поменять в нем IP на $NEW_IP_ADDRESS? (y/n): " CHEK

while [[ "$CHEK" != [yY] ]]; do
    read -p "Че ты жмал? " CHEK
done

cp "$NETWORK_CONFIG_DIR" "$NETWORK_CONFIG_DIR".bak

if ! grep -q "^iface $INTERFACE" "$NETWORK_CONFIG_DIR"; then
    echo -e "iface $INTERFACE inet static\n\taddress $NEW_IP_ADDRESS\n\tnetmask 255.255.255.0" >> "$NETWORK_CONFIG_DIR"
else
    sed -i "/iface $INTERFACE inet static/{N;s/address .*/address $NEW_IP_ADDRESS/;N;s/netmask .*/netmask 255.255.255.0/}" "$NETW>
fi

echo "Ну все интернета не будет твой IP-  $NEW_IP_ADDRESS"

systemctl restart networking
