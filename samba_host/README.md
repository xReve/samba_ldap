# DOCKER CLIENT

Docker en el qual els usuaris locals i LDAP podran fer connexions i els seus homes seran montats del servidor Samba

MOUNT TYPE **CIFS**

```
<volume user="*" fstype="cifs" server="samba" path="%(USER)" mountpoint="~/%(USER)" />

```


## EXECUCIÓ

```
docker run --rm --privileged --name host -h host --network sambanet -it eescriba/sambahost:smbldap

```

## EXEMPLE

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

[pere@host ~]$ ll
total 0
drwxr-xr-x 2 pere users 0 Feb 21 15:42 pere

```




