Chromium
========

Summary

General information, installation and troubleshooting for Chromium.

Related

Chromium Tips and Tweaks

Browser Plugins

Firefox

Opera

Chromium is an open source graphical web browser from Google, based on
the WebKit rendering engine.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 File associations                                            |
|     -   2.2 Font Rendering                                               |
|         -   2.2.1 Non-Latin characters                                   |
|                                                                          |
|     -   2.3 Default browser                                              |
|     -   2.4 Flash Player                                                 |
|     -   2.5 Google Play & Flash                                          |
|     -   2.6 Open PDF files inside Chromium                               |
|         -   2.6.1 Using Google Chrome's libpdf                           |
|             -   2.6.1.1 Using packages from AUR                          |
|             -   2.6.1.2 Manual method                                    |
|                                                                          |
|         -   2.6.2 Using mozplugger                                       |
|         -   2.6.3 Using the KParts plugin                                |
|                                                                          |
|     -   2.7 Certificates                                                 |
|                                                                          |
| -   3 Tips and Tricks                                                    |
| -   4 Troubleshooting                                                    |
|     -   4.1 Proxy Settings                                               |
|     -   4.2 Default profile                                              |
|     -   4.3 WebGL                                                        |
|     -   4.4 Pulseaudio & PA-Alsa-Bridge & Pepper-Flash                   |
|                                                                          |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Chromium can be installed with the package chromium, available in the
official repositories.

In the AUR you can also find:

-   chromium-dev - a development version of the Chromium browser.
-   chromium-update - an update. script for Chromium nighly builds,
    pre-compiled on the Chromium buildbot server.
-   chromium-browser-bin - a binary version of the latest Chromium
    build.
-   iron-bin - a binary version of Chromium without Google's 'tracking
    features'

Note:Compiling chromium-dev takes at least as long as compiling the
Linux kernel.

Various versions of the modified Google Chrome browser can be found in
the AUR:

-   google-chrome
-   google-chrome-beta
-   google-chrome-dev

See these two articles for an explanation of the differences between
Stable/Beta/Dev, as well as Chromium vs. Chrome and the version numbers.

Configuration
-------------

> File associations

Unlike Firefox, Chromium does not maintain its own database of
mimetype-to-application associations. Instead, it relies on xdg-open to
open files and other mime types, for example, magnet links.

There are exceptions to this rule though. In the case of mailto URIs,
Chromium calls out to xdg-email which is similar to xdg-open. Other
protocol handlers may have equivalent scripts so check /usr/bin/xdg*.

The behaviour of xdg-* tools is managed automatically in environments
such as GNOME, KDE, Xfce or LXDE, but does not work in others. Usually
this behaviour can be fixed by tricking them into thinking that they are
operating in one of the supported desktop environments. Depending on
your environment one may work and another will not so trying each is
recommended. You can set the desktop environment with the following
variable:

    export DE=INSERT_DE_HERE

where the recognised desktop environments are: gnome, kde, xfce and
lxde. For the variable to be always set, put it somewhere like
~/.xinitrc or ~/.bashrc.

An alternative is to edit the xdg-open or xdg-email scripts and
hard-code a useful DE. At the bottom of the file you will see something
like this:

    /usr/bin/xdg-open

    detectDE

    if [ x"$DE" = x"" ]; then
        DE=generic
    fi

    DEBUG 2 "Selected DE $DE"

    # if BROWSER variable is not set, check some well known browsers instead
    if [ x"$BROWSER" = x"" ]; then
        BROWSER=links2:elinks:links:lynx:w3m
        if [ -n "$DISPLAY" ]; then
            BROWSER=x-www-browser:firefox:seamonkey:mozilla:epiphany:konqueror:chromium-browser:google-chrome:$BROWSER
        fi
    fi

    case "$DE" in
        kde)
        open_kde "$url"
        ;;

        gnome*)
        open_gnome "$url"
        ;;

        mate)
        open_mate "$url"
        ;;

        xfce)
        open_xfce "$url"
        ;;

        lxde)
        open_lxde "$url"
        ;;

        generic)
        open_generic "$url"
        ;;

        *)
        exit_failure_operation_impossible "no method available for opening '$url'"
        ;;
    esac

change the third line: DE=generic to one of the supported desktop
environments (e.g. DE=gnome).

Note:These changes are lost when any of the utilities are upgraded.

An approach which is less useful is to place the required application in
the default browser list:

       BROWSER=links2:links:lynx:w3m
       if [ -n "$DISPLAY" ]; then
           BROWSER=firefox:mozilla:epiphany:konqueror:chromium-browser:google-chrome:$BROWSER
       fi

xdg-open and xdg-email fall back to this list of browsers and will use
the first that they find to attempt to open the URI. You could add the
name of the application to the beginning of the list. However there is
no guarantee that the application will be called correctly to meet your
needs, e.g. your mail client will open but it will not correctly receive
the mailto address. Also it will only work for one application.

