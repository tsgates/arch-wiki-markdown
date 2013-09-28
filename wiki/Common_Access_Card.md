Common Access Card
==================

This page explains how to setup Arch to use a US Department of Defense
Common Access Card (CAC). It was tested with an SCR331 USB card reader
which is a very common one. Others may work...or not.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Software Installation                                              |
| -   2 Configuring Firefox                                                |
|     -   2.1 Enabling Firefox to use the CAC Reader                       |
|     -   2.2 Importing the DoD Certificates                               |
|                                                                          |
| -   3 Testing                                                            |
+--------------------------------------------------------------------------+

Software Installation
---------------------

1.  Install pcsclite and ccid from [community] and install cackey.
2.  Enable pcscd sudo systemctl enable pcscd
3.  Reboot -or- type sudo systemctl start pcscd in a terminal to enable
    the smart card reader.
4.  Install the latest version of cackey
    (https://software.forge.mil/sf/go/projects.community_cac/frs.cackey)
5.  Install the latest version of the DoD Configuration extension for
    Firefox. (http://www.forge.mil/Resources-Firefox.html)
6.  Plug in the card reader without a card inserted. The SCR331's light
    should turn on (not flashing).
7.  Put a CAC into the reader and make sure (at least on the SCR331)
    that the light starts flashing. If it does, it's set up correctly.

NOTE: You must log in using a CAC card to access the cackey file. This
may require you to download it on a seperate computer and transfer the
file.

Configuring Firefox
-------------------

> Enabling Firefox to use the CAC Reader

Insert CAC into reader - the green light should flash on the SCR331.

Add CAC Reader to Firefox as a Security Device

1.  Go to Edit->Preferences on the toolbar.
2.  Click on Advanced
3.  Click on the Encryption Tab
4.  Click on the Security Devices Button
5.  Click on the Load Button
6.  Enter CAC Reader as the module name, and browse to
    /usr/local/lib/libcackey.so then click Open.

> Importing the DoD Certificates

If you have installed the DoD Configuration extension for Firefox you
can use it to import the appropriate certificates.

Tools > Addons > Extensions > DoD Configuration > Preferences

If you're using a branded version of Firefox you should be able to go to
http://dodpki.c3pki.chamb.disa.mil/rootca.html and click on the
high-level certificates to install them and be done.

If you're using Namoroka this site will not recognize it as Firefox and
simply clicking on the link above will not get you into the site. You
can work around this problem (which affects some other websites too) by
changing Namoroka's configuration a little.

1.  Open a new tab in Namoroka
2.  Type about:config in the address bar and press enter
3.  Type 'useragent' in the search box
4.  Double-click on the value where you see "Namoroka"
5.  Change "Namoroka" to "Firefox"
6.  Close the tab

Once you get into the site, you can download the certificates by
following the directions on the page.

The primary root certificate used has a CN of "DoD Root CA 2": this
certificate can be converted to PEM format for use in other browsers:

1.  Download the CA bundle. This includes approximately 36 certificates.
    $ curl -O http://dodpki.c3pki.chamb.disa.mil/rel3_dodroot_2048.p7b
2.  Extract the root certificate into a PEM-formatted file.

$ openssl pkcs7 -inform DER -in rel3_dodroot_2048.p7b -print_certs | sed -n '/subject=.*CN=DoD Root CA 2/,${/^$/q;P;D}' > DoD_Root_CA_2.pem

Testing
-------

Visit your favorite CAC secured web page and you should be asked for the
Master Password for your certificate. Enter it and if you get in, you
know it's working.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Common_Access_Card&oldid=248345"

Category:

-   Other hardware
