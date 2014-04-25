Chromium tweaks
===============

Related articles

-   Chromium
-   Firefox tweaks

Contents
--------

-   1 Browsing experience
    -   1.1 chrome://xxx
    -   1.2 Broken icons in Download Tab
    -   1.3 Chromium overrides/overwrites Preferences file
    -   1.4 Scroll speed of mouse wheel
    -   1.5 Search Engines
    -   1.6 Tmpfs
        -   1.6.1 Cache in tmpfs
        -   1.6.2 Profile in tmpfs
    -   1.7 Launch a new browser instance
    -   1.8 Directly open *.torrent files and magnet links with a
        torrent client
-   2 Profile Maintenance
-   3 Security
    -   3.1 Disable insecure RC4 cipher
    -   3.2 User Agent
    -   3.3 Making it all persistent
    -   3.4 SSL Certificates
        -   3.4.1 Adding CAcert Certificates for Self-Signed
            Certificates
        -   3.4.2 Example 1: Using a Shell Script Isolate the
            Certificate from TomatoUSB
        -   3.4.3 Example 2: Using Firefox to Isolate the Certificate
            from TomatoUSB
-   4 See also

Browsing experience
-------------------

> chrome://xxx

A number of tweaks can be accessed via typing chrome://xxx in the URL
field. A complete list is available by typing chrome://chrome-urls into
the URL field. Some of note are listed below:

-   chrome://flags - access experimental features such as WebGL and
    rendering webpages with GPU, etc.
-   chrome://plugins - view, enable and disable the currently used
    Chromium plugins.
-   chrome://gpu - status of different GPU options.
-   chrome://sandbox - indicate sandbox status.
-   chrome://version - display version and switches used to invoke the
    active /usr/bin/chromium.

An automatically updated, complete listing of Chromium switches is
available here.

> Broken icons in Download Tab

If Chromium shows icon placeholders (icons representing broken
documents) instead of appropriate icons in its download tab, the likely
cause is that the gnome-icon-theme package is not installed.

> Chromium overrides/overwrites Preferences file

If you enabled syncing with a Google Account, then Chromium will
override any direct edits to the Preferences file found under
$HOME/.config/chromium/Default/Preferences. To work around this, start
Chromium with the --disable-sync-preferences switch:

    $ chromium --disable-sync-preferences

If Chromium is started in the background when you login in to your
desktop environment, make sure the command your desktop environment uses
is

    $ chromium --disable-sync-preferences --no-startup-window

> Scroll speed of mouse wheel

As of 22 Feb 2013, upstream has removed the --scroll-pixels flag. The
chromium-scroll-pixels package can be installed from the AUR, which
contains a patch to enable the --scroll-pixels flag.

Tip:Due to long compilation times, package maintainer graysky provides
pre-compiled packages in his unofficial repo, repo-ck.

Example usage:

    $ chromium --scroll-pixels=320

> Search Engines

Make sites like wiki.archlinux.org and wikipedia.org easily searchable
by first executing a search on those pages, then going to Settings >
Search and click the Manage search engines.. button. From there, "Edit"
the Wikipedia entry and change its keyword to "w" (or some other
shortcut you prefer). Now searching Wikipedia for "Arch Linux" from the
address bar is done simply by entering "w arch linux".

Note: Google search is used automatically when typing something into the
URL bar. A hard-coded keyword trigger is also available using the ?
prefix.

> Tmpfs

Cache in tmpfs

Note:Chromium actually keeps its cache directory separate from its
browser profile directory.

To limit Chromium from writing its cache to a physical disk, one can
define an alternative location via the --disk-cache-dir=/foo/bar flag:

    $ chromium --disk-cache-dir=/tmp/cache

Cache should be considered temporary and will not be saved after a
reboot or hard lock.

Alternative way, in /etc/fstab:

    tmpfs	/home/<USER>/.cache	tmpfs	noatime,nodev,nosuid,size=400M	0	0

