Nokia6230i
==========

Contents
--------

-   1 Common settings
    -   1.1 DKU2 cable
-   2 GPRS
    -   2.1 DKU2
    -   2.2 Bluetooth
-   3 Backup/restore phonebook
    -   3.1 Backup
    -   3.2 Restore

Common settings
---------------

Install gnokii

     pacman -S gnokii

> DKU2 cable

-   Edit /etc/gnokiirc

    [global]
    port = 1                                                                                                                       
    model = series40                                                                                                               
    initlength = default                                                                                                           
    connection = dku2libusb                                                                                                        
    use_locking = yes                                                                                                              
    serial_baudrate = 19200                                                                                                        
    #serial_write_usleep = 10000                                                                                                   
    #handshake = software                                                                                                          
    #require_dcd = 1                                                                                                               
    #rfcomm_channel = 1                                                                                                            
    #sm_retry = 1                                                                                                                  
    #connect_script = /absolute/path/to/gnokii/Docs/sample/cimd-connect                                                            
    #disconnect_script =                                                                                                           
    smsc_timeout = 10                                                                                                              

    [gnokiid]
    bindir = /usr/sbin/

    [connect_script]
    TELEPHONE = 12345678

    [disconnect_script]

    [logging]
    debug = off
    rlpdebug = off
    xdebug = off

In this sample libusb used as recommended.

-   Add cdc-acm module into rc.conf or load it manualy (needed for GPRS)

GPRS
----

NOTE: Of course you should edit following files and adjust your provider
settings.

> DKU2

pppd peer file (in /etc/ppp/peers/)

    /dev/ttyUSB0 57600
    connect '/usr/sbin/chat -v -f /etc/ppp/peers/mts-gprs-dialup.chat'
    noauth
    defaultroute
    lock 
    debug
    novjccomp 
    nopcomp 
    noaccomp 
    nodeflate 
    novj 
    nobsdcomp
    default-asyncmap
    ipcp-accept-local
    ipcp-accept-remote
    usepeerdns
    user mts
    nodetach

chat file

    TIMEOUT 5
    ECHO    ON
    ABORT   '\nBUSY\r'
    ABORT   '\nERROR\r'
    ABORT   '\nNO ANSWER\r'
    ABORT   '\nNO CARRIER\r'
    ABORT   '\nNO DIALTONE\r'
    ABORT   '\nRINGING\r\n\r\nRINGING\r'
    ''              \rAT
    TIMEOUT 12
    OK              ATH
    OK              ATE1
    OK              AT+CGDCONT=1,"IP","internet.mts.ru"
    OK              ATD*99***1#
    CONNECT

Command to establish internet connection

     pppd call <peer-file-name>

> Bluetooth

chat file is the same as in DKU2 example

pppd peer file (in /etc/ppp/peers/)

    /dev/rfcomm0 57600
    connect '/usr/sbin/chat -v -f /etc/ppp/peers/mts-gprs-dialup.chat'
    noauth
    defaultroute
    lock 
    debug
    novjccomp 
    nopcomp 
    noaccomp 
    nodeflate 
    novj 
    nobsdcomp
    default-asyncmap
    ipcp-accept-local
    ipcp-accept-remote
    usepeerdns
    user beeline
    nodetach

Commands to establish internet connection

     rfcomm bind rfcomm0 <BT-ADDR> 1
     pppd call <peer-file-name>

Backup/restore phonebook
------------------------

> Backup

Use command

     gnokii --getphonebook ME 1 end -r >phonebook-`date +%Y%m%d`.raw

> Restore

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nokia6230i&oldid=205808"

Category:

-   Mobile devices

-   This page was last modified on 13 June 2012, at 10:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
