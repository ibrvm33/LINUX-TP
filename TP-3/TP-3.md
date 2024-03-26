# TP3 : Services

## I. Service SSH

## 1. Analyse du service

### 🌞 S'assurer que le service sshd est démarré

```
[ibrahim@node1 ~]$ systemctl status
● node1.tp2.b1
    State: running
    Units: 283 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Mon 2024-01-29 10:58:57 CET; 6min ago
  systemd: 252-13.el9_2
   CGroup: /
           ├─init.scope
           │ └─1 /usr/li ...
```

### 🌞 Analyser les processus liés au service SSH

```
[ibrahim@node1 ~]$ ps -ef | grep sshd
root         699       1  0 10:58 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1334     699  0 10:59 ?        00:00:00 sshd: ibrahim [priv]
ibrahim        1337    1334  0 10:59 ?        00:00:00 sshd: ibrahim@pts/0
ibrahim        1408    1338  0 11:10 pts/0    00:00:00 grep --color=auto sshd
```

### 🌞 Déterminer le port sur lequel écoute le service SSH

```
[ibrahim@node1 ~]$ sudo ss -alnpt | grep ssh
[sudo] password for ibrahim:
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=699,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=699,fd=4))
```

### 🌞 Consulter les logs du service SSH

```
[ibrahim@node1 log]$ sudo tail secure
Jan 29 11:03:56 node1 sudo[1389]: pam_unix(sudo:session): session closed for user root
Jan 29 11:14:12 node1 sudo[1425]:    ibrahim : TTY=pts/0 ; PWD=/home/ibrahim ; USER=root ; COMMAND=/sbin/ss -alnpt
Jan 29 11:14:12 node1 sudo[1425]: pam_unix(sudo:session): session opened for user root(uid=0) by ibrahim(uid=1000)
Jan 29 11:14:12 node1 sudo[1425]: pam_unix(sudo:session): session closed for user root
Jan 29 11:27:54 node1 sudo[1444]:    ibrahim : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/tail secure
Jan 29 11:27:54 node1 sudo[1444]: pam_unix(sudo:session): session opened for user root(uid=0) by ibrahim(uid=1000)
Jan 29 11:27:54 node1 sudo[1444]: pam_unix(sudo:session): session closed for user root
Jan 29 11:28:11 node1 sudo[1449]:    ibrahim : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/tail secure -n 37
Jan 29 11:28:11 node1 sudo[1449]: pam_unix(sudo:session): session opened for user root(uid=0) by ibrahim(uid=1000)
Jan 29 11:28:11 node1 sudo[1449]: pam_unix(sudo:session): session closed for user root
```

## 2. Modification du service

### 🌞 Identifier le fichier de configuration du serveur SSH

```
[ibrahim@node1 ssh]$ sudo find  -name "sshd_config"
./sshd_config
```

### 🌞 Modifier le fichier de conf

- exécutez un echo $RANDOM pour demander à votre shell de vous fournir un nombre aléatoire
```
[ibrahim@node1 ssh]$ echo $RANDOM
2176
```

- changez le port d'écoute du serveur SSH 

```
[ibrahim@node1 ssh]$ sudo cat sshd_config | grep "Port"
#Port 2176
```
- gérer le firewall