Note:Adjust the size as needed and be careful. If the size is too large
and you are using a sync daemon such as psd on a conventional HDD, it
will likely result in very slow start-up times of your graphical system
due to long sync back times of the daemon.

Profile in tmpfs

Relocate the browser profile to a tmpfs filesystem, including /tmp, or
/dev/shm for improvements in application response as the entire profile
is now stored in RAM.

Use an active profile management script for maximal reliability and ease
of use.

profile-sync-daemon is such a script and is directly available from the
AUR. It symlinks and syncs the browser profile directories to RAM. Refer
to the Profile-sync-daemon wiki article for additional information on
it.

> Launch a new browser instance

When you launch the browser, it first checks if another instance using
the same profile is already running. If there is one, the new window is
associated with the old instance. To prevent this, you can specifically
ask the browser to run with a different profile.

    $ chromium --user-data-dir=<PATH TO A PROFILE>

Note:It won't work if you specify a link or even a symlink to your
regular chromium profile (typically ~/.config/chromium/Default). If you
want to use the same profile as your current one for this new instance,
first copy the folder ~/.config/chromium/Default to a directory of your
choice, keeping the same Default name, and launch the browser using the
following command by specifying the parent folder of the Default folder
you have just copied.

e.g. if you copied the Default folder to ~/Downloads/

    $ chromium --user-data-dir=~/Downloads

> Directly open *.torrent files and magnet links with a torrent client

By default, Chromium downloads *.torrent files directly and you need to
click the notification from the bottom left corner of the screen in
order for the file to be opened with your default torrent client. This
can be avoided with the following method:

-   Download a *.torrent file.
-   Right click the notification displayed at the bottom left corner of
    the screen.
-   Check the "Always Open Files of This Type" checkbox.

For torrent magnet links to open with Deluge automatically when they are
clicked, run the following commands:

Note:If you would like to use Transmission instead of Deluge, you can
use transmission-gtk.desktop here instead.

    $ gvfs-mime --set x-scheme-handler/magnet deluge.desktop
    $ xdg-mime default deluge.desktop x-scheme-handler/magnet

Profile Maintenance
-------------------

Chromium uses Sqlite databases to manage history and the like. Sqlite
databases become fragmented over time and empty spaces appear all
around. But, since there are no managing processes checking and
optimizing the database, these factors eventually result in a
performance hit. A good way to improve startup and some other bookmarks
and history related tasks is to defragment and trim unused space from
these databases.

profile-cleaner and browser-vacuum in the AUR do just this.

Security
--------

> Disable insecure RC4 cipher

Since a while RC4 is declared as insecure, but the cipher is still in
Chrome present. You should disable the cipher in Chrome. This can be
done by starting chrome from the command line with following option:

    /usr/bin/chromium --cipher-suite-blacklist=0x0001,0x0002,0x0004,0x0005,0x0017,0x0018,0xc002,0xc007,0xc00c,0xc011,0xc016,0xff80,0xff81,0xff82,0xff83

You can check for that on https://cc.dcsec.uni-hannover.de/ for the
supported list if ciphers. Make sure to test it before and after you
make the change.

To make the change persistent, you can modify the /etc/chromium/default
and add the line above. To check, open the website mentioned before. A
alternative is to grep inside of your process list for the keyword
cipher.

External Information:

There is no cleaner way to disable. Also the source-code only show the
right hexadecimal value for the single cipher. basic information with
recommendation to disable RC4 on wikipedia RC4

German Blog showing to disable RC4 in common browsers.

> User Agent

