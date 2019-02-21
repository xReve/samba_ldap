# SERVIDOR LDAP


## @edt ASIX M06-ASO Curs 2018-2019

Servidor ldap amb edt.org, amb usuaris i grups

## EXECUCIÓ

```

docker run --rm --name ldap -h ldap --network sambanet -d eescriba/ldapserver:smbldap

```


El repositori conté els següents arxius:


- **DB CONFIG** arxiu de configuració per a bases de dades tipus bdb / hdb. Substitueix el predeterminat en iniciar-se el container.

- **Dockerfile** arxiu de creació de la imatge Docker. Aquest fitxer fa que s'instal·lin en el container els paquets necessaris per a LDAP (OpenLDAP-clients i OpenLDAP-servers)

- **edt.ldif** arxiu amb les dades de edt.org a introduir a la base de dades LDAP, en format ldif. Es carrega automàticament en iniciar el container.

- **install.sh** script que s'executa en arrencar la imatge, configura el container (substitueix les configuracions per defecte per les versions modificades, carrega les dades a la base de dades).

- **ldap.conf**  arxiu de configuració de LDAP. En ell hem d'especificar el dn de la base de dades (dc = edt, dc = org) i la URI on trobar-la (ldap: // ldap)

- **samba.schema** arxiu de schema de LDAP amb les definicions necessàries per a emmagatzemar la informació de SAMBA a la base de dades LDAP. En arrencar el container es copia a / etc / OpenLDAP / schema.

- **slapd.conf** arxiu de configuració del daemon slapd. Ens hem d'assegurar que conté un include amb l'arxiu de definicions samba.schema, i que el sufix i el rootdn de la base de dades ldap siguin els nostres (dc = edt, dc = org i 'cn = Manager, dc = edt , dc = org 'respectivament).

- **startup.sh** script que s'executa en encendre el container. Crida a l'script install.sh i arrenca el dimoni slapd.




