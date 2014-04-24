Small Business Server (Italiano)/LDAP Server
============================================

Ora si entra nel vivo, si comincia ad installare e configurare i servizi
sulla nostra box ancora "vuota". Iniziamo con LDAP che useremo come
servizio di autenticazione per i nostri utenti e servizi.

Contents
--------

-   1 LDAP Server
    -   1.1 Introduzione
    -   1.2 Installazione
    -   1.3 Configurazione del Server
        -   1.3.1 /etc/openldap/slapd.conf
        -   1.3.2 /etc/nsswitch.conf
        -   1.3.3 /etc/rc.sysinit
        -   1.3.4 PAM
            -   1.3.4.1 /etc/pam.d/login
            -   1.3.4.2 /etc/pam.d/shadow
            -   1.3.4.3 /etc/pam.d/passwd
            -   1.3.4.4 /etc/pam.d/sshd
            -   1.3.4.5 /etc/hosts.allow
        -   1.3.5 Database di OpenLDAP
-   2 LDAP Client
    -   2.1 /etc/openldap/ldap.conf
    -   2.2 /etc/pam_ldap.conf e /etc/nss_ldap.conf
    -   2.3 /etc/ldap.secret
-   3 Avvio del servizio

LDAP Server
===========

Introduzione
------------

Il server LDAP è essenzialmente un database gerarchico che viene
utilizzato per la memorizzazione dei dati degli utenti, e di tutto
quanto si desideri gestire tramite una base dati condivisibile via rete
tra più sistemi. Per maggiori informazioni potete leggere la definizione
che ne da wikipedia. Perchè installiamo questo servizio ? Per la sua
grande versatilità e comodità. La recente normativa sulla privacy impone
(tra le altre cose) di cambiare periodicamente la password degli utenti.
Oltretutto ogni utente deve poter cambiare la propria password in modo
autonomo. Non vorrete mica ogni volta aggiornare manualmente prima la
password nel pc, poi della condivisione poi della mail, poi ...
Installando un server LDAP (nel nostro caso OpenLDAP) abbiamo la
possibilità di centralizzare tutto (o quasi). Cambiando la password nel
pc dell'utente questa verrà salvata nell'albero LDAP e tutti i servizi
saranno sincronizzati. Signori e Signore ecco il Single Signon, il santo
graal di ogni amministratore di rete :).

Installazione
-------------

Preleviamo ed installiamo i pacchetti che ci servono :

    sudo pacman -S openldap openldap-clients nss_ldap pam_ldap

pacman provvederà ad installare eventuali dipendenze.

Configurazione del Server
-------------------------

OpenLDAP è un progetto complesso, qui non fornirò nessuna informazione
"supplementare" a questo servizio, come sempre date una occhiata al sito
di riferimento per maggiori informazioni. Iniziamo con la parte server :

> /etc/openldap/slapd.conf

La parte server di openLDAP và configurata editando una serie di file,
per primo il file /etc/openldap/slapd.conf

    sudo nano /etc/openldap/slapd.conf

che facciamo diventare così :

    include         /etc/openldap/schema/core.schema
    include         /etc/openldap/schema/cosine.schema
    include         /etc/openldap/schema/inetorgperson.schema
    allow bind_v2
    password-hash {md5}
    pidfile   /var/run/slapd.pid
    argsfile  /var/run/slapd.args
    database        bdb
    suffix          "dc=mede,dc=it"
    rootdn          "cn=Manager,dc=mede,dc=it"
    #Per la password usa il comando
    #slappasswd -h {MD5} -s passwordstring
    #e copia il risultato
    rootpw          {MD5}En3fj26GwP2ni1HHJHe1KA==
    directory       /var/lib/openldap/openldap-data
    index   objectClass     eq
    index   uid     eq

Attenzione al parametro rootpw: la stringa che vedete corrisponde all'
hash MD5 della password che ho deciso, nel mio caso archimede, che ho
ottenuto così:

    slappasswd -h {MD5} -s archimede

decidete la vostra password e mettetela come parametro di rootpw.

> /etc/nsswitch.conf

Il file del Network Services Switch /etc/nsswitch.conf determina
l'ordine delle ricerche effettuate quando viene richiesta una certa
informazione, proprio come il file /ets/host.conf che determina il modo
in cui effettuare le ricerche degli host. Per esempio la riga:

    hosts: files dns ldap