```
[ibrahim@node1 ssh]$ sudo firewall-cmd --remove-service ssh
[ibrahim@node1 ssh]$ sudo firewall-cmd --add-port=2176/tcp --permanent
success
[ibrahim@node1 ssh]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client
  ports: 80/tcp 2176/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

### 🌞 Redémarrer le service

```
[ibrahim@node1 ~]$ sudo systemctl restart sshd
[sudo] password for ibrahim:
[ibrahim@node1 ~]$
```

### 🌞 Effectuer une connexion SSH sur le nouveau port

```
PS C:\Users\ghass> ssh -p 2176 ibrahim@10.2.1.11
Last login: Mon Jan 29 11:56:52 2024 from 10.2.1.1
[ibrahim@node1 ~]$
```

## II. Service HTTP

## 1. Mise en place

### 🌞 Installer le serveur NGINX

```
[ibrahim@node1 ~]$ sudo dnf install nginx
```

### 🌞 Démarrer le service NGINX
```
[ibrahim@node1 nginx]$ systemctl restart nginx.service
```

### 🌞 Déterminer sur quel port tourne NGINX

- vous devez filtrer la sortie de la commande utilisée pour n'afficher que les lignes demandées
```
[ibrahim@node1 ~]$ sudo ss -tlupn | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=11576,fd=6),("nginx",pid=11575,fd=6))
tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=11576,fd=7),("nginx",pid=11575,fd=7))
```
- ouvrez le port concerné dans le firewall
```
[ibrahim@node1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client
  ports: 80/tcp 2176/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

### 🌞 Déterminer les processus liés au service NGINX

```
[ibrahim@node1 ~]$ ps -ef | grep nginx
root       11575       1  0 12:11 ?        00:00:00 nginx: master process nginx
nginx      11576   11575  0 12:11 ?        00:00:00 nginx: worker process
ibrahim       11633    1676  0 12:29 pts/0    00:00:00 grep --color=auto nginx
```

### 🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```
[ibrahim@node1 ~]$ cat /etc/passwd | grep root
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
```

### 🌞 Test !

```
[ibrahim@node1 ~]$ curl http://10.2.1.11:80 -s | head -n 7
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

## 2. Analyser la conf de NGINX

### 🌞 Déterminer le path du fichier de configuration de NGINX

```
[ibrahim@node1 nginx]$ ls -al /etc/nginx
total 84
drwxr-xr-x.  4 root root 4096 Jan 29 12:09 .
drwxr-xr-x. 78 root root 8192 Jan 30 10:29 ..
drwxr-xr-x.  2 root root    6 Oct 16 20:00 conf.d
drwxr-xr-x.  2 root root    6 Oct 16 20:00 default.d
-rw-r--r--.  1 root root 1077 Oct 16 20:00 fastcgi.conf
-rw-r--r--.  1 root root 1077 Oct 16 20:00 fastcgi.conf.default
-rw-r--r--.  1 root root 1007 Oct 16 20:00 fastcgi_params
-rw-r--r--.  1 root root 1007 Oct 16 20:00 fastcgi_params.default
-rw-r--r--.  1 root root 2837 Oct 16 20:00 koi-utf
-rw-r--r--.  1 root root 2223 Oct 16 20:00 koi-win
-rw-r--r--.  1 root root 5231 Oct 16 20:00 mime.types
-rw-r--r--.  1 root root 5231 Oct 16 20:00 mime.types.default
-rw-r--r--.  1 root root 2334 Oct 16 20:00 nginx.conf
-rw-r--r--.  1 root root 2656 Oct 16 20:00 nginx.conf.default
-rw-r--r--.  1 root root  636 Oct 16 20:00 scgi_params
-rw-r--r--.  1 root root  636 Oct 16 20:00 scgi_params.default
-rw-r--r--.  1 root root  664 Oct 16 20:00 uwsgi_params
-rw-r--r--.  1 root root  664 Oct 16 20:00 uwsgi_params.default
-rw-r--r--.  1 root root 3610 Oct 16 20:00 win-utf
```

### 🌞 Trouver dans le fichier de conf

```
[ibrahim@node1 nginx]$ cat nginx.conf | grep "server {" -A 16
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

## 3. Déployer un nouveau site web

### 🌞 Créer un site web

```
[ibrahim@node1 www]$ sudo mkdir tp3_linux
[ibrahim@node1 www]$ ls
tp3_linux
[ibrahim@node1 www]$ cd tp3_linux/
[ibrahim@node1 tp3_linux]$ ls
[ibrahim@node1 tp3_linux]$ nano index.html


[ibrahim@node1 tp3_linux]$ cat index.html
<h1>Je m'appel pas</h1>
```

### 🌞 Gérer les permissions

```
[ibrahim@node1 tp3_linux]$ ls -l
total 4
-rw-r--r--. 1 root root 24 Jan 30 10:44 index.html
[ibrahim@node1 tp3_linux]$ man chmod
[ibrahim@node1 tp3_linux]$ sudo chmod 744 index.html
```

### 🌞 Adapter la conf NGINX

```
[ibrahim@node1 nginx]$ systemctl restart nginx.service
```

### 🌞 Visitez votre super site web

```
[ibrahim@node1 nginx]$ curl http://10.2.1.11:80
<h1>Je m'appel pas</h1>
```

## III. Your own services

## 1. Au cas où vous l'auriez oublié

## 2. Analyse des services existants

### 🌞 Afficher le fichier de service SSH

```
[ibrahim@node1 nginx]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

### 🌞 Afficher le fichier de service NGINX

```
[ibrahim@node1 nginx]$ cat /usr/lib/systemd/system/nginx.service | grep ExecStart=
ExecStart=/usr/sbin/nginx
```

## 3. Création de service

### 🌞 Créez le fichier /etc/systemd/system/tp3_nc.service

```
[ibrahim@node1 nginx]$ echo $RANDOM
4617

[ibrahim@node1 nginx]$ sudo nano /etc/systemd/system/tp3_nc.service
```

### 🌞 Indiquer au système qu'on a modifié les fichiers de service

```
[ibrahim@node1 nginx]$ sudo systemctl daemon-reload
```

### 🌞 Démarrer notre service de ouf

```
[ibrahim@node1 nginx]$ sudo systemctl start tp3_nc.service
```

### 🌞 Vérifier que ça fonctionne

```
[ibrahim@node1 nginx]$ systemctl status tp3_nc.service

[ibrahim@node1 nginx]$  sudo ss -alnpt | grep nc
LISTEN 0      10           0.0.0.0:4617      0.0.0.0:*    users:(("nc",pid=1918,fd=4))
LISTEN 0      10              [::]:4617         [::]:*    users:(("nc",pid=1918,fd=3))

[ibrahim@node1 nginx]$ sudo systemctl status tp3_nc
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 11:32:58 CET>
   Main PID: 1918 (nc)
      Tasks: 1 (limit: 4673)
     Memory: 788.0K
        CPU: 4ms
     CGroup: /system.slice/tp3_nc.service
             └─1918 /usr/bin/nc -l 4617 -k

Jan 30 11:32:58 node1.tp2.b1 systemd[1]: Started Super netcat t>
Jan 30 11:45:41 node1.tp2.b1 nc[1918]: llele
Jan 30 11:45:41 node1.tp2.b1 nc[1918]: le
Jan 30 11:45:41 node1.tp2.b1 nc[1918]: le
Jan 30 11:45:42 node1.tp2.b1 nc[1918]: el
Jan 30 11:45:42 node1.tp2.b1 nc[1918]: el
Jan 30 11:45:42 node1.tp2.b1 nc[1918]: el
Jan 30 11:45:42 node1.tp2.b1 nc[1918]: ele
```

### 🌞 Les logs de votre service

- une commande journalctl filtrée avec grep qui affiche la ligne qui indique le démarrage du service
```
[ibrahim@node1 nginx]$ journalctl | grep "systemctl start"
Jan 30 11:32:58 node1.tp2.b1 sudo[1914]:     ibrahim : TTY=pts/0 ; PWD=/etc/nginx ; USER=root ; COMMAND=/bin/systemctl start tp3_nc.service
```

- une commande journalctl filtrée avec grep qui affiche un message reçu qui a été envoyé par le client

```
[ibrahim@node1 nginx]$ journalctl | grep coucou
Jan 30 11:46:45 node1.tp2.b1 nc[1918]: coucou
```

- une commande journalctl filtrée avec grep qui affiche la ligne qui indique l'arrêt du service

```
[ibrahim@node1 nginx]$ journalctl | grep finished | tail -n 1
Jan 30 12:01:01 node1.tp2.b1 run-parts[2045]: (/etc/cron.hourly) finished 0anacron
```

### 🌞 S'amuser à kill le processus

- repérez le PID du processus nc lancé par votre service
```
[ibrahim@node1 nginx]$ ps -ef | grep nc | grep root
root        1918       1  0 11:32 ?        00:00:00 /usr/bin/nc -l 4617 -k
```
- utilisez la commande kill pour mettre fin à ce processus nc
```
[ibrahim@node1 nginx]$ sudo kill 1918
[sudo] password for ibrahim:
[ibrahim@node1 nginx]$
```

### 🌞 Affiner la définition du service

- ajoutez Restart=always dans la section [Service] de votre service
```
[ibrahim@node1 nginx]$ cat /usr/lib/systemd/system/sshd.service | grep Restart
Restart=always
```
- n'oubliez pas d'indiquer au système que vous avez modifié les fichiers de service :)
```
[ibrahim@node1 nginx]$ sudo systemctl restart nginx.service
```

- normalement, quand tu kill il est donc relancé automatiquement

```

```