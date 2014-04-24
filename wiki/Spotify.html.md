Spotify
=======

Spotify is a digital music service that gives you access to millions of
songs.

This Internet music service allows you to select any song in its
database and stream for free. The service was recently introduced to the
United States after previously being exclusive to Europe. The Linux
client is only officially packaged for Debian and Fedora distributions,
but is also available in the AUR: spotify. Officially, they recommend
that Linux users run the windows client under Wine. There are also the
occasional voice ads in between songs for users who do not wish to
subscribe.

Spotify also offers free users the ability to create playlist which can
be shuffled, and set to repeat tracks. Content provided by Spotify comes
in explicit versions as well as censored.

  

Contents
--------

-   1 Installing The Client
    -   1.1 Installation of Linux Client
    -   1.2 Installation of Windows Client using Wine
        -   1.2.1 Install Wine
        -   1.2.2 Configure Wine
        -   1.2.3 Run Installer
-   2 Global Media Hotkeys
    -   2.1 Linux Client
        -   2.1.1 Using a bash-script and xdotool
        -   2.1.2 D-Bus
    -   2.2 Windows-Client (via wine)
-   3 Tips & Tricks
    -   3.1 Mute Commercials
    -   3.2 Remote Control
        -   3.2.1 Send Commands via SSH
        -   3.2.2 Grab the Spotify Window via SSH
-   4 Troubleshooting
    -   4.1 Broken radio
    -   4.2 Spotify won't play local files
-   5 See also

Installing The Client
---------------------

Choose which client you would prefer. The Linux client is receiving good
reviews. However, if you are comfortable with wine and it's
configuration, you might want to choose the windows client. Please note
that you do NOT need to install both.

> Installation of Linux Client

Follow the instructions for installing packages from the AUR:
https://wiki.archlinux.org/index.php/AUR#Installing_packages and install
the AUR package here: spotify. The pkgbuild will automatically download
the software. It would be a good use of time to go to the spotify
website and create your user account while it's building. If you wish to
play local files you will need to install ffmpeg-spotify as well. You
can also install spotify-gnome-git to control spotify with gnome's media
keys.

> Installation of Windows Client using Wine

Install Wine

First, you must ensure that you have Wine installed on your system. In
addition to installing Wine you will need to take a moment to configure
it for the user who will be running the application.

Depending on your choice of architecture it may be necessary for you to
enable the multilib repositories. This is necessary to install Wine on
x86_64 systems, if not enabled pacman will inform you that the package
was not found.

    # pacman -Syy
    # pacman -S wine wine_gecko

Configure Wine

When wine is installed you will need to change some configuration
settings using the winecfg application on your every day user account
(not root).

    $ winecfg

After launching the winecfg application you will be presented with
multiple tabs that can assist you in tweaking the performance of the
emulator. However for this purpose your main focus will be the Audio
tab.

While under the audio tab, you will enable either the ALSA or OSS driver
by clicking the check box next to them, depending on what software you
prefer to use. Also note that the hardware acceleration will need to be
changed from Full to Emulation. When done you may exit the winecfg
application.

Failure to perform the above task will result in the inability to hear
playback.

Run Installer

Obtaining Spotify can be done by registering for an account on their
Website, the application does not offer in-app registration.

However you can obtain the application prior to registering by using the
following URL. [1]

After you have registered and downloaded your copy of the installer you
will need to run the application through Wine, depending on your setup
you may be able to run the application by right clicking the file. If
not terminal will work just fine, as long as you run the below command
in the directory of your download.

    $ wine Spotify\ Installer.exe

Once the application is successfully installed you may run Spotify by
using one of the following commands in terminal, or in the ALT+F2
launcher:

If you use a x86_64 copy of ArchLinux, you'll have to run it like this:

    $ wine "/home/username/.wine/drive_c/Program Files (x86)/Spotify/spotify.exe"

If you use a x86 copy of ArchLinux, you can use this command just fine:

    $ wine ~/.wine/drive_c/Program\ Files/Spotify/spotify.exe

If you have any additional problems, I recommend setting the winecfg to
Windows XP or Windows 7 emulation.

Global Media Hotkeys
--------------------

Spotify has support for media keys like XF86AudioPlay, but out of the
box they only work inside Spotify. We can use for example xbindkeys to
catch the global media keypresses, and then forward them to Spotify
using one of the methods below.

> Linux Client

Using a bash-script and xdotool

