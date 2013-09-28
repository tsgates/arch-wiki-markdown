Browser Plugins
===============

These plugins work in Firefox, Opera and WebKit derivatives.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Flash Player                                                       |
|     -   1.1 Gnash                                                        |
|     -   1.2 Lightspark                                                   |
|     -   1.3 Adobe Flash Player                                           |
|         -   1.3.1 Configuration                                          |
|         -   1.3.2 Disable the "Press ESC to exit full screen mode"       |
|             message                                                      |
|                                                                          |
| -   2 PDF viewer                                                         |
|     -   2.1 PDF.js                                                       |
|     -   2.2 External PDF viewers                                         |
|     -   2.3 Adobe Reader                                                 |
|         -   2.3.1 32-bit                                                 |
|         -   2.3.2 64-bit                                                 |
|                                                                          |
| -   3 Citrix                                                             |
| -   4 Java (IcedTea)                                                     |
| -   5 Video Plugins                                                      |
| -   6 Other                                                              |
|     -   6.1 MozPlugger                                                   |
|     -   6.2 kpartsplugin                                                 |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Flash Player: No sound                                       |
|     -   7.2 Flash Player: Blocking sound for other applications or       |
|         delayed playback                                                 |
|     -   7.3 Flash Player: Bad (choppy) sound on the 64-bit version       |
|     -   7.4 Flash Player: Performance                                    |
|     -   7.5 Flash Player: Low webcam resolution                          |
|     -   7.6 Flash Player: Black bars in full screen playback on          |
|         multi-headed setups                                              |
|     -   7.7 Flash Player: Blue tint on videos with Nvidia                |
|     -   7.8 Flash Player: Leaking overlay with Nvidia                    |
|     -   7.9 Flash Player: Videos not working on older systems            |
|     -   7.10 Plugins are installed but not working                       |
|     -   7.11 Gecko Media Player will not play Apple trailers             |
+--------------------------------------------------------------------------+

Flash Player
------------

> Gnash

See the Wikipedia article on this subject for more information: Gnash

GNU Gnash is a free (libre) alternative to Adobe Flash Player. It is
available both as a standalone player for desktop computers and embedded
devices, as well as a browser plugin, and supports the SWF format up to
version 7 (with versions 8 and 9 under development) and about 80% of
ActionScript 2.0.

GNU Gnash can be installed with the package gnash-gtk, available in the
official repositories.

> Lightspark

Lightspark is another attempt to provide a free alternative to Adobe
Flash aimed at supporting newer Flash formats. Although it is still very
much in development, it supports some popular sites.

Lightspark can be installed with the package lightspark or
lightspark-git, available in the AUR.

> Adobe Flash Player

The Adobe Flash Player is also available in the official repositories,
although it was discontinued on Linux (for both 32-bit and 64-bit).
Adobe will be providing security updates for another 5 years (i.e.
2017), but new versions of the plugin will only come integrated with
Google Chrome (using its new PPAPI).

Install flashplugin from the official repositories.

Note:

-   Some versions of Epiphany have trouble recognizing the Flash plugin.
    See Epiphany#Flash for more details.
-   The Adobe Flash Player may also require ttf-ms-fonts from the AUR in
    order to properly render text.

Tip:Chromium can also use the Google Chrome Flash Player, see
Chromium#Flash Player.

Configuration

To change the preferences (privacy settings, resource usage, etc.) of
Flash Player, right click on any embedded Flash content and choose
Settings from the menu, or go to the Macromedia website. There, a Flash
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

     $ wget http://forum.videohelp.com/attachments/14900-1354083401/Flash%20Fullscreen%20Patcher%202.0.zip
     $ unzip Flash\ Fullscreen\ Patcher\ 2.0.zip
     $ wine Flash\ Fullscreen\ Patcher\ 2.0.exe

Patch libflashplayer.so (the one from your home directory) using the
GUI. Copy the patched Flash Player back to the plugins directory:

     # cp ~/libflashplayer.so /usr/lib/mozilla/plugins/

PDF viewer
----------

> PDF.js

See the Wikipedia article on this subject for more information: Pdf.js

PDF.js is a PDF renderer created by Mozilla and built using HTML5
technologies. It is currently only available as a Firefox plugin.

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
repositories. See this comment for an explanation.

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

-   Install bin32-acroread (with all its 32-bit dependencies) from AUR.
    Be advised that the Firefox plugin cannot be used directly with this
    binary -- it will not load in the 64-bit browser. To load it install
    the nspluginwrapper package from the official [multilib] repository
    and run:

    $ nspluginwrapper -v -a -i

as a normal user. This checks the plugin directory and links the plugins
as needed.

Citrix
------

See the main article: Citrix

Java (IcedTea)
--------------

