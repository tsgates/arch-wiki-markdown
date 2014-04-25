Small Business Server (Italiano)/Operazioni Preliminari
=======================================================

Arch Linux su di un server ? E perchè no ? La sua semplicità di gestione
unita al fatto che solo i servizi necessari saranno installati e
configurati, secondo me fanno di Arch una ottima soluzione lato server.
In questa serie di articoli installeremo e configureremo un piccolo (ma
neanche tanto) server tuttofare basandoci sulla nostra ditribuzione
preferita. Mettiamoci comodi ed iniziamo con le operazioni preliminari.

Contents
--------

-   1 Operazioni Preliminari
    -   1.1 Convenzioni
-   2 Preparare il sistema
    -   2.1 Aggiornamento pacchetti
        -   2.1.1 Pacchetti aggiuntivi indispensabili
            -   2.1.1.1 yaourt
            -   2.1.1.2 cpan4pacman
        -   2.1.2 Rimozione pacchetti inutili
-   3 Amministrazione remota con OpenSSH
    -   3.1 Installazione
    -   3.2 Configurazione
    -   3.3 Configurazione schede di rete
-   4 Sudo
    -   4.1 Introduzione
    -   4.2 Il comando sudo
    -   4.3 Creazione di un utente amministrativo
    -   4.4 Installazione di sudo
    -   4.5 Configurazione
    -   4.6 Disabilitare l'utente root
-   5 Operazioni aggiuntive

Operazioni Preliminari
======================

Iniziamo la configurazione del nostro Arch Linux SBS con delle
operazioni preliminari per rendere la nostra box pronta al via.

Convenzioni
-----------

-   eth0 sarà la scheda ethernet collegata alla nostra LAN. Verrà
    fornita di un indirizzo IP statico.
-   eth1 sarà la scheda ethernet collegata a internet (o alla WAN). Avrà
    un indirizzo IP statico (se disponibile) o assegnato dal provider
    con DHCP. Attenzione: se volessi configurare la mia box come server
    VPN un indirizzo statico è consigliato.
-   192.168.20.0/24 è la mia rete interna
-   192.168.20.1 è l'indirizzo IP statico assegnato a eth0
-   il nostro server si chiama archi (che fantasia!)
-   il nostro dominio sarà mede.it
-   il nostro utente amministrativo sarà admin

Iniziamo a preparare il nostro archi.mede.it :)

Preparare il sistema
====================

Aggiornamento pacchetti
-----------------------

Prima di iniziare rendiamo la nostra installazione aggiornata alle
ultime versioni dei pacchetti disponibili.

    pacman -Syu

> Pacchetti aggiuntivi indispensabili

yaourt

yaourt è un pacchetto che, con una sintassi uguale a pacman, ci permette
di installare direttamente anche da AUR. Naturalmente questa opzione và
usata con cautela, ma nel proseguo della nostra guida ci sarà
indispensabile. Creiamo una directory "yaourt" nella home e
posizioniamoci ("mkdir yaourt" e cd "yaourt" insomma) e scarichiamo i
files necassari :

    pacman -S diffutils
    wget https://aur.archlinux.org/packages/yaourt/yaourt/PKGBUILD
    wget https://aur.archlinux.org/packages/yaourt/yaourt/yaourt.install

e creiamo il pacchetto :

    makepkg

finita l'installazione vi troverete il pacchetto pronto. Installiamolo
con

    pacman -U yaourt-0.8.4-1-i686.pkg.tar.gz

ora abbiamo il pacchetto pronto all'uso.

Per utilizzare anche gli ultimi aggiornamenti CVS/SVN/mercurial
installiamo anche versionpkg

    pacman -S versionpkg

cpan4pacman

Questo non è che è indispensabile, ma molto utile sì. Questo pacchetto
fà qualcosa di simpatico: scarica i moduli perl che gli indichiamo da
CPAM e li trasforma in pacchetti per Arch. Il che, ripeto, non è che sia
proprio indispensabile, ma molto utile per mantenere solo software
pacchettizzato sulla nostra box questo sì.

    pacman -S perl-cpanplus-pacman

Appena finito di installare dobbiamo aggiornare il nostro albero ABS :

    pacman -S cvsup abs
    abs core extra community

