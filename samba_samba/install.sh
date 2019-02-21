#! /bin/bash
# @edt ASIX M06 2018-2019
# instal.lacio
#  - crear usuaris locals
# -------------------------------------
groupadd localgrp01
groupadd localgrp02
useradd -g users -G localgrp01 local01
useradd -g users -G localgrp02 local02
echo "local01" | passwd --stdin local01
echo "local02" | passwd --stdin local02


mkdir /var/lib/samba/homes
chmod 777 /var/lib/samba/homes
cp /opt/docker/* /var/lib/samba/homes/.
cp /opt/docker/smb.conf /etc/samba/smb.conf

./authconfig.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf
cp /opt/docker/ldap.conf /etc/openldap/ldap.conf
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf


# engegar el dimoni perque funcioni el getent
/usr/sbin/nslcd && echo "nslcd Ok"
/usr/sbin/nscd && echo "nscd Ok"


# se han de crear els homes perque aixi es pot montar 

mkdir /tmp/home
mkdir /tmp/home/pere
mkdir /tmp/home/pau
mkdir /tmp/home/anna
mkdir /tmp/home/marta
mkdir /tmp/home/jordi
mkdir /tmp/home/admin

cp README.md /tmp/home/pere
cp README.md /tmp/home/pau
cp README.md /tmp/home/anna
cp README.md /tmp/home/marta
cp README.md /tmp/home/jordi
cp README.md /tmp/home/admin
cp README.md /tmp/home/local01
cp README.md /tmp/home/local02


chown -R pere.users /tmp/home/pere
chown -R pau.users /tmp/home/pau
chown -R anna.alumnes /tmp/home/anna
chown -R marta.alumnes /tmp/home/marta
chown -R jordi.users /tmp/home/jordi
chown -R admin.wheel /tmp/home/admin
chown -R local01.users /tmp/home/local01
chown -R local02.users /tmp/home/local02


# - CONFIGURAMOS LDAP COMO BACKEND
# -----------------------------------------------------------
cp /opt/docker/smbldap.conf /etc/smbldap-tools/smbldap.conf
cp /opt/docker/smbldap_bind.conf /etc/smbldap-tools/smbldap_bind.conf
smbpasswd -w secret
echo -e "secret\nsecret" | smbldap-populate -i /opt/docker/populate.ldif


# users nomes de samba 
useradd patipla
useradd lila
useradd roc
useradd pla

echo -e "patipla\npatipla" | smbpasswd -a patipla
echo -e "lila\nlila" | smbpasswd -a lila
echo -e "roc\nroc" | smbpasswd -a roc
echo -e "pla\npla" | smbpasswd -a pla

getent passwd 


# users ldap 

echo -e "smbpere\nsmbpere" | smbpasswd -a pere
echo -e "smbpau\nsmbpau" | smbpasswd -a pau
echo -e "smbanna\nsmbanna" | smbpasswd -a anna
echo -e "smbmarta\nsmbmarta" | smbpasswd -a marta
echo -e "smbjordi\nsmbjordi" | smbpasswd -a jordi
echo -e "smbadmin\nsmbadmin" | smbpasswd -a admin


# users locals 
echo -e "smblocal01\nsmblocal01" | smbpasswd -a local01
echo -e "smblocal02\nsmblocal02" | smbpasswd -a local02





