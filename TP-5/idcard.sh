#!/bin/bash

# Machine name
machine_name=$(hostnamectl --static)

# OS name and kernel version
if [ -f "/etc/redhat-release" ]; then
    os_name=$(cat /etc/redhat-release)
elif [ -f "/etc/os-release" ]; then
    os_name=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
else
    os_name="Unknown"
fi
kernel_version=$(uname -r)

# IP address
ip_address=$(ip -o -4 addr show scope global | awk '{print $4}' | cut -d'/' -f1)

# RAM
ram_info=$(free -h | awk 'NR==2{print $4}' && free -h | awk 'NR==2{print $2}')

# Disk space
disk_space=$(df -h / | awk 'NR==2{print $4}')

# Top 5 processes by RAM usage
top_processes=$(ps -eo comm,%mem --sort=-%mem | awk 'NR<=6{if (NR>1) print $1}')

# Listening ports
listening_ports=$(ss -tuln | awk 'NR>1 {print $1, $5}' | while read type local_address; do
    port=$(echo $local_address | awk -F: '{print $NF}')
    program=$(echo $local_address | awk -F: '{print $NF-1}')
    if [[ $type == "tcp" ]]; then
        protocol="tcp"
    elif [[ $type == "udp" ]]; then
        protocol="udp"
    else
        protocol="Unknown"
    fi
    echo "  - $port $protocol : $(basename $(readlink -f /proc/$program/exe))"
done)

# PATH directories
path_directories=$(echo "$PATH" | tr ":" "\n")

# Affichage des informations
echo "Machine name: $machine_name"
echo "OS: $os_name and kernel version is $kernel_version"
echo "IP: $ip_address"
echo "RAM: $ram_info memory available on $(echo $ram_info | awk '{print $2}') total memory"
echo "Disk: $disk_space space left"
echo "Top 5 processes by RAM usage :"
echo "$top_processes"
echo "Listening ports :"
echo "$listening_ports"
echo "PATH directories :"
echo "$path_directories" | while read directory; do
    echo "  - $directory"
done