e creare il database dei moduli perl disponibili nei repositories di
Arch Linux.

    cpan4pacman --abs-cache

Ora sarà possibile creare il pacchetto della libreria perl con (esempio
Net::Server) :

    cpan4pacman Net::Server

Molto utile, ci servirà.

> Rimozione pacchetti inutili

Facciamo "dimagrire" il più possibile la nostra installazione rimuovendo
tutti i pacchetti per noi inutili. Meno pacchetti significa meno
problemi di sicurezza e maggior velocità negli aggiornamenti. Perchè
tenere quello che non mi serve ? Cominciamo con eliminare eventuali
pacchetti orfani, pacchetti, cioè, che non sono utilizzati da nessuno e
che possono quindi essere fatti scomparire.

Comuque diamo prima un occhio ai nostri pacchetti orfani :

    pacman -Qe | less

Se ci sono dubbi con un

    pacman -Qi <nome pacchetto>

ho delle info aggiuntiva sullo stesso. Spariti i miei dubbi eliminiamo
tutti gli orfani (si fà per dire :D)

    pacman -Qer

Ora potrei eliminare tutti quei pacchetti che non mi servono, una buona
lista da cui partire potrebbe essere questa :

-   hwd: Dal momento che conosco il mio hardware ...
-   lshwd: una dipendenza di hwd
-   pcmciautils: Non credo che il nostro server utilizzi hardware
    PCMCIA/Cardbus.
-   grub / lilo: Eliminiamo quello che non viene usato.
-   nano / vim: Tenete il vostro editor preferito. Se siete come me che
    non ha mai imparato ad usare vim (vergogna!), rimuovetelo e tenetevi
    nano. Tanto per complicare le cose io uso joe come editor ..
-   raidtools: serve solo se utilizzate RAID. Altrimenti raus !
-   e2fsprogs / jfsutils / reiserfsprogs / xfsprogs: tenere solo il
    pacchetto corrispondente al filesystem usato.
-   wireless_tools: se non intendete fare un wireless gateway
    rimuovetelo pure.

Per rimuoverli completamente :

    pacman -Rn pacchetto1 pacchetto2 pacchetto3

Amministrazione remota con OpenSSH
==================================

Se vogliamo amministrare remotamente il nostro server dobbiamo
installare e configurare openssh. Non vorrete mica ogni volta andare
davanti alla console ! :D

Installazione
-------------

Installazione e avvio del servizio :

    pacman -S openssh

    /etc/rc.d/sshd start

Se ora tento di connettermi da un'altra macchina via rete ottengo un bel
"Connection refused". Devo editare il file /etc/hosts.allow e aggiungere
gli hosts abilitati. Per ora (orrore!) abilitiamo tutti:

    nano /etc/hosts.allow

e aggiungiamo la riga :

    sshd sshd1 sshd2 : ALL : allow

Ora qualunque host/Indirizzo IP può tentare di connettersi remotamente.
Non è una buona idea, internet è pieno di "cattivi" meglio ridurre al
minimo i rischi.

Configurazione
--------------

Per ridurre (magari si potesse azzerarli) i rischi di sicurezza editiamo
il file di configurazione :

    nano /etc/ssh/sshd_config

e inseriamo (o togliamo il commento) almeno queste voci:

    #Cambiamo la porta di default (da 22 a 2223) e accettiamo solo connessioni dalla rete interna
    #Se, come capita spesso, dovete remotamente amministrare il vostro server da internet mettete solo Port 2223
    #a questo punto scegliete una password "robusta" per il vostro utente amministratore
    ListenAddress 192.168.10.1:2223
    #Abilitiamo solo il nostro utente a collegarsi (esempio admin da ovunque, foobar solo dall'host 192.168.10.20)
    AllowUsers admin foobar@192.168.10.20
     #Rifiutiamo le connessioni con l'utente root. Meglio usare admin e poi su se non ho abilitato sudo
    #Se ho installato sudo e disabilitato root non serve
    DenyUsers root
    PermitRootLogin no
    #Abilita solo il protocollo ssh2 molto più sicuro di ssh1
    Protocol 2