To enable Java support in your browser, you have two options: use either
Oracle's non-free JRE or the OpenJDK environment (recommended). For
details about why OpenJDK is recommended see this.

To use OpenJDK, you have to install the IcedTea browser plugin:

-   icedtea-web-java7 for version 7 of the Java environment.

If you want to use Oracle's JRE you have to install the jre or jre6
package, available in the AUR.

See Java#OpenJDK JVM for additional details and references.

Note:If you experience any problems with the Java plugin (it is not
recognized by the browser), you can try this solution.

Video Plugins
-------------

-   Gecko Media Player — A Mozilla browser plugin to handle media on
    websites, using MPlayer.

https://sites.google.com/site/kdekorte2/gecko-mediaplayer ||
gecko-mediaplayer

-   Totem Plugin — A browser plugin based on the Totem media player for
    Gnome which uses Gstreamer.

http://projects.gnome.org/totem/ || totem-plugin

-   Rosa Media Player Plugin — A Qt-based browser plugin also based on
    MPlayer.

https://abf.rosalinux.ru/uxteam/ROSA_Media_Player ||
rosa-media-player-plugin

-   VLC Plugin — A NPAPI-based plugin that uses VLC technologies.

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
    ### OpenOffice
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

> Flash Player: No sound

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

> Flash Player: Blocking sound for other applications or delayed playback

If sound is delayed within Flash videos or Flash stops sound from any
other application, then make sure you do not have snd_pcm_oss module
loaded:

    $ lsmod | grep snd_pcm_oss

You can unload it:

    # rmmod snd_pcm_oss

and restart the browser to see if it helps.

> Flash Player: Bad (choppy) sound on the 64-bit version

There is a problem with Flash plugin 11 on 64-bit systems and a new
memcpy routine in glibc (for more details see this Fefora bug report),
which makes the sound choppy on MP3 streams. Current workarounds are:

-   replacing the memcpy routine as suggested in this thread.
-   installing flashplugin-square from the AUR (this is a version of the
    Flash plugin with working hardware acceleration).

> Flash Player: Performance

Adobe's Flash plugin has some serious performance issues, especially
when CPU frequency scaling is used. There seems to be a policy not to
use the whole CPU workload, so the frequency scaling governor does not
clock the CPU any higher. To work around this issue, see
cpufrequtils#Changing the ondemand governor's threshold

> Flash Player: Low webcam resolution

If your webcam has low resolution in Flash (the image looks very
pixelated) you can try starting your browser with this:

    $ LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so [broswer]

> Flash Player: Black bars in full screen playback on multi-headed setups

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

Note:While the author mentions using Nvidia's TwinView, the hack should
work for any multi-monitor setup.

> Flash Player: Blue tint on videos with Nvidia

An issue with flashplugin versions 11.2.202.228-1 and 11.2.202.233-1
causes it to send the U/V panes in the incorrect order resulting in a
blue tint on certain videos. Version 0.5 of libvdpau includes a
workaround to fix this, see the official announcement.

> Flash Player: Leaking overlay with Nvidia

This bug is due to the incorrect color key being used by the flashplugin
version 11.2.202.228-1 (see this post on the Nvidia forums) and causes
the Flash content to "leak" into other pages or solid black backgrounds.
To avoid this issue simply export VDPAU_NVIDIA_NO_OVERLAY=1 within
either your shell profile (e.g. ~/.bash_profile or ~/.zprofile) or
~/.xinitrc

> Flash Player: Videos not working on older systems

If you have Adobe Flash installed on an older system and you start
playing a video which simply turns black with nothing happening, it is
most likely that your CPU does not support SSE2. You can simply check
this by looking at your CPU flags with this command:

    # cat /proc/cpuinfo | grep sse2

If no results are returned, then you need to install an older version of
Flash (for example 10.3). Older versions possibly will have
vulnerabilities. You should then consider sandboxing Firefox using
sandfox, available in the AUR. See the sandfox homepage for usage
information.

Older versions of Flash are available here:
http://www.adobe.com/products/flashplayer/distribution3.html

You need to copy libflashplayer.so to the folder
/usr/lib/mozilla/plugins/

> Plugins are installed but not working

A common problem is that the plugin path is unset. This typically occurs
on a new install, when the user has not re-logged in before running
Firefox after the installation. Test if the path is unset:

    echo $MOZ_PLUGIN_PATH

If unset, then either re-login, or source
/etc/profile.d/mozilla-common.sh and start Firefox from the same shell:

    . /etc/profile.d/mozilla-common.sh && firefox

> Gecko Media Player will not play Apple trailers

If Apple Trailers appear to start to play and then fail, try setting the
user agent for your browser to:

    QuickTime/7.6.2 (qtver=7.6.2;os=Windows NT 5.1Service Pack 3)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Browser_Plugins&oldid=254931"

Category:

-   Web Browser
