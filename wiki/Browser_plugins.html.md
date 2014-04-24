Browser plugins
===============

These plugins work in Firefox, Opera and WebKit derivatives.

Contents
--------

-   1 Flash Player
    -   1.1 Shumway
    -   1.2 Gnash
    -   1.3 Lightspark
    -   1.4 Adobe Flash Player
        -   1.4.1 Configuration
        -   1.4.2 Disable the "Press ESC to exit full screen mode"
            message
        -   1.4.3 Fullscreen fix for GNOME 3
            -   1.4.3.1 Firefox
            -   1.4.3.2 Chrome / Chromium
            -   1.4.3.3 Epiphany / GNOME Web
-   2 PDF viewer
    -   2.1 PDF.js
    -   2.2 External PDF viewers
    -   2.3 Adobe Reader
        -   2.3.1 32-bit
        -   2.3.2 64-bit
-   3 Citrix
-   4 Java (IcedTea)
-   5 Video plugins
-   6 Other
    -   6.1 MozPlugger
    -   6.2 kpartsplugin
-   7 Troubleshooting
    -   7.1 Flash Player: no sound
    -   7.2 Flash Player: blocking sound for other applications or
        delayed playback
    -   7.3 Flash Player: bad (choppy) sound on the 64-bit version
    -   7.4 Flash Player: performance
    -   7.5 Flash Player: low webcam resolution
    -   7.6 Flash Player: black bars in full screen playback on
        multi-headed setups
    -   7.7 Flash Player: blue tint on videos with NVIDIA
    -   7.8 Flash Player: leaking overlay with NVIDIA
    -   7.9 Flash Player: videos not working on older systems
    -   7.10 Plugins are installed but not working
    -   7.11 Gecko Media Player will not play Apple trailers

Flash Player
------------

> Shumway

Shumway is an HTML5 technology experiment that explores building a
faithful and efficient renderer for the SWF file format without native
code assistance. As of 2013-01-01, the plugin may be installed directly
from Mozilla's github.io site. According to the Shumway wiki,
"Integration with Firefox is a possibility if the experiment proves
successful."

Shumway is also embedded in Firefox Nightly/Aurora builds.

> Gnash

See the Wikipedia article on this subject for more information: Gnash

GNU Gnash is a free (libre) alternative to Adobe Flash Player. It is
available both as a standalone player for desktop computers and embedded
devices, as well as a browser plugin, and supports the SWF format up to
version 7 (with versions 8 and 9 under development) and about 80% of
ActionScript 2.0.

GNU Gnash can be installed with the package gnash-gtk, available in the
official repositories.

Note:If you find that Gnash doesn't work properly right out of the box,
then you may also need to install gstreamer0.10-ffmpeg from the official
repositories.

> Lightspark

Lightspark is another attempt to provide a free alternative to Adobe
Flash aimed at supporting newer Flash formats. Lightspark has the
ability to fall back on Gnash for old content, which enables users to
install both and enjoy wider coverage. Although it is still very much in
development, it supports some popular sites.

Lightspark can be installed with the package lightspark or
lightspark-git, available in the AUR.

> Adobe Flash Player

Install flashplugin from the official repositories.

> Note:

-   Adobe Flash Player for Linux using the NPAPI was discontinued by
    Adobe, although security updates for version 11.2 will be provided
    for another 5 years by Adobe (i.e. 2017). Adobe will, however,
    release new versions of PPAPI version of the plugin, shipped with
    Google Chrome. See Chromium#Adobe Flash Player (Pepper plugin API)
    for more information.
-   Some Flash apps may require ttf-ms-fonts from the AUR in order to
    properly render text.

Configuration

To change the preferences (privacy settings, resource usage, etc.) of
Flash Player, right click on any embedded Flash content and choose
Settings from the menu, or go to the Adobe website. There, a Flash
animation will give you access to your local settings.

You can also use the Flash settings file /etc/adobe/mms.cfg. An example
configuration:

    /etc/adobe/mms.cfg

    # Adobe player settings
    AVHardwareDisable = 0
    FullScreenDisable = 0
    LocalFileReadDisable = 1
    FileDownloadDisable = 1
    FileUploadDisable = 1
    LocalStorageLimit = 1
    ThirdPartyStorage = 1
    AssetCacheSize = 10
    AutoUpdateDisable = 1
    LegacyDomainMatching = 0
    LocalFileLegacyAction = 0
    AllowUserLocalTrust = 0
    # DisableSockets = 1 
    OverrideGPUValidation = 1

    # Prevent sites to identify you by snooping the fonts installed:
    DisableDeviceFontEnumeration = 1

    # Enable VDPAU hardware decoding:
    EnableLinuxHWVideoDecode=1