A fourth option is to make a softlink from your preferred application to
one of the names on the browser list. This approach has the same
problems as the previous work around. For more discussion on these ideas
see this forum thread.

> Font Rendering

Chromium is now supposed to use the settings in ~/.fonts.conf, though
you may have to edit it manually (see Font Configuration). If your fonts
setting are stored in another place, create ~/.fonts.conf and add these
lines:

    ~/.fonts.conf

     <match target="font">
        <edit name="autohint" mode="assign">
          <bool>true</bool>
        </edit>
        <edit name="hinting" mode="assign">
          <bool>true</bool>
        </edit>
        <edit mode="assign" name="hintstyle">
          <const>hintslight</const>
        </edit>
      </match>

If the fonts are still rendered badly, you can use Xft settings as
suggested here. Create ~/.Xresources if it does not exist and add in:

    ~/.Xresources

    ...
    ! Xft settings ---------------------------------------------------------------
    Xft.dpi:        96
    Xft.antialias:  true
    Xft.rgba:       rgb
    Xft.hinting:    true
    Xft.hintstyle:  hintslight
    ...

Then update the X Resources database using:

    xrdb -merge ~/.Xresources

Note:These settings will affect any application that uses X Resources
for font settings; one example is rxvt-unicode.

Non-Latin characters

Install needed fonts to correctly display Chinese, Japanese, Korean
characters. For examples of recommended fonts for various languages see
Font Packages.

For the Arch Wiki, one only needs the ttf-arphic-uming package.

> Default browser

The simplest way to make Chromium the default browser is to set variable
$BROWSER=chromium in ~/.profile

    if [ -n "$DISPLAY" ]; then
         BROWSER=chromium
    fi

To test if this was applied successfully, try to open an URL with
xdg-open as follows:

    $ xdg-open http://google.com/

If everything went well, either a new tab inside Chromium, or a new
window would open and display the Google homepage, depending on your
settings.

Another option, when using mimeo, is to associate "http://" links with
Chromium:

    ~/.config/mimeo.conf

    /usr/bin/chromium
      ^http://

If all of that still does not get it working, you can try adding the
following to the [Added Associations] list in
~/.local/share/applications/mimeapps.list:

    x-scheme-handler/http=chromium.desktop

If even that didn't work, try this:

    $ xdg-mime default chromium.desktop x-scheme-handler/http
    $ xdg-mime default chromium.desktop x-scheme-handler/https

For more info, see Xdg-open.

> Flash Player

The Adobe Flash plugin can be installed with the package flashplugin,
available in the official repositories.

While the classic Flash plugin will not be updated for Linux, Chromium
can use the Flash plugin from Google Chrome (that uses the new Pepper
API). This plugin is available in the AUR with the chromium-pepper-flash
or chromium-pepper-flash-stable packages.

Note:Make sure to enable the Flash plugin with location
/usr/lib/PepperFlash/libpepflashplayer.so in chrome://plugins and
disable the plugin with location
/usr/lib/mozilla/plugins/libflashplayer.so.

If Pepper Flash doesn't show up in the plugins list (as is the case for
Iron) then disable libflashplayer.so and start with the following
command.

    iron --ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=11.5.31.101

Enable only one flash player at a time by going to chrome://plugins ->
details -> Adobe Flash Player

> Google Play & Flash

DRM content on Flash still requires HAL to play. This is readily
apparent with Google Play Movies. If one attempts to play a Google Play
movie without HAL, they will receive a youtube like screen but the video
will not play.

Note : Chromium-pepper-flash doesn't work with this method, the user
must ensure they are using flashplugin.

As per "Watching movies from Google Play on Arch Linux"; install hal and
hal-info. Then run the following bash code :

    cd ~/.adobe/Flash_Player;                       ## enter the adobe Flash player directory
    rm -rf NativeCache AssetCache APSPrivateData2;  ## remove cache

Start the HAL daemon and one will be able to watch Google Play Movie
content.

    # systemctl start hal.service

Alternately one can just save the following bash script below and run it
before they want to watch Google Play Movie content.

    #!/bin/bash

    ## written by Mark Lee <bluerider>
    ## using information from <https://wiki.archlinux.org/index.php/Chromium#Google_Play_.26_Flash>

    ## Start and stop Hal service on command for Google Play Movie service

    function main () {  ## run the main insertion function
    clear-cache;  ## remove adobe cache
    start-hal;  ## start the hal daemon
    read -p "Press 'enter' to stop hal";  ## pause the command line with a read line
    stop-hal;  ## stop the hal daemon
    }

    function clear-cache () {  ## remove adobe cache
    cd ~/.adobe/Flash_Player;  ## go to Flash player user directory
    rm -rf NativeCache AssetCache APSPrivateData2;  ## remove cache
    }

    function start-hal () {  ## start the hal daemon
    sudo systemctl start hal.service && ( ## systemd : start hal daemon
     echo "Started hal service..."
     ) || (
     echo "Failed to start hal service!"
     ) 
    }

    function stop-hal () {  ## stop the hal daemon
    sudo systemctl stop hal.service && (  ## systemd : stop hal daemon
     echo "Stopped hal service..."
     ) || (
     echo "Failed to stop hal service!"
     )
    }

    main;  ## run the main insertion function

