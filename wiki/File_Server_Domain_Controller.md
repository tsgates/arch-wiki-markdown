Small Business Server (Italiano)/File Server Domain Controller
==============================================================

Contents
--------

-   1 Introduzione
    -   1.1 Samba
    -   1.2 Cos’e’ questa guida ?
    -   1.3 Samba Server è meglio di Windows Server ?
    -   1.4 Ma allora perché usare Samba ?
    -   1.5 E’ più facile usare/amministrare Windows o Linux/Samba ?
    -   1.6 Sostituisco i miei server Windows con Linux/Samba ?
-   2 Installazione
    -   2.1 Operazioni preliminari
    -   2.2 Il repository radioattivo
        -   2.2.1 Attiviamo il repository
    -   2.3 Installazione pacchetti
        -   2.3.1 Samba
        -   2.3.2 LDAP Tools
        -   2.3.3 Samba LDAP Schema
-   3 Configurazione autenticazione LDAP
    -   3.1 OpenLDAP server
    -   3.2 LDAP Tools
    -   3.3 Popolare LDAP
-   4 Pianificazione condivisioni
    -   4.1 Gruppi
        -   4.1.1 Creiamo gli altri gruppi
        -   4.1.2 Creiamo gli utenti
        -   4.1.3 Assegniamo gli utenti ai gruppi
    -   4.2 Condivisioni
        -   4.2.1 public
            -   4.2.1.1 La "rogna" dei permessi utente
        -   4.2.2 netlogon & profiles
        -   4.2.3 rootdir
        -   4.2.4 apps
        -   4.2.5 homes
-   5 Configurazione di Samba
    -   5.1 Parametri globali
    -   5.2 Condivisioni
        -   5.2.1 public
        -   5.2.2 netlogon
    -   5.3 smb.conf completo
-   6 Avvio del servizio
-   7 Join al dominio e scripts di manutenzione
    -   7.1 Join al dominio
    -   7.2 Funziona ?
    -   7.3 Scripts di manutenzione
        -   7.3.1 purge
        -   7.3.2 setchown
    -   7.4 Firewall
    -   7.5 Abbiamo finito ?
-   8 Gestione dei permessi
    -   8.1 Gli utenti Windows
    -   8.2 Un caso pratico
    -   8.3 Mettamoci la lavoro
    -   8.4 Samba non c'entra
    -   8.5 ACL POSIX
        -   8.5.1 setfacl & getfacl
-   9 Conclusioni
    -   9.1 Print services
    -   9.2 Client grafici di amministrazione
    -   9.3 Quota
    -   9.4 Comandi Samba
    -   9.5 Lock sui file
    -   9.6 Sicurezza
    -   9.7 Client Linux
    -   9.8 Concludiamo managgia !

Introduzione
============

Questa parte della guida è, personale opinione, la più importante. Un
file server in una azienda è sicuramente lo scopo principale per cui si
installa un server (almeno inizialmente). Oramai nessuno può svolgere i
compiti principali senza condivisione di dati tra utenti, e le soluzioni
peer to peer di condivisione hanno limiti che non stò neanche a
considerare qui. Prima di proseguire permettetemi di sintetizzare dei
concetti di base che devono essere ben chiari prima di passare alla fase
di implementazione della rete vera e propria.

Samba
-----

Con GNU/Linux ho diverse possibilità di scelta, ma io considererò solo
la soluzione Samba che mi permette di interagire ottimamente con dei
clients Microsoft Windows che, volenti o dolenti, rappresentano il 98%
del mercato desktop. Samba è un grande, complesso progetto. Scopo del
progetto è l’ interoperabilità il più trasparente possibile tra il mondo
Microsoft Windows e i sistemi Unix/Linux. Samba offre servizi di
autenticazione e condivisione file e stampanti da una qualsiasi
piattaforma TCP/IP enabled. Le piattaforme originali erano Unix e
Linux,ma oggi vengono impiegati con successo anche altri tipi di
sistemi.

Cos’e’ questa guida ?
---------------------

Ricordo ancora che questa guida NON è una guida completa a Samba e
OpenLDAP, oltre a quanto già ribadito presuppone anche che abbiate già
una buona conoscenza di come funziona una rete Windows basata su un
dominio. Lo scopo che ci prefiggiamo qui è quello di descrivere in modo
abbastanza esteso un caso di reale implementazione di una rete che
utilizzano Microsoft Windows sui loro desktop e Linux, Samba e OpenLDAP
su lato server in sostituzione dei prodotti server di Microsoft. Essendo
un progetto di una certa complessità non bisogna trascurare il fatto che
leggere le guide “ufficiali” molto ben fatte e aggiornate che trovate
sul sito è molto più di un consiglio: fare le cose senza capirle bene è
una pessima abitudine.

Samba Server è meglio di Windows Server ?
-----------------------------------------

Ad essere sinceri, secondo me, la risposta è NO. Samba è fantastico nel
“mascherare” le evidenti differenze tra le piattaforme Windows e
Linux/Posix, il risultato non è perfetto, ma essendo un prodotto il
continua e veloce evoluzione queste “imperfezioni” sono sempre meno
percettibili. Và comunque detto che queste “imperfezioni” non si
riferiscono alle funzionalità nei servizi offerti da Samba (questi
oramai hanno raggiunto un grado di affidabilità molto elevata,
considerando il fatto che milioni di PC nel mondo usano questi servizi),
ma bensì al fatto di far credere ai client Windows che dalla parte
server non c’e’ Samba ma un “regolare” server Windows. Non tutte le
funzionalità sono state implementate (ad esempio i gruppi nidificati e
le utili Group Policy) e quindi se voglio usare Samba qualche
caratteristica avanzata deve essere lasciata da parte. Queste “mancanze”
saranno dei macigni per un fido Microsoft sponsor, dei sassolini per
chi, come me, non ama le guerre di religione Microsoft/Linux, ma cerca
di cavare il meglio dalle due piattaforme. Pane al pane, vino al vino:
Windows sui Desktop (per ora) e, ove possibile e conveniente, Linux sui
Server. Ricordiamoci, inoltre, che Samba NON puo’ agire come ADS (Active
Directory) Domain Controller (Windows 2000/2003 server), ma puo’
efficacemente diventarne membro come server aggiuntivo. La funzionalità
ADS domain controller sarà inclusa nella versione 4 di Samba ora in fase
di sviluppo. Samba 3 puo’ “emulare” un Domain Controller stile Windows
NT 4 anche se con notevoli miglioramenti nella scalabilità dovuti in
gran parte alla adozione di OpenLDAP come possibile backend (repository)
per utenti, gruppi e passwords. Naturalmente dei server Windows 2000 o
2003 possono efficacemente essere inseriti in un dominio controllato da
Samba 3 come server membri.

Ma allora perché usare Samba ?
------------------------------

I motivi possono essere molti. Vi posso dire i miei personali. Ho optato
per Samba perché :

-   Salute. Mi viene il mal di testa quando leggo le politiche licensing
    di Microsoft, non per i costi ma per il garbuglio di opzioni che
    cambiano ad ogni quando. Con Linux/Samba questi pensieri svaniscono
    per sempre.
-   Risparmio. Fate voi il conto di quanto costano le licenze per un
    dominio con il numero di PC nella vostra rete e il server.
    Attenzione però, inutile illudersi, generalmente i costi di
    manutenzione sono grossomodo gli stessi.
-   Sicurezza. Non voglio sindacare sul livello di sicurezza raggiunto
    da Windows (dipende naturalmente anche da chi lo installa), ma il
    fatto che Linux è molto meno preso di mira da virus e allegra
    brigata mi fa dormire sonni più tranquilli.
-   Single Signon. Con OpenLDAP riesco ad avere un unico repository dei
    dati utenti/password per tutti i servizi e server aziendali (posta,
    rete ecc.). Il cambio password di un utente non è più un incubo,
    ogni Desktop o Server, Windows o Linux che sia, viene autenticato
    centralmente nell’ albero OpenLDAP.

E’ più facile usare/amministrare Windows o Linux/Samba ?
--------------------------------------------------------

Qui sarebbe difficile trovare due persone con la stessa opinione.
Personalmente vi posso dire che Windows e il suo Active Directory
Services (ADS è un LDAP pesantemente personalizzato da Microsoft per lo
scopo) è un eccellente prodotto e capire come realizzare un dominio con
esso vuol dire masticare argomenti disparati quali LDAP, DNS, DHCP,
TCP/IP, KERBEROS, WINS, e tutti gli aspetti inerenti ad una rete
Microsoft: Primary Domain Controller (PDC), Backup Domain Controller
(BDC), Browsing della rete, Access Control List (ACL) alle share,
Profili Roaming eccetera. Insomma l’argomento è complesso, e
avventurarsi in una installazione di questo tipo senza padroneggiare
questi concetti è una PESSIMA IDEA. E con Linux/Samba ? Stessa cosa,
devo avere alba di cosa sia Linux, come si installa e come si amministra
in modo almeno basilare, oltre a tutte le cose dette per Windows: LDAP,
DNS, WINS, PDC, BDC, ACL, Profili Roaming ecc.. Ovviamente anche con
Samba ci scontreremo con questi concetti basilari. Alla fine della fiera
la differenza sarà che con Windows ho dei comodi (ma a parer mio a volte
diseducativi) tools grafici per fare il tutto, con Linux un mix tra
tools grafici e cari e vecchi (ma efficaci) tools da linea di comando.

