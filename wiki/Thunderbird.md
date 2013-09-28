Thunderbird
===========

Summary

This article discusses the installation and configuration of the e-mail
client, Mozilla Thunderbird. It also provides information about several
popular add-ons and extensions to the program, including EnigMail,
Lightning, and WebMail.

Related

Thunderbird Export URLs

Firefox

Mozilla Thunderbird is an email, newsgroup, and news feed client
designed around simplicity and full-featuredness while avoiding bloat.
It supports POP, IMAP, SMTP, S/MIME, and OpenPGP encryption (through the
Enigmail extension). Similarly to Firefox, it has a wide variety of
extension and addons available for download that add more features.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Extensions                                                         |
|     -   2.1 Encryption with EnigMail                                     |
|         -   2.1.1 Installation                                           |
|             -   2.1.1.1 Via addons.mozilla.org                           |
|             -   2.1.1.2 Via enigmail.mozdev.org                          |
|             -   2.1.1.3 Via AUR                                          |
|             -   2.1.1.4 Issues with the x86_64 version of enigmail       |
|                                                                          |
|         -   2.1.2 Creating a Keypair                                     |
|         -   2.1.3 Sharing your Public Key                                |
|         -   2.1.4 Encrypting your Emails                                 |
|         -   2.1.5 Decrypting Emails                                      |
|                                                                          |
|     -   2.2 Adding a Calendar with Lightning                             |
|     -   2.3 Plain-text Mode and Font Uniformity                          |
|     -   2.4 Resizeable tray icon                                         |
|     -   2.5 Links in Thunderbird do NOT open in Firefox                  |
|     -   2.6 Webmail with Thunderbird                                     |
|     -   2.7 Opening links in Thunderbird with Firefox                    |
|         -   2.7.1 Setting Firefox to open links in new tabs/new windows  |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Segfault at startup                                          |
|     -   3.2 Folder name in local language but menus in english after     |
|         Thunderbird update                                               |
+--------------------------------------------------------------------------+

Installation
------------

The thunderbird package can be found in the [extra] repository and
installed with pacman:

    # pacman -S thunderbird

There are a number of language packs available if English is not your
preferred language. To see a list of available language packs, try:

    $ pacman -Ss thunderbird-i18n

Extensions
----------

> Encryption with EnigMail

Installation

Via addons.mozilla.org

Note:This method won't work for x86_64, see #Via AUR.

Note: The section below that points you to the static builds seems to
work fine for x86_x64. The aur is out of date (07/25/12). You have to
use the nightly builds though because arch is using v14 of thunderbird.

The first step to setting up email encryption is to download the GNU
Privacy Guard (GnuPG). GnuPG is required by pacman, which is a part of
'base' system, so you do not have to install them manually.

EnigMail can be downloaded from here, at Mozilla's addon database. Make
sure that it is installed as a Thunderbird addon and isn't automatically
interpreted to be a Firefox addon. This can be done by going to Tools ->
Add-ons and clicking Install, then selecting the XPI addon package.
Congratulations, EnigMail is now installed. You should now restart
Thunderbird.

Via enigmail.mozdev.org

Note: As of 07/25/12 this worked. It is nightly build though. Who knows
if it will work tommorow?!

EnigMail addons that works for x86_64 can be downloaded from this page.
Select the Arch build of the addon and follow the instructions in the
previous section to install.

Via AUR

There is an AUR package: enigmail.

Issues with the x86_64 version of enigmail

It is possible that Thunderbird (Lanikai) hasn't got the same build-type
(Error: Linux_x86-gcc3) as the enigmail (x86_64) and won't get
installed. Downloading Thunderbird in the i686 version an installing
enigmail by the Add-On application works fine.

If you download Thunderbird manually, remember copying the files to /opt
and creating a directory for Thunderbird. To still be able start
Thunderbird from the "default location" create a file that points at
/opt/thunderbird/thunderbird for example.

Open a new file called thunderbird.

    # nano /usr/bin/thunderbird

Write in the file:

    /opt/thunderbird/thunderbird

Finish with setting the right permissions and "updating" your shell.

    # chmod 755 /usr/bin/thunderbird
    # bash

Creating a Keypair

A keypair can be created by opening Thunderbird and finding the
'OpenPGP' menu and clicking 'Setup Wizard'. The wizard will now help you
create your keypair. All of the options are fairly self-explanatory and
are not discussed in this article.

Sharing your Public Key

There are a variety of ways to distribute your public key. One way is to
upload it to a public keyserver network. Another is to share it with
friends who are also using email encryption.

Encrypting your Emails

First of all, encryption does not always work properly with emails
containing HTML. It is best to make all of the encrypted emails you wish
to send plaintext. This can be ensured by going to Options in the 'New
Email' window and finding Format, then clicking on "Plain-text only".

