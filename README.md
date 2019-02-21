# SAMBA with LDAP as backend

## ERIC ESCRIBA CURS 2018/2019 M06


## EXPLICACIÓ

En aquest repositori es troben els arxius necessaris per muntar un sistema de servidors LDAP i SAMBA (amb LDAP fent de backend de SAMBA). Per tant el sistema a muntar consta de dos contenidors docker: Ldap i Samba

### Arquitectura

Perquè SAMBA utilitzi LDAP com backend i els directoris HOME es montin automàticament  mitjançant SAMBA al loguejar necessitem el següent:

- **Xarxa Local** anomenada **sambanet** (en aquesta practica) en la que els dockers es podran communicar entre si

- Servidor **LDAP** docker on s'emmagatzemaran els usuaris i grups

- Servidor **SAMBA** docker on s'emmagatzemaran els homes dels usuaris LDAP i locals


## IMATGES

**eescriba/ldapserver:smbldap** Imatge del servidor LDAP 

**eescriba/sambahost:smbldap** Imatge que fara de client

**eescriba/samba:smbldap** Imatge del servidor Samba amb backend LDAP que exporta els homes


## EXECUCIÓ

```
**LDAP**
docker run --rm --name ldap -h ldap --network sambanet -d eescriba/ldapserver:smbldap

**HOST**
docker run --rm --privileged --name host -h host --network sambanet -it eescriba/sambahost:smbldap

**SAMBA**
docker run --rm --name samba -h samba --network sambanet -it eescriba/samba:smbldap

```

## COMPROVACIÓ

EXEMPLES:

- POPULATE

```

Populating LDAP directory for domain MYGROUP (S-1-5-21-50104076-3018563654-3657664915)
entry dc=edt,dc=org already exist. 
entry ou=usuaris,dc=edt,dc=org already exist. 
entry ou=grups,dc=edt,dc=org already exist. 
entry ou=hosts,dc=edt,dc=org already exist. 
entry ou=domains,dc=edt,dc=org already exist. 
entry sambaDomainName=SAMBA,dc=edt,dc=org already exist. 
adding new entry: sambaDomainName=sambaDomain,dc=edt,dc=org
adding new entry: uid=root,ou=usuaris,dc=edt,dc=org
adding new entry: uid=nobody,ou=usuaris,dc=edt,dc=org
adding new entry: cn=Domain Admins,ou=grups,dc=edt,dc=org
adding new entry: cn=Domain Users,ou=grups,dc=edt,dc=org
adding new entry: cn=Domain Guests,ou=grups,dc=edt,dc=org
adding new entry: cn=Domain Computers,ou=grups,dc=edt,dc=org
adding new entry: cn=Administrators,ou=grups,dc=edt,dc=org
adding new entry: cn=Account Operators,ou=grups,dc=edt,dc=org
adding new entry: cn=Print Operators,ou=grups,dc=edt,dc=org
adding new entry: cn=Backup Operators,ou=grups,dc=edt,dc=org
adding new entry: cn=Replicators,ou=grups,dc=edt,dc=org


```


- USUARI LDAP

```
[root@host docker]# su - pere
Creating directory '/tmp/home/pere'.
reenter password for pam_mount:

[pere@host ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
overlay         370G   52G  300G  15% /
tmpfs            64M     0   64M   0% /dev
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sda5       370G   52G  300G  15% /etc/hosts
shm              64M     0   64M   0% /dev/shm
//samba/pere    370G   71G  300G  20% /tmp/home/pere/pere

[pere@host ~]$ mount -t cifs
//samba/pere on /tmp/home/pere/pere type cifs (rw,relatime,vers=default,cache=strict,username=pere,uid=5001,forceuid,gid=100,forcegid,addr=172.20.0.4,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1)

```


- MONTAR HOME D'UN USUARI A /mnt

**NOTA**

Montem el recurs a traves del servidor anomenat **samba** pero això no es pot fer si no tens un DNS que apunti a la direcció en que esta el servidor samba. 
És a dir afegim la següent linia al fitxer `/etc/hosts`:

```
#IP_SAMBA_SERVER    samba

```


```
root@xarlio:~/samba_ldap/samba_host# mount -t cifs -o "user=marta" //samba/marta /mnt
Password for marta@//samba/marta:  ********
root@xarlio:~/samba_ldap/samba_host# mount -t cifs
//samba/marta on /mnt type cifs (rw,relatime,vers=default,cache=strict,username=marta,uid=0,noforceuid,gid=0,noforcegid,addr=172.20.0.4,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1,user=marta)



```

