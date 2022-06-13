#!/bin/bash

# Architecture
echo -n "#Achitecture: "
uname -a

# CPU physical
echo -n "#CPU physical: "
cat /proc/cpuinfo | grep "physical id" | uniq | wc -l

# vCPU
echo -n "#vCPU: "
cat /proc/cpuinfo | grep processor | wc -l

# Memory Usage
memuse=$(free -m | grep Mem | awk '{print $3}')
memtot=$(free -m | grep Mem | awk '{print $2}')
memperc=$(free | grep Mem | awk '{printf("%.2f", $3/$2 * 100.0)}')
echo "#Memory Usage: ${memuse}/${memtot} MB (${memperc}%)"

# DISK USAGE
diskt=$(df -Bg | grep /dev/ | grep -v /boot |  awk '{diska+=$2} END {printf("%.f", diska)}')
disku=$(df -Bg | grep /dev/ | grep -v /boot |  awk '{diskb+=$3} END {printf("%.f", diskb)}')
diskperc=$(df -Bg | grep /dev/ | grep -v /boot |  awk '{diskb+=$2} {diska+=$3} END {printf("%.f", diska/diskb * 100.0)}')
echo "#Disk Usage: $disku/${diskt}GB ${diskperc}%"

#CPU USAGE
CPU=$(top -bn1 | grep %Cpu | cut -c 11- | awk '{printf("%.2f%%", $1+$3)}')
echo "#CPU load: ${CPU}"

# SYSTEM BOOT

boot_data=$(who -b | cut -d ' ' -f13)
boot_time=$(who -b | cut -d ' ' -f14)
echo "#Last boot: $boot_data $boot_time"

# LVM
lvmstatus=$(lsblk | grep lvm | wc -l)
echo -n "#LVM status: "
if [ ${lvmstatus} != 0 ]
then
	echo yes
else
	echo no
fi

#TCP CONNECTIONS
tcp_c=$(netstat -ant | grep ESTABLISHED | wc -l)
echo "#Connections TCP: $tcp_c ESTABLISHED"

#USERS LOGGED IN
user_s=$(who | wc -l)
echo "#User log: $user_s"

#IPV4 MAC ADRESS
ipv4=$(ifconfig | grep inet | sed -n '1p' | cut -d ' ' -f10)
maca=$(ip link show | awk '$1 == "link/ether" {print $2}')
echo "#Network: IP $ipv4 (${maca})"

# SUDO COMMANDS
sudocmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
echo "#Sudo: $sudocmd cmd"