Once you have chosen a recipient and title and have written your
message, you can sign and encrypt the message by using the OpenPGP menu.
Once that is done, simply click "Send" and your encrypted email has been
sent.

Decrypting Emails

This article will not go into the details of key signing.

Assuming that the email was encrypted properly, just trying to open it
should result in a popup window asking you to type in your keyphrase. Do
so now, and the email will be decrypted for your viewing pleasure.

> Adding a Calendar with Lightning

Lightning is an extension that brings Sunbird's functionality to
Thunderbird. This integrates calendar functions into Thunderbird.

> Plain-text Mode and Font Uniformity

Plain-text mode lets you view all your emails without HTML rendering. It
can be configured from View menu > Message Body As option. This defaults
to monospace font but font size is still inherited from original system
fontconfig settings. You can uniform the default font and font size
across all emails by overwriting it fontconfig user configuration.
Appending below in user font config file before the closing
</fontconfig> tag, will use replace monospace with Ubuntu Mono font with
size of 10 pixels (provided you have already installed Ubuntu font
family). Then run 'fc-cache -fv' to update system font cache.

    # vim /etc/fonts/conf.d/50-user.conf
      <match target="pattern">
       <test qual="any" name="family"><string>monospace</string></test>
       <edit name="family" mode="assign" binding="same"><string>Ubuntu Mono</string></edit>
       <edit name="pixelsize" mode="assign"><int>10</int></edit>
     </match>

> Resizeable tray icon

There are a number of plugins that let Thunderbird close to tray, but
most of them seem to make use of
/usr/lib/thunderbird-5.0/chrome/icons/default/default16.png, and if you
are using a big screen and a bigger-than-standard dock (e.g. Avant
Window Navigator) the icon could appear too little compared to the other
tray icons.

To make those plugins use the icons from /usr/share/icons/hicolor/ you
just have to disable
/usr/lib/thunderbird-5.0/chrome/icons/default/default16.png renaming it
for example to default16.png.disabled, not forgetting to prevent pacman
from reinstalling it by adding the following line to /etc/pacman.conf:

    NoExtract = usr/lib/thunderbird-5.0/chrome/icons/default/default16.png

> Links in Thunderbird do NOT open in Firefox

If you update from Firefox 3 to Firefox 4, you may no longer be able to
click on a link in Thunderbird and have it open in Firefox. Especially
if you are using KDE. To correct the problem, issue the following as
your user, from the command line:

    gconftool-2 --type=string -s /desktop/gnome/url-handlers/http/command "firefox %s"
    gconftool-2 --type=string -s /desktop/gnome/url-handlers/https/command "firefox %s"

Another option is go to the preferences => advanced => general and then
select Config Editor.

    Search for "network.protocol-handler.warn-external"

those following three were false, turn then to true, and then
Thunderbird will ask you when clicking on liks which application to use.
Select /usr/bin/firefox or /usr/bin/xdg-open and do not forgot to select
remember my choice wink

    network.protocol-handler.warn-external.ftp
    network.protocol-handler.warn-external.http
    network.protocol-handler.warn-external.https

the mimetype where saved on ~/.thunderbird/.default/mimeTypes.rdf

> Webmail with Thunderbird

Please see upstream wiki: Using webmail with your email client.

> Opening links in Thunderbird with Firefox

Launch Thunderbird and navigate to the Config Editor by clicking the
following menu items:

Edit -> Preferences -> Advanced -> General -> Config Editor.

Right click in the list of parameters, select New and String in the
menu.

A box appears, asking you for the preference name. Put :

    network.protocol-handler.app.http

Click OK, the box then asks you for the value : set it to :

    /usr/bin/firefox

Do it again for the preference named network.protocol-handler.app.https
.

Note:Xfce4 users may want to set this preference value to "exo-open",
which then will use the browser set up in "Preferred Applications".

You can now click on URL directly to launch them into Firefox !

Setting Firefox to open links in new tabs/new windows

You can change whether links are opened in new tabs or in new windows by
opening up /usr/bin/mozilla-firefox in a text editor.

There are two lines near the top that say:

    OPEN_IN=new-window
    #OPEN_IN=new-tab

This setup will open URL's in a new window. Simply comment the first
line and uncomment the second line to open URL's in a new tab!

Another way to do that is to select the right radiobutton in
Edit/Preferences/Tabs in your Firefox browser menu.

Troubleshooting
---------------

> Segfault at startup

A problem (mozilla-bug) arises on systems configured to use ldap to
fetch user information: Thunderbird segfaults at startup. A work around
exists.

> Folder name in local language but menus in english after Thunderbird update

First, verify that you have package thunderbird-i18n-xx installed, where
"xx" is the language you want. If not, install it. If you have it
already installed remove it with sudo pacman -R thunderbird-i18n-xx and
reinstall it again.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Thunderbird&oldid=253475"

Category:

-   Email Client
