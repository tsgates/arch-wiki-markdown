Chromium Tips and Tweaks
========================

Summary

Tips and Tweaks for Chromium are captured in this article.

Related

Chromium

Firefox Tweaks

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Browsing experience                                                |
|     -   1.1 about:xxx                                                    |
|     -   1.2 Broken icons in Download Tab                                 |
|     -   1.3 Chromium overrides/overwrites Preferences file               |
|     -   1.4 Memory usage                                                 |
|     -   1.5 Scroll speed of mouse wheel                                  |
|     -   1.6 Search Engines                                               |
|     -   1.7 Tmpfs                                                        |
|         -   1.7.1 Cache in tmpfs                                         |
|         -   1.7.2 Profile in tmpfs                                       |
|                                                                          |
| -   2 Profile Maintenance                                                |
| -   3 Security                                                           |
|     -   3.1 Run in a Sandbox                                             |
|     -   3.2 User Agent                                                   |
|     -   3.3 Making it all persistent                                     |
|     -   3.4 SSL Certificates                                             |
|         -   3.4.1 Adding CAcert Certificates for Self-Signed             |
|             Certificates                                                 |
|         -   3.4.2 Example 1: Using a Shell Script Isolate the            |
|             Certificate from TomatoUSB                                   |
|         -   3.4.3 Example 2: Using Firefox to Isolate the Certificate    |
|             from TomatoUSB                                               |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Browsing experience
-------------------

> about:xxx

A number of tweaks can be accessed via typing about:xxx in the URL
field. A complete list is available by typing about:chrome-urls into the
URL field. Some of note are listed below:

-   about:flags - access experimental features such as WebGL and
    rendering webpages with GPU, etc.
-   about:plugins - view, enable and disable the currently used Chromium
    plugins.
-   about:gpu-internals - status of different GPU options.
-   about:sandbox - indicate sandbox status.
-   about:version - display version and switches used to invoke the
    active /usr/bin/chromium.

An automatically updated, complete listing of Chromium switches is
available here.

> Broken icons in Download Tab

If Chromium shows icon placeholders (icons representing broken
documents) instead of appropriate icons in its download tab, the likely
cause is that the gnome-icon-theme package is not installed.

> Chromium overrides/overwrites Preferences file

If you enabled syncing with a Google Account, then Chromium will tend to
override any edits made by hand to the Preferences file found under
$HOME/.config/google-chrome/Default/Preferences. To work around this,
start Chromium with the --disable-sync-preferences switch:

    $ chromium --disable-sync-preferences

If Chromium is started in the background when you login to your desktop
environment, make sure the command your desktop environment uses is

    $ chromium --disable-sync-preferences --no-startup-window

> Memory usage

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Now chromium no  
                           longer support           
                           --memory-model option.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Chromium offers some command-line options to help control how efficient
it is with system memory, by determining how often it should release
memory back to the operating system. It is done with the flag
--memory-model=X, where X is one of the following:

-   high - Never voluntarily relinquish memory.
-   medium - Voluntarily reduce working set when switching tabs.
-   low - Voluntarily reduce working set when switching tabs and also
    when the browser is not actively being used.

It is also possible to manually force Chromium to purge its memory. The
flag --purge-memory-button enables a button in the task manager
(available in Tools > Task Manager, or by pressing Shift+Esc) to do
this.

> Scroll speed of mouse wheel

Note:As of 22-Feb-2013, this method is deprecate upstream. See this.

chromium-scroll-pixels in the AUR reverses this patch.

Graysky provides this package compiled for x86_64 only on his unofficial
repo, Repo-ck.

The following switch can be used to set the scroll speed of the wheel
mouse: --scroll-pixels=X

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

Note:Adjust the size as needed.

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

> Run in a Sandbox

Run chromium in a sandbox for added security:

    $ chromium --enable-seccomp-sandbox

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
"https://wiki.archlinux.org/index.php?title=Chromium_Tips_and_Tweaks&oldid=255357"

Category:

-   Web Browser
