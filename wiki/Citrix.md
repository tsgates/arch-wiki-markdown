Citrix
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Missing           
                           overview/explanation at  
                           top (Discuss)            
  ------------------------ ------------------------ ------------------------

Manual Install
--------------

Citrix Receiver (icaclient) Installation

-   Step 0. 64-bit Arch systems only - install 32-bit libs:

from Arch repositories: openmotif, lib32-libxmu, printproto,
nspluginwrapper, lib32-alsa-lib, lib32-gcc-libs, lib32-libxft,
lib32-gtk2, lib32-libxdamage. From AUR: lib32-libxp, lib32-libxpm,
lib32-libxaw, lib32-openmotif

-   Step 1. Download Citrix Receiver It can be found here. Choose the
    latest version of the x86 client in the .tar.gz format.

-   Step 2. Unpack the archive:

    # tar zxvf en.linuxx86.tar.gz
    ./
    ./PkgId
    ./install.txt
    ./eula.txt
    ./readme.txt
    ./setupwfc
    ./linuxx86/
    ./linuxx86/hinst
    ./linuxx86/linuxx86.cor/
    ./linuxx86/linuxx86.cor/nls/
    ./linuxx86/linuxx86.cor/nls/en/
    ./linuxx86/linuxx86.cor/nls/en/UTF-8/
    ./linuxx86/linuxx86.cor/nls/en/UTF-8/Wfica
    ./linuxx86/linuxx86.cor/nls/en/UTF-8/Wfcmgr
    ... many more files ...

-   Step 3. Run setupwfc:

        # ./setupwfc

    (Follow all instructions prompted by setupwfc.)

-   Step 4. (Applies only for Firefox integration:)

The setup program should have made appropriate links to the "Citrix
Receiver for Linux" plugin. You can check this as such:

    # find / -name npica.so
    /opt/Citrix/ICAClient/npica.so

Or you can check if your browser loads the plugin, in Firefox this can
be done by typing "about:plugins" in the address bar. If you have a
64-bit version of Firefox, the plugin will not be loaded. You can check
below what to do.

Create missing links as such:

    # ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/mozilla/plugins/

-   Step 6. Restart your browser

At this point, everything should work, including wfcmgr. In the case of
Opera, integration should be automatic. The ICAClient will automatically
be launched whenever you try to access a citrix-based application from
either Firefox or Opera.

Note: If for some reason firefox prompts you for which application to
use when opening a citrix-based application, use
/opt/Citrix/ICAClient/wfica

Security Certificates

Because ICAClient uses SSL you may need a security certificate to
connect to the server, check with the server administrator. If there is
a certificate download and place it in
/usr/lib/ICAClient/keystore/cacerts/.

You may then receive the error
You have not chosen to trust the issuer of the server's security certificate. (SSL Error 61).
This means you do not have the root Certificate Authority (CA)
certificates.

These are already installed on most systems, they are part of the core
package ca-certificates, but they are not where ICAClient looks for
them. Copy the certificates from /usr/share/ca-certificates/mozilla/ to
/usr/lib/ICAClient/keystore/cacerts/. As root, run the following
command:

    # cp /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Citrix&oldid=300991"

Category:

-   Virtualization

-   This page was last modified on 23 February 2014, at 20:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
