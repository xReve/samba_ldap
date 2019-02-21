# SAMBA SERVER

## ERIC ESCRIBA CURS 2018/2019 M06

## EXECUCIÓ

```
docker run --rm --name samba -h samba --network sambanet -it eescriba/samba:smbldap

```


## EXPLICACIÓ

El repositori conté els següents arxius:

**authconfig.conf** script que utilitza la comanda authconfig per establir la connexió amb LDAP. S'executa automàticament en engegar l'container.
   
**Dockerfile** arxiu de creació de la imatge Docker. Aquest fitxer fa que s'instal·lin en el container els paquets necessaris (samba samba-client OpenLDAP-clients nss-pam-ldapd authconfig smbldap-tools). També còpia tots els fitxers de configuració al contenidor i estableix l'script startup.sh com comandament predeterminat a executar en arrencar el container.
   
**install.sh** script que s'executa en arrencar la imatge, configura el container i arrenca serveis necessaris (nslcd per a LDAP, sshd per SSH)
   
**nsswitch.con** arxiu de configuració de nsswitch, sobreescriu l'predefinit en executar install.sh. Necessari per a la comunicació amb LDAP.
   
**populate.ldif** arxiu amb els objectes LDAP necessaris per a poder emmagatzemar la informació de SAMBA a la base de dades LDAP.
   
**smb.conf** arxiu amb la configuració dels shares de SAMBA. En aquest arxiu s'ha d'especificar que es va a utilitzar LDAP com backend incloent el text següent dins de l'apartat [global]

**smbldap-bind.conf** arxiu de configuració de l'usuari administrador d'LDAP per SAMBA, emmagatzema el dn i contrasenya dels usuaris administradors dels servidors LDAP mestre i esclau. Si només hi ha un servidor LDAP (el nostre cas), s'usa el mateix usuari / password per mestre i esclau. Aquest fitxer sobreescriu l'original en / etc / smbldap-tools / en arrencar el container.

**smbldap.conf** arxiu de configuració de SAMBA que defineix la connexió amb el backend LDAP. En ell hem d'especificar el servidor LDAP a utilitzar (en el nostre cas masterLDAP = "ldap: // ldap"), assegurar-nos que no s'utilitza TLS (ldapTLS = "0") el sufix de la base de dades LDAP (suffix = " dc = edt, dc = org) i de diversos grups d'elements importants que també han estat definits en smb.conf (usuaris en 'ou = usuaris, $ {suffix}', hosts en 'ou = hosts, $ {suffix}' ), groups en ou = grups, $ {suffix}, entrades de IDMap a ou = domains, $ {suffix}. la resta es deixa amb la configuració per defecte. Aquest fitxer substitueix el predeterminat en / etc / smbldap-tools / a arrencar el container.

**startup.sh** crida a l'script install.sh i especifica el programa pare en arrencar el container.


