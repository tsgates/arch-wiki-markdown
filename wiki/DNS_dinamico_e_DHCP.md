Small Business Server (Italiano)/DNS dinamico e DHCP
====================================================

Contents
--------

-   1 DNS Dinamico e DHCP
    -   1.1 Installazione
    -   1.2 Configurazione
    -   1.3 Avvio del servizio

DNS Dinamico e DHCP
===================

I servizi DNS (Domain Name System) e DHCP (Dynamic Host Configuration
Protocol) oramai da tempo sono diventati una soluzione obbligata in una
rete locale, e considerando che i nostri client di rete saranno tutti (o
quasi) Windows XP che utilizzano il DNS come protocollo primario di
risoluzione dei nomi sulla rete, non possiamo assolutamente
tralasciarli. Vi è mai capitata una rete di PC peer to peer con Windows
XP e accesso ad internet condiviso in cui il browsing della rete locale
era lentissimo ? A me parecchie volte, ed è uno dei motivi per cui non
ci si dovrebbe cimentare in queste cose senza capire quello che si stà
facendo. Il browsing della rete era lentissimo perchè XP prima interroga
il DNS per conoscere il nome dell'host e solo dopo usa il suo simpatico
broadcast o il file HOSTS. Bene, considerate che il DNS della rete era
quello del provider e comincerete a capire perchè era così lento ... :D.
In GNU/Linux i pacchetti che la fanno da padrone in questo campo sono
bind e dhcpd, ma data la semplice natura della nostra rete optiamo per
un pacchetto più semplice che integra tutto quello che ci server: DNS
dinamico, DHCP e Caching. Ottenere la stessa cosa con bind e dhcpd è un
po' più complicato e magari ci torneremo su. Il pacchetto che
utilizzeremo si chiama dnsmasq e offre, ma non solo, le seguenti
funzionalità :

-   La configurazione del DNS di macchine "dietro" al firewall è
    semplice e non dipende dai DNS del provider.
-   I client che interrogano il DNS quando, ad esempio, il collegamento
    internet non è disponibile ricevono immediatamente il timeout, senza
    inutili attese.
-   Dnsmasq ricava i nomi dal file /etc/hosts file del firewall: se il
    nome della macchina locale richiesta viene trovato, si viene
    immediatamente indirizzati alla stessa senza il bisogno di mantenere
    il file hosts in ogni macchina.
-   Il servizio DHCP server integrato supporta DHCP leases statici e
    dinamici e IP ranges multipli. Le macchine configurate con DHCP
    vengono automaticamente inserite nel DNS, e i nomi possono essere
    specificati in ogni macchina o centralmente associando il nome al
    MAC address nel file di configurazione di dnsmasq.
-   Dnsmasq esegue il caching degli indirizzi internet (A records e AAAA
    records e PTR records), aumentando le performance della rete.
-   Dnsmasq supporta i records di tipo MX e SRV e può essere configurato
    per fornire il record MX per alcune o tutte le macchine della rete
    locale.

Installazione
-------------

Il pacchetto (tanto per cambiare) lo si installa così:

    sudo pacman -S dnsmasq dnsutils

Configurazione
--------------

Editiamo il file di configurazione :

    sudo nano /etc/dnsmasq.conf

Il file è ben commentato. Impostiamo i seguenti parametri :

    addn-hosts=/etc/dnshosts
    no-hosts
    local=/mede.it/
    interface=eth1
    expand-hosts
    domain=mede.it
    dhcp-range=192.168.20.50,192.168.20.150,12h
    dhcp-option=option:router,192.168.20.1
    dhcp-option=44,192.168.20.1  # set netbios-over-TCP/IP nameserver(s) aka WINS server(s)
    dhcp-option=45,192.168.20.1  # netbios datagram distribution server
    dhcp-option=46,8             # netbios node type
    dhcp-option=47               # empty netbios scope.
    dhcp-option=6,192.168.20.1
    mx-host=archi.mede.it,50
    mx-target=archi.mede.it
    localmx
    log-queries
    log-dhcp

Per vedere tutti i parametri "dhcp-options" possibili eseguite il
comando :

    dnsmasq --help dhcp

Per le spiegazioni sui singoli parametri fate riferimento alla guida in
linea

    man dnsmasq

oppure ai commenti dello stesso file di configurazione.

Ora modifichiamo il nostro file /etc/resolv.conf

    sudo nano /etc/resolv.conf

che deve contenere i DNS che il server interroga, cioè se stesso e in
seconda battuta il DNS del provider di cui farà la cache (ad esempio
151.99.125.1)

    search mede.it
    nameserver 127.0.0.1
    nameserver 151.99.125.1

Se voglio utilizzare degli indirizzi statici basta inserirli nel file
/etc/dnshosts (come speficato dal parametro addn-hosts) nella solita
forma (senza dominio, quello lo fornisce dnsmasq) che si usa per il file
/etc/hosts. Ad esempio mettiamo il nostro server principale (a cui diamo
anche i nomi "mail" e "proxy" ad esempio) e un altro con IP fisso :

    192.168.20.1  archi mail proxy
    192.168.20.2  myserver

dnsmasq fornirà la risoluzione anche di myserver o myserver.mede.it a
tutte le macchine della rete.

Non uso il predefinito file /etc/hosts usato da dnsmasq per evitare che
il DNS si metta a risolvere anche i nomi "privati" che potrei mettere
qui, tipo ad esempio localhost.

Avvio del servizio
------------------

Ora possiamo avviare il servizio:

    sudo /etc/rc.d/dnsmasq start

e modificare la riga DAEMONS aggiungendo dnsmasq

    DAEMONS=(... ... ... ... ... dnsmasq ... ... ...)

Fatto ! Il mio DNS/DHCP è bello che pronto. Alle macchine della rete
verrà fornito un indirizzo IP, il gateway, il DNS e il WINS tramite
DHCP. Nello stesso momento verrà registrata sul DNS, così tutte le altre
macchine potranno puntare in modo univoco alla stessa senza più
preoccuparsi dell'indirizzo fisico TCP/IP.

Posso visualizzare gli indirizzi IP che dnsmasq rilascia visualizzando
il file:

    sudo cat /var/lib/misc/dnsmasq.leases

Finalmente il nostro server comincia a servire a qualcosa :)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server_(Italiano)/DNS_dinamico_e_DHCP&oldid=143704"

Category:

-   Small Business Server (Italiano)

-   This page was last modified on 2 June 2011, at 22:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