Sostituisco i miei server Windows con Linux/Samba ?
---------------------------------------------------

Mah, dipende. Se ho già un dominio Windows 2000/2003 ADS funzionante
significa che ho già investito in licenze ed ammennicoli vari e
sostituirlo con Samba non è che porta a svolte miracolose. Io eviterei,
ribadisco che ADS è un buon prodotto. Se invece devo aggiungere un file
server al dominio ADS, Samba puo’ essere una valida opzione. Diverso il
caso in cui dovessi aggiornare dei server Windows NT che ora Microsoft
non segue più. Anche in questo caso la migrazione a Samba può essere una
valida opzione.

N.B. Se ho più server ricordiamoci un concetto importante : Se il PDC è
Windows il/i BDC devono essere Windows, i server membri aggiuntivi sia
Samba che Windows. Se il PDC è Samba il/i BDC devono essere Samba, i
server membri aggiuntivi sia Samba che Windows.

Bene, ora che è tutto chiaro (...) con possiamo iniziare :) .

Installazione
=============

Cominciamo con la configurazione del nostro file server domain
controller basato su Samba e OpenLDAP. Come primo passo dedichiamoci
all' installazione dei pacchetti necessari.

Operazioni preliminari
----------------------

In questo tipo di configurazioni è bene concentrarci sul singolo
problema, evitando di correr dietro a cause esterne dovute ad altri
servizi. Tutto questo per dire che se per caso avete attivato il
firewall è giunto il momento di disattivarlo momentaneamente. Quando
tutto funzionerà a dovere lo ripristineremo con le rules aggiuntive
opportune. Quindi:

    sudo /etc/rc.d/shorewall stop

In più abilitiamo momentaneamente **tutti** i protocolli :

    sudo nano /etc/hosts.allow

e aggiungiamo la riga

    all: ALL : allow

Bene, ora che abbiamo eliminato eventuali cause esterne possiamo
proseguire.

Il repository radioattivo
-------------------------

Durante l'installazione ho, purtroppo, constatato che i pacchetti
necessari in questa impresa non sono tutti disponibili né sui repository
ufficiali nè su AUR. Certo, essendo degli script perl e delle librerie
dello stesso, avrei potuto usare CPAN ed installare gli script a mano,
ma finché posso voglio evitare questa pratica e allora (rullo di
tamburi:)) ho creato un piccolo e radioattivo repository personale con
quello che ci serve. Creare un repository con Arch è veramente una
operazione banale con il comando repo-add, un po' più complicati sono i
PKGBUILD. Di grande aiuto mi è stata l'utility cpan4pacman installata
precedentemente, che mi ha creato i PKGBUILD per le librerie perl
mancanti, appena un po' più complesso il pacchetto smbldap-tools che ho
dovuto fare da zero (o quasi). Perchè radioattivo ? Perchè ho ignorato
tutte le opzioni di verifica delle dipendenze e i checksum MD5. Sono
script in perl, di bassa pericolosità, ma naturalmente non mi assumo
responsabilità.

> Attiviamo il repository

    sudo nano /etc/pacman.conf

aggiungiamo in fondo :

    [stenoweb]
    Server = http://www.stenoweb.it/repo/i686

e per finire aggiorniamo la lista dei pacchetti "risucchiando" la lista
anche dal repo stenoweb:

    sudo pacman -Sy

Bene ! Non dovreste ottenere errori.

Installazione pacchetti
-----------------------

> Samba

Ma come diavolo si installerà Samba ? io proverei con un:

    sudo pacman -S samba

Funziona ! Scusate non ho resistito ...

> LDAP Tools

E qui interviene il mio repository. Gli LDAP Tools sono degli script
realizzati in perl che permettono di gestire utenti e gruppi Samba/Unix
salvando i dati sull'albero LDAP anziché sui file /etc/passwd e
/etc/group. In pratica sostituiscono i vari comandi standard linux di
gestione degli utenti. Iniziamo con installare le librerie perl
necessarie :

    sudo pacman -S perl-digest-sha1 perl-crypt-smbhash perl-jcode perl-unicode-map perl-unicode-map8 perl-unicode-maputf8 perl-unicode-string perl-ldap perl-io-socket-ssl 

e poi il pacchetto vero e proprio con gli scripts:

    sudo pacman -S smbldap-tools

Gli script sono stati copiati/installati in /usr/local/bin e i file di
configurazione in /etc/smbldap-tools. I comandi sono nella forma (ad
esempio per aggiungere un utente) :

    sudo /usr/local/bin/smbldap-useradd nomeutente

ma non provateci adesso, mancando la necessaria configurazione otterrete
solo un errore. Ho fatto qualcosa in più: data la lunghezza del comando
lo script di installazione del pacchetto crea anche dei link simbolici
di più agevole forma in /bin. Il comando di prima diventerà il più
semplice:

    sudo netuseradd nomeutente

Prolunghiamo la vita alle nostre tastiere! :)

> Samba LDAP Schema

Per ultimo abbiamo bisogno del file di schema da applicare a OpenLDAP
per memorizzare i dati di cui ha bisogno Samba. Cos'e' un file di
schema ? LDAP in buona sostanza è un database, lo schema non è altro che
il tracciato record che descrive, dichiara e crea i campi nel database
LDAP. Nello schema Samba ci sono i campi per il nome utente, la
password, la home, i gruppi ecc. che servono a memorizzare i nostri dati
nell'albero LDAP. Il file samba.schema di cui abbiamo bisogno è fornito
con i sorgenti di Samba: anziché scaricare i 17MB, scompattare e
recuperare il file ve lo fornisco io direttamente. Spostiamoci nella
cartella degli schemi di OpenLDAP :

    cd /etc/openldap/schema

e scarichiamoci lo schema:

    sudo wget http://www.stenoweb.it/repo/noarch/samba.schema

Configurazione autenticazione LDAP
==================================

Dopo aver installato tutti i pacchetti necessari cominciamo con la
configurazione di OpenLDAP e la inizializzazione del suo database con
gli utenti e gruppi di default richiesti da un dominio stile Microsoft.

OpenLDAP server
---------------

Abbiamo già configurato in modo basilare OpenLDAP, ora rimettiamo mano
alla configurazione per includere ciò di cui ha bisogno samba.

    sudo nano /etc/openldap/slapd.conf

Includiamo gli schemi necessari all'inizio (nis e samba):

    include	/etc/openldap/schema/core.schema
    include	/etc/openldap/schema/cosine.schema
    include	/etc/openldap/schema/inetorgperson.schema
    include	/etc/openldap/schema/nis.schema
    include	/etc/openldap/schema/samba.schema

Impostiamo le regole di accesso :

    access to dn.base=""
                   by self write
                   by * auth

    access to attrs=userPassword,sambaNTPassword,sambaLMPassword
           by dn="cn=Manager,dc=mede,dc=it" write
           by anonymous auth
           by self write
           by * none

    access to *
                   by * read
                   by anonymous auth

Soffermiamoci su di un aspetto: il rootdn cn=Manager,dc=mede,dc=it ha
comunque accesso ai dati in lettura scrittura anche se non specifico
nulla, ma di particolare importanza è la regola di accesso "access to
attrs=userPassword,sambaNTPassword,sambaLMPassword" che di fatto
permette ai singoli utenti di cambiare la propria password direttamente
da Windows. Per ultima cosa definiamo gli indici di ricerca per
velocizzare gli accessi all'albero ldap (eliminate le voci "index" già
presenti e sostituitele con queste) :

    # Indices
    index objectClass           eq
    index cn                    pres,sub,eq
    index sn                    pres,sub,eq
    index uid                   pres,sub,eq
    index displayName           pres,sub,eq
    index uidNumber             eq
    index gidNumber             eq
    index memberUID             eq
    index sambaSID              eq
    index sambaPrimaryGroupSID  eq
    index sambaDomainName       eq
    index default               sub

Per attivare le nuove impostazioni riavviamo il servizio:

    sudo /etc/rc.d/slapd restart

Il nostro albero è pronto.

LDAP Tools
----------

Gli LDAP tools sono necessari per gestire utenti e gruppi, per poterli
utilizzare dobbiamo configurarli a dovere. Per prima cosa diamo un file
di configurazione di base a Samba :

    sudo nano /etc/samba/smb.conf

e inseriamo :

    [global]
           unix charset = LOCALE
           workgroup = MEDE
           netbios name = ARCHI
           server string = %h PDC (%v)
           interfaces = eth1, lo
           bind interfaces only = Yes
           enable privileges = yes
           guest account = guest
           domain logons = Yes
           domain master = yes
           preferred master = Yes
           os level = 65
           wins support = Yes
           security = user
           ldap suffix = dc=mede,dc=it
           ldap user suffix = ou=Users
           ldap machine suffix = ou=Computers
           ldap group suffix = ou=Groups
           ldap idmap suffix = ou=Idmap
           ldap admin dn = cn=Manager,dc=mede,dc=it
           idmap backend = ldap:ldap://archi.mede.it
           idmap uid = 10000-20000
           idmap gid = 10000-20000
           ldap passwd sync = Yes
          #ldap ssl = start tls
           ldap ssl = no

