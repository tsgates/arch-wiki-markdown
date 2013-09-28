Internet key Momo Design
========================

  ------------------------ ------------------------ ------------------------
  [Tango-preferences-deskt This article or section  [Tango-preferences-deskt
  op-locale.png]           needs to be translated.  op-locale.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Il Momo design è un 3.5G HSDPA USB modem usato per la navigazione in
internet. La sua installazione può risultare un po' ostica su linux
visto che i produttori non rilasciano driver specifici per linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Prima di tutto                                                     |
| -   3 Connessione con wvdial                                             |
|     -   3.1 Packages                                                     |
|     -   3.2 Scripting                                                    |
|     -   3.3 Connessione                                                  |
|                                                                          |
| -   4 Connessione con ppp                                                |
|     -   4.1 Configurazione                                               |
|     -   4.2 Connessione                                                  |
|                                                                          |
| -   5 Regolazione dei dettagli                                           |
|     -   5.1 Verifica dello stato della connessione                       |
|                                                                          |
| -   6 Links                                                              |
+--------------------------------------------------------------------------+

Hardware
========

Nel momento della connessione al pc dovremmo vedere con dmesg quanto
segue:

    cdc_acm 2-1:1.0: ttyACM0: USB ACM device
    usbcore: registered new interface driver cdc_acm
    cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters

Questo significa che il nostro modem sta lavorando su ttyACM0, una porta
virtuale, ed è qui che dovremo configuarlo.

Prima di tutto
==============

Accertarsi di avere installato pppd

    # pacman -Qs ppp
    local/ppp 2.4.4-9 (base)
    A daemon which implements the PPP protocol for dial-up networking

avviare il modulo ppp-generic inserendolo nell'apposita riga di
/etc/rc.conf

    MODULES=(nvidia ppp-generic !usblp option) 

modificare il file /etc/resolv.conf con i vostri server DNS oppure
quelli open come nell'esempio

    nameserver 208.67.222.222
    nameserver 208.67.220.220

Per rendere persistente la modifica anche dopo il riavvio

    chattr +i /etc/resolv.conf

Connessione con wvdial
======================

Packages
--------

Installiamo il pacchetto wvdial se non è già presente

    # pacman -S wvdial

Scripting
---------

Andiamo a creare o modificare se esiste già il file /etc/wvdial.conf con
il nostro editor preferito

    [Dialer Defaults]
    Modem = /dev/ttyACM0
    ISDN = off
    Modem Type = Analog
    Modem Baud = 460800
    Init2 = ATX3
    Init3 = AT+COPS?
    Init4 = AT+CGDCONT=1,"ip","datacard.tre.it"
    Phone = *99#
    Dial Attempts = 1
    Dial Command = ATM1L3DT
    Ask Password = off
    Password = tre
    Username = tre
    Auto Reconnect = off
    Abort on Busy = off
    Carrier Check = on
    Check Def Route = on
    Abort on No Dialtone = on
    Stupid Mode = on
    Idle Seconds = 0
    Auto DNS = off

L'esempio è per una connessione mediante provider 3 (modificare se
necessario le seguenti righe)

    Init4 = AT+CGDCONT=1,"ip","datacard.tre.it"
    Phone = *99#
    Password = tre
    Username = tre

Connessione
-----------

Ora lanciando da root il comando wvdial dovremo effettuare la
connessione.

    # wvdial

Se non funzione provare da un altro terminale a dare il seguente comando
per instradare le richieste verso internet su ppp0.

    # ip route add default dev ppp0

Connessione con ppp
===================

Configurazione
--------------

Creiamo uno script che chiameremo /etc/ppp/peers/conn3 con questi dati
all'interno (scopiazzato da qui)

    #!/bin/bash                                                                                                              
    /dev/ttyACM0   #If using cdc-acm module                                                                                  
    #demand         #Connessione a richiesta                                                                                 
    debug        # Comment this off, if you don't need more info                                                             
    # scripts to initialize the 3G / EDGE / GPRS modem                                                                       
    connect '/usr/sbin/chat -v -f /etc/ppp/peers/connect-chat'                                                               
    # AT commands used to 'hangup' the connection                                                                            
    disconnect '/usr/sbin/chat -v -f /etc/ppp/peers/disconnect-chat'                                                         
    460800      # Serial port line speed                                                                                     
    crtscts    # hardware flow control for cable                                                                             
    local        # Ignore carrier detect signal from the modem:                                                              
    lcp-echo-failure 0
    lcp-echo-interval 0
    # IP addresses:
    :0.0.0.0
    # - accept peers idea of our local address and set address peer as 10.6.6.6
    # (any address would do, since IPCP gives 0.0.0.0 to it)
    # - if you use the 10. network at home or something and pppd rejects it,
    # change the address
    noipdefault        # pppd must not propose any IP address to the peer!
    ipcp-accept-local    # Accept peers idea of our local address
    defaultroute        # Add the ppp interface as default route to the IP routing table
    #replacedefaultroute    # New route should be our default route to Internet
    #usepeerdns        # User DNS returned by server
    noauth            # The phone is not required to authenticate
    # Most phone do not support compression, so turn it off.
    noipv6
    novj
    nobsdcomp
    novjccomp
    nopcomp
    noaccomp
    # Username and password:
    # If username and password are required by the APN, put here the username
    # and put the username-password combination to the secrets file:
    # /etc/ppp/pap-secrets for PAP and /etc/ppp/chap-secrets for CHAP
    # authentication. See pppd man pages for details.
    user "tre"        # Change this
    persist            # Persistent connection
    maxfail 99999        # Retry and retry and retry if failed...