You can also refer to the mms.cfg from Gentoo, which is extensively
commented.

Disable the "Press ESC to exit full screen mode" message

For a way to disable this message see this ubuntuforums.org post.

Backup libflashplayer.so:

    # cp /usr/lib/mozilla/plugins/libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so.backup 

Make a copy of it in your home directory:

    # cp /usr/lib/mozilla/plugins/libflashplayer.so ~/

Install wine from the official repositories.

Download Flash Fullscreen Patcher.zip from this page, extract and
execute with wine:

    $ wget http://forum.videohelp.com/attachments/16250-1360745667/Flash%20Fullscreen%20Patcher.zip
    $ unzip Flash\ Fullscreen\ Patcher\ 2.0.zip
    $ wine Flash\ Fullscreen\ Patcher\ 2.0.exe

Patch libflashplayer.so (the one from your home directory) using the
GUI. Copy the patched Flash Player back to the plugins directory:

    # cp ~/libflashplayer.so /usr/lib/mozilla/plugins/

Fullscreen fix for GNOME 3

If you have problems with Flash's fullscreen-mode (video freezes but
audio keeps playing), then it's probably because the fullscreen flash
window is displayed behind the browser window. This is a known upstream
bug in mutter. You can easily fix this by using devilspie:

Install devilspie from the official repositories.

Create the ~/.devilspie directory:

    # mkdir ~/.devilspie

Now you have to create a config file for each browser you use (see
below)

Finally, add devilspie to your list of startup items (usually in
gnome-session-properties).

Firefox

    ~/.devilspie/flash-fullscreen-firefox.ds

    (if
    (is (application_name) "plugin-container")
    (begin
    (focus)
    )
    )

Chrome / Chromium

    ~/.devilspie/flash-fullscreen-chrome.ds

    (if
    (is (application_name) "exe")
    (begin
    (focus)
    )
    )

Epiphany / GNOME Web

    ~/.devilspie/flash-fullscreen-epiphany.ds

    (if
    (is (application_name) "WebKitPluginProcess")
    (begin
    (focus)
    )
    )

PDF viewer
----------

> PDF.js

See the Wikipedia article on this subject for more information: Pdf.js

PDF.js is a PDF renderer created by Mozilla and built using HTML5
technologies. It is currently available as a Firefox plugin. For Chrome
there is an experimental version in the Chrome web store or
alternatively can be built from the source of Pdf.js

> External PDF viewers

To use an external PDF viewer you need #MozPlugger or #kpartsplugin.

If you want to use MozPlugger with Evince, for example, you have to find
the lines containing pdf in the /etc/mozpluggerrc file and modify the
corresponding line after GV() as below:

    repeat noisy swallow(evince) fill: evince "$file"

(replace evince with something else if it is not your viewer of choice).

If this isn't enough, you may need to change 2 values in about:config:

-   Change pdfjs.disabled's value to true;
-   Change plugin.disable_full_page_plugin_for_types's value to an empty
    value.

Restart and it should work like a charm!

> Adobe Reader

Due to licensing restrictions, Adobe Reader cannot be distributed from
any of the official Arch Linux repositories. There are versions
available in the AUR. Please note that no matter how many votes it
receives, Adobe Reader will never be included in the official
repositories.

Also, there are localizations available in many languages.

32-bit

Adobe Acrobat Reader is only available as a 32-bit binary. It can be
installed with the acroread package, available in the AUR.

This package installs the Acrobat Reader application as well as the
Firefox plugin. Note that hardware-assisted rendering is unavailable
under Linux (at least using a Geforce 8600GTS with driver version
185.18.14).

64-bit

There is yet to be an official 64-bit version of Adobe Reader.

To use it in a 64-bit environment, you can:

-   Follow this guide originally posted in the forums. It involves
    creating a chrooted environment that could be reused for other
    32-bit only applications.

-   Install acroread (with all its 32-bit dependencies) from AUR. Be
    advised that the Firefox plugin cannot be used directly with this
    binary -- it will not load in the 64-bit browser. To load it install
    the nspluginwrapper package from the official [multilib] repository
    and run:

    $ nspluginwrapper -v -a -i

as a normal user. This checks the plugin directory and links the plugins
as needed.

Citrix
------

See the main article: Citrix.

Java (IcedTea)
--------------

To enable Java support in your browser, you have two options: the
open-source OpenJDK (recommended) or Oracle's proprietary version. For
details about why OpenJDK is recommended see this.