Come si può notare al momento (ricordo che il servizio samba non è stato
ancora avviato) forniamo sono i dati essenziali, quali il dominio
(workgroup = MEDE), il nome del server (netbios name = ARCHI), il suo
ruolo di Domain Controller (domain logons = Yes) e i parametri LDAP.
Sugli altri parametri consiglio una buona guida di Samba o le sue
manpage :). Come secondo passo prendiamo nota del SID del nostro server:

    sudo net getlocalsid

dovrei ottenere qualcosa del tipo:

    SID for domain ARCHI is: S-1-5-21-1491279793-2809991009-2777690449

Ora editiamo i file di configirazione dei smbldap-tools:

    nano /etc/smbldap-tools/smbldap.conf

e scorrendo i parametri impostamoli così:

    #Il SID ricavato con il comando precedente
    SID="S-1-5-21-1491279793-2809991009-2777690449"
    sambaDomain="MEDE"
    suffix="dc=mede,dc=it"
    hash_encrypt="MD5"
    defaultMaxPasswordAge="180"
    userSmbHome=""
    userProfile=""
    userHomeDrive="K:"
    userScript="%U.bat"
    mailDomain="mede.it"

Gli altri lasciamoli con i valori di default. Salviamo e editiamo il
file:

    sudo nano /etc/smbldap-tools/smbldap_bind.conf

e facciamo diventare così:

    slaveDN="cn=Manager,dc=mede,dc=it"
    slavePw="archimede"
    masterDN="cn=Manager,dc=mede,dc=it"
    masterPw="archimede"

Ricordo che "archimede" è la password che ho deciso per l'amministratore
LDAP, la stessa che ho messo in /etc/openldap/slapd.conf in formato MD5
e in /etc/ldap.secret in chiaro. Finito questo proteggiamo i file da
occhi indiscreti:

    sudo chmod 0644 /etc/smbldap-tools/smbldap.conf
    sudo chmod 0600 /etc/smbldap-tools/smbldap_bind.conf

Ora non ci resta che dire anche a Samba la password da utilizzare per
accedere a LDAP:

    sudo smbpasswd -w archimede

se ottenete una risposta del tipo:

    Setting stored password for "cn=Manager,dc=mede,dc=it" in secrets.tdb

Significa che fino ad ora tutto và per il verso giusto, e possiamo
proseguire.

Popolare LDAP
-------------

Per il funzionamento corretto SAMBA ha bisogno di diversi gruppi
predefiniti e 2 utenti: Administrator e guest. Inoltre, affinché si
riesca ad aggiungere computer al dominio in modo automatico (da macchine
Windows), deve esistere un utente con uid = 0 da utilizzare per questa
operazione. Tale utente può essere un utente root (da aggiungere a mano)
o lo stesso Administrator cambiandogli l'uid. Quest'ultima è la scelta
presa in questa configurazione, in modo da avere un utente Administrator
che è Administrator per Samba e root per il "dominio" UNIX. Gli ldap
tools forniscono un comodo comando per svolgere questa operazione:
smbldap-populate. Lanciamolo così con questi parametri:

    sudo /usr/local/bin/smbldap-populate -a Administrator -u 5001 -g 5001 -r 5001 -b guest -l 5000

al termine ci viene chiesta la password di "Administrator", mettiamo la
stessa di root per non fare confusione. Dovrei vedere qualcosa del
genere :

    Populating LDAP directory for domain MEDE (S-1-5-21-1491279793-2809991009-2777690449)
    (using builtin directory structure)
     
    adding new entry: dc=mede,dc=it
    adding new entry: ou=Users,dc=mede,dc=it
    adding new entry: ou=Groups,dc=mede,dc=it
    adding new entry: ou=Computers,dc=mede,dc=it
    adding new entry: ou=Idmap,dc=mede,dc=it
    adding new entry: uid=Administrator,ou=Users,dc=mede,dc=it
    adding new entry: uid=guest,ou=Users,dc=mede,dc=it
    adding new entry: cn=Domain Admins,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Domain Users,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Domain Guests,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Domain Computers,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Administrators,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Account Operators,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Print Operators,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Backup Operators,ou=Groups,dc=mede,dc=it
    adding new entry: cn=Replicators,ou=Groups,dc=mede,dc=it
    adding new entry: sambaDomainName=MEDE,dc=mede,dc=it
     
    Please provide a password for the domain Administrator:
    Changing UNIX and samba passwords for Administrator
    New password:
    Retype new password: 

Come possiamo notare smbldap-populate ha creato utenti e gruppi
predefiniti in una installazione di windows server. Per vedere se tutto
funziona proviamo a creare un utente user1:

    sudo netuseradd -a -m user1

e diamogli una password :

    sudo netpasswd user1

ora controlliamo se l'utente c'e':

    sudo getent passwd

Dovrei ottenere la lista degli utenti tra cui :

    Administrator:x:0:0:Netbios Domain Administrator:/home/Administrator:/bin/false
    guest:x:5000:514:guest:/dev/null:/bin/false
    user1:x:5001:513:System User:/home/user1:/bin/bash

per le opzioni complete digitiamo netuseradd senza parametri e diamo una
occhiata. Nell'esempio il parametro -a crea sia l'utente unix che samba
e -m crea la home (/home/user1) dell'utente.

Pianificazione condivisioni
===========================

E' (quasi) giunto il momento di avviare Samba, ma prima dobbiamo
pianificare un po' COSA andremo a condividere e COME impostare gli
accessi al file system (ACL). Quello che propongo qui è solo un esempio,
i casi possono essere innumerevoli, ma secondo me questa rappresenta
comunque una buona base di partenza.

Gruppi
------

Definiamo e creiamo un insieme di gruppi di utenti a cui poi assegnare
una condivisione "privata". I nomi sono di fantasia (anche se non
proprio :)):

  Gruppo         Descrizione
  -------------- --------------------------------------
  commerciale    utenti ufficio commerciale
  tecnico        utenti ufficio tecnico
  Domain Users   gruppo che contiene tutti gli utenti

  : 

Domain Users è già stato creato con smbldap-populate. Ogni nuovo utente
viene assegnato in modo automatico a questo gruppo.

> Creiamo gli altri gruppi

    sudo netgroupadd -a Commerciale
    sudo netgroupadd -a Tecnico

> Creiamo gli utenti

    sudo netuseradd -a -m commerciale1
    sudo netpasswd commerciale1
    sudo netuseradd -a -m tecnico1
    sudo netpasswd tecnico1

se abbiamo fatto tutto correttamente non dovrei vedere errori,
controlliamo con:

    sudo getent passwd

Alla fine dovrei vedere gli utenti appena creati:

    commerciale1:x:5001:513:System User:/home/commerciale1:/bin/bash
    tecnico1:x:5002:513:System User:/home/tecnico1:/bin/bash

Nota: come possiamo vedere ad ogni utente viene concesso l'accesso shell
(/bin/bash). Se vogliamo togliere questo privilegio basta modificare
l'utente (ad esempio tecnico1) così:

    sudo netusermod -s /bin/false tecnico1

> Assegniamo gli utenti ai gruppi

    sudo netgroupmod -m commerciale1 Commerciale
    sudo netgroupmod -m tecnico1 Tecnico

Anche qui possiamo controllare con :

    sudo getent group

e ottenere qualcosa del genere:

    Commerciale:*:5001:commerciale1
    Tecnico:*:5002:tecnico1

I comandi net* li trovo in /bin: è utile prendere dimestichezza con
questi per amministrare utenti e gruppi.

Condivisioni
------------

Vediamo ora cosa andremo a condividere, ho deciso di mettere tutto
(tranne le home directory) in /samba:

  Condivisione   Percorso          Descrizione
  -------------- ----------------- ----------------------------------------------------------------------------------------------
  public         /samba/public     Cartella pubblica. Contiene una cartella per ogni gruppo (vedi dopo)
  netlogon       /samba/netlogon   Cartella di sistema necessaria in un domain controller. Contiene gli script di login utente.
  profiles       /samba/profiles   Cartella di sistema. Mi serve se uso i Profili Roaming di windows.
  rootdir        /samba            Condivisione ad uso backup. Contiene anche i symlink ai file più importanti del mio server
  apps           /samba/apps       Cartella applicazioni. Sola lettura
  homes          /home             Cartelle home per gli utenti. Ognuno la sua.

  : 

> public

Questa condivisione è la principale, anziché creare una condivisione per
ogni gruppo ho deciso di mettere tutto dentro a public e di "giocare"
poi con i permessi sulle cartelle. Per capirci meglio :

  --------------------------- ---------------------------------------------------------------
  /samba/public               di proprietà di root/Administrator solo leggibile dagli altri
  /samba/public/commerciale   Cartella per gruppo "Commerciale"
  /samba/public/tecnico       Cartella per gruppo "Tecnico"
  /samba/public/comune        Cartella condivisa di tutti ("Domain Users")
  --------------------------- ---------------------------------------------------------------

  : 

