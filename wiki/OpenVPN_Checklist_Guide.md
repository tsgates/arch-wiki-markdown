OpenVPN Checklist Guide
=======================

  
 This article summarizes the install process required for OpenVPN. See
OpenVPN instead for a walkthrough.

Contents
--------

-   1 Install
-   2 Prepare data
-   3 Generate the certificates
-   4 Setting up the server
-   5 Setting up the clients

Install
-------

Install the package openvpn from the official repositories.

Prepare data
------------

-   Copy /usr/share/openvpn/easy-rsa to /etc/openvpn/easy-rsa and cd
    there
-   Edit the vars file with the information you want, then source it.
    Read Create a Public Key Infrastructure Using the easy-rsa Scripts
    for details.

    # source ./vars

-   Clean up any previous keys:

    # ./clean-all

Generate the certificates
-------------------------

-   Create the "certificate authority" key

    #  ./build-ca

-   Create certificate and private key for the server

    #  ./build-key-server <server-name>

-   Create the Diffie-Hellman pem file for the server. Don't enter a
    challenge password or company name when you set these up.

    #  ./build-dh

-   Create a certificate for each client.

    # ./build-key <client-name>

All certificates are stored in keys directory. If you mess up, you can
start all over by doing a ./clean-all

Copy to each client the ca.crt, and their respective crt and key files.

Setting up the server
---------------------

-   Create /etc/openvpn/myvpnserver.conf with a content like this:

    /etc/openvpn/myvpnserver.conf

    port <port>
    proto tcp
    dev tun0

    ca /etc/openvpn/easy-rsa/keys/ca.crt
    cert /etc/openvpn/easy-rsa/keys/<server-name>.crt
    key /etc/openvpn/easy-rsa/keys/<server-name>.key
    dh /etc/openvpn/easy-rsa/keys/<your pem file>

    server <desired base ip> 255.255.255.0
    ifconfig-pool-persist ipp.txt
    keepalive 10 120
    comp-lzo
    user nobody
    group nobody
    persist-key
    persist-tun
    status /var/log/openvpn-status.log
    verb 3

    log-append /var/log/openvpn
    status /tmp/vpn.status 10

-   Start and, optionally, enable for autostart on boot, the daemon. (In
    this example, is openvpn@myvpnserver.service)

Read Daemon for more information.

Setting up the clients
----------------------

-   Create a .conf file for each client like this:

    a-client-conf-file.conf

    client
    remote <server> <port>
    dev tun0
    proto tcp
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    verb 2
    ca ca.crt
    cert <client crt file with full path>
    key <client key file with full path>
    comp-lzo

-   Start the connection with

    # openvpn a-client-conf-file.conf &

Optionally, enable for autostart on boot the daemon. (In this example,
is openvpn@a-client-conf-file.service)

Read Daemon for more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenVPN_Checklist_Guide&oldid=305748"

Category:

-   Virtual Private Network

-   This page was last modified on 20 March 2014, at 01:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
