Small Business Server (Italiano)/Firewall
=========================================

Un firewall è un sistema designato alla prevenzione di accessi non
autorizzati alla o dalla tua rete privata (che può anche essere solo il
sistema stesso). Possono essere implementati sia con hardware dedicato,
con software o con una combinazione di entrambi. Nel caso che tratteremo
il nostro piccolo server tuttofare sarà il firewall della nostra
azienda. Questa parte è un po' complicata e necessita di tuning per la
messa a punto che dipende dai servizi installati sul nostro server.
Mettetevi il cuore in pace non potete far a meno di un firewall, quindi
studiare, studiare :) I firewall sono utiltizzati in special modo per
prevenire che utenti esterni alla nostra rete possano accedere alla
nostra rete locale, ma anche per l'opposto motivo: prevenire che utenti
"interni" possano accedere a servizi internet non autorizzati.

Ogni messaggio (meglio: ogni pacchetto) che entra o esce dalla nostra
rete sarà analizzato dal firewall che, in base ai criteri di sicurezza
impostati, potrà abilitare (allow) o negare (deny) la richiesta.

Contents
--------

-   1 Shorewall
    -   1.1 Installazione
    -   1.2 Configurazione
        -   1.2.1 /etc/shorewall/interfaces
            -   1.2.1.1 /etc/shorewall/zones
            -   1.2.1.2 /etc/shorewall/policy
            -   1.2.1.3 /etc/shorewall/rules
        -   1.2.2 IP Masquerading (SNAT)
        -   1.2.3 Port Forwarding (DNAT)
    -   1.3 Avvio del servizio
    -   1.4 Problemi ?
    -   1.5 Considerazioni

Shorewall
=========

Shoreline Firewall, più comunemente conosciuto come Shorewall, è un tool
ad alto livello per configurare Netfilter. Le "regole" del firewall sono
descritte usando dei file di configurazione testuale relativamente
semplici da capire ed interpretare nascondendo la complessità insita in
iptables. Shorewall legge questi file di configurazione e, con l'aiuto
dell'utility iptables, configura Netfilter secondo le tue esigenze.
Shorewall può essere utilizzato sia in un sistema dedicato che in un
sistema GNU/Linux standalone. Vista la sua completezza e la sua ottima
documentazione è di certo una ottima soluzione.

Installazione
-------------

Installiamo Shorewall. E' nel repository [community] che dovrebbe essere
attivato in /etc/pacman.conf

    pacman -S shorewall

Pacman provvederà anche ad installare correttamente le dipendenze
iptables e iproute

Configurazione
--------------

Il file di configurazione primario di Shorewall possiamo editarlo così :

    sudo nano /etc/shorewall/shorewall.conf

il file è ben documentato, per il momento controlliamo solo che questi
valori siano corretti :

    IP_FORWARDING=On #Per le funzionalità di gateway
    STARTUP_ENABLED=Yes #Ricordarsi di mettere "Yes" !
    SUBSYSLOCK=/var/lock/shorewall

Shorewall viene fornito con dei file di esempio già quasi pronti
all'uso. i file si trovano in /etc/share/shorewall/Samples. Li possiamo
anche trovare così:

     pacman -Ql shorewall | grep Sample