Poi andremo a mappare una unità L: (a scelta) sulla condivisione
"public" e gli utenti del gruppo "Commerciale" vedranno L:\COMUNE e
L:\COMMERCIALE, gli utenti del gruppo "Tecnico" vedranno solo L:\COMUNE
e L:\TECNICO. Nessuno (tranne i membri del gruppo "Domain Admins", off
course) possono creare files o cartelle nella root di L:. Tengo a
precisare che questa non è una regola ma una mia personale idea su come
organizzare le condivisioni. Quando abbiamo a che fare con molti gruppi
ritengo abbastanza noioso e confusionario fare condivisioni separate. Un
utente membro di diversi gruppi si troverebbe con molte mappature
diverse che esauriscono in breve l'alfabeto. In questo modo ho una unica
mappatura (L:\) e ognuno vedrà le sottocartelle a cui avrà accesso.
Molto più ordinato e comodo. Questo tipo di organizzazione è la stessa
che usavo quando installavo Novell Netware 10-15 anni fà, e quindi non
ha niente di specifico di Samba o di Windows. Quindi creiamo la
struttura :

    sudo mkdir /samba/public
    sudo mkdir /samba/public/commerciale
    sudo mkdir /samba/public/tecnico
    sudo mkdir /samba/public/comune

e sistemiamo i permessi e la proprietà :

    sudo chmod 770 /samba/public/commerciale
    sudo chgrp Commerciale /samba/public/commerciale
    sudo chmod 770 /samba/public/tecnico
    sudo chgrp Tecnico /samba/public/tecnico
    sudo chmod 770 /samba/public/comune
    sudo chgrp "Domain Users" /samba/public/comune

Controlliamo cosa abbiamo combinato:

    ls -al /samba/public

e dovrei vedere qualcosa del genere:

    drwxr-xr-x 5 root root         4096 17 dic 16:24 .
    drwxr-xr-x 7 root root         4096 12 dic 16:11 ..
    drwxrwx--- 2 root Commerciale  4096 17 dic 16:24 commerciale
    drwxrwx--- 2 root Domain Users 4096 17 dic 16:24 comune
    drwxrwx--- 2 root Tecnico      4096 17 dic 16:24 tecnico

La "rogna" dei permessi utente

Ora che abbiamo dato i permessi alle cartelle ci troviamo di fronte ad
un problema inaspettato. Quando gli utenti creano nuovi files o cartelle
nelle condivisioni questi vengono flaggati con utente=UtenteCreatore e
gruppo=GruppoDefaultUtente. Il gruppo di default è "Domain Users",
quindi tutti i nuovi files vengono impostati con questo gruppo. Dunque i
nuovi files creati in "commerciale" sono potenzialmente a disposizione
anche degli utenti del gruppo "Tecnico", essendo anche questi membri del
gruppo "Domain Users". In questo caso sono protetti dai permessi della
cartella stessa, ma potrebbe non essere così in un altro caso. L'utente
"Administrator" ha come gruppo di default "Domain Admins", quindi ogni
file creato/copiato/ripristinato dall'amministratore risulta non
accessibile dagli utenti "normali". Indubbiamente una bella rottura di
scatole dover ogni volta reimpostare a mano i permessi sui files
manipolati dall'amministratore ... Ma non disperate ! :) Ci viene in
aiuto il flag SETUID di unix. Se leggete l'articolo linkato sembra non
centrare una benemerita fava con l'argomento in questione, ma in questo
caso l'effetto del flag è quello da noi voluto. In pratica abilitiamo il
flag sul gruppo in questo modo :

    sudo chmod g+s /samba/public/commerciale
    sudo chmod g+s /samba/public/tecnico
    sudo chmod g+s /samba/public/comune

se ricontrollo ora con ls -al dovrei vedere che la tripletta dei
permessi sul gruppo è cambiata da rwx a rws che indica, appunto, che è
attivo il setuid. Cosa provoca questo ? Questo trucchetto fà si che ogni
file creato nelle cartelle avrà come gruppo proprietario il guppo della
cartella e non quello dell'utente. Quindi ogni file, ad esempio, creato
in "commerciale" avrà come gruppo proprietario "Commerciale" che
corrisponde al gruppo proprietario della cartella. Ora potete usare
anche "Administrator" per ripristinare o creare files che saranno
accessibili agli utenti normali. Fiuuuuuu. Andiamo avanti.

> netlogon & profiles

Queste sono due condivisioni di sistema, necessarie quando si configura
un domain controller. In netlogon si saranno gli script di login degli
utenti (che vedremo come creare al "volo" in modo dinamico), in profiles
ci saranno i profili utente nel caso avessimo deciso di usare i profili
roaming di Microsoft (utili i certi casi, ma a me, idea personalissima,
non piacciono). Creiamo le certelle e diamo i permessi :

    sudo mkdir /samba/netlogon
    sudo mkdir /samba/profiles
    chmod 777 /samba/profiles

> rootdir

Questa è una condivisione di "comodo" accessibile solo
all'amministratore. Creiamo anche una cartella system con i link
simbolici alle cartelle o ai file che poi potremmo salvare via
condivisione samba da un altro PC per fare dei veloci backup.

    sudo ln -s /home /samba/home

In questo modo l'amministratore accedendo alla condivisione "rootdir"
potrà vedere e manipolare tutte le home degli utenti

    sudo mkdir /samba/system
    sudo ln -s /etc /samba/system/etc
    sudo ln -s /var/lib/openldap/openldap-data /samba/system/ldap

Ora l'amministratore trova nella cartella "system" anche i file di
configurazione del server e il database utenti/gruppi di OpenLDAP. Molto
comodo, e potrei anche aggiungere altri link senza inventarmi
condivisioni "esotiche".

> apps

In questa condivisione mettiamo i programmi condivisi nella rete. Solo
"Administrator" può scrivere nella cartella, gli altri utenti possono
solo leggere e eseguire i file contenuti. creiamo la cartella e settiamo
i permessi:

    sudo mkdir /samba/apps
    sudo chmod 750 /samba/apps
    sudo chgrp "Domain Users" /samba/apps
    sudo chmod g+s /samba/apps

> homes

Questa condivisione è creata automaticamente (o quasi) da Samba. Le home
degli utenti saranno mappate con K: e sarà privata ad ogni utente.

Bene, dovremmo esserci. Ora siamo pronti a completare la configurazione
di samba ed ad avviare (finalmente) il servizio.

Configurazione di Samba
=======================

E' giunta l' ora del servizio Samba finalmente. Configuriamolo a dovere
e avviamo il servizio. Vediamo anche una (breve) spiegazione dei
parametri principali applicati al nostro smb.conf. Andiamo ad editare il
file di configurazione di Samba:

    sudo nano /etc/samba/smb.conf

e vediamo cosa scriverci ...

Parametri globali
-----------------

Nella sezione [global] abbiamo i parametri generali del server,
soffermiamoci solo su quelli (per me) significativi. Alla fine c'e' il
file completo per un comodo copia/incolla. Per il resto rimando alla
guida. Il nome del dominio:

    workgroup = MEDE

Il nome del server :

    netbios name = ARCHI

Samba rimane in ascolto solo sulle interfacce specificate, la eth0 che è
rivolta all'esterno verso internet naturalmente non viene servita. O
vogliamo dare servizi di file server al mondo ? :)

    interfaces = eth1, lo
    bind interfaces only = Yes

Diciamo a Samba che il repository di utenti, gruppi e password è il
server LDAP specificato.

    passdb backend = ldapsam:ldap://archi.mede.it

Ordine con cui vengono risolti i nomi delle workstation. Broadcast per
ultimo off course.

    name resolve order = wins host dns bcast

Script richiamati da Samba quando da Windows tento le operazioni citate.
Questo mi permette di usare tools windows per gestire utenti e gruppi,
oltre che ad eseguire la join al dominio.

    add user script = /bin/netuseradd -a -m '%u'
    delete user script = /bin/netuserdel '%u'
    add group script = /bin/netgroupadd -a -p '%g'
    delete group script = /bin/netgroupdel '%g'
    add user to group script = /bin/netgroupmod -m '%u' '%g'
    delete user from group script = /bin/netgroupmod -x '%u' '%g'
    set primary group script = /bin/netusermod -g '%g' '%u'
    add machine script = /bin/netuseradd -w '%u'

Script di login eseguiti dagli utenti quando si collegano. %U viene
trasformata nel nome utente. Ad esempio l' utente tecnico1 eseguirà (se
esiste) lo script tecnico1.bat che si trova in netlogon.

    logon script = %U.bat

Non voglio i profili roaming, quindi metto a null questi parametri.
Attenzione che i parametri userSmbHome e userProfile specificati in
/etc/smbldap-tools/smbldap.conf hanno la precedenza su questi !

    logon path =
    logon home =

Il mio server è un domain controller :)

    domain logons = Yes

Eleggiamo il nostro server ad autorità maxima, facciamolo diventare
master browser per il segmento della nostra rete.

    domain master = yes
    preferred master = Yes
    os level = 65

Il nostro server è anche server wins

    wins support = Yes