With the help of xdotool it is possible to send your hotkeys to the
application. The following script is an example of how to control
Spotify from the outside:

    #!/bin/sh

    case $1 in
       "play")
           key="XF86AudioPlay"
           ;;
       "next")
           key="XF86AudioNext"
           ;;
       "prev")
           key="XF86AudioPrev"
           ;;
       *)
           echo "Usage: $0 play|next|prev"
           exit 1
            ;;
    esac
    xdotool key --window $(xdotool search --name "Spotify (Premium )?- Linux Preview"|head -n1) $key
    exit 0

Let's call it musickeys.sh. Make the script executable:

    $ chmod +x musickeys.sh

By executing ./musickeys.sh play you can now toggle playing a song. Now
you can bind this script to any tool that catches keypresses, such as
xbindkeys. For Openbox you can use the following example (see
Openbox#Configuration for help):

    <keybind key="XF86AudioPlay">
      <action name="Execute">
          <execute>~/bin/musickeys.sh play</execute>
      </action>
    </keybind>
    <keybind key="XF86AudioNext">
      <action name="Execute">
          <execute>~/bin/musickeys.sh next</execute>
      </action>
    </keybind>
    <keybind key="XF86AudioPrev">
      <action name="Execute">
          <execute>~/bin/musickeys.sh prev</execute>
      </action>
    </keybind>

D-Bus

An alternative to the above is D-Bus, which should be available by
default as it is a dependency of systemd. With D-Bus we have a
consistent and reliable way to communicate with other processes, such as
Spotify. To play or pause the current song in Spotify:

    $ dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause

In order to bind this and the other commands to the media keys you need
to install Xbindkeys and edit your .xbindkeysrc and add the following
lines:

    # Play/Pause
    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
    XF86AudioPlay

    # Next
    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
    XF86AudioNext

    # Previous
    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
    XF86AudioPrev

    # Stop
    "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop"
    XF86AudioStop

> Windows-Client (via wine)

If you prefer the wine-version of Spotify, you can use spotifycmd to
send actions to Spotify.

Tips & Tricks
-------------

> Mute Commercials

With blockify you can mute commercials (works on both the Wine version
and the native Linux client). It is available in the AUR as blockify.

> Remote Control

Send Commands via SSH

If you set up ssh on the server, you can send controls from a client to
a remote Spotify instance with

    $ ssh user@host 'yourcommand'

where yourcommand can be spotifycmd that you installed on the server or
a dbus script for the linux version, as described above.

Grab the Spotify Window via SSH

Aside from grabbing the whole desktop with TeamViewer or VNC to remotely
control your server, you can also only grab the Spotify Window from the
server to your client.

To do that, you need to configure sshd on your server and install x11vnc
on both server and client as well as tigervnc on the client. Then you
can use these scripts to grab either the complete dektop or only the
Spotify window, which essentially gets you GUI client-like behavior as
with MPD.

    #!/bin/bash
    # vncget.sh

    if [[ $1 == all ]];then
      ssh -f -t -L 5900:localhost:5900 user@host "x11vnc -q -display :0 -auth .Xauthority"
    else
      ssh -f -t -L 5900:localhost:5900 user@host ".bin/vncgetspotify.sh"
    fi
     
    for i in {1..4}; do
      sleep 2
      if vncviewer localhost:0; then break; fi
    done

    #!/bin/bash
    # vncgetspotify.sh

    export DISPLAY=:0

    id=$(wmctrl -lx | awk '/spotify.exe.Wine/ {print $1}')
    [[ -z $id ]] && id=$(wmctrl -lx | awk '/spotify.Spotify/ {print $1}')

    x11vnc -sid $id -display :0 -auth .Xauthority

You will need to copy the second script to ~/.bin/vncgetspotify.sh on
the server and the first script to any place on your client.

Finally, to grab the spotify window, run on the client:

    $ sh vncget.sh

or, for the whole desktop:

    $ sh vncget.sh all

  

Troubleshooting
---------------

> Broken radio

Spotify bug report concerning mixed locales

If your radio page is broken (stuck when starting and unsresponsive to
input) you might be using a custom locale. Try setting the environment
variable LC_NUMERIC to en_US.utf8 before starting Spotify.

  

> Spotify won't play local files

Try installing ffmpeg-compat, as per this forum discussion.

See also
--------

-   SpotCommander: A web based remote control for Spotify
-   http://www.spotify.com/int/help/faq/wine/
-   http://www.spotify.com/int/download/previews/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Spotify&oldid=305901"

Categories:

-   Audio/Video
-   Wine

-   This page was last modified on 20 March 2014, at 16:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
