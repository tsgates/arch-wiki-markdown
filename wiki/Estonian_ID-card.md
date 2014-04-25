Estonian ID-card
================

Packages to enable Estonian ID-card support are available from the Arch
User Repository. This article explains how to install the official
software versions by AS Sertifitseerimiskeskus.

Quick install
-------------

Install pcsclite from the official repositories and esteidfirefoxplugin,
qdigidoc and qesteidutil from the AUR.

Enable pcscd.socket using systemd.

Browser plugin (web authentication & digital signatures)
--------------------------------------------------------

The browser plugin AUR package is called esteidfirefoxplugin, which also
requires dependencies esteidpkcs11loader and esteidcerts.

It also requires you to run the PCSC daemon, which can be installed with
pcsclite from the official repositories.

Make it auto-start on demand by enabling pcscd.socket using systemd.

Don't forget to restart Firefox after finishing.

ID-card and Digidoc utilities
-----------------------------

The ID-card utility packages are qesteidutil and qdigidoc, with
dependencies esteidcerts, libdigidoc and libdigidocpp.

These applications will automatically appear in your application menus.
You can also start from command line with qdigidocclient and
qesteidutil.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Estonian_ID-card&oldid=279342"

Category:

-   Security

-   This page was last modified on 22 October 2013, at 10:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
