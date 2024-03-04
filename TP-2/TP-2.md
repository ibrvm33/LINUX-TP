# TP 1

# Partie 1 : Files and users

 ## I. Fichiers

* Find me 
#

    🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

        [ibrahim@localhost ~]$ pwd
        /home/ibrahim


## 

    🌞 Trouver le chemin du fichier de logs SSH

        [ibrahim@localhost ~]$ cd /var/log

##

    🌞 Trouver le chemin du fichier de configuration du serveur SSH

        [ibrahim@localhost ~]$ cd /etc/ssh/

##

## Users

### 1. Nouveau user

    🌞 Créer un nouvel utilisateur

    [ibrahim@localhost ~]$ sudo useradd -m -d /home/papier_alu marmotte

    [ibrahim@localhost ~]$ sudo passwd marmotte
    Changing password for user marmotte.
    New password: chocolat
    BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
    Retype new password: chocolat
    passwd: all authentication tokens updated successfully.


### 2. Infos enregistrées par le système

    🌞 Prouver que cet utilisateur a été créé

    [ibrahim@localhost ~]$ cat /etc/passwd
    *
    *
    *
    marmotte:x:1001:1001::/home/papier_alu:/bin/bash

#

    🌞 Déterminer le hash du password de l'utilisateur marmotte

    [ibrahim@localhost ~]$ cat /etc/passwd
    *
    *
    *
    marmotte:x:1001:1001::/home/papier_alu:/bin/bash

### 3. Connexion sur le nouvel utilisateur
    
    🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

    [ibrahim@localhost ~]$ su marmotte
    Password: chocolat
    [marmotte@localhost ibrahim]$

#

    🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

    [marmotte@localhost ibrahim]$ ls
    ls: cannot open directory '.': Permission denied

# Partie 2 : Programmes et paquets

## I. Programmes et processus

### 1. Run then kill

    🌞 Lancer un processus sleep

        [ibrahim@localhost ~]$ sleep 1000

        [ibrahim@localhost ~]$ ps -ef
        *
        *
        *
        *
        ibrahim     1436    1277  0 14:17 tty1     00:00:00 sleep 1000
        ibrahim     1438    1409  0 14:18 pts/2    00:00:00 sleep 1000

#

    🌞 Terminez le processus sleep depuis le deuxième terminal

        [ibrahim@localhost ~]$ kill 1436
        [ibrahim@localhost ~]$ kill 1438

## 2. Tâche de fond

    🌞 Lancer un nouveau processus sleep, mais en tâche de fond

        [ibrahim@localhost ~]$ sleep 1000&
        [1] 1448

#

    🌞 Visualisez la commande en tâche de fond
        [ibrahim@localhost ~]$ jobs
        [1]+  Running                 sleep 1000 &

## 3. Find paths

    🌞 Trouver le chemin où est stocké le programme sleep

        [ibrahim@localhost ~]$ ls -al /usr/bin/sleep | grep sleep
        -rwxr-xr-x. 1 root root 36312 Apr 24  2023 /usr/bin/sleep

#

    🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les    fichiers qui s'appellent .bashrc

        [ibrahim@localhost ~]$ sudo find / -name ".bashrc"
            /etc/skel/.bashrc
            /root/.bashrc
            /home/ibrahim/.bashrc
            /home/papier_alu/.bashrc

## 4. La variable PATH

        🌞 Vérifier que les commandes sleep, ssh, et ping sont bien des programmes stockés dans l'un des dossiers listés dans votre PATH

         [ibrahim@localhost ~]$ echo $PATH
            /home/ibrahim/.local/bin:/home/ibrahim/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

         [ibrahim@localhost ~]$ which sleep
            /usr/bin/sleep
        
        [ibrahim@localhost ~]$ which ssh
            /usr/bin/ssh

        [ibrahim@localhost ~]$ which ping
            /usr/bin/ping

## II. Paquets

    🌞 Installer le paquet firefox

        [ibrahim@localhost ~]$ sudo dnf install git