specifica che le funzioni di ricerca degli host dovrebbero prima
guardare nel file locale /etc/hosts, di seguito fare una richiesta al
servizio dei nomi di dominio DNS ed infine utilizzare il server ldap. A
quel punto, se nessuna corrispondenza è stata trovata, viene riportato
un errore. Questo file deve essere leggibile da ogni utente! Dobbiamo
istruire nsswitch al fine di fargli usare il nostro server LDAP per la
risoluzione perlomeno delle password. Per ovviare ad un fastidioso baco
di udev (o di nsswitch, non saprei) creiamo due file che poi scambieramo
al boot (vedi più avanti). Prima il file che non utilizza ldap :

    sudo nano /etc/nsswitch.file

che diventa :

    #Begin /etc/nsswitch.conf
    passwd: files
    group: files
    shadow: files
    publickey: files
    netmasks: files
    bootparams: files
    automount: files
    sendmailvars: files
    hosts: files dns
    networks: files
    protocols: db files
    services: db files
    ethers: db files
    rpc: db files
    netgroup: db files
    #End /etc/nsswitch.conf

e poi il file che invece lo utilizza:

    sudo nano /etc/nsswitch.ldap

che diventa :

    #Begin /etc/nsswitch.conf
    passwd: files ldap
    group: files ldap
    shadow: files ldap
    publickey: files
    netmasks: files
    bootparams: files
    automount: files
    sendmailvars: files
    hosts: files dns
    networks: files
    protocols: db files
    services: db files
    ethers: db files
    rpc: db files
    netgroup: db files
    netmasks:   files
    bootparams: files
    publickey:  files
    automount:  files
    aliases:    files
    sendmailvars:   files
    #End /etc/nsswitch.conf

> /etc/rc.sysinit

Per ovviare al fastidioso bug menzionato sopra che fà bloccare il nostro
server al boot durante l'avvio di udev, applichiamo un (non molto bello)
workaround che per lo meno mi permette di non buttare tutto alle
ortiche. Prima editiamo il nostro file menu.lst di grub per montare il
file system in scrittura al boot :

    sudo nano /boot/grub/menu.lst

e cambiamo la riga kernel sostituendo "ro" (read only) con "rw" (read
write).

    #(0) Arch Linux
    title  Arch Linux
    root   (hd0,0)
    kernel /vmlinuz26 root=/dev/sda3 rw
    initrd /kernel26.img

Ora editiamo il file di inizializzazione:

    sudo nano /etc/rc.sysinit

andiamo nella sezione di udev dove vedete scritto:

    status "Starting UDev Daemon" /etc/start_udev init

e facciamola diventare così:

    status "Stopping LDAP authentication" /bin/cp /etc/nsswitch.file /etc/nsswitch.conf
    status "Starting UDev Daemon" /etc/start_udev init
    status "Starting LDAP authentication" /bin/cp /etc/nsswitch.ldap /etc/nsswitch.conf

come possiamo vedere disabiliamo le modifiche a /etc/nsswitch.conf prima
che parta udev e subito dopo le ripristiniamo. Se qualcuno ha notizia su
come si possa far meglio me lo comunichi subito !

> PAM

PAM (Pluggable Authentication Modules) è un meccanismo per integrare più
schemi di autenticazione a basso livello in un'unica API ad alto
livello, permettendo a programmi che necessitino di una forma di
autenticazione, di essere scritti indipendentemente dallo schema di
autenticazione sottostante utilizzato. Ora modifichiamo i nostri file di
configurazione di PAM per fargli utilizzare anche LDAP. I seguenti file
non sono "la verità assoluta" ma nel mio caso funzionano e sono una
buona base di partenza. Per maggiorni informazioni rivolgetevi alla
documentazione ufficiale. I nomi dei file dovrebbero già far capire a
che servizio ci si riferisce. Fate sempre una copia dei vostri file
originali prima di applicare le modifiche.

/etc/pam.d/login

    auth            requisite       pam_securetty.so
    auth            requisite       pam_nologin.so
    auth            sufficient      pam_ldap.so
    auth            required        pam_unix.so use_first_pass 
    auth            required        pam_tally.so onerr=succeed file=/var/log/faillog
    account         required        pam_access.so
    account         required        pam_time.so
    account         required        pam_unix.so
    account         sufficient      pam_ldap.so
    password        sufficient      pam_ldap.so
    session         required        pam_unix.so
    session         required        pam_env.so
    session         required        pam_motd.so
    session         required        pam_limits.so
    session         optional        pam_mail.so dir=/var/spool/mail standard
    session         sufficient      pam_ldap.so
    session         optional        pam_lastlog.so