Parametri dell'albero LDAP a cui Samba si collega. In questo modo si
indica a Samba dove trovare utenti, gruppi, computer e il nome utente da
utilizzare per connettersi (cn=Manager). Ricordiamo che la password la
abbiamo memorizzata con il comando smbpasswd -w nell'articolo
precedente.

    ldap suffix = dc=mede,dc=it
    ldap user suffix = ou=Users
    ldap machine suffix = ou=Computers
    ldap group suffix = ou=Groups
    ldap idmap suffix = ou=Idmap
    ldap admin dn = cn=Manager,dc=mede,dc=it
    idmap backend = ldap:ldap://archi.mede.it
    idmap uid = 10000-20000
    idmap gid = 10000-20000
    ldap passwd sync = Yes
    ldap ssl = no

Il tipo di autenticazione da usare (IMPORTANTISSIMO!).

    security = user

Ho specificato dei parametri aggiuntivi che vedete alla fine del post,
lascio a voi il compito di interpretarli ;). Ora passiamo alla sezione
condivisioni.

Condivisioni
------------

Abbiamo visto nell' articolo precedente quali condivisioni andiamo a
realizzare, vediamo come sono state tradotte sul file di configurazione.
Non le espongo tutte, ma solo quelle che hanno qualche parametro
significativo da spiegare. La versione completa del file smb.conf la
trovate alla fine del post.

> public

Nome e percorso condivisione

    comment = "L: - Cartella Pubblica Utenti"
    path = /samba/public

Scrivibile:

    writeable = yes

La vedo nel browsing della rete:

    browseable = Yes

Nascondi i file e le cartelle che l'utente non può leggere. Questo è
utile, in questa condivisione un utente vedrà solo quello che gli serve
anzichè chiedersi cosa ci sia "dentro" una cartella che non riesce ad
aprire... :)

    hide unreadable = Yes

Questa serie di parametri corrispondono ad una serie di tentativi per
fare in modo che questa condivisione funzioni a dovere. Ora non me la
sento di cambiare qualcosa. Chi lascia la vecchia strada ...

    directory mask = 0775
    create mask = 0775
    force create mode = 0775
    force directory mode = 6775
    security mask = 0777
    force security mode = 0
    directory security mask = 0777
    force directory security mode = 0

I vfs objects sono un utile "plugin" di Samba. In questo caso usiamo
l'oggetto recycle per realizzare un cestino di rete. I file eliminati
non andranno eliminati immediatamente ma finiranno in una cartella
nascosta .cestino/nomeutente. Poi faremo uno script di purge per vuotare
i cestini ogni tanto. I parametri aggiuntivi servono per dire a samba di
non salvare i file temporanei e di backup e di non applicare il
versioning ai file di office (creano problemi con il salvataggio
automatico di quest'ultimo).

    vfs objects = recycle
    recycle:repository = .cestino/%U
    recycle:keeptree = yes
    recycle:touch = yes
    recycle:versions= yes
    recycle:exclude = *.tmp *.bak ~$*
    recycle:exclude_dir = /tmp /temp /cache
    recycle:noversions = *.doc *.xls *.ppt

> netlogon

Questa condivisione di "servizio" è fondamentale per la gestione degli
script di logon degli utenti. Intanto la nascondiamo dal browsing della
rete.

    browseable = No

Nel momento in cui l'utente accede alla condivisione (e tutti gli utenti
di un dominio lo fanno) viene eseguito /etc/samba/logon.pl a cui vengono
passati dei parametri tipo il nome utente che ha richiamato lo script,
il gruppo, l'orario ecc.. Cosa fà questo programmino ? Semplice, crea lo
script di logon dell'utente "al volo" secondo le regole definite in
logon.pl. Ad esempio viene creato tecnico1.bat per l'utente tecnico1.
Potrei omettere questo parametro e creare a mano lo script, ma così è
molto più comodo e vedremo perché.

    root preexec = /etc/samba/logon.pl "%U" "%G" "%L" "%T" "%m" "%a"

E ora vediamo come è fatto questo logon.pl.

    sudo nano /etc/samba/logon.pl

e impostiamolo così:

    #!/usr/bin/perl
    #
    open LOG, ">>/var/log/samba/netlogon.log";
    print LOG "$ARGV[3] - Utente $ARGV[0] collegato a $ARGV[2]\n";
    close LOG;
    #
    # Elenco utenti per share
    #
    $APPS   ="-tecnico1-tecnico2-";
    $NOLOGON ="-administrator-";
    $DELMAP  ="-winnt-win2k-win2k3-winxp-";
    $ADMIN   ="administrator";
    #
    # Inizio generazione script
    #
    open LOGON, ">/samba/netlogon/$ARGV[0].bat";
    print LOGON "\@ECHO OFF\r\n";
    print LOGON "ECHO ARCHI logon script\r\n";
    print LOGON "ECHO.\r\n";
    #
    # Sincronizza orario con il server
    #
    print LOGON "NET TIME \\\\ARCHI /SET /YES\r\n";
    #
    # Se piattaforma PC in lista $DELMAP cancella i vecchi mappaggi
    #
    if (index($DELMAP,"-".lc($ARGV[5])."-") >=0)
     {
           print LOGON "NET USE * /DEL /YES\r\n";
     }
    #
    # Esci se utente in lista $NOLOGON altrimenti applica i mappaggi comuni
    #
    if (index($NOLOGON,"-".lc($ARGV[0])."-") == -1)
     {
       # Disco L: (PUBLIC)
       print LOGON "NET USE L: \\\\ARCHI\\public /YES\r\n";
       # Disco K: (HOME)
       print LOGON "NET USE K: \\\\ARCHI\\$ARGV[0] /YES\r\n";
      
       # Disco X: (APPS)
       if (index($APPS,"-".lc($ARGV[0])."-") >=0)
         {
           print LOGON "NET USE X: \\\\ARCHI\\apps /YES\r\n";
         }
     }
    # Chiudi il file.
    close LOGON;

Possiamo vedere che condizioniamo la creazione dello script in base a
delle variabili in testa. Ad esempio solo la lista degli utenti
specificata in $APPS (tecnico1 e tecnico2 separati con "-") avranno la
mappatura X:, e gli utenti listati in $NOLOGON (administrator) non
avranno alcuno script. Tutto chiaro ? Questo script può essere
modificato ed esteso con semplicità seguendo questo schema di esempio, e
ha il pregio di semplificare la gestione degli script di logon. Voglio
che anche l'utente "commerciale1" mappi la X: per \\archi\apps ? Basta
aggiungerlo nella lista $APPS e la prossima volta che si collega al
server avrà il suo script aggiornato "al volo". In più ho anche un file
di log in /var/log/samba/netlogon.log che mi informa dell'orario di
collegamento degli utenti.

Wow. A volte le cose semplici sono le più importanti. Come compito a
casa mi fate lo script che scrive nel log l'orario in cui si scollegano
usando il parametro root postexec. ;)

Tengo a precisare che i parametri root preexec (e root postexec che
viene eseguito allo "scollegamento") non sono una prerogativa di
netlogon. Possono essere usati con qualunque condivisione per eseguire
"qualcosa" al momento del collegamento (e/o dello scollegamento).

Ricordiamoci di rendere eseguibile lo script perl :

    sudo chmod 775 /etc/samba/logon.pl

smb.conf completo
-----------------

