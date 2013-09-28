Citrix
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Install from AUR                                                   |
|     -   1.1 Install Package                                              |
|     -   1.2 Update make dependencies for package lib32-libxaw (x86_64    |
|         only)                                                            |
|     -   1.3 Set Firefox to use Citrix                                    |
|     -   1.4 Google Chromium                                              |
|                                                                          |
| -   2 Manual Install                                                     |
|     -   2.1 Installation                                                 |
|     -   2.2 Security Certificates                                        |
+--------------------------------------------------------------------------+

Install from AUR
----------------

Install Package

citrix-client x86 and x86_64 (multilib)

icaclient x86_64

SSL connections are supported by default in both of these packages.

Update make dependencies for package lib32-libxaw (x86_64 only)

When installing the lib32-xaw dependency, a conflict will be signalled
for the packages gcc, gcc-libs, and binutils.

Replace these packages with their multilib versions, but do not forget
to reinstall them after icaclient has been succesfully installed

Set Firefox to use Citrix

Then set Firefox to use one the following programs to open .ICA files,
depending on your architecture.

x86:

    /usr/bin/citrix-client.sh

x86_64:

    /opt/Citrix/ICAClient/wfica

Google Chromium

If you have problems launching Citrix applications with Chromium, just
go to about:plugins and disable "Citrix Receiver for Linux".

Next, create /usr/share/applications/wfica.desktop (Exec path may vary
based on package installed):

    [Desktop Entry]
    Name=Citrix ICA client
    Comment="Launch Citrix applications from .ica files"
    Categories=Network;
    Exec=/usr/bin/wfica
    Terminal=false
    Type=Application
    NoDisplay=true
    MimeType=application/x-ica;

Now xdg-open will handle .ica extensions using /usr/bin/wfica.

Note: if you are running Xfce and Chromium is opening the .ica files in
the wrong application (e.g. a text editor), make sure you have
xorg-xprop installed.

Manual Install
--------------

Installation

-   Step 0. 64-bit Arch systems only - install 32-bit libs:

from arch repositories: lib32-libxmu, for nspluginwrapper:
lib32-alsa-lib, lib32-gcc-libs, lib32-libxft, lib32-gtk2,
lib32-libxdamage. From AUR: lib32-printproto, lib32-libxp, lib32-libxpm,
lib32-libxaw, lib32-openmotif, nspluginwrapper

If you have a 64 bit version of Firefox, the Citrix plugin will not be
detected. To use the 32 bit plugin, install nspluginwrapper-ubuntu from
the AUR. Then do:

    # nspluginwrapper -i /usr/lib32/ICAClient/npica.so

You can read this thread for more information.

  

-   Step 1. Download the Citrix XenApp linux binary. It can be found
    here: citrix.com > Downloads > Citrix Clients > Linux Clients >
    Choose the latest version of the x86 client in the .tar.gz format.
    It reads "x86 client - requires OpenMotif v.2.3.1"
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

    # find /usr -name npica.so
    /usr/local/lib/netscape/plugins/npica.so
    /usr/lib/ICAClient/npica.so
    /usr/lib/firefox-3.5/plugins/npica.so
    /usr/lib/mozilla/plugins/npica.so

Or you can check if your browser loads the plugin, in Firefox this can
be done by typing "about:plugins" in the address bar. If you have a
64-bit version of Firefox, the plugin will not be loaded. You can check
below what to do.

Create missing links as such:

    # ln -s /usr/lib32/ICAClient/npica.so /opt/mozilla/lib/plugins/

-   Step 5. Install openmotif:

        # pacman -S community/openmotif

-   Step 6. (Might not be necessary:)

        # ln -s /usr/lib/libXm.so.4 /usr/lib/libXm.so.3

-   Step 7. Restart your browser

At this point, everything should work, including wfcmgr. In the case of
Opera, integration should be automatic. The ICAClient will automatically
be launched whenever you try to access a citrix-based application from
either Firefox or Opera.

Note: If for some reason firefox prompts you for which application to
use when opening a citrix-based application, use
/usr/lib/ICAClient/wfica

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

    # cp /usr/share/ca-certificates/mozilla/* /usr/lib/ICAClient/keystore/cacerts/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Citrix&oldid=249400"

Category:

-   Virtualization