To use OpenJDK, you have to install the IcedTea browser plugin:

-   icedtea-web-java7 for version 7 of the Java environment.

If you want to use Oracle's JRE, install the jre (or jre6) package,
available in the AUR.

See Java#OpenJDK for additional details and references.

Note:If you experience any problems with the Java plugin (e.g. it is not
recognized by the browser), you can try this solution.

Video plugins
-------------

-   Gecko Media Player — Mozilla browser plugin to handle media on
    websites, using MPlayer.

https://sites.google.com/site/kdekorte2/gecko-mediaplayer ||
gecko-mediaplayer

-   Totem Plugin — Browser plugin based on the Totem media player for
    Gnome which uses Gstreamer.

http://projects.gnome.org/totem/ || totem-plugin

-   Rosa Media Player Plugin — Qt-based browser plugin also based on
    MPlayer.

https://abf.rosalinux.ru/uxteam/ROSA_Media_Player ||
rosa-media-player-plugin

-   VLC Plugin — NPAPI-based plugin that uses VLC technologies.

http://git.videolan.org/?p=npapi-vlc.git;a=summary || npapi-vlc-git

Other
-----

> MozPlugger

MozPlugger can be installed with the mozplugger package, respectively
mozplugger-chromium, available in the AUR.

MozPlugger is a Mozilla plugin which can show many types of multimedia
inside your browser. To accomplish this, it uses external programs such
as MPlayer, xine, Evince, OpenOffice, TiMidity, etc. To modify or add
applications to be used by MozPlugger just modify the /etc/mozpluggerrc
file.

For example, MozPlugger uses OpenOffice by default to open doc files. To
change it to use LibreOffice instead, look for the OpenOffice section:

    /etc/mozpluggerrc

    ...
    ### OpenOffice
    define([OO],[swallow(VCLSalFrame) fill: ooffice2.0 -nologo -norestore -view $1 "$file"
        swallow(VCLSalFrame) fill: ooffice -nologo -norestore -view $1 "$file"
        swallow(VCLSalFrame) fill: soffice -nologo $1 "$file"])
    ...

and add LibreOffice at the beginning of the list:

    /etc/mozpluggerrc

    ...
    ### LibreOffice/OpenOffice
    define([OO],[swallow(VCLSalFrame) fill: libreoffice --nologo --norestore --view $1 "$file"
        swallow(VCLSalFrame) fill: ooffice2.0 -nologo -norestore -view $1 "$file"
        swallow(VCLSalFrame) fill: ooffice -nologo -norestore -view $1 "$file"
        swallow(VCLSalFrame) fill: soffice -nologo $1 "$file"])
    ...

Note:Be sure to also choose LibreOffice as your preferred application to
open doc files.

As another simple example, if you want to open cpp files with your
favorite text editor (we will use Kate) to get syntax highlighting, just
add a new section to your mozpluggerrc file:

    /etc/mozpluggerrc

    text/x-c++:cpp:C++ Source File
    text/x-c++:hpp:C++ Header File
        repeat noisy swallow(kate) fill: kate -b "$file"

For a more complete list of MozPlugger options see this page.

> kpartsplugin

The KParts plugin is a plugin that uses KDE's KPart technology to embed
different file viewers in the browser, such as Okular (for PDF), Ark
(for different archives), Calligra Words (for ODF), etc. It cannot use
applications that are not based on the KPart technology.

The KParts plugin can be installed with the package kpartsplugin,
available in the official repositories.

Troubleshooting
---------------

> Flash Player: no sound

Flash Player outputs its sound only through the default ALSA device,
which is number 0. If you have multiple sound devices (a very common
example is having a sound card and HDMI output in the video card), then
your preferred device may have a different number.

For a list of available devices with their respective numbers, run:

    $ aplay -l

     **** List of PLAYBACK Hardware Devices ****
     card 0: Generic [HD-Audio Generic], device 3: HDMI 0 [HDMI 0]
       Subdevices: 1/1
       Subdevice #0: subdevice #0
     card 1: DX [Xonar DX], device 0: Multichannel [Multichannel]
       Subdevices: 0/1
       Subdevice #0: subdevice #0
     card 1: DX [Xonar DX], device 1: Digital [Digital]
       Subdevices: 1/1
       Subdevice #0: subdevice #0

In this case, the HDMI output is card 0 and the sound card is card 1. To
make your sound card the default for ALSA, create the file .asoundrc in
your home directory, with the following content:

    ~/.asoundrc

    pcm.!default {
        type hw
        card 1
    }
     
    ctl.!default {
        type hw
        card 1
    }