#

    🌞 Utiliser une commande pour lancer Firefox
        [ibrahim@localhost ~]$ firefox

#

    [ibrahim@localhost ~]$
    └─$ sudo apt install nginx  
    Reading package lists... Done
    Building dependency tree... Done
    Reading state information... Done
    The following additional packages will be installed:
    nginx-common
    Suggested packages:
    fcgiwrap nginx-doc
    The following packages will be upgraded:
    nginx nginx-common
    2 upgraded, 0 newly installed, 0 to remove and 844 not upgraded.
    Need to get 643 kB of archives.
    After this operation, 3072 B of additional disk space will be used.
    Do you want to continue? [Y/n] y
    Get:1 http://mirror.init7.net/kali kali-rolling/main amd64 nginx amd64 1.24.0-2 [532 kB]
    Get:2 http://kali.download/kali kali-rolling/main amd64 nginx-common all 1.24.0-2 [111 kB]
    Fetched 643 kB in 22s (29.5 kB/s)                
    Preconfiguring packages ...
    (Reading database ... 398459 files and directories currently installed.)
    Preparing to unpack .../nginx_1.24.0-2_amd64.deb ...
    Unpacking nginx (1.24.0-2) over (1.24.0-1) ...
    Preparing to unpack .../nginx-common_1.24.0-2_all.deb ...
    Unpacking nginx-common (1.24.0-2) over (1.24.0-1) ...
    Setting up nginx (1.24.0-2) ...
    Setting up nginx-common (1.24.0-2) ...
    Installing new version of config file /etc/nginx/mime.types ...
    nginx.service is a disabled or a static unit not running, not starting it.
    Processing triggers for man-db (2.11.2-3) ...
    Processing triggers for kali-menu (2023.4.3) ...
#

    🌞 Déterminer
  [ibrahim@localhost ~]$[/var/log/nginx]
    └─$ sudo find /var/log -name nginx
    /var/log/nginx


  [ibrahim@localhost ~]$[/var/log/nginx]
    └─$ sudo find /etc -name nginx    
    /etc/default/nginx
    /etc/init.d/nginx
    /etc/ufw/applications.d/nginx
    /etc/logrotate.d/nginx
    /etc/nginx
#
    🌞 Mais aussi déterminer...
  [ibrahim@localhost ~]$[/var/log/nginx]
    └─$ cat /etc/apt/sources.list
    # See https://www.kali.org/docs/general-use/kali-linux-sources-list-repositories/
    deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware

    # Additional line for source packages
    # deb-src http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
#

    🌞 Récupérer le fichier meow
  [ibrahim@localhost ~]$[~/Downloads]
    └─$ wget "https://gitlab.com/it4lik/b1-linux-2023/-/blob/master/tp/2/meow"       
    --2024-01-29 03:15:02--  https://gitlab.com/it4lik/b1-linux-2023/-/blob/master/tp/2/meow
    Resolving gitlab.com (gitlab.com)... 172.65.251.78, 2606:4700:90:0:f22e:fbec:5bed:a9b9
    Connecting to gitlab.com (gitlab.com)|172.65.251.78|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 38536 (38K) [text/html]
    Saving to: ‘meow’

    meow                                                       100%[=======================================================================================================================================>]  37.63K  --.-KB/s    in 0.001s  

    2024-01-29 03:15:09 (37.5 MB/s) - ‘meow’ saved [38536/38536]
#

    🌞 Trouver le dossier dawa/
    utilisez la commande file /path/vers/le/fichier pour déterminer le type du fichier:
  [ibrahim@localhost ~]$[~/Downloads]
    └─$ file meow                                                             
    meow: HTML document, Unicode text, UTF-8 text, with very long lines (15796)                                                    
    renommez-le fichier correctement (si c'est une archive compressée ZIP, il faut ajouter .zip à son nom) :
  [ibrahim@localhost ~]$[~/Downloads]
    └─$ mv meow meow.zip 