Creiamo o modifichiamo /etc/ppp/pap-secrets

    # Secrets for authentication using PAP
    # client        server  secret                  IP addresses
    tre     *       tre

Sempre presupponendo che la connessione sia fatta al provider 3

Creiamo o modifichiamo il file /etc/ppp/peers/connect-chat

    ABORT BUSY
    ABORT ERROR
    ABORT 'NO CARRIER'
    ABORT 'NO DIALTONE'
    ABORT 'Invalid Login'
    ABORT 'Login incorrect'
    ABORT VOICE
    ABORT 'NO ANSWER'
    ABORT DELAYED
    ABORT 'SIM PIN'
     ATZ
    OK-AT-OK 'ATX3'
    OK-AT-OK 'AT+COPS?'
    OK-AT-OK 'AT+CGDCONT=1,"IP","datacard.tre.it"'
    OK 'ATM1L3DT*99#'
    TIMEOUT 120
    CONNECT 
    TIMEOUT 5
    '~--' 

Creiamo o modifichiamo il file /etc/ppp/peers/disconnect-chat

    #!/bin/sh
    # send break exec /usr/sbin/chat -V -s -S    \
    ABORT           "BUSY"          \
    ABORT           "ERROR"         \
    ABORT           "NO DIALTONE"   \
    SAY             "\nSending break to the modem\n"        \
    ""              "\K"            \
    ""              "\K"            \
    ""              "\K"            \
    ""              "\d\d+++\d\dATH"        \
    SAY             "\nPDP context detached\n"

Connessione
-----------

Ora con il comando

    # pon conn3

la connessione dovrebbe avvenire (controllare con ifconfig se si attiva
la rete ppp0)

Per praticità è possibile creare il seguente link simbolico

    # ln -s /etc/ppp/peers/conn3 /etc/ppp/peers/provider

così sarà possibile connettersi con il semplice comando

    # pon

Se non funzione provare da un altro terminale a dare il seguente comando
per instradare le richieste verso internet su ppp0.

    # ip route add default dev ppp0

Regolazione dei dettagli
========================

Verifica dello stato della connessione
--------------------------------------

Per verificare lo stato della connessione suggerisco questo escamotage:
Creare un file dove salvare la risposta che da pppd al comando in
/etc/ppp/peers/connect-chat OK-AT-OK 'AT+COPS?'

    touch /var/log/monitorconn.log

Editare i seguenti due script: /etc/ppp/ip-up.d/monitorconnessione.sh

    #!/bin/bash
    echo "`grep 'COPS:' /var/log/ppp.log | tail --lines=1 | cut -c48-`" > /var/log/monitorconn.log

e /etc/ppp/ip-down.d/clearmonitorconnessione.sh

    #!/bin/bash
    echo "." > /var/log/monitorconn.log

Ora ogni volta che ci connetteremo il file /var/log/monitorconn.log
verrà aggiornato con il provider di connessione e ogni volta che ci
sconnetteremo verrà pulito. L'unica cosa è assicurarsi che
all'accensione del pc il file sia pulito: aggiungere al file
/etc/rc.sysinit la seguente riga

    /bin/echo " " > /var/log/monitorconn.log ## per verificare connessione 3

Per far apparire il contenuto di /var/log/monitorconn.log in conky
aggiungere al file di configurazione nella sezione TEXT

    ${color lightgrey}Network ppp0: ${exec cat "/var/log/monitorconn.log" | head --lines=1}

Links
=====

-   Huawei_E220
-   PPPoE_Setup_with_pppd
-   http://www.gentoo-wiki.info/Mobile_Phone
-   Speeding_up_DNS_with_dnsmasq#Conserve_DNS_settings

Retrieved from
"https://wiki.archlinux.org/index.php?title=Internet_key_Momo_Design&oldid=249161"

Categories:

-   Other hardware
-   Modems