e riavviamo il servizio con

    /etc/rc.d/sshd restart

Ora non ci resta che editare il nostro rc.conf per abilitare il daemon
sshd ad ogni riavvio:

    nano /etc/rc.conf

e modificare la riga DAEMONS aggiungendo sshd

    DAEMONS=(... ... ... ... ... sshd ... ... ...)

Notare che cambiare la porta d'ascolto di sshd è fondamentale per la
sicurezza del nostro sistema. Infatti, praticamente qualunque macchina
esposta su Internet è soggetta ad attacchi di tipo brute force ssh
utilizzando vari nomi utente (tra cui root, rootroot, oracle, admin,
temp, devel o nomi propri di persona).

Configurazione schede di rete
-----------------------------

Anche se non c'entra con OpenSSH, preparamo le schede di rete con la
configurazione che ci servirà: editiamo ancora una volta il nostro
/etc/rc.conf e nella sezione network config impostiamo gli indirizzi IP.
Ne nostro esempio per la rete interna connessa a eth0 la classe C
completa :

-   network address : 192.168.20.0
-   gateway : 192.168.20.1
-   netmask : 255.255.255.0
-   broadcast : 192.168.20.255

    lo="lo 127.0.0.1"
    eth0="eth0 192.168.20.1 netmask 255.255.255.0 broadcast 192.168.20.255"
    eth1="dhcp"

Nell'esempio eth1 dispone di un indirizzo IP dinamico assegnato dal
provider (o dal router DSL, o da quello che avete). Se disponiamo di un
indirizzo statico inseriamolo qui nella riga "eth1".

Sudo
====

Introduzione
------------

Nei sistemi operativi Unix/Linux c'è un utente particolare, detto super
utente e contraddistinto dall'avere un UID (User ID) uguale a 0 e nome
utente root, che ha totale accesso al sistema senza nessuna restrizione,
è l' amministratore del sistema.

Nella maggior parte dei sistemi GNU/Linux, l'amministratore del computer
non usa l'utente amministratore (per motivi di sicurezza) ma usa un
utente normale per svolgere il lavoro quotidiano. Quando ha la necessità
di svolgere mansioni di amministrazione apre un terminale e avvia una
sessione come utente root, oppure se si trova già in un terminale come
utente normale usa il comando su per diventare utente root.

Io preferisco usare un approccio diverso per svolgere mansioni
amministrative, basato sull'utilizzo del comando sudo. Qui esistono
diverse scuole di pensiero in merito alla sicurezza di sudo rispetto a
su.

In ognuno dei due modelli, sudo e su, ci sono vantaggi e svantaggi.

Siccome sudo costringe l'esecuzione controllata di singoli comandi ha
questi vantaggi:

-   Riduce il tempo in cui gli utenti sono nel sistema come root e
    quindi riduce i rischi di lanciare inavvertitamente comandi dannosi
    per il sistema.
-   Aumenta la possibilità di ricerca e analisi sul sistema grazie al
    log dei comandi.

Di contro, se qualcuno scopre la password di un utente abilitato
all'utilizzo di sudo come root in effetti può ottenere accesso come
root. Nel caso di utilizzo di sudo bisogna prestare una maggiore
attenzione alla scelta della password utente. I sostenitori del modello
su, cioè account di root abilitato e utilizzo di una shell di root per
compiti amministrativi, sostengono che su sia più sicuro in quanto il
livello di root si ottiene dopo l'inserimento di due password, la
password utente e la password di root. D'altra parte, chi cerca di
entrare in un sistema ha la necessità di scoprire due cose, il nome
utente e la password. Con l'account di root abilitato, una delle due è
già nota, serve solo scoprire la password. Con sudo si devono scoprire
entrambe (nome utente e password). Quando in un sistema alcuni compiti
amministrativi sono assegnati a vari utenti, l'utilizzo di sudo evita di
dover dare la password di root a più utenti. L'amministratore può
assegnare a qualsiasi utente, temporaneamente, privilegi particolari,
eliminandoli o limitandoli quando non vi è più necessità.

Il comando sudo
---------------

