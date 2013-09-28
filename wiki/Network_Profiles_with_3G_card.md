Network Profiles with 3G card
=============================

Telenor Sweden Configuration
----------------------------

/etc/network.d/telenor:

    CONNECTION="ppp"
    INTERFACE="ignore"
    PEER="telenor"

/etc/ppp/peers/telenor:

    /dev/ttyUSB0
    460800
    idle 7200
    lock
    crtscts
    modem
    noauth
    defaultroute
    user Anyname
    password Anypassword
    connect "/usr/sbin/chat -V -f /etc/ppp/isp.chat"
    connect-delay 20000
    noipdefault
    usepeerdns
    nobsdcomp
    novj
    persist

/etc/ppp/isp.chat:

    ABORT BUSY
    ABORT 'NO CARRIER'
    ABORT ERROR
    REPORT CONNECT
    TIMEOUT 10
    "" "AT&F"
    OK "AT+CPIN=<PIN>"
    OK "ATE1"
    OK "AT+CGDCONT=1,\042IP\042,\042internet.telenor.se\042"
    SAY "Calling...\n"
    TIMEOUT 60
    OK "ATD*99***1#"

Wvdial
------

Use wvdial and netcfg. https://aur.archlinux.org/packages.php?ID=50983

Retrieved from
"https://wiki.archlinux.org/index.php?title=Network_Profiles_with_3G_card&oldid=237835"

Category:

-   Networking
