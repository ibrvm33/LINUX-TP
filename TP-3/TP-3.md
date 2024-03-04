# I. Service SSH

## 1. Analyse du service

    🌞 S'assurer que le service sshd est démarré

            [ibrahim@localhost ~]$ systemctl status
        ● localhost.localdomain
            State: running
            Units: 279 loaded (incl. loaded aliases)
            Jobs: 0 queued
        Failed: 0 units
            Since: Tue 2024-01-30 14:14:07 CET; 3min 57s ago
        systemd: 252-13.el9_2
        CGroup: /
                ├─init.scope
                │ └─1 /usr/lib/systemd/systemd --switched-root --system --deseri>
                ├─system.slice
                │ ├─NetworkManager.service
                │ │ └─688 /usr/sbin/NetworkManager --no-daemon
                │ ├─auditd.service
                │ │ └─626 /sbin/auditd
                │ ├─chronyd.service
                │ │ └─678 /usr/sbin/chronyd -F 2
        lines 1-17
#

    🌞 Analyser les processus liés au service SSH

        [ibrahim@localhost ~]$ ps -ef | grep sshd
        root         696       1  0 14:14 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
        root        1337     696  0 14:15 ?        00:00:00 sshd: ibrahim [priv]
        ibrahim     1341    1337  0 14:15 ?        00:00:00 sshd: ibrahim@pts/0
        ibrahim     1370    1342  0 14:20 pts/0    00:00:00 grep --color=auto sshd
    
#

    🌞 Déterminer le port sur lequel écoute le service SSH

        [ibrahim@localhost ~]$ sudo ss -alnpt | grep ssh
        [sudo] password for ibrahim:
        LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=696,fd=3))
        LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=696,fd=4))

#

    🌞 Consulter les logs du service SSH

        [ibrahim@localhost ~]$ journalctl

        journalctl -xe | grep ssh
            Jan 30 14:14:08 localhost systemd[1]: Created slice Slice /system/sshd-keygen.
             Subject: A start job for unit sshd-keygen@ecdsa.service has finished successfully
            A start job for unit sshd-keygen@ecdsa.service has finished successfully.
             Subject: A start job for unit sshd-keygen@ed25519.service has finished successfully
             A start job for unit sshd-keygen@ed25519.service has finished successfully.
             Subject: A start job for unit sshd-keygen@rsa.service has finished successfully
            A start job for unit sshd-keygen@rsa.service has finished successfully.
            Jan 30 14:14:09 localhost systemd[1]: Reached target sshd-keygen.target.
             Subject: A start job for unit sshd-keygen.target has finished successfully
             A start job for unit sshd-keygen.target has finished successfully.
             Subject: A start job for unit sshd.service has begun execution
             A start job for unit sshd.service has begun execution.
            Jan 30 14:14:10 localhost sshd[696]: main: sshd: ssh-rsa algorithm is disabled
            Jan 30 14:14:10 localhost sshd[696]: Server listening on 0.0.0.0 port 22.
            Jan 30 14:14:10 localhost sshd[696]: Server listening on :: port 22.
             Subject: A start job for unit sshd.service has finished successfully
             A start job for unit sshd.service has finished successfully.
            Jan 30 14:15:17 localhost.localdomain sshd[1337]: main: sshd: ssh-rsa algorithm is disabled
            Jan 30 14:15:19 localhost.localdomain sshd[1337]: Accepted password for ibrahim from 10.3.1.1 port 64901 ssh2
            Jan 30 14:15:19 localhost.localdomain sshd[1337]: pam_unix(sshd:session): session opened for user ibrahim(uid=1000) by (uid=0)

# II. Service HTTP

    🌞 Installer le serveur NGINX

        [ibrahim@localhost ~]$ sudo dnf install nginx

#

    🌞 Démarrer le service NGINX

        [ibrahim@localhost ~]$ sudo systemctl restart nginx.service
        [sudo] password for ibrahim:
    
#

    🌞 Déterminer sur quel port tourne NGINX
        [ibrahim@localhost ~]$ sudo ss -tlupn | grep nginx
        tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1357,fd=6),("nginx",pid=1356,fd=6))
        tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1357,fd=7),("nginx",pid=1356,fd=7))
        
### - Ouvrez le port concerné dans le firewall

        [ibrahim@localhost ~]$ sudo firewall-cmd --list-all
            public (active)
            target: default
            icmp-block-inversion: no
            interfaces: enp0s3 enp0s8
            sources:
            services: cockpit dhcpv6-client ssh
            ports:
            protocols:
            forward: yes
            masquerade: no
            forward-ports:
            source-ports:
            icmp-blocks:
            rich rules:
    
#

    🌞 Déterminer les processus liés au service NGINX
        ps -ef | grep nginx
        root        1356       1  0 22:56 ?        00:00:00 nginx: master process /usr/sbin/nginx
        nginx       1357    1356  0 22:56 ?        00:00:00 nginx: worker process
        ibrahim     1395    1325  0 23:03 pts/0    00:00:00 grep --color=auto nginx

#

    🌞 Déterminer le nom de l'utilisateur qui lance NGINX

        [ibrahim@localhost ~]$ cat /etc/passwd | grep root
            root:x:0:0:root:/root:/bin/bash
            operator:x:11:0:operator:/root:/sbin/nologin

#

    🌞 Test !

        [ibrahim@localhost ~]$ curl http://10.2.1.11:80 -s | head -n 7
        <!doctype html>
        <html>
        <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <title>HTTP Server Test Page powered by: Rocky Linux</title>
        <style type="text/css">

## 2. Analyser la conf de NGINX

    🌞 Déterminer le path du fichier de configuration de NGINX

        [ibrahim@localhost ~]$  ls -al /etc/nginx
        total 84
        drwxr-xr-x.  4 root root 4096 Jan 23 15:02 .
        drwxr-xr-x. 78 root root 8192 Feb  4 12:28 ..
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

#

    🌞 Trouver dans le fichier de conf

        [ibrahim@localhost ~]$ cat nginx.conf | grep "server {" -A 16
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

# 3. Déployer un nouveau site web

    🌞 Créer un site web

        [ibrahim@localhost ~]$ sudo mkdir tp3
        [ibrahim@localhost ~]$ cd tp3/
        [ibrahim@localhost tp3]$ sudo nano index.html
        [ibrahim@localhost tp3]$ cat index.html
        <h1>Voici le site web<h1>

#

    🌞 Gérer les permissions

        [ibrahim@localhost tp3]$ ls -l
        total 4
        -rw-r--r--. 1 root root 26 Feb  4 12:43 index.html
        [ibrahim@localhost tp3]$ sudo chmod 744 index.html
        [ibrahim@localhost tp3]$ ls -l
        total 4
        -rwxr--r--. 1 root root 26 Feb  4 12:43 index.html

#

    🌞 Adapter la conf NGINX

    [ibrahim@localhost tp3]$ sudo systemctl restart nginx.service

#

    🌞 Visitez votre super site web

        
