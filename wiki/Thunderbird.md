Thunderbird
===========

Related articles

-   Thunderbird Export URLs
-   Firefox

Mozilla Thunderbird is an email, newsgroup, and news feed client
designed around simplicity and full-featuredness, while avoiding bloat.
It supports POP, IMAP, SMTP, S/MIME, and OpenPGP encryption (through the
Enigmail extension). Similarly to Firefox, it has a wide variety of
extension and addons available for download that add more features.

Contents
--------

-   1 Installation
-   2 Extensions
    -   2.1 EnigMail - Encryption
        -   2.1.1 Sharing the public key
        -   2.1.2 Encrypting emails
        -   2.1.3 Decrypting emails
        -   2.1.4 Enabling higher privacy
    -   2.2 Lightning - Calendar
    -   2.3 FireTray - Tray icon
-   3 Tips and tricks
    -   3.1 Setting the default browser
    -   3.2 Plain Text mode and font uniformity
    -   3.3 Webmail with Thunderbird
-   4 Troubleshooting
    -   4.1 LDAP Segfault

Installation
------------

Install thunderbird from the official repositories.

Other alternatives from the AUR include:

-   thunderbird-esr-bin (a long-term supported version)
-   thunderbird-beta-bin (the official cutting-edge version by Mozilla)
-   thunderbird-nightly (a nightly version)

There are a number of language packs available, if English is not your
preferred language. To see a list of available language packs, try:

    $ pacman -Ss thunderbird-i18n

Extensions
----------

> EnigMail - Encryption

EnigMail is an extension that allows writing and receiving email signed
and/or encrypted with the OpenPGP standard. It relies on the GNU Privacy
Guard (GnuPG).

It can be installed from addons.mozilla.org (e.g. through the
Add-ons Manager) or the AUR. Common packages include:
thunderbird-enigmail and thunderbird-enigmail-bin.

Sharing the public key

There are a variety of ways to distribute the public key. One way is to
upload it to a public keyserver network. Another is to share it with
friends who are also using email encryption.

Encrypting emails

Encryption does not always work properly with emails containing HTML. It
is best to use plain text by choosing Options > Delivery Format > Plain
Text Only in the new email window.

Once the email is finished it can be signed through the OpenPGP menu.

Decrypting emails

Assuming that the email was encrypted properly, just trying to open it
should result in a popup window asking to type in the keyphrase.

Enabling higher privacy

By default, Enigmail discloses some information in the email headers and
in the OpenPGP comment field. This includes which Enigmail is being used
and its version. Both can be disabled in the Config Editor (Edit >
Preferences > Advanced > General > Config Editor).

To delete the email header (X-Enigmail-version) set
extensions.enigmail.addHeaders to false.

Counter-intuitively, to disable the the OpenPGP comment, set the
extensions.enigmail.useDefaultComment to true.

Disabling the user agent itself (which shows one is using Thunderbird)
is currently not possible.

> Lightning - Calendar

Lightning is a calendar extension that brings Sunbird's functionality to
Thunderbird. You can use addons.mozilla.org or the AUR package
thunderbird-lightning-bin to install Lightning.

> FireTray - Tray icon

FireTray is an extension that adds a customizable system tray icon for
Thunderbird. It can be installed from addons.mozilla.org or the AUR
package thunderbird-firetray.

Tips and tricks
---------------

> Setting the default browser

Note:Since version 24 the network.protocol-handler.app.* keys have no
effect and will not be able to set the default browser.

Recent versions of Thunderbird use the default browser as defined by the
system MIME settings. This is commonly modified by the Gnome Control
Center (Gnome Control Center > Details > Default Applications > Web)
(available in: gnome-control-center).

This can be overridden in Thunderbird through Edit > Preferences >
Advanced > General > Config Editor by searching for
network.protocol-handler.warn-external.

If the following three are all set to false (default), turn them to
true, and Thunderbird will ask you when clicking on links which
application to use (remember to also check "Remember my choice for ..
links").

    network.protocol-handler.warn-external.ftp
    network.protocol-handler.warn-external.http
    network.protocol-handler.warn-external.https

> Plain Text mode and font uniformity

Plain Text mode lets you view all your emails without HTML rendering and
is available in View > Message Body As. This defaults to the Monospace
font but the size is still inherited from original system fontconfig
settings. The following example will overwrite this with Ubuntu Mono of
10 pixels (available in: ttf-ubuntu-font-family).

Remember to run fc-cache -fv to update system font cache. See Font
Configuration for more information.

    ~/.config/fontconfig/fonts.conf

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <match target="pattern">
        <test qual="any" name="family"><string>monospace</string></test>
        <edit name="family" mode="assign" binding="same"><string>Ubuntu Mono</string></edit>
        <!-- For Thunderbird, lowering default font size to 10 for uniformity -->
        <edit name="pixelsize" mode="assign"><int>10</int></edit>
      </match>
    </fontconfig>

> Webmail with Thunderbird

See upstream Wiki: Using webmail with your email client.

Troubleshooting
---------------

> LDAP Segfault

An LDAP clash (Bugzilla#292127) arises on systems configured to use it
to fetch user information. A possible workaround consists of renaming
the conflicting bundled LDAP library.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Thunderbird&oldid=306181"

Category:

-   Email Client

-   This page was last modified on 20 March 2014, at 20:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
