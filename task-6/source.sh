#!/bin/bash

echo Date: "$(date)"
echo User: "$USER"
echo Hostname: "$(hostname)"
echo Private IP: "$(hostname -I | awk '{print $1}')"
echo Public IP: "$(curl -s ifconfig.me)"
source /etc/os-release
echo OS Name: "$NAME"
echo OS Version: "$VERSION"
echo Uptime: "$(uptime -p)"
echo Used Space: "$(df -h --total | tail -n 1 | awk '{print $3}')"
echo Free Space: "$(df -h --total | tail -n 1 | awk '{print $4}')"
echo Total Ram: "$(free -h | grep Mem | awk '{print $2}')"
echo Free Ram: "$(free -h | grep Mem | awk '{print $4}')"
echo Cores Count: "$(nproc)"
echo Cores Frequencies: "$(cat /proc/cpuinfo | grep "MHz")"