E dulcis in fundo ecco il file di configurazione completo da spulciare e
studiare. Posso, ad esempio, notare che ho gestito il cestino anche
sulle home e autorizzato solo i membri del gruppo "Domain Admins" ad
accedere alla condivisione di "servizio" rootdir.

    [global]
           workgroup = MEDE
           netbios name = ARCHI
           server string = %h PDC (%v)
           interfaces = eth1, lo
           bind interfaces only = Yes
           passdb backend = ldapsam:ldap://archi.mede.it
           enable privileges = yes
           log level = 0
           log file = /var/log/samba/%m
           max log size = 50
           smb ports = 139 445
           hide dot files = yes
           name resolve order = wins host dns bcast
           time server = Yes
           guest account = guest
           show add printer wizard = No
           add user script = /bin/netuseradd -a -m '%u'
           delete user script = /bin/netuserdel '%u'
           add group script = /bin/netgroupadd -a -p '%g'
           delete group script = /bin/netgroupdel '%g'
           add user to group script = /bin/netgroupmod -m '%u' '%g'
           delete user from group script = /bin/netgroupmod -x '%u' '%g'
           # Disabilitare quando a fare il join al dominio è un Windows NT
           set primary group script = /bin/netusermod -g '%g' '%u'
           add machine script = /bin/netuseradd -w '%u'
           logon script = %U.bat
           # Profili Roaming
           #logon path = \\%L\profiles\%U
           logon path =
           logon home =
           logon drive = K:
           domain logons = Yes
           domain master = yes
           preferred master = Yes
           os level = 65
           wins support = Yes
           # LDAP
           ldap suffix = dc=mede,dc=it
           ldap user suffix = ou=Users
           ldap machine suffix = ou=Computers
           ldap group suffix = ou=Groups
           ldap idmap suffix = ou=Idmap
           ldap admin dn = cn=Manager,dc=mede,dc=it
           idmap backend = ldap:ldap://archi.mede.it
           idmap uid = 10000-20000
           idmap gid = 10000-20000
           ldap passwd sync = Yes
          #ldap ssl = start tls
           ldap ssl = no
           map acl inherit = Yes
           #printing = cups
           lock directory = /var/lock/samba
           winbind use default domain = yes
           winbind enum users = yes
           winbind enum groups = yes
           security = user
           template shell = /bin/false
    [public]
           comment = "L: - Cartella Pubblica Utenti"
           path = /samba/public
           writeable = yes
           browseable = Yes
           hide unreadable = Yes
           directory mask = 0775
           create mask = 0775
           force create mode = 0775
           force directory mode = 6775
           security mask = 0777
           force security mode = 0
           directory security mask = 0777
           force directory security mode = 0
           #inherit acls = yes
           #inherit permissions = yes
           vfs objects = recycle
           recycle:repository = .cestino/%U
           recycle:keeptree = yes
           recycle:touch = yes
           recycle:versions= yes
           recycle:exclude = *.tmp *.bak ~$*
           recycle:exclude_dir = /tmp /temp /cache
           recycle:noversions = *.doc *.xls *.ppt
    [homes]
           comment = "K: - Cartella privata di %U, %u"
           writeable = yes
           create mask = 0700
           directory mask = 0775
           browseable = No
           force user = %U
           vfs objects = recycle
           recycle:repository = .cestino
           recycle:keeptree = yes
           recycle:touch = yes
           recycle:versions= yes
           recycle:exclude = *.tmp *.bak ~$*
           recycle:exclude_dir = /tmp /temp /cache
           recycle:noversions = *.doc *.xls *.ppte_dir = /tmp /temp /cache
           recycle:noversions = *.doc *.xls *.ppt
    [rootdir]
           comment = Cartella globale, solo per amministrazione e backup
           path = /samba
           writeable = yes
           browseable = yes
           directory mask = 0770
           create mask = 0775
           force create mode = 0775
           force directory mode = 6775
           security mask = 0777
           force security mode = 0
           directory security mask = 0777
           admin users = Administrator
           valid users = "@Domain Admins"
           force create mode = 0644
           force directory mode = 6775
    [apps]
           comment = "Y: - Applicazioni"
           path = /samba/apps
           writeable = yes
           browseable = Yes
           directory mask = 0770
           create mask = 0775
           security mask = 0777
           force security mode = 0
           directory security mask = 0777
           force directory security mode = 0
           hide unreadable = Yes
           force create mode = 0775
           force directory mode = 6775
    [netlogon]
           comment = Network Logon Service
           path = /samba/netlogon
           guest ok = Yes
           locking = No
           browseable = No
           root preexec = /etc/samba/logon.pl "%U" "%G" "%L" "%T" "%m" "%a"
           #root postexec = /etc/samba/logoff.pl "%U" "%G" "%L" "%T"
    [profiles]
           comment = Profile Share
           path = /samba/profiles
           writeable = yes
           profile acls = Yes
           browsable = No

Avvio del servizio
==================

Quasi me ne dimenticavo :)

    sudo /etc/rc.d/samba start

e mettiamolo nella lista dei nostri daemons:

    DAEMONS=(... ... ... ... ... samba ... ... ...) 

Join al dominio e scripts di manutenzione
=========================================

Ora che finalmente abbiamo avviato Samba, facciamo la join del server al
nostro dominio nuovo fiammante, controlliamo che funzioni e creiamo un
paio di script bash utili per la manutenzione del sistema

Join al dominio
---------------

Per prima cosa dobbiamo unire il nostro server al dominio (che
traduzione orrenda: diciamo che dobbiamo fare la join...), con il
comando :

    sudo net rpc join -S ARCHI -U Administrator

dopo aver digitato la password dovreste vedere il messaggio:

    Joined domain MEDE.

In questa fase Samba ha creato l'account workstation per il vostro
server nel suo backend LDAP nel formato nomemacchina$. Andiamo a vedere
se è vero con il comando getent:

    sudo getent passwd

Alla fine dovrei vedere il mio server :

    archi$:*:5004:515:Computer:/dev/null:/bin/false

Ottimo. Passiamo oltre.

Funziona ?
----------

Controlliamo subito. Facciamolo con i comandi di Samba, così siamo
sicuri che sia lui a rispondere alle nostre richeste:

    sudo pdbedit -L

Dovrebbe mostrarmi la lista degli utenti, tipo questa:

    Administrator:0:Administrator
    guest:5000:guest
    commerciale1:5001:commerciale1
    tecnico1:5002:tecnico1
    archi$:5004:Computer

e ora controlliamo anche le condivisioni :

    sudo smbclient -L localhost -U administrator

e dopo la password dovrei vedere una cosa del tipo :

    Domain=[MEDE] OS=[Unix] Server=[Samba 3.0.28]
            Sharename       Type      Comment
            ---------       ----      -------
            IPC$            IPC       IPC Service (archi PDC (3.0.28))
            print$          Disk      Printer Drivers
            apps            Disk      Y: - Applicazioni
            rootdir         Disk      Cartella globale, solo per amministrazione e backup
            public          Disk      L: - Cartella Pubblica Utenti
            Administrator   Disk      K: - Cartella privata di administrator, Administrator
    Domain=[MEDE] OS=[Unix] Server=[Samba 3.0.28]
            Server               Comment
            ---------            -------
            ARCHI                archi PDC (3.0.28)
            Workgroup            Master
            ---------            -------
            MEDE                 ARCHI

Wow! Ce l'abbiamo fatta, il nostro domain controller è pronto ad
accogliere le vostre workstation Windows (e Linux off course) tra le sue
forti braccia.

Scripts di manutenzione
-----------------------

> purge

Predentemente abbiamo abilitato il plugin Samba per gestire il cestino
del server: ogni utente che cancella i file in realtà li sposta nella
cartella .cestino/nomeutente che abbiamo definito. Capirete anche voi
che non possiamo lasciarli lì per sempre ma abbiamo bisogno di purgare i
cestini di tanto in tanto per mantenere il sistema pulito dalla
spazzatura. Chi ha conosciuto Novell Netware non può non ricordare il
comando purge che svolgeva egregiamente questa funzione, purtroppo qui
non abbiamo niente di simile, e dobbiamo arrangiarci con bash.
Tranquilli, ci ho già pensato io qualche anno fa, niente di eclatante ma
svolge la sua funzione in modo preciso. Creiamo il file:

    sudo nano /bin/purge

