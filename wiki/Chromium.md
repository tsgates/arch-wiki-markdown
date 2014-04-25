Chromium
========

Related articles

-   Chromium tweaks
-   Browser plugins
-   Firefox
-   Opera

Chromium is an open-source graphical web browser from Google, based on
the Blink rendering engine.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Set Chromium as default browser
    -   2.2 File associations
    -   2.3 Font rendering
    -   2.4 Flash Player plugin
        -   2.4.1 Adobe Flash Player (Netscape plugin API)
        -   2.4.2 Adobe Flash Player (Pepper plugin API)
    -   2.5 PDF viewer plugin
        -   2.5.1 libpdf
        -   2.5.2 Using mozplugger
        -   2.5.3 Using the KParts plugin
    -   2.6 Print preview
    -   2.7 Certificates
-   3 Tips and tricks
-   4 Troubleshooting
    -   4.1 Constant freezes under KDE
    -   4.2 Cracking Sound
    -   4.3 Proxy settings
    -   4.4 Default profile
    -   4.5 WebGL
    -   4.6 Google Play and Flash
    -   4.7 Force 3D acceleration in Pepper Flash Player and i.g. the
        browser with radeon driver
    -   4.8 speech-dispatcher dumps core
-   5 See also

Installation
------------

The open source project, Chromium, can be installed with the package
chromium, available in the official repositories. In the AUR you can
also find:

-   chromium-dev - the development version (binary version:
    chromium-browser-bin)

The modified browser, Google Chrome, bundled with Flash Player and PDF
Reader, can be installed with the package google-chrome, available in
the AUR. In the AUR you can also find:

-   google-chrome-beta - the beta version
-   google-chrome-dev - the development version

Tip:See these two articles for an explanation of the differences between
Stable/Beta/Dev, as well as Chromium vs. Chrome and an explanation of
the version numbering.

Configuration
-------------

> Set Chromium as default browser

This behaviour is related to xdg-open: see xdg-open#set the default
browser. For more information about the topic in general, see Default
applications.

> File associations

This behaviour is related to xdg-open: see xdg-open#Configuration. For
more information about the topic in general, see Default applications.

> Font rendering

Note:Chromium bug 55458 seems to be affecting Arch Linux, causing
overlapping text sometimes.

Chromium (and Google Chrome) will use the settings in
~/.config/fontconfig/fonts.conf. For possibly better rendering you may
try the following. Create the file if it does not already exist.

    ~/.config/fontconfig/fonts.conf

    <match target="font">
      <edit mode="assign" name="autohint"><bool>true</bool></edit>
      <edit mode="assign" name="hinting"><bool>true</bool></edit>
      <edit mode="assign" name="hintstyle"><const>hintslight</const></edit>
    </match>

If the fonts are still rendered badly, you can use Xft settings as
suggested here:

    ~/.Xresources

    [...]
    ! Xft settings ---------------------------------------------------------------
    Xft.dpi:        96
    Xft.antialias:  true
    Xft.rgba:       rgb
    Xft.hinting:    true
    Xft.hintstyle:  hintslight
    [...]

Then update the X Resources database using:

    $ xrdb -merge ~/.Xresources

Note:These settings will affect any application that uses X Resources
for font settings; e.g. rxvt-unicode.

> Flash Player plugin

Adobe Flash Player (Netscape plugin API)

Warning:This version will not be updated (except for security updates),
and is stuck at version 11.2. It will be completely disabled by April
2014.[1]

The Adobe Flash plugin can be installed with the package flashplugin,
available in the official repositories.

Adobe Flash Player (Pepper plugin API)

While the classic Flash plugin will not be updated for Linux, an updated
Flash Player is included with Google Chrome. It is compatible with
Chromium.

The easiest way to install pepper-flash for Chromium is using one of the
packages provided in the AUR:

-   chromium-pepper-flash for the stable version.
-   chromium-pepper-flash-dev for a development version.

Note:If you have still flashplugin installed, in order for Chromium to
use this new Pepper Flash plugin, please make sure the plugin location
from /usr/lib/mozilla/plugins/libflashplayer.so is disabled and
/usr/lib/PepperFlash/libpepflashplayer.so is enabled in
chrome://plugins.

> PDF viewer plugin

There are multiple ways of enabling PDF support in Chromium that are
detailed below.