Noi abbiamo un classico server con due interfacce (eth0 e eth1), dunque
quelli che a noi interessano ti trovano in
/usr/share/shorewall/Samples/two-interfaces e ce li copiamo in
/etc/shorewall :

    sudo cp /usr/share/shorewall/Samples/two-interfaces/* /etc/shorewall/

Ora bisogna leggere la relativa guida per configurare correttamente i
file. Leggere con attenzione la guida, è molto importante!. Comunque
possiamo fare un semplice sunto della questione andando a vedere i file
di configurazione che ci servono.

> /etc/shorewall/interfaces

Qui devo definire gli "alias" delle mie interfacce che poi saranno usati
negli altri file di configurazione. Per noi sarà così :

    #ZONE   INTERFACE BROADCAST        OPTIONS
    net     eth1      detect           tcpflags,nosmurfs
    loc     eth0      detect           dhcp,tcpflags,routefilter,nosmurfs,logmartians

Quindi da questo momento la mia scheda "interna" la chiamerò 'loc',
quella esterna 'net'. Per le opzioni si veda la guida.

/etc/shorewall/zones

Shorewall vede la rete dove sta girando come composta da zone. nella
configurazione di esempio two-interface sono usate i seguenti nomi di
zona definiti nel file /etc/shorewall/zones :

    #ZONE   TYPE     OPTIONS                 IN                      OUT
    ##                                       OPTIONS                 OPTIONS
    fw      firewall
    net     ipv4
    loc     ipv4

Notate che Shorewall assegna una zona anche al firewall stesso: quando
il file /etc/shorewall/zones viene processato, il nome della zona
firewall viene memorizzato nella variabile shell $FW che può essere
usata per riferirsi al firewall nei file di configurazione.

Quindi abbiamo (anzi era già ok) tre zone:

    net -> internet
    fw -> il firewall ossia il server stesso
    loc -> la rete locale

Ricordiamoci questo, perchè quando definiremo le regole (Rules) per
abilitare (allow) o negare (deny) il traffico tra le interfacce faremo
sempre riferimento alle zone. Ad esempio voglio collegarmi al server
dalla rete locale via ssh ? Dovrò creare una regole apposita da loc ->
fw. Oppure voglio accedere a internet dal firewall stesso ? Dovrò creare una regola da fw
-> net

/etc/shorewall/policy

Questo file serve per le policy di dafault del nostro server. In file è
autodocumentato e dovrei capire il meccanismo che usa shorewall per
configurare il firewall. Ad esempio contiene :

    #SOURCE    DEST        POLICY      LOG LEVEL    LIMIT:BURST
    loc        net         ACCEPT
    net        all         DROP        info

La zona "all" non esiste in /etc/shorewall/zones, viene usata per
riferirsi a tutte le zone. Dunque di dafault il mio firewall farà
passare il traffico dalla rete interna a internet (loc net ACCEPT) e
bloccherà tutto quello che arriva dall'esterno. Per abilitare il
server/firewall ad accedere a internet (altrimenti non funzioneranno
nemmeno gli aggiornamenti!!) e i pc della rete locale ad accedere ai
servizi del server devo aggiungere/modificare queste policy :

    #SOURCE    DEST        POLICY      LOG LEVEL    LIMIT:BURST
    $FW        net         ACCEPT
    loc        $FW         ACCEPT
    $FW        loc         ACCEPT

Ora anche il mio server può collegarsi a internet, e dalla rete locale
posso collegarmi al server (ad esempio con ssh).

/etc/shorewall/rules

In questo file vengono definite le eccezioni alle policy di dafault
definite in /etc/shorewall/policy Editando il file possiamo notare che
si commenta da solo. Solo un appunto. Questo file fà uso delle
cosiddette macro, delle configurazioni predefinite che shorewall
fornisce già pronte. Le posso vedere in /usr/share/shorewall e sono
tutti quei file che iniziano con "macro.". Ad esempio guardiamo
macro.DNS e macro.HTTP :

    #ACTION SOURCE  DEST    PROTO   DEST    SOURCE  ORIGINAL        RATE    USER/
    ##                              PORT    PORT(S) DEST            LIMIT   GROUP
    PARAM   -       -       udp     53
    PARAM   -       -       tcp     53
    #LAST LINE -- ADD YOUR ENTRIES BEFORE THIS ONE -- DO NOT REMOVE

    #ACTION SOURCE  DEST    PROTO   DEST    SOURCE  ORIGINAL        RATE    USER/
    ##                               PORT    PORT(S) DEST            LIMIT   GROUP
    PARAM   -       -       tcp     80
    #LAST LINE -- ADD YOUR ENTRIES BEFORE THIS ONE -- DO NOT REMOVE

vediamo che shorewall definisce per il DNS le porte UDP e TCP 53 così
nel mio file di configurazione basta che metta:

    #ACTION         SOURCE          DEST            PROTO   DEST    SOURCE
    DNS/ACCEPT      $FW             net
    HTTP/ACCEPT     loc             $FW

Anzichè

    #ACTION         SOURCE          DEST            PROTO   DEST    SOURCE
    ACCEPT          $FW             net             tcp     53
    ACCEPT          $FW             net             udp     53
    ACCEPT          loc             $FW             tcp     80

Per ultimo blocchiamo il PING dall'esterno e lo abilitiamo all'interno:

    Ping/ACCEPT     loc             $FW
    Ping/REJECT     net             $FW
    ACCEPT          $FW             loc             icmp
    ACCEPT          $FW             net             icmp

Comodo e più facile da leggere :)

> IP Masquerading (SNAT)

Le reti delle classi

-   192.168.0.0
-   172.16.0.0 - 172.31.0.0
-   10.0.0.0

sono riservate alle reti locali e non vengono instradate mai su
internet. Per permettere ad uno dei nostri utenti sulla rete locale di
connettersi ad un host su internet deve intervenire il firewall facendo
credere all'host remoto che la richiesta arrivi da lui. Quando riceve
risposta dall' host remoto il firewall gira i pacchetti sul computer
interno che ha generato la richiesta. Questo processo prende il nome di
"Network Address Translation (NAT)".

Nei sistemi GNU/Linux, questo processo è anche conosciuto come "IP
Masquerading" oppure a volte è usato anche il termine "Source Network
Address Translation (SNAT)". Shorewall segue la seguente convenzione con
Netfilter:

-   Masquerade descrive il caso in cui il firewall trova automaticamente
    l'indirizzo dell'interfaccia esterna
-   SNAT il caso in cui viene specificato in modo esplicito l'indirizzo

In Shorewall, entrambi Masquerading e SNAT sono configurati con il file
/etc/shorewall/masq. Normalmente si usa Masquerading se l'indirizzo
dell'interfaccia esterna eth1 ha un indirizzo IP dinamico e SNAT se
l'indirizzo IP è statico.

Per noi il file /etc/shorewall/masq dovrebbe essere così :

    #INTERFACE              SOURCE          ADDRESS
    eth1                    eth0            

Se l'indirizzo esterno è statico lo possiamo inserire nella terza
colonna del file /etc/shorewall/masq. Probabilmente funzionerà lo stesso
anche omettendo questa configurazione ma il processo SNAT (specificando
l'indirizzo) dovrebbe essere più efficente.

Naturalmente le possibilità sono molte, come ad esempio permettere sono
a determinati host di navigare su internet, oppure specificare
particolari porte. Per i dettagli vi rimando alla guida di shorewall.

> Port Forwarding (DNAT)

Spesso capita di dover "girare" le richieste sulle porte del firewall ad
una macchina interna della nostra rete. Supponiamo ad esempio di avere
un web server sulla macchina interna con IP 192.168.20.10 che vogliamo
far raggiungere dall'esterno quando "puntano" il browser sul mio
server/firewall sulla posta 8080. Basta mettere in
/etc/shorewall/rules :

    DNAT        net        loc:192.168.20.10:80        tcp        8080

Cosa c'e' di più facile ? :D

Avvio del servizio
------------------

Prima assicuriamoci che il parametro del file
/etc/shorewall/shorewall.conf

    STARTUP_ENABLED=Yes

sia correttamente impostato, poi posso avviare il firewall in due modi.
Con il classico

    sudo /etc/rc.d/shorewall start

Oppure con la sua utility

    sudo shorewall start

La sua utility ha anche funzionalità aggiuntive come ad esempio

    sudo shorewall status

che mi mostra lo stato del firewall. Diamo un occhio alle altre opzioni
(reset, save, show ...) che vedo con

    sudo shorewall --help

che sono utilissime in fase di definizione delle regole. Solo a
configurazione ultimata lo posso far partire nel modo tradizionale. Se
non ricevo messaggi di errore è giunta l'ora di mettere anche shorewall
nella riga "DAEMONS" del file /etc/rc.conf

    DAEMONS=(... ... ... ... ... shorewall ... ... ...)

così ad ogni riavvio del server il mio firewall sarà up and running.

Problemi ?
----------

A volte si pastrocchia un po' con shorewall, ma spesso basta dare un
occhio al file di LOG :

    sudo tail -f /var/log/iptables.log

mentre si tenta "qualcosa". Vedrete subito i motivi del blocco.

Considerazioni
--------------

Come già detto questa materia è complessa e và posta in opera con
cognizione di causa. Spesso una errata configurazione del firewall
pregiudica il funzionamento di altri servizi o, peggio, ci si espone a
pericoli (informatici, ovvio) inutili. Qualcuno storcerà in naso per la
soluzione adottata, cioè ogni buon amministratore di rete raramente fà
coincidere il firewall con il server aziendale optando per un hardware
esterno. Giusto. Ma questo esula dallo scopo di questa (breve) guida.
Chi acquista dimestichezza con la materia non avrà nessuna difficoltà a
farlo da sè, sia che opti per soluzioni software che hardware dedicate.
Il consiglio che posso dare è (se possibile) disabilitare shorewall
quando si prova un nuovo servizio per escludere problemi riconducibili
ad un errato filtraggio dei pacchetti. Ad esempio se installo Samba e mi
dimentico di permettere il traffico sulle sue porte tra il firewall e la
rete locale inutile dire che non funzionerà un tubo. Quindi occhio: è
fondamentale saper leggere i log di sistema per individuare i problemi !

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server_(Italiano)/Firewall&oldid=143718"

Category:

-   Small Business Server (Italiano)

-   This page was last modified on 2 June 2011, at 22:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
