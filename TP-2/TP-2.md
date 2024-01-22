# TP 1

## Partie 1 : Files and users

 ### I. Fichiers

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