e inseriamoci quanto segue:

    #!/bin/bash
    # purge
    # Vuota il cestino degli utenti e di sistema
    # by steno 2005-2007
    #
    # Controlla i parametri
    if [ $# = 0 ]
     then
       echo "uso: purge {all|<username>}"
       exit;
     else
      if [ $1 = 'all' ]
       then
        DIR=`ls /home -F | awk '/\/$/ {sub( /\/$/,""); print}'`; 
       else
        DIR=$1;
      fi;
    fi;
    #
    # Vuota il cestino privato degli utenti
    #
    for user in $DIR; do
      if [ -e /home/$user/.cestino ];
       then
        X="`(cd /home/$user/.cestino ; echo *)`";
        if [ ! "$X" = "*" ] ; then
                    echo "Elimina file dal cestino utente <$user>";
                    rm /home/$user/.cestino/* -r;
        else
                    echo "Cestino personale utente <$user> vuoto";
        fi;
      fi;
    done;
    #
    # Vuota il cestino globale di "public"
    #
    DIR=`ls /samba/public/.cestino -F | awk '/\/$/ {sub( /\/$/,""); print}'`;
    for user in $DIR; do
     X="`(cd /samba/public/.cestino/$user ; echo *)`";
     if [ ! "$X" = "*" ] ; then
      echo "Elimina file dal cestino globale utente <$user>" ;
      rm /samba/public/.cestino/$user -R;
     else
      echo "Cestino globale utente <$user> vuoto";
     fi 
    done;

Come vedete possiamo "purgare" tutto con il parametro all o limitarci ad
uno specifico utente. Lo script è poi suddiviso in due parti, la prima
si occupa del cestino di ogni singola home/user, la seconda del cestino
della share principale public. Rendiamo eseguibile lo script:

    sudo chmod 755 /bin/purge

e creiamo il Cestino globale dando i permessi corretti alla cartella:

    sudo mkdir /samba/public/.cestino
    sudo chmod 770  /samba/public/.cestino 
    sudo chgrp "Domain Users" /samba/public/.cestino

Ora basta digitare purge all da shell per avviare le pulizie di
primavera :), purge tecnico1 per il cestino del solo utente tecnico1.
Prendiamo anche in considerazione la possibilità di schedularlo con
crontab per avviarlo automaticamente al "calar della notte".

> setchown

Questo script si usa meno del precedente, ma in alcuni casi è molto
utile. Cosa fà lo script ? Semplice, corregge i permessi su file e
directory delle home degli utenti. A volte magari, come amministratore,
si ripristinano, copiano o spostano dei file da una cartella di un
utente ad un altro e poi dobbiamo manualmente lavorare di chown e chmod
per sistemare il tutto. Lo script setchown lo fa da solo spazzolando
tutte le home degli utenti (con i parametro all) correggendo permessi e
proprietà. Creiamo il file:

    sudo nano /bin/setchown 

e inseriamoci quanto segue:

    #!/bin/bash
    # setchown
    # Setta il proprietario della home dir e dei file allo user
    # escludi dal processo le home listate nella var "exclude"
    exclude="httpd ftp amavis";
    # Controlla i parametri
    if [ $# = 0 ]
     then
       echo "uso: setchown {all|<username>}"
       exit;
     else
      if [ $1 = 'all' ]
       then
        DIR=`ls /home -F | awk '/\/$/ {sub( /\/$/,""); print}'`;
       else
        DIR=$1;
      fi;
    fi; 
    #
    for user in $DIR; do
        mask=${exclude#*$user};
        if [ "$mask" = "$exclude" ]
         then
          chown $user /home/$user -R
          chmod 700 /home/$user
          echo "Permessi corretti in /home/$user";
        fi
    done

Anche qui vediamo che possiamo digitare setchown all per tutte le home
oppure setchown tecnico1 per la singola home. Non dimentichiamoci di
rendere eseguibile lo script:

    sudo chmod 755 /bin/setchown

Tenete presente anche la variabile $exclude nello script, in cui
dobbiamo inserire la lista delle cartelle in home da non processare. Ho
messo "httpd","ftp" e "amavis" che Archlinux ha la malaugurata idea di
creare in home (ma /var faceva schifo ?).

Firewall
--------

Ora possiamo riabilitare il firewall. Prima modifichiamo il file rules:

    sudo nano /etc/shorewall/rules

e aggiungiamo le nuove regole:

    SMB/ACCEPT      $FW             loc
    SMB/ACCEPT      loc             $FW

Per riavviare il servizio usiamo il comando shorewall, così vediamo se
abbiamo commesso sbagli:

    sudo shorewall start

Abbiamo finito ?
----------------

In teoria sì, in pratica no. Per domini semplici da pochi utenti
potreste essere già ok, ma la realtà è ben diversa dalla teoria e nel
proseguo scoprirete uno dei perché con un semplice esempio.

Gestione dei permessi
=====================

Seeee, abbiamo il nostro nuovo scintillante domain controller Samba su
Archlinux, abbiamo sottomesso i creduloni client windows (avete fatto la
join al dominio da windows ? Questo non ve lo spiego mica ...) facendoli
illudere di giocare in casa. Ah! Con il petto in fuori ci fregiamo a
pieno titolo del grado di "sysnetworksuperexpertadmin". Wow, e cosa ci
ferma più? --- Vi fermo io, e con un esempio semplice semplice. Ecco un
caso pratico che dimostra ancora una volta, se ce ne fosse bisogno, come
fra la teoria e la pratica ... ci sia di mezzo il vostro zelante capo
ufficio tecnico.

Raccontiamo una storia.

Gli utenti Windows
------------------

Tutti abbiamo abbiamo usato o usiamo tuttora (e perchè no?) Windows.
Voglia o no questo sistema operativo rappresenta il motore del 92%-98%
(a seconda degli studi) dei PC in questo pianeta. Impossibile non farci
i conti. Un tipico utente di questo sistema operativo (e per tipico
intendo chi lo usa per lavoro o per gioco senza conoscenze tecniche
informatiche) non ha mai avuto a che fare con diritti di accesso e
permessi su file o attività del computer. Probabilmente non sanno
nemmeno che esistono dato che il 99% dei PC con windows lavorano con
Administrator o con un utente equivalente. (Spesso se ci si sottrae a
questa regola addirittura certi software non funzionano, quindi
candidamente ammetto che pure io in Windows lavoro come Administrator).

Ma quando però scoprono che esistono è la fine, specie se hanno qualche
autorità in azienda. "Io voglio vedere i file di Antonio che può vedere
quelli Giovanni che però non può cancellare quelli di Lucia. Ok ? "
Vengono da voi "sysnetworksuperexpertadmin" e cominciano con queste
richieste cambiando idea ogni 2 minuti circa. Vi assicuro che capita,
capita...

Un caso pratico
---------------

Senza andare sul paradossale presentiamo un caso molto frequente e per
niente ingiustificato, e vediamo se riusciamo a risolverlo con Samba.
Come dicevo all'inizio, il Responsabile dell'Ufficio Tecnico viene da
voi e vi dice:

"Antonio e Giovanni disegnano e amministrano le schede tecniche dei
prodotti. Vorrei che salvassero i disegni su L:\prodotti e che Lucia e
Maria potessero visualizzarle o inviarle ai clienti senza però poterle
cancellare o modificare."

Bhe, richiesta ragionevole direi. Sufficente, però, a metterci in crisi.
Vediamo perchè.

Mettamoci la lavoro
-------------------

Allora, noi abbiamo la condivisione "public" (che i nostri utenti
chiamano L:\), creiamo gli utenti, la cartella "prodotti" e un gruppo
"Prodotti" che come membri ha Antonio e Giovanni. Cosa già vista,
facciamolo il fretta:

    sudo netuseradd -a -m Antonio
    sudo netpasswd Antonio
    sudo netuseradd -a -m Giovanni
    sudo netpasswd Giovanni 
    sudo netgroupadd -a Prodotti
    sudo netgroupmod -m Antonio,Giovanni Prodotti
    sudo mkdir /samba/public/prodotti
    sudo chmod 770 /samba/public/prodotti
    sudo chgrp Prodotti /samba/public/prodotti
    sudo chmod g+s /samba/public/prodotti

Bene. Ora Antonio e Giovanni hanno a disposizione L:\prodotti su cui
possono leggere e scrivere liberamente senza aver minimamente modificato
la configurazione di Samba, ho solo agito su utenti gruppi e permessi
sul file system. Andiamo avanti. Per Lucia e Maria creiamo un gruppo
"Prodotti-RO" (Read Only):

    sudo netuseradd -a -m Lucia
    sudo netpasswd Lucia
    sudo netuseradd -a -m Maria
    sudo netpasswd Maria
    sudo netgroupadd -a Prodotti-RO
    sudo netgroupmod -m Lucia,Maria Prodotti-RO

E adesso ? Cosa faccio ?

1.  Cambio permessi a /samba/public/prodotti in 775 così gli "altri"
    possono leggerci ma non scriverci. Sbagliato. Così anche gli utenti
    del gruppo "Commerciale" che non c'entrano nulla possono leggerci.
2.  Uso i parametri di smb.conf "Read List" e "Write List". Sbagliato. I
    parametri agiscono su tutta la share/condivisione "public" e hanno
    la precedenza su quelle del file system. Lucia e Maria non
    potrebbero scrivere nemmeno su L:\COMUNE.
3.  Faccio una share "prodotti" apposita slegata da "public".Ok,
    funziona ma a me non piace. Se per ogni caso del genere devo fare
    una share nuova in breve esaurisco le lettere dell'alfabeto per
    mapparle e il mio smb.conf diventa un libro. E poi ci hanno
    richiesto "L:\prodotti", non vorrete mica deluderli ? Con Windows si
    faceva in due secondi.

Prima che buttiate dalla finestra la vostra spilla di Samba vi dico che
la soluzione c'e'. Poco usata e pubblicizzata ma c'e'.

Samba non c'entra
-----------------

E sì. Samba non c'entra con questa limitazione. Samba poggia i suoi
servizi sul file system che trova (ext3 nel mio caso) e fà il possibile
per "mascherarlo" ma in questo caso non può nulla. Semplicemente abbiamo
scoperto la forte limitazione del meccanismo "tripletta" rwxrwxrwx
tipico di unix. Fanno quasi tenerezza se confrontati con la granularità
di permessi che riesco a raggiungere con NTFS. Inadeguati. Completamente
inadeguati. Ma non penserete mica che nessuno ci abbia fatto caso a
questo ? Naturalmente sì, e un bel po' di anni fà.

ACL POSIX
---------

La soluzione al nostro problema passa attraverso una estensione della
gestione dei permessi chiamate ACL POSIX. Ancora una bozza, non facili
da capire e gestire ma perfettamente funzionanti su Linux. La cosa
simpatica è che sulla nostra Arch (su tutte le distro che io sappia)
sono già installate e supportate, basta solo attivarle. Editiamo il
nostro /etc/fstab :

    sudo nano /etc/fstab

e abilitamole specificando il flag "acl" nel mount del nostro file
system:

    /dev/sda3 / ext3 defaults,acl 0 1

Riavviamo e siamo a posto. Abbiamo le estensioni attivate.

setfacl & getfacl

Questi sono i nostri due nuovi amici, setfacl per settare i permessi
estesi e getfacl per visualizzarli. Non stò a spiegare come funzionano
in dettaglio le acl posix, c'e' chi lo ha già fatto in modo ottimale.
Per approfondire leggete ad esempio qui, oppure qui se preferite la
lingua italiana. Questa è la nostra situazione:

    drwxrws---  2 root Prodotti     4096 21 dic 15:46 prodotti

Visualizziamola con :

    sudo getfacl /samba/public/prodotti

e ottengo questo, non ho attivato alcuna estensione e quindi
corrispondono ai normali flag che tutti conosciamo :

    # file: samba/public/prodotti
    # owner: root
    # group: Prodotti
    user::rwx
    group::rwx
    other::---

Ora impostamo i nostri sospirati permessi al gruppo "Prodotti-RO":

    sudo setfacl -d -m group:Prodotti-RO:r-x /samba/public/prodotti
    sudo setfacl -m group:Prodotti-RO:r-x /samba/public/prodotti

Visualizziamo di nuovo:

    sudo getfacl /samba/public/prodotti

e stavolta ottengo questo:

    # file: prodotti
    # owner: root
    # group: Prodotti
    user::rwx
    group::rwx
    group:Prodotti-RO:r-x
    mask::rwx
    other::---
    default:user::rwx
    default:group::rwx
    default:group:Prodotti-RO:r-x
    default:mask::rwx
    default:other::---

Bene. Abbiamo dato i permessi di lettura al gruppo "Permessi-RO",
impostandoli anche come default. Riappuntiamoci sul petto la nostra
spilla di "sysnetworksuperexpertadmin" :). Se adesso riguardiamo la
situazione con ls -al vedo questo :

    drwxrws---+  2 root Prodotti     4096 21 dic 15:46 prodotti

Il segno '+' alla fine indica che nella cartella prodotti sono attive le
estensioni acl posix.

Questa parte non è proprio specifica di Arch, ma serve sopratutto per
capire come anche problemi semplici a volte possono farci traballare e
desistere se non si hanno delle basi. E se ne potrebbe fare una montagna
di esempi come questo, anche qualcuno da cui non se ne esce ... I
manuali di Samba in PDF hanno oltre 1200 pagine, e nessuna scritta per
niente. La cosa divertente è che leggendoli e studiandoli capite pure
come funziona Windows meglio di molti altri. Le ACL Posix sono
importanti e hanno un piacevole effetto collaterale (voluto ovviamente):
'possiamo gestire e cambiare i permessi sulle cartelle anche
direttamente da Windows. Basta collegarsi con "Administrator" sul
dominio da una macchina Windows e con pulsante
destro->proprieta->protezione sulla cartella "prodotti" vedo le
permissions ACL Posix che posso pure cambiare: Samba si occuperà del
comando setfacl corrispondente.

Ma voi preferite la shell vero ?

Conclusioni
===========

Terminiamo qui la parte File Server. Si potrebbe continuare per non sò
quanto, ma tutto quello che potremmo dire sarebbe "Off Topic" in questa
guida incentrata su ArchLinux. Tutto "il di più" sarebbe qualcosa di
cross distro (sì può dire ?) ed esistono già valide guide sul web.
Limitiamoci allora ad una lista di cose che potrebbero risultare utili e
su cui magari sarebbe oppurtuno approfondire in modo autonomo.

Print services
--------------

Non abbiamo minimamente parlato delle condivisioni delle stampanti. Qui
si aprirebbe un altro fronte che coinvolge CUPS e la distribuzione
automatica dei drivers stampante ai client Windows. Samba supporta
questa funzionalità, e il posto migliore dove apprendere questa tecnica
sono le guide ufficiali. Io personalmente non l'ho mai implementato non
per pigrizia ma per le oramai onnipresenti stampanti con scheda di rete
integrata a cui i client inviano direttamente le stampe. Tuttavia una
sbirciatina non fà male.

Client grafici di amministrazione
---------------------------------

Abbiamo già visto come sia possibile da Windows amministrare le
permissions sulle share Samba. Esistono anche delle GUI che ci
permettono di gestire utenti e password in modo semplice, specie se le
opzioni da settare sono un po' esotiche, tipo la scadenza della password
o la lista delle workstation da cui un utente può fare il logon. Ne
esistono diversi, dall'ufficale Samba Web Adiministration Tool (SWAT)
all' LDAP Account Manager. Possiamo usarne anche da Windows, ad esempio
dal mio preferito (forse perchè fatto con Delphi ?) LDAP Admin, allo
User Manager for Domains "ufficiale" fornito da Microsoft (non è uno
scherzo) per amministrare i vari aspetti e flag.

Quota
-----

Altro aspetto interessante è la gestione delle Disk Quota da assegnare
ad utenti e gruppi. Questo, come per le ACL Posix, è un "affare" anche
del file system, oltre che di Samba con il vfs objects = default_quota.

Per installare le utility di gestione usate :

    sudo pacman -S quota-tools

Potete trovare informazioni sulla parte file system su come
amministrarli e configurarli in giro per la rete, ad esempio qui. Per la
parte Samba naturalmente la solita "bibbia" rappresentata dalle guide
ufficiali.

Comandi Samba
-------------

Samba viene fornito con una serie di comandi utili all'amministratore,
da pdbedit per amministrare utenti e gruppi alla pletora dei comandi net
disponibili. Facciamo un paio di esempi, con il comando:

    sudo net rpc rights list -U Administrator

ottengo questo:

        SeMachineAccountPrivilege  Add machines to domain
         SeTakeOwnershipPrivilege  Take ownership of files or other objects
                SeBackupPrivilege  Back up files and directories
               SeRestorePrivilege  Restore files and directories
        SeRemoteShutdownPrivilege  Force shutdown from a remote system
         SePrintOperatorPrivilege  Manage printers
              SeAddUsersPrivilege  Add users and groups to the domain
          SeDiskOperatorPrivilege  Manage disk shares

e vedo i permessi dell'utente Administrator. Potrei voler assegnare una
"right" di amministrazione a qualche altro utente, e questo si fà con i
comandi net rpc right.

Se digito :

    sudo pdbedit -L -v Antonio

Ottengo

    Unix username:        antonio
    NT username:          antonio
    Account Flags:        [UX         ]
    User SID:             S-1-5-21-1491279793-2809991009-2777690449-11012
    Primary Group SID:    S-1-5-21-1491279793-2809991009-2777690449-513
    Full Name:            antonio
    Home Directory:
    HomeDir Drive:        K:
    Logon Script:         antonio.bat
    Profile Path:
    Domain:               MEDE
    Account desc:
    Workstations:
    Munged dial:
    Logon time:           0
    Logoff time:          never
    Kickoff time:         never
    Password last set:    0
    Password can change:  0
    Password must change: 0
    Last bad password   : 0
    Bad password count  : 0
    Logon hours         : FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

che sono tutte le impostazioni assegnate all'utente Antonio e che posso
variare con pdbedit. Gran parte di queste le posso anche amministrare
con il nostro netusermod, ma sicuramente il comando standard è più
completo essendo parte di Samba.

I comandi man net e man pdbedit forniscono le informazioni di cui si ha
bisogno.

Lock sui file
-------------

Stiamo amministrando un server con dei file condivisi, quindi il lock
dei file è cosa vitale. In genere non ci sono problemi, Samba "standard"
ci risolve già gran parte dei problemi, ma in alcuni casi (tipo il
"solito" file access mdb condiviso) dovete metter manina voi. Vi
scontrerete ad esempio con il concetto di "Opportunistic Locking"
inventato da Microsoft per aumentare le performance in rete, ma che in
alcuni casi con Samba non produce gli effetti desiderati. Niente paura,
vanno solo gestiti. Anche in questo caso (son stufo di scriverlo) vi
rimando alla guida ufficiale.

Sicurezza
---------

Non abbiamo nemmeno discusso della messa in sicurezza del colloquio tra
Samba e OpenLDAP che adesso avviene in chiaro. Essendo entrambi i
servizi nella stessa macchina magari il problema e minimo, ma se
cominciate ad avere più server Samba che "puntano" allo stesso server
LDAP o più server LDAP replicati magari in remoto tra sedi diverse è una
opzione da prendere in seria considerazione.

Client Linux
------------

O perbacco ! E i client Linux ? Qualcuno comincerà ad arrivare... Per le
autenticazioni LDAP e le share non credo sia un problema (anche se devo
ogni volta digitare utente e password), ma il logon ad un dominio
Microsoft ? Ho visto solo due distro che lo fanno: SLED e la sua
controparte libera OpenSUSE. Quindi è possibile ma mi sento proprio
impreparato sull'argomento. Fatemi sapere voi magari.

Concludiamo managgia !
----------------------

Dite la verità: Pensavate fosse più semplice. O almeno è quello che ho
pensato io la prima volta che mi sono imbattuto in questi argomenti.
Spero di aver acceso l'interesse di qualcuno che abbia la voglia di
studiare, la rete offre tutto di cui si ha bisogno. E credetemi, se
imparate bene ad amministrare LOS (Linux Openldap Samba) amigos (senza
dimenticare DNS/DHCP) domani (quasi) potete installare una rete con
Windows, perchè i concetti li conoscete (anche più in profondità di
altri), dovete solo scoprire dove fare "click" con il mouse (uaaaah,
questa forse è grossa ma suona bene :)).

Ma che bello era fare "Pulsante destro sulla cartella -> convidi con
nome -> ok " ?

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server_(Italiano)/File_Server_Domain_Controller&oldid=304959"

Category:

-   Small Business Server (Italiano)

-   This page was last modified on 16 March 2014, at 09:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