> Open PDF files inside Chromium

There are multiple ways of enabling PDF support in Chromium that are
detailed below.

Using Google Chrome's libpdf

libpdf is Google's own implementation of a PDF renderer. While
compatible, it is currently only part of Chrome releases, not Chromium
ones.

Note:chromium-dev includes development versions of libpdf and
PepperFlash.

Using packages from AUR

The easiest way to install libpdf for chromium is using one of the
packages provided in the AUR:

-   chromium-libpdf-stable for the stable version.
-   chromium-libpdf for a development version.

Note:To install libpdf for other Chromium packages, edit the PKGBUILD of
chromium-libpdf-stable to install libpdf.so into correct path. For
example, to install it for chromium-browser-bin, replace

    install -m644 opt/google/chrome/libpdf.so "${pkgdir}/usr/lib/chromium"

with

    install -m644 opt/google/chrome/libpdf.so "${pkgdir}/opt/chromium-browser"

Manual method

To do it manually, download a Google Chrome release that corresponds to
the version of Chromium you use:

    $ wget https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_i386.deb
    $ wget https://dl-ssl.google.com/linux/direct/google-chrome-unstable_current_i386.deb

    $ wget https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    $ wget https://dl-ssl.google.com/linux/direct/google-chrome-unstable_current_amd64.deb

Extract the deb file with

    $ ar vx <deb-file>

Extract LZMA archive with

    $ tar -xJf <lzma-file>

Move libpdf.so from opt/google/chrome/ to the appropriate directory as
stated above. A change of its file permissions and ownership may be
necessary (the permission of libpdf.so should be 755).

To verify that the installation went correctly: start Chromium, open
about:plugins and check if "Chrome PDF Viewer" is available (it may need
to be enabled).

Note:As a new version of Chromium will not update libpdf.so, it may
become incompatible. Thus and with respect to possible security fixes it
is advisable to update both at the same time.

Using mozplugger

See the main article: Browser Plugins#MozPlugger

For information about the installation see Browser Plugins#PDF viewer.

Using the KParts plugin

See the main article: Browser Plugins#kpartsplugin

> Certificates

Chromium uses NSS for the certificate management. Certificates can be
managed (including added) by going to Settings, clicking the Show
advanced settings.. link and then Manage Certificates.

Tips and Tricks
---------------

See the main article: Chromium Tips and Tweaks

Troubleshooting
---------------

> Proxy Settings

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

you have to set the correct owner of the directory ~/.config/chromium as
following:

    $ sudo chown -R yourusername:yourusergroup /home/yourusername/.config/chromium

> WebGL

Sometimes, Chromium will disable WebGL with certain graphics card
configurations. This can generally be remedied by typing about:flags
into the URL bar and enabling the WebGL flag. You may also enable WebGL
by passing the command line flag --enable-webgl to Chromium in the
terminal.

There is also the possibility that your graphics card has been
blacklisted by Chromium. To override this, pass the flag
--ignore-gpu-blacklist when starting Chromium, alternatively, go to
about:flags and enable Override software rendering list.

> Pulseaudio & PA-Alsa-Bridge & Pepper-Flash

Given a certain version of Chrome (23.x seem to exhibit this problem)
and Pepper-Flash (11.x) while using the PA-Alsa-Bridge, sound may not
play, become distorted, start skipping or outright keep crashing the
PA-Alsa-Bridge continously. See [1] for the bugreport.

A possible workaround is to use pasuspender to suspend Pulseaudio and
force Chrome to use Alsa directly.

First, create an ~/.asoundrc file to default Alsa to your real hardware
instead of Pulseaudio. See Alsa and [2] for more information. Exemplary
~/.asoundrc:

    ~/.asoundrc

    pcm. !default {
        type hw
        card 0
        device 0
    }

Then use pasuspender to suspend Pulseaudio and force Chrome to use Alsa
which now uses your real hardware.

    pasuspender -- google-chrome

The problem might be related to the tsched=0 option in Pulseaudio. See
Pulseaudio#Glitches, skips or crackling and comment #27 in [3].

See Also
--------

-   Chromium Homepage
-   Google Chrome Release Notes
-   Chrome Web Store
-   Differences between Chromium and Google Chrome
-   List of Chromium command-line switches

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chromium&oldid=253210"

Category:

-   Web Browser