sudo (superuser do) consente di eseguire un comando come se si fosse un
altro utente. Effettua una specie di sostituzione, previa
autorizzazione, tra l'utente attuale (colui che esegue il comando sudo)
e l'utente target (colui che esegue l'effettivo comando). Mentre con il
comando su si cambia utente fino al termine della sessione del
terminale, sudo assegna i privilegi dell'utente target al solo processo
(e ai suoi processi figli) che viene con esso avviato.

Per eseguire dei comandi con privilegi d'amministrazione è sufficiente
digitare sudo e successivamente il comando che si desidera eseguire come
utente root, come nel seguente esempio:

    sudo nano /etc/rc.conf

Una volta digitato il comando, il sistema chiederà la password
dell'utente attuale e non la password dell'utente target. La password
viene chiesta la prima volta e memorizzata per un certo lasso di tempo,
quindi è possibile usare il comando sudo più volte consecutive senza
dover inserire ogni volta la password.

Con sudo l'amministratore del sistema può assegnare privilegi
particolari a qualsiasi utente, definire quali comandi far eseguire e
quali no e avere il log (/var/log/auth.log) di tutte le operazioni
effettuate su tentativi di accesso non autorizzati.

Creazione di un utente amministrativo
-------------------------------------

A me piacciono i sistemi "rootless", cioè privi dell' utente "root" che
tanti problemi di sicurezza può causare. Quindi creiamo un utente
amministrativo con una solida password. In seguito a questo utente
assegneremo privilegi particolari per poter disabilitare root e
amministrare il sistema. Siccome sono a corto di idee chiamo questo
utente "admin"

    adduser admin

Lasciamo le impostazioni di default e assegniamo una bella password che
naturalmente non si deve dimenticare e proseguiamo.

Installazione di sudo
---------------------

Per installare sudo :

    pacman -S sudo

Configurazione
--------------

Per abilitare il nostro utente "admin" a svolgere i compiti
amministrativi utilizzando sudo devo aggiungerlo al file /etc/sudoers.
Per editare questo file devo utilizzare il comando :

    visudo

che apre il file utilizzando l'editor vim (che io conosco ben poco...).
visudo controlla quanto scrivete su questo importantissimo file evitando
possibili errori di sintassi. Se volete utilizzare nano, o un altro
editor, il comando da lanciare è:

    EDITOR=nano visudo

-   spostatevi nella sezione "User privilege specification" ci dovrebbe
    essere una riga con 'root'
-   premete il tasto i (insert) create una riga vuota e scrivete :

    admin ALL=(ALL) SETENV: ALL

-   premete ESC (con cui uscite dal modo insert)
-   digitate :x per salvare e uscire

Ora l'utente "admin" dovrebbe essere abilitato al comando "sudo". Prima
di proseguire provate a loggarvi sulla console con l'utente admin e poi
provate, ad esempio:

    sudo nano /etc/rc.conf

dopo aver digitato la password di admin provate a salvare il file, se
non vi dà errore tutto è filato liscio.

Disabilitare l'utente root
--------------------------

Quando siete sicuri che admin abbia i privilegi di amministrazione
attraverso sudo possiamo disabilitare l'utente root:

    sudo passwd -l root

In caso di pentimento potete riabilitarlo con:

    sudo passwd root

Il nostro sistema "rootless" è pronto. Da ora in avanti ci loggheremo
alla console con il nostro utente admin e utilizzeremo sudo per i
compiti amministrativi.

Operazioni aggiuntive
=====================

Per terminare questa sezione preliminare non dimenticate di :

-   assegnare un nome al vostro server (sempre su /etc/rc.conf, ma serve
    dirlo ?)
-   aggiungere il nome del server al file /etc/hosts accanto a localhost

    127.0.0.1 localhost archi

-   impostare il nome del dominio ed eventualmente il DNS nel caso non
    vi venga assegnato dal provider in /etc/resolv.conf

    search mede.it
    nameserver xxx.xxx.xxx.xxx

Bene. Terminate le operazioni prelimiari non abbiamo ancora fatto
niente :D.

Ma chi ben inizia ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server_(Italiano)/Operazioni_Preliminari&oldid=211058"

Category:

-   Small Business Server (Italiano)

-   This page was last modified on 24 June 2012, at 09:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
