# Partie 1 : Script carte d'identité

    #!/bin/bash
    #Ibrvm33
    #26.03.24


    machineName=$(hostname)

    if [ -f "/etc/redhat-release" ]; then
        os_name=$(cat /etc/redhat-release)
    elif [ -f "/etc/os-release" ]; then
        os_name=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    else
        os_name="Unknown"
    fi
    kernel_version=$(uname -r)

    ip_address=$(ip -o -4 addr show scope global | awk '{print $4}' | cut -d'/' -f1)

    totalRam=$(free -h | grep Mem |tr -s ' ' | cut -d ' ' -f2)
    currentRam=$(free -h | grep Mem |tr -s ' ' | cut -d ' ' -f7)

    disk_space=$(df -h / | awk 'NR==2{print $4}')

    top_processes=$(ps -eo comm,%mem --sort=-%mem | awk 'NR<=6{if (NR>1) print $1}')

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

    path_directories=$(echo "$PATH" | tr ":" "\n")

    # Affichage 
    echo "Machine name : ${machineName}"
    echo "OS: $os_name and kernel version is $kernel_version"
    echo "IP: $ip_address"
    echo "RAM : ${currentRam} memory available on ${totalRam} total memory"
    echo "Disk: $disk_space space left"
    echo "Top 5 processes by RAM usage :"
    echo "$top_processes"
    echo "Listening ports :"
    echo "$listening_ports"
    echo "PATH directories :"
    echo "$path_directories" | while read directory; do
        echo "  - $directory"
    done

### 🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

    [ibrahim@ibrahim idcard]$ ./idcard.sh
    Machine name : localhost.localdomain
    OS: Rocky Linux release 9.2 (Blue Onyx) and kernel version is 5.14.0-284.11.1.el9_2.x86_64
    IP: 10.3.1.3
    10.0.3.15
    RAM : 484Mi memory available on 771Mi total memory
    Disk: 5.1G space left
    Top 5 processes by RAM usage :
    firewalld
    NetworkManager
    systemd
    systemd
    systemd-udevd
    Listening ports :
    - 323 udp :
    - 323 udp :
    - 22 tcp :
    - 22 tcp :
    PATH directories :
    - /home/ibrahim/.local/bin
    - /home/ibrahim/bin
    - /usr/local/bin
    - /usr/bin
    - /usr/local/sbin
    - /usr/sbin
# Partie 2
## 1. Premier script youtube-dl
### 📁 Le script /srv/yt/yt.sh

    #!/bin/bash
    #ibrvm33



    if [[ $# -eq 0 ]]; then
        echo "Aucun lien youtube trouvé !"
        exit 1
    fi


    DOWNLOAD_FOLDER_NAME="downloads"
    LOG_FOLDER_PATH="/var/log/yt"
    LOG_DOWNLOAD_FILE_NAME="download.log"
    LOG_DESCRIPTION_FILE_NAME="description"

    localDirectory=$(dirname $(realpath "$0"))
    downloadDirectory="${localDirectory}/${DOWNLOAD_FOLDER_NAME}"


    videoName=$(youtube-dl --skip-download --get-title --no-warnings $1)
    videoDescription=$(youtube-dl --skip-download --get-description --no-warnings $1)

    futureVideoDirectory="${downloadDirectory}/${videoName}"
    mkdir -p "${futureVideoDirectory}"
    echo $videoDescription > "${futureVideoDirectory}/${LOG_DESCRIPTION_FILE_NAME}"

    youtube-dl -f mp4 -o "${futureVideoDirectory}/%(title)s-%(id)s.%(ext)s" --no-warnings $1 > /dev/null


    echo "La vidéo ${1} a été téléchargée."
    echo "Chemin du fichier : ${futureVideoDirectory}"


    if [ ! -d "${LOG_FOLDER_PATH}" ]; then
        exit
    fi

    currentDate=$(date +"%y/%m/%d %H:%M:%S")
    echo "[${currentDate}] La vidéo ${1} a été téléchargée. Chemin du fichier : ${futureVideoDirectory}" >> "${LOG_FOLDER_PATH}/${LOG_DOWNLOAD_FILE_NAME}"
#
### 📁 Le fichier de log
    [ibrahim@localhost ~]$ cat download.log
    [ 26/03/04 19:38:04 ] Video https://www.youtube.com/watch?v=Irej-yNWUNA was downloaded. File path : /srv/yt/downloads/Boot Camp Day 44: Try not to Trade
#
### 🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie

    [ibrahim@localhost ~]$ ./yt.sh https://www.youtube.com/watch?v=Irej-yNWUNA
    Video https://www.youtube.com/watch?v=Irej-yNWUNA was downloaded.
    File path : /srv/yt/downloads/Boot Camp Day 44: Try not to Trade

        