> Flash Player: blocking sound for other applications or delayed playback

If sound is delayed within Flash videos or Flash stops sound from any
other application, then make sure you do not have snd_pcm_oss module
loaded:

    $ lsmod | grep snd_pcm_oss

You can unload it:

    # rmmod snd_pcm_oss

and restart the browser to see if it helps.

> Flash Player: bad (choppy) sound on the 64-bit version

There is a problem with Flash plugin 11 on 64-bit systems and a new
memcpy routine in glibc (for more details see this Fedora bug report),
which makes the sound choppy on MP3 streams. Current workarounds are:

-   replacing the memcpy routine as suggested in this thread.
-   installing flashplugin-square from the AUR (this is a version of the
    Flash plugin with working hardware acceleration).

> Flash Player: performance

Adobe's Flash plugin has some serious performance issues, especially
when CPU frequency scaling is used. There seems to be a policy not to
use the whole CPU workload, so the frequency scaling governor does not
clock the CPU any higher. To work around this issue, see Cpufrequtils

> Flash Player: low webcam resolution

If your webcam has low resolution in Flash (the image looks very
pixelated) you can try starting your browser with this:

    $ LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so [broswer]

> Flash Player: black bars in full screen playback on multi-headed setups

The Flash plugin has a known bug where the full screen mode does not
really work when you have a multi-monitor setup. Apparently, it
incorrectly determines the full screen resolution, so the full screen
Flash Player fills the correct monitor but gets scaled as if the monitor
had the resolution of the total display area.

To fix this, you can use the "hack" described here. Simply download the
source from the link given on the page, and follow the instructions in
the README.

Tip:The hack is available in the AUR and can be installed with the
fullscreenhack package.

Note:While the author mentions using NVDIA's TwinView, the hack should
work for any multi-monitor setup.

> Flash Player: blue tint on videos with NVIDIA

An issue with flashplugin versions 11.2.202.228-1 and 11.2.202.233-1
causes it to send the U/V panes in the incorrect order resulting in a
blue tint on certain videos. Version 0.5 of libvdpau includes a
workaround to fix this, see the official announcement.

> Flash Player: leaking overlay with NVIDIA

This bug is due to the incorrect color key being used by the flashplugin
version 11.2.202.228-1 (see this post on the NVIDIA forums) and causes
the Flash content to "leak" into other pages or solid black backgrounds.
To avoid this issue simply export VDPAU_NVIDIA_NO_OVERLAY=1 within
either your shell profile (e.g. ~/.bash_profile or ~/.zprofile) or
~/.xinitrc

> Flash Player: videos not working on older systems

If you have Adobe Flash installed on an older system and you start
playing a video which simply turns black with nothing happening, it is
most likely that your CPU does not support SSE2. You can simply check
this by looking at your CPU flags with this command:

    $ grep sse2 /proc/cpuinfo

If no results are returned, then you need to install an older version of
Flash (for example 10.3, or 11.1). Older versions possibly will have
vulnerabilities. You should then consider sandboxing Firefox using
sandfox, available in the AUR. See the sandfox homepage for usage
information.

Older versions of Flash are available here:
https://www.adobe.com/products/flashplayer/distribution3.html You need
to copy libflashplayer.so to the folder /usr/lib/mozilla/plugins/

Older flashplugin packages can be downloaded from the AUR e.g.
flashplugin-nosse2. Alternatively, you can install
flashplugin-sse2-nosse2 which can be used on CPUs with and without SSE2.

The most recent package without SSE2 is
flashplugin-11.1.102.63-1-i686.pkg.tar.xz. If you use the packaged
version, you have to add IgnorePkg = flashplugin to /etc/pacman.conf.

> Plugins are installed but not working

A common problem is that the plugin path is unset. This typically occurs
on a new install, when the user has not re-logged in before running
Firefox after the installation. Test if the path is unset:

    echo $MOZ_PLUGIN_PATH

If unset, then either re-login, or source
/etc/profile.d/mozilla-common.sh and start Firefox from the same shell:

    source /etc/profile.d/mozilla-common.sh && firefox

> Gecko Media Player will not play Apple trailers

If Apple Trailers appear to start to play and then fail, try setting the
user agent for your browser to:

    QuickTime/7.6.2 (qtver=7.6.2;os=Windows NT 5.1Service Pack 3)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Browser_plugins&oldid=305496"

Category:

-   Web Browser

-   This page was last modified on 18 March 2014, at 17:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