libpdf

libpdf is Google's own implementation of a PDF renderer included with
Google Chrome. It is compatible with Chromium. It runs in the
NaCl/Pepper sandbox.

The easiest way to install libpdf for Chromium is using one of the
packages provided in the AUR:

-   chromium-libpdf for the stable version.
-   chromium-libpdf-dev for a development version.

Enable the plugin in chrome://plugins.

> Note:

-   As a new version of Chromium will not update libpdf.so, it may
    become incompatible. Thus it is advisable to update both at the same
    time.
-   To install libpdf for other Chromium packages, edit the PKGBUILD of
    chromium-libpdf to install libpdf.so into correct path. For example,
    to install it for chromium-browser-bin, replace

    install -m644 opt/google/chrome/libpdf.so "${pkgdir}/usr/lib/chromium"

with

    install -m644 opt/google/chrome/libpdf.so "${pkgdir}/opt/chromium-browser"

Using mozplugger

See the main article: Browser plugins#MozPlugger

Using the KParts plugin

See the main article: Browser plugins#kpartsplugin

> Print preview

The print preview feature is disabled by default in Chromium, unlike
Google Chrome. Enabling it requires passing --enable-print-preview with
the #PDF viewer plugin installed.

> Certificates

Chromium uses NSS for the certificate management. Certificates can be
managed in Settings → Show advanced settings... →
Manage Certificates....

Tips and tricks
---------------

See the main article: Chromium tweaks

Troubleshooting
---------------

> Constant freezes under KDE

Uninstall libcanberra-pulse. See: BBS#1228558.

> Cracking Sound

There have been reports of cracking sound with chromium over hdmi audio.
Start chromium with a different audio buffer size to fix the issue:

    $ chromium --audio-buffer-size=2048

> Proxy settings

There have been many situations in which proxy settings do not work
properly, especially if set through the KDE interface. A good method as
of now is to use Chromium's command-line options, like --proxy-pac-url
and --proxy-server, to set your proxy.

> Default profile

If you cannot get your default profile when you try to run Chromium and
get a similar error instead:

    $ chromium

    [2630:2630:485325611:FATAL:chrome/browser/browser_main.cc(755)] Check failed: profile. 
    Cannot get default profile. Trace/breakpoint trap

You have to set the correct owner of the directory ~/.config/chromium as
following:

    # chown -R yourusername:yourusergroup ~/.config/chromium

> WebGL

Sometimes, Chromium will disable WebGL with certain graphics card
configurations. This can generally be remedied by typing about:flags
into the URL bar and enabling the WebGL flag. You may also enable WebGL
by passing the command line flag --enable-webgl to Chromium in the
terminal.

There is also the possibility that your graphics card has been
blacklisted by Chromium. To override this use the --ignore-gpu-blacklist
flag or go to about:flags and enable Override software rendering list.

If you're using Chromium with Bumblebee, WebGL might crash due to GPU
sand-boxing. In this case, you can disable GPU sand-boxing with
optirun chromium --disable-gpu-sandbox.

> Google Play and Flash

DRM content on Flash still requires HAL to play. This is readily
apparent with Google Play Movies. If one attempts to play a Google Play
movie without HAL, they will receive a YouTube-like screen, but the
video will not play. See Flash DRM content for more information.

Note:It is necessary to use flashplugin since chromium-pepper-flash does
not work with this method.

> Force 3D acceleration in Pepper Flash Player and i.g. the browser with radeon driver

To force 3D rendering there is an option "Override software rendering
list" in chrome://flags, also you would have to export video
acceleration variables, see ATI#Enabling_video_acceleration. You could
check if it is working in chrome://gpu.

> speech-dispatcher dumps core

Note:This was reported as bug FS#38456.

Chromium installs speech-dispatcher as a dependency. The latter is an
independent layer for speech synthesis interface and by default uses
festival as its back end. If you are frequently receiving core dumps, it
is likely caused by not having installed festival. To resolve the error
message, either install festival or change the back end used by
speech-dispatcher.

See also
--------

-   Chromium homepage
-   Google Chrome release notes
-   Chrome web store
-   Differences between Chromium and Google Chrome
-   List of Chromium command-line switches

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chromium&oldid=305082"

Category:

-   Web Browser

-   This page was last modified on 16 March 2014, at 12:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
