#!/bin/bash

# 设置网卡名称（例如eth0或ens33，请根据实际情况修改）
INTERFACE="enp97s0f1"

# 设置静态IP地址、子网掩码和网关
IP_ADDRESS="192.168.10.9"
PREFIX="24"
GATEWAY="192.168.10.1"

# 设置DNS服务器为Google DNS
DNS1="8.8.8.8"
DNS2="8.8.4.4"

# 配置静态IP地址
echo "Configuring static IP address..."
nmcli con mod $INTERFACE ipv4.addresses $IP_ADDRESS/$PREFIX
nmcli con mod $INTERFACE ipv4.gateway $GATEWAY
nmcli con mod $INTERFACE ipv4.dns "$DNS1 $DNS2"
nmcli con mod $INTERFACE ipv4.method manual

# 应用更改并重启网络接口
echo "Applying changes and restarting network interface..."
nmcli con up $INTERFACE

echo "Network configuration updated successfully."