By default Chromium already sends an excessively detailed User Agent, as
is viewable via the EFF's Panopticlick test. That alone makes each
browser readily identifiable with high accuracy — and is further
exacerbated by the use of non-stable versions, ones not recently
provided by Google's release channels, ones customized e.g. by a
distribution (such as the AUR's chromium-browser-ppa), etc.

However, this User Agent can be arbitrarily modified at the start of
Chromium's base instance via its --user-agent="[string]" parameter.

For the same User Agent as the stable Chrome release for Linux i686 (at
the time of writing the most popular Linux edition of Chrome) one would
use:

    --user-agent="Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11"

An official, automatically updated listing of Chromium releases which
also shows the included WebKit version is available as the OmahaProxy
Viewer.

> Making it all persistent

You can export your flags from ~/.profile:

    export CHROMIUM_USER_FLAGS="--disk-cache-dir=/tmp --disk-cache-size=50000000"

Or add them to /etc/chromium/default:

    # Default settings for chromium. This file is sourced by /usr/bin/chromium
    #
    # Options to pass to chromium
    CHROMIUM_FLAGS="--scroll-pixels=200"

Chromium will prefer the user defined flags in CHROMIUM_USER_FLAGS to
those defined in /etc/chromium/default.

If you want to use CHROMIUM_USER_FLAGS and Pepperflash, you should add
Chromium Pepperflash arguments to your ~/.profile file.

    export CHROMIUM_USER_FLAGS="--ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=11.7.700.141"

> SSL Certificates

Unfortunately, Chromium doesn't have a SSL certificate manager. It
relies on the NSS Shared DB ~/.pki.nssdb. In order to add SSL
certificates to the database, users will have to use the shell.

Adding CAcert Certificates for Self-Signed Certificates

Grab the CAcerts and create a nssdb if one does not already exist. To do
this, first install the nss package, then complete these steps:

    [[ ! -e $HOME/.pki/nssdb ]] && mkdir -p $HOME/.pki/nssdb && cd $HOME/.pki/nssdb && certutil -N -d sql:.

Note:Users will need to create a password for the database should it not
exist.

    curl -k -o "cacert-root.crt" "http://www.cacert.org/certs/root.crt"
    curl -k -o "cacert-class3.crt" "http://www.cacert.org/certs/class3.crt"
    certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "CAcert.org" -i cacert-root.crt 
    certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "CAcert.org Class 3" -i cacert-class3.crt

Note:Users will need to create a password for the database should it not
exist.

Now users may manually import a self-signed certificate.

Example 1: Using a Shell Script Isolate the Certificate from TomatoUSB

Below is a simple script that will extract and add a certificate to the
user's nssdb:

    #!/bin/sh
    #
    # usage:  import-cert.sh remote.host.name [port]
    #
    REMHOST=$1
    REMPORT=${2:-443}
    exec 6>&1
    exec > $REMHOST
    echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
    certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "$REMHOST" -i $REMHOST 
    exec 1>&6 6>&-

Syntax is advertised in the commented lines.

Reference:

-   http://blog.avirtualhome.com/adding-ssl-certificates-to-google-chrome-linux-ubuntu

Example 2: Using Firefox to Isolate the Certificate from TomatoUSB

The firefox browser can used to save the certificate to a file for
manunal import into the DB.

Using firefox:

1.  Browse to the target URL.
2.  Upon seeing the "This Connection is Untrusted" warning screen, click
    I understand the Risks>Add Exception...
3.  Click View>Details>Export and save the certificate to a temporary
    location (/tmp/easy.pem in this example).

Now import the certificate for use in Chromium:

    certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "easy" -i /tmp/easy.pem

Note:Adjust the name to match that of the certificate. In the example
above, "easy" is the name on the certificate.

Reference:

-   http://sahissam.blogspot.com/2012/06/new-ssl-certificates-for-tomatousb-and.html

See also
--------

-   Profile-sync-daemon - Systemd service that saves Chromium profile in
    tmpfs and syncs to disk
-   Tmpfs - Tmpfs Filesystem in /etc/fstab
-   Official tmpfs kernel Documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chromium_tweaks&oldid=305076"

Category:

-   Web Browser

-   This page was last modified on 16 March 2014, at 12:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
