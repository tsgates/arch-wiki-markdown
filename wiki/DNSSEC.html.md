DNSSEC
======

  

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Facts
-   2 DNSSEC Packages
-   3 Howto enable DNSSEC in specific software
    -   3.1 OpenSSH (fixes only weak point in SSH design)
    -   3.2 Firefox (secure browsing - enchancment of HTTPS)
    -   3.3 Chromium/Google Chrome (secure browsing - enchancment of
        HTTPS)
    -   3.4 BIND (serving signed DNS zones)
    -   3.5 Postfix (fight spam and frauds)
    -   3.6 jabberd (fight spam and frauds)
    -   3.7 Thunderbird (secure logins)
    -   3.8 lftp (secure downloads and logins)
    -   3.9 wget (secure downloads)
    -   3.10 proftpd
    -   3.11 Sendmail (fight spam and frauds)
    -   3.12 LibSPF
    -   3.13 ncftp (secure downloads and logins)
    -   3.14 libpurple (pidgin + finch -> secure messaging)
-   4 DNSSEC Hardware
-   5 See Also

Facts
-----

-   Wikipedia:Domain Name System Security Extensions
-   http://www.dnssec.net/
    -   http://www.dnssec.net/practical-documents
    -   http://www.dnssec.net/rfc
-   https://www.iana.org/dnssec/
-   https://www.dnssec-tools.org/
-   http://linux.die.net/man/1/sshfp
-   https://bugs.archlinux.org/task/20325 - [DNSSEC] Add DNS validation
    support to ArchLinux

DNSSEC Packages
---------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           DNSSEC#Howto enable      
                           DNSSEC in specific       
                           software.                
                           Notes: Duplicated        
                           information (Discuss)    
  ------------------------ ------------------------ ------------------------

-   dnssec-anchors
    -   essential package contains keys to internet from IANA stored in
        /usr/share/dnssec-trust-anchors/
    -   VERY important!
-   ldns
    -   DNS(SEC) library libldns
    -   drill tool (like dig with DNSSEC support)
        -   can be used for basic DNSSEC validation. eg.:
            -   Should success (return 0):
                -   drill -TD nic.cz #valid DNSSEC key
                -   drill -TD google.com #not signed domain
            -   Should fail (simulating fraudent DNS records):
                -   drill -TD rhybar.cz
                -   drill -TD badsign-a.test.dnssec-tools.org
            -   to use root-zone trust anchor add option -k
                /usr/share/dnssec-trust-anchors/root-anchor.key
-   dnssec-tools (package is very experimental and volatile right now)
    -   https://www.dnssec-tools.org/
    -   another good library libval which can add DNSSEC support to lots
        of programs
        -   https://www.dnssec-tools.org/wiki/index.php/DNSSEC_Applications
    -   some tools
        https://www.dnssec-tools.org/wiki/index.php/DNSSEC-Tools_Components
        -   https://www.dnssec-tools.org/wiki/index.php/Applications
    -   libval-shim LD_PRELOAD library to enable DNSSEC for lots of
        DNSSEC unaware programs
        http://www.dnssec-tools.org/docs/tool-description/libval_shim.html
    -   PERL API
-   openssh-dnssec
    -   see lower on this page
-   sshfp
    -   Generates DNS SSHFP-type records from SSH public keys from
        public keys from a known_hosts file or from scanning the host's
        sshd daemon.
    -   not directly related to DNSSEC, but i guess this will become
        very popular because of DNSSEC
-   opendnssec
    -   Signs DNS zones to be later published by a DNS server (bind,
        nsd, etc.)
    -   Automates refreshing signatures, key rollovers

Howto enable DNSSEC in specific software
----------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           DNSSEC#DNSSEC Packages.  
                           Notes: Duplicated        
                           information (Discuss)    
  ------------------------ ------------------------ ------------------------

If you want full support of DNSSEC, you need each single application to
use DNSSEC validation. It can be done using several ways:

-   patches
    -   https://www.dnssec-tools.org/wiki/index.php/DNSSEC_Applications
    -   https://www.dnssec-tools.org/wiki/index.php/DNSSEC_Application_Development
-   plugins, extensions, wrappers
-   universal LD_PRELOAD wrapper
    -   overriding calls to: gethostbyname(3), gethostbyaddr(3),
        getnameinfo(3), getaddrinfo(3), res_query(3)
    -   libval-shim from dnssec-tools:
        http://www.dnssec-tools.org/docs/tool-description/libval_shim.html
-   DNS proxy

> OpenSSH (fixes only weak point in SSH design)

-   dnssec-tools + patch:
    https://www.dnssec-tools.org/wiki/index.php/Ssh
    -   http://www.dnssec-tools.org/readme/README.ssh
-   openssh-dnssec wrapper
    -   DNSSEC (ldns) wrapper for OpenSSH client.
    -   instantly adds minimal DNSSEC support to ssh (no SSHFP support).
    -   usage: alias ssh=ssh-dnssec

> Firefox (secure browsing - enchancment of HTTPS)

-   DNSSEC Validator plugin
    https://addons.mozilla.org/en-US/firefox/addon/64247/
-   DNSSEC Drill plugin
    http://nlnetlabs.nl/projects/drill/drill_extension.html
    -   you need ldns and dnssec-root-zone-trust-anchors packages for
        this plugin
-   dnssec-tools + firefox patch:
    https://www.dnssec-tools.org/wiki/index.php/Firefox

> Chromium/Google Chrome (secure browsing - enchancment of HTTPS)

-   Vote for #50874
    -   Patches not yet...
    -   DNSSEC Drill extension (EXPERIMENTAL!)
        -   you need ldns and dnssec-root-zone-trust-anchors packages
            for this plugin

> BIND (serving signed DNS zones)

-   See BIND for more information on BIND
-   http://www.dnssec.net/practical-documents
    -   http://www.cymru.com/Documents/secure-bind-template.html
        (configuration template!)
    -   http://www.bind9.net/manuals
    -   http://www.bind9.net/BIND-FAQ
-   http://blog.techscrawl.com/2009/01/13/enabling-dnssec-on-bind/
-   Or use an external mechanisms such as OpenDNSSEC (fully-automatic
    key rollover)

> Postfix (fight spam and frauds)

-   dnssec-tools + patch

> jabberd (fight spam and frauds)

-   dnssec-tools + patch

> Thunderbird (secure logins)

-   dnssec-tools + patch

> lftp (secure downloads and logins)

-   dnssec-tools + patch

> wget (secure downloads)

-   dnssec-tools + patch

> proftpd

-   dnssec-tools + patch

> Sendmail (fight spam and frauds)

-   dnssec-tools + patch

> LibSPF

-   dnssec-tools + patch

> ncftp (secure downloads and logins)

-   dnssec-tools + patch

> libpurple (pidgin + finch -> secure messaging)

-   no patches yet

-   Vote for #12413

DNSSEC Hardware
---------------

You can check if your router, modem, AP, etc. supports DNSSEC (many
different features) using dnssec-tester (Python and GTK+ based app) to
know if it is DNSSEC-compatible, and using this tool you can also upload
gathered data to a server, so other users and manufacturers can be
informed about compatibility of their devices and eventualy fix the
firmware (they will be probably urged to do so). (Before running
dnssec-tester please make sure, that you do not have any other
nameservers in /etc/resolv.conf). You can also find the results of
performed tests on the dnssec-tester website.

See Also
--------

-   AppArmor

Retrieved from
"https://wiki.archlinux.org/index.php?title=DNSSEC&oldid=282321"

Categories:

-   Security
-   Domain Name System

-   This page was last modified on 11 November 2013, at 12:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