/etc/pam.d/shadow

    auth            sufficient      pam_rootok.so
    auth            required        pam_unix.so
    auth            sufficient      pam_ldap.so use_first_pass
    account         required        pam_unix.so
    account         sufficient      pam_ldap.so
    session         required        pam_unix.so
    session         sufficient      pam_ldap.so
    password        sufficient      pam_ldap.so
    password        required        pam_permit.so

/etc/pam.d/passwd

    password        sufficient      pam_ldap.so 
    password        required        pam_unix.so shadow nullok

/etc/pam.d/sshd

    auth            required        pam_nologin.so
    auth            sufficient      pam_ldap.so 
    auth            required        pam_env.so
    auth            required        pam_unix.so use_first_pass
    account         sufficient      pam_ldap.so
    account         required        pam_unix.so
    account         required        pam_time.so
    password        required        pam_ldap.so 
    password        required        pam_unix.so
    session         required        pam_mkhomedir.so skel=/etc/skel/ umask=0022
    session         required        pam_unix_session.so
    session         sufficient      pam_ldap.so 
    session         required        pam_limits.so

I file /etc/pam.d/su e /etc/pam.d/sudo preferisco lasciarli come stanno.

/etc/hosts.allow

Per ultima cosa ricordiamoci di abilitare il permesso a contattare il
server attraverso il protocollo LDAP, altrimenti (come per sshd) non
funzionerà niente.

    sudo nano /etc/hosts.allow

e aggiungiamo la riga

    slapd : ALL : allow

> Database di OpenLDAP

Diamo una configurazione di base al database di OpenLDAP copiando il suo
file di esempio che a noi và più che bene:

    sudo cp /var/lib/openldap/openldap-data/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG

Bene! la parte server è conclusa (o perlomeno io mi fermo qui per il
momento). Inutile dirvi che commenti e precisazioni sono le benvenute, e
che spiegazioni dettagliate consultiate l'abbondante documentazione
online.

LDAP Client
===========

Terminamo la configurazione di LDAP mettendo a punto la parte client per
istruire il server a utilizzare LDAP nella risoluzione delle password
degli utenti.  :) La parte client si fà editando quattro file di
configurazione:

/etc/openldap/ldap.conf
-----------------------

Questo file definisce quale server contattare (URI) e quale struttura
dell'albero (BASE)

    sudo nano /etc/openldap/ldap.conf

impostiamo i seguenti parametri :

    BASE    dc=mede, dc=it
    URI     ldap://localhost

nel parametro URI potreste usare anche (se avete correttamente impostato
il vostro file /etc/hosts) anche il nome completo :

    URI     ldap://archi.mede.it  

la sostanza non cambia.

/etc/pam_ldap.conf e /etc/nss_ldap.conf
---------------------------------------

Questi file sono identici e sinceramente il motivo mi sfugge :)
indagherò sul motivo, ma comunque accetto dritte. Limitiamoci a renderli
identici.

    host archi.mede.it
    base dc=mede,dc=it
    uri ldap://archi.mede.it/
    ldap_version 3
    rootbinddn cn=Manager,dc=mede,dc=it
    scope sub
    timelimit 5
    bind_timelimit 5
    nss_reconnect_tries 2
    pam_login_attribute uid
    pam_member_attribute gid
    pam_password md5
    pam_password exop
    nss_base_passwd dc=mede,dc=it?sub
    nss_base_shadow dc=mede,dc=it?sub

/etc/ldap.secret
----------------

Creiamo questo file e scriviamoci la password (in chiaro) per collegarci
al server LDAP nel nostro caso "archimede".

    sudo nano /etc/ldap.secret

    archimede

e proteggiamolo da occhi indiscreti.

    sudo chmod 600 /etc/ldap.secret 

Avvio del servizio
==================

Bene, dovremmo aver finito (per ora) la parte ldap del nostro server e
dovremmo poter avviare il servizio senza errori

    sudo /erc/rc.d/slapd start

per vedere se funziona provate a lanciare il comando  :

    ldapsearch -x

se non ottenete errori ma una lista (vuota) LDIF siete a cavallo e
potete inserirlo nella vostra riga DAEMON in /etc/rc.conf in modo che il
servizio parta ad ogni avvio:

    DAEMONS=(... ... ... ... ... slapd ... ... ...)

Per ora così come è stato fatto openLDAP non server a niente :D, in
quanto non ci sono utenti nel suo database, ma appena configureremo il
file server con Samba ci ritorneremo su.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server_(Italiano)/LDAP_Server&oldid=238721"

Category:

-   Small Business Server (Italiano)

-   This page was last modified on 5 December 2012, at 23:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
