Skype
=====

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing and Running Skype                                       |
| -   2 Securing Skype                                                     |
|     -   2.1 AppArmor                                                     |
|     -   2.2 TOMOYO                                                       |
|     -   2.3 Use Skype with special user                                  |
|                                                                          |
| -   3 Skype Sound                                                        |
|     -   3.1 Skype PulseAudio Sound (2.1+)                                |
|     -   3.2 Skype ALSA Sound (2.0+)                                      |
|     -   3.3 Skype-OSS Sound (Pre-2.0)                                    |
|         -   3.3.1 A. With OSS or Kernel OSS emulation for ALSA           |
|         -   3.3.2 B. Making ALSA + dMix work for Skype                   |
|         -   3.3.3 C. Using OSS emulation with oss2jack                   |
|                                                                          |
| -   4 Skype plugin for Pidgin                                            |
| -   5 Problems                                                           |
|     -   5.1 Skype crashes immediately                                    |
|     -   5.2 Skype crashes shortly after login                            |
|     -   5.3 I can receive multiple audio streams, but I can only send    |
|         one                                                              |
|     -   5.4 No video with GSPCA webcams                                  |
|     -   5.5 No video with Compiz                                         |
|     -   5.6 Skype does not use my GTK theme, even though other QT apps   |
|         do                                                               |
|     -   5.7 The microphone does not work                                 |
|     -   5.8 No incoming video stream                                     |
|     -   5.9 Low sound in Skype, but works everywhere else                |
|     -   5.10 Monster/low-octave "growling" distortion over mic           |
|     -   5.11 Skype can only see pulseaudio, but not ALSA devices         |
|     -   5.12 Crackling / Noisy sound (mainly using 64-bit OS)            |
|     -   5.13 Problem with Audio Playback on x86_64                       |
|     -   5.14 Skype sounds stops media player or other sound sources      |
+--------------------------------------------------------------------------+

Installing and Running Skype
----------------------------

Install skype from the official repositories. If you have a 64-bit
system, enable the multilib repository first as Skype is 32-bit only.
For OSS-users, skype-oss is available.

Running Skype is just as easy. Type skype into a terminal or
double-click the Skype icon on your desktop or in your DE's application
menu.

Securing Skype
--------------

There are a couple of reasons you might want to restrict Skype's access
to your computer:

-   The skype binary is disguised against decompiling, so nobody is
    (still) able to reproduce what it really does.
-   It produces encrypted traffic even when you are not actively using
    Skype.
-   ...

See [1] for more information.

> AppArmor

Follow the instructions here to set up AppArmor.

The userland tools for AppArmor come with a collection of example
profiles. Skype is amongst them. Copy this to the directory where
AppArmor profiles are stored.

    # cp -ip /etc/apparmor/profiles/extras/usr.bin.skype /etc/apparmor.d/

For whatever reason, the profile is not complete. You may wish to modify
it further. Here is an example, and here is another one for Skype4. (If
the Mozilla denials annoy you, feel free to uncomment the appropriate
lines.)

To use the profile, first be sure securityfs is mounted,

    # mount -t securityfs securityfs /sys/kernel/security

Load the profile by the command,

    # apparmor_parser -r /etc/apparmor.d/usr.bin.skype

Now you can run Skype restricted but as your own user. Denials are
logged in messages.log.

> TOMOYO

Follow the instructions here to install TOMOYO. Please note that this
section describes using TOMOYO 2.5.

During Skype audit it was discovered that Skype reads DMI information
and Mozilla profile. To give Skype minimal access to your system using
TOMOYO, please follow these steps.

-   Open /etc/tomoyo/exception_policy.conf file and add these lines:

    path_group SKYPE_DIRS /home/\*/.Skype/
    path_group SKYPE_DIRS /home/\*/.Skype/\{\*\}/
    path_group SKYPE_DIRS /home/\*/.config/Skype/\{\*\}/
    path_group SKYPE_DIRS /usr/share/skype/\{\*\}/
    path_group SKYPE_DIRS /home/pf/work/tmp/\{\*\}/
    path_group SKYPE_FILES /home/\*/.Skype/\{\*\}/\*
    path_group SKYPE_FILES /home/\*/.config/Skype/\{\*\}/\*
    path_group SKYPE_FILES /usr/share/skype/\{\*\}/\*
    path_group SKYPE_FILES /home/pf/work/tmp/\{\*\}/\*
    path_group SKYPE_FILES /home/\*/.Skype/\*
    path_group SKYPE_FILES /home/\*/.config/Skype/\*
    path_group SKYPE_FILES /usr/share/skype/\*
    path_group SKYPE_FILES /home/pf/work/tmp/\*
    path_group ICONS_DIRS /usr/share/icons/\{\*\}/
    path_group ICONS_FILES /usr/share/icons/\{\*\}/\*
    path_group ICONS_FILES /usr/share/icons/\*
    initialize_domain /usr/bin/skype from any
    initialize_domain /usr/lib32/skype/skype from any

Note that /home/pf/work/tmp folder is only the folder to which Skype
will be able to save received files and from which it will be able to
send all files. You have to change this folder.

-   Then open /etc/tomoyo/domain_policy.conf and add the following
    lines:

    <kernel> /usr/bin/skype
    use_profile 3
    use_group 0

    misc env \*
    file read /bin/bash
    file read /usr/bin/bash
    file read/write /dev/tty
    file read /usr/lib/locale/locale-archive
    file read /usr/lib/gconv/gconv-modules
    file read /usr/bin/skype
    file read /usr/lib32/skype/skype
    file execute /usr/lib32/skype/skype exec.realpath="/usr/lib32/skype/skype" exec.argv[0]="/usr/lib32/skype/skype"

    <kernel> /usr/lib32/skype/skype
    use_profile 3
    use_group 0

    file append /dev/snd/pcm\*
    file chmod /home/\*/.Skype/ 0700
    file create /home/\*/.cache/fontconfig/\* 0600-0666
    file create /tmp/qtsingleapp-\*-lockfile 0600-0666
    file create @SKYPE_FILES 0600-0666
    file execute /usr/bin/firefox
    file execute /usr/bin/gnome-open
    file execute /usr/bin/notify-send
    file execute /usr/bin/opera
    file execute /usr/bin/xdg-open
    file ioctl /dev/snd/\* 0-0xFFFFFFFFFFFFFFFF
    file ioctl /dev/video0 0-0xFFFFFFFFFFFFFFFF
    file ioctl anon_inode:inotify 0x541B
    file ioctl socket:[family=1:type=2:protocol=0] 0x8910
    file ioctl socket:[family=1:type=2:protocol=0] 0x8933
    file ioctl socket:[family=2:type=1:protocol=6] 0x541B
    file ioctl socket:[family=2:type=2:protocol=17] 0x541B
    file ioctl socket:[family=2:type=2:protocol=17] 0x8912
    file ioctl socket:[family=2:type=2:protocol=17] 0x8927
    file ioctl socket:[family=2:type=2:protocol=17] 0x8B01
    file link /home/\*/.cache/fontconfig/\* /home/\*/.cache/fontconfig/\*
    file mkdir /home/\*/.cache/fontconfig/\* 0600
    file mkdir @SKYPE_DIRS 0700-0777
    file mksock /tmp/qtsingleapp-\* 0755
    file read /dev/urandom
    file read /etc/fonts/conf.avail/\*.conf
    file read /etc/fonts/conf.d/\*.conf
    file read /etc/fonts/fonts.conf
    file read /etc/group
    file read /etc/host.conf
    file read /etc/hosts
    file read /etc/machine-id
    file read /etc/nsswitch.conf
    file read /etc/passwd
    file read /etc/resolv.conf
    file read /home/\*/.ICEauthority
    file read /home/\*/.XCompose
    file read /home/\*/.Xauthority
    file read /home/\*/.Xdefaults
    file read /home/\*/.fontconfig/\*
    file read /home/\*/.config/fontconfig/\*
    file read /usr/lib/locale/locale-archive
    file read /usr/lib32/gconv/UTF-16.so
    file read /usr/lib32/gconv/gconv-modules
    file read /usr/lib32/libv4l/v4l2convert.so
    file read /usr/lib32/qt/plugins/bearer/libq\*bearer.so
    file read /usr/lib32/qt/plugins/iconengines/libqsvgicon.so
    file read /usr/lib32/qt/plugins/imageformats/libq\*.so
    file read /usr/lib32/qt/plugins/inputmethods/libqimsw-multi.so
    file read /usr/lib32/skype/skype
    file read /usr/share/X11/locale/\*/Compose
    file read /usr/share/X11/locale/\*/XLC_LOCALE
    file read /usr/share/X11/locale/compose.dir
    file read /usr/share/X11/locale/locale.alias
    file read /usr/share/X11/locale/locale.dir
    file read /usr/share/alsa/alsa.conf
    file read /usr/share/alsa/cards/\*.conf
    file read /usr/share/alsa/pcm/\*.conf
    file read /usr/share/fonts/\*/\*/\*
    file read @ICONS_FILES
    file read proc:/cpuinfo
    file read proc:/stat
    file read proc:/sys/kernel/osrelease
    file read proc:/sys/kernel/ostype
    file read sysfs:/devices/\*/\*/\*/\*/\*/\*/modalias
    file read sysfs:/devices/\*/\*/\*/\*/\*/\*/video4linux/video0/dev
    file read sysfs:/devices/\*/\*/\*/\*/\*/idProduct
    file read sysfs:/devices/\*/\*/\*/\*/\*/idVendor
    file read sysfs:/devices/\*/\*/\*/\*/\*/speed
    file read sysfs:/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
    file read sysfs:/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
    file read sysfs:/devices/system/cpu/online
    file read/write /dev/snd/\*
    file read/write /dev/video0
    file read/write/truncate /home/\*/.config/Trolltech.conf
    file read/write/unlink /home/\*/.cache/fontconfig/\*
    file read/write/unlink /tmp/qtsingleapp-\*
    file read/write/unlink/truncate @SKYPE_FILES
    file rename /home/\*/.cache/fontconfig/\* /home/\*/.cache/fontconfig/\*
    file rename @SKYPE_DIRS @SKYPE_DIRS
    file rename @SKYPE_FILES @SKYPE_FILES
    file rmdir @SKYPE_DIRS
    misc env \*
    network inet dgram bind 0.0.0.0 0-65535
    network inet dgram bind 127.0.0.1 0
    network inet dgram bind/send 0.0.0.0-255.255.255.255 0-65535
    network inet stream bind/listen 0.0.0.0 0-65535
    network inet stream connect 0.0.0.0-255.255.255.255 0-65535
    network unix stream bind/listen /tmp/qtsingleapp-\*
    network unix stream connect /tmp/.ICE-unix/\*
    network unix stream connect /tmp/qtsingleapp-\*
    network unix stream connect /var/run/dbus/system_bus_socket
    network unix stream connect /var/run/nscd/socket
    network unix stream connect \000/tmp/.ICE-unix/\*
    network unix stream connect \000/tmp/.X11-unix/X0
    network unix stream connect \000/tmp/dbus-\*

    <kernel> /usr/lib32/skype/skype /usr/bin/xdg-open
    use_profile 0
    use_group 0


    <kernel> /usr/lib32/skype/skype /usr/bin/gnome-open
    use_profile 0
    use_group 0

    <kernel> /usr/lib32/skype/skype /usr/bin/notify-send
    use_profile 0
    use_group 0

-   After finishing editing reload TOMOYO config files by executing
    these commands:

    # tomoyo-loadpolicy -df </etc/tomoyo/domain_policy.conf
    # tomoyo-loadpolicy -ef </etc/tomoyo/exception_policy.conf

Voilà — your Skype is sandboxed now.

Please note that this config is generated on 64-bit Arch system, and
some of your ioctls and library paths may differ from mentioned above.
So in order to fine-tune TOMOYO config for your Skype load tomoyo-auditd
daemon:

    # systemctl start tomoyo-auditd

Then go to /var/log/tomoyo folder and start watching reject_003.log:

    tail -f reject_003.log

The output of this command will show you rejected actions for Skype, so
you'll be able to add them to domain_policy.conf file if needed.

Detailed guide about TOMOYO configuring can be found here.

> Use Skype with special user

Instead of using AppArmor or TOMOYO which require the installation of
extra packages, one may prefer to add a special user. This user is only
used for running Skype within one's normal environment. This approach
restricts Skype to reading only the data of this particular user instead
of one's main user. (The new user should not be used for any other
thing. Skype only.)

Optionally, we first add a default group for the skype user. I will call
the new user and its default group "skype". The security advantage in
keeping the "skype" user in its separate group is that it can be
restricted from accessing some places other users are allowed in.

    # groupadd skype

Then we have to add the new user:

    # useradd

Enter the details for the new user (assumed login name: "skype"). If you
created the default "skype" group and want to keep "skype" outside the
"users" group, enter "skype" when the wizard asks for the initial group.
As additional groups we need "audio,video,pulse-access,pulse-rt".

Now add the following line to /home/skype/.bashrc:

    export DISPLAY=":0.0"

At last we define the alias (e.g. in ~/.bashrc):

    alias skype='xhost +local: && su skype -c skype'

Now we can start Skype as the newly created user simply by running skype
from the command line and entering the password of the user skype.

If you are tired of typing in the skype user's password every time, make
sure you installed the sudo package, run visudo then add this line at
the bottom:

    %wheel ALL=(skype) NOPASSWD: /usr/bin/skype

And use this alias to launch skype:

    alias skype='xhost +local: && sudo -u skype /usr/bin/skype'

I noticed that the newly created user is able to read some of the files
in my home directory because the permissions were a+r, so I changed them
manually to a-r u+r and changed umask from 022 to 066.

In order to restrict user "skype" accessing your external drive mounted
in /media/data for instance, make sure first that "skype" does not
belong to group "users" (if you used the default group "skype",
everything should be fine), then change the accesses on the mount point:

    # chown :users /media/data
    # chmod o-rwx /media/data

This way, it is ensured that only the owner (normally "root") and
"users" can access the specified directory tree while the others,
including "skype", will be forbidden.

Skype Sound
-----------

Skype supports PulseAudio since version 2.1 and ALSA since version 2.0.
Earlier versions support only the deprecated OSS.

> Skype PulseAudio Sound (2.1+)

Sound should work out of the box, if not you can select another input
using pavucontrol (you may have to install it first).

If you are on x86_64 and use the multilib skype package, you also need
lib32-libpulse.

> Skype ALSA Sound (2.0+)

Sound should work out of the box, if not you can select a sound device
to use in Skype options. If you have problems with Skype blocking your
sound device, you only need to add the following to your ~/.asoundrc

    pcm.dmixout {
      # Just pass this on to the system dmix
      type plug
      slave {
         pcm "dmix"
      }
    }

then you can start Skype as normal, go to the audio options and select
dmixout as your speaker- and ringingdevice.

> Skype-OSS Sound (Pre-2.0)

If you have a recent version of Skype, this will not work and is not
needed, look at the "important notes" on start of this page. Option B is
preferred over other options. With option B you can use Skype AND let
other programs play sound too. With option C you can do that too, but
option B is way easier to set up.

You can install the legacy skype-oss from Comunity repo.

If you need 64x-86x support then download an OSS compatible version from
here and the PKGBUILD form here. Also install lib32-libxinerama.
Finally, run

    $ makepkg -s

to create the pacman installable package.

A. With OSS or Kernel OSS emulation for ALSA

Start Skype and make sure no other program is using your soundcard. If
you want to use Skype AND let another program play sound too, look at
option B instead.

B. Making ALSA + dMix work for Skype

First of all, we need to install the alsa-oss package with pacman:

    # pacman -S alsa-oss

Add the following to ~/.asoundrc. If the file does not exist yet, just
create it! (Many thanks to Lorenzo Colitti for figuring this out!)

    # .asoundrc to use skype at the same time as other audio apps like xmms
    #
    # Successfully tested on an IBM x40 with i810_audio using Linux 2.6.15 and
    # Debian unstable with skype 1.2.0.18-API. No sound daemons (asound, esd, etc.)
    # running. However, YMMV.
    #
    # For background, see:
    #
    # https://bugtrack.alsa-project.org/alsa-bug/view.php?id=1228
    # https://bugtrack.alsa-project.org/alsa-bug/view.php?id=1224
    #
    # (C) 2006-06-03 Lorenzo Colitti - http://www.colitti.com/lorenzo/
    # Licensed under the GPLv2 or later

    pcm.skype {
       type asym
       playback.pcm "skypeout"
       capture.pcm "skypein"
    }

    pcm.skypein {
       # Convert from 8-bit unsigned mono (default format set by aoss when
       # /dev/dsp is opened) to 16-bit signed stereo (expected by dsnoop)
       #
       # We cannot just use a "plug" plugin because although the open will
       # succeed, the buffer sizes will be wrong and we will hear no sound at
       # all.
       type route
       slave {
          pcm "skypedsnoop"
          format S16_LE
       }
       ttable {
          0 {0 0.5}
          1 {0 0.5}
       }
    }

    pcm.skypeout {
       # Just pass this on to the system dmix
       type plug
       slave {
          pcm "dmix"
       }
    }

    pcm.skypedsnoop {
       type dsnoop
       ipc_key 1133
       slave {
          # "Magic" buffer values to get skype audio to work
          # If these are not set, opening /dev/dsp succeeds but no sound
          # will be heard. According to the ALSA developers this is due
          # to skype abusing the OSS API.
          pcm "hw:0,0"
          period_size 256
          periods 16
          buffer_size 16384
       }
       bindings {
          0 0
       }
    }

If you get the error message :

    The dmix plugin supports only playback stream

then add the following to .asoundrc:

    pcm.asymed {
            type asym
            playback.pcm "dmix"
            capture.pcm "dsnoop"
    }

    pcm.!default {
            type plug
            slave.pcm "asymed"
    }

  
 Now run Skype in this way each time you want to use it:

    ALSA_OSS_PCM_DEVICE="skype" aoss skype

Optionally you can make a script to start Skype:

As root, create the file: /usr/bin/askype

    # Little script to run Skype correctly using the modified .asoundrc
    # See: https://wiki.archlinux.org/index.php/Skype for more information!
    #
    # Questions/Remarks: profox@debianbox.be

    ALSA_OSS_PCM_DEVICE="skype" aoss skype

Now make sure every user is able to execute the file:

    # chmod a+x /usr/bin/askype

You can also fix the menu entry so you can start Skype from the your
window manager's menu:

Edit the file: /usr/share/applications/skype.desktop

    [Desktop Entry]
    Name=Skype
    Comment=P2P software for high-quality voice communication
    Exec=askype
    Icon=skype.png
    Terminal=0
    Type=Application
    Encoding=UTF-8
    Categories=Network;Application;

Sometimes it takes a while for Skype to start up but once it is loaded
it should work ok!

C. Using OSS emulation with oss2jack

oss2jack is another way to have OSS emulation without using ALSA
directly. Instead, oss2jack creates a OSS device that forwards
everything to JACK (JACK Audio Connection Kit), which in turn mixes,
then outputs to the standard ALSA device.

Skype plugin for Pidgin
-----------------------

See Pidgin#Skype plugin.

Problems
--------

> Skype crashes immediately

Try creating the directory

    ~/.Skype/Logs

> Skype crashes shortly after login

If Skype crashes shortly after logging in, changing the rights for
libpulse.so.0.12.4 (minor version might differ) and
libpulse-simple.so.0.0.3 might fix the issue.[2]

    # cd /usr/lib
    # chmod ugo-r libpulse.so.0.12.*
    # chmod ugo-r libpulse-simple.so.0.0.3

64bit users might have to cd to /usr/lib32 instead.

> I can receive multiple audio streams, but I can only send one

Skype can send and receive audio and I still hear other sounds playing
from other applications, but I cannot record my microphone with other
applications. That is because Skype or aoss blocks the audio input for
itself.

> No video with GSPCA webcams

For i686, install v4l-utils, userspace tools and conversion library for
Video 4 Linux, and run Skype with

    LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so skype

to start Skype with v4l1 compatibility.

For x86_64, install lib32-v4l-utils from [multilib] repository and run
Skype with

    LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so skype

To make it running from DE menus and independent of Skype updates, you
can add alias (e.g. in ~/.bashrc):

    alias skype='LD_PRELOAD=/usr/libxx/libv4l/v4l1compat.so skype'

where `libxx' should be edited as appropriate.

> No video with Compiz

Try this

    $ XLIB_SKIP_ARGB_VISUALS=1 skype

> Skype does not use my GTK theme, even though other QT apps do

Recent versions of Skype allow you to change the theme via the Options
menu. However, selecting the GTK+ option may not work properly. This is
probably because you do not have a 32-bit theme engine installed. Try to
find the engine your theme uses in the multilib repository or the AUR.
If you have no idea which engine your theme is using, the easiest fix is
to install lib32-gtk-engines. This does however contain quite a lot of
packages, so the best would be to find and install only the needed
package.

Note:You may not have to install lib32-gtk-engines. First try if the
following steps work for you if you only install lib32-gtk2 and a gtk2
theme respectively. See also the forums.

Once installed, it will still not work unless you have a 32-bit version
of GConf installed. You could build and install lib32-gconf if desired,
but there is an easier workaround. First, create or edit ~/.gtkrc-2.0 so
that it contains the following line:

    $ gtk-theme-name = "My Theme"

Replace My Theme by the name of your theme, but leave the quotes.
Second, run Skype like this:

    $ export GTK2_RC_FILES="/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0"
    $ skype

The GTK+ theme should now appear correctly. You can make this permanent
either by running Skype from a script containing the above 2 lines, or
by exporting GTK2_RC_FILES in ~/.xprofile or ~/.xinitrc, depending on
how you start X.

If you cannot change the theme in the Options menu, run Skype using the
following command:

    $ /usr/bin/skype --disable-cleanlooks -style GTK

If you wish menus within desktop environments to load Skype with a GTK
theme by default then modify the 'Exec' line of
/usr/share/applications/skype.desktop so that it reads:

    $ Exec=/usr/bin/skype --disable-cleanlooks -style GTK

Similarly if you have set Skype to autostart then modify
~/.config/autostart/skype.desktop in the same way.

> The microphone does not work

Run amixer,

    $ amixer

and check if you have an output for Capture similar to the one below.

    Simple mixer control 'Capture',0
     Capabilities: cvolume cswitch penum
     Capture channels: Front Left - Front Right
     Limits: Capture 0 - 15
     Front Left: Capture 8 [53%] [12.00dB] [on]
     Front Right: Capture 8 [53%] [12.00dB] [on]

If your output is similar, your microphone is working just fine, and the
issue is either hardware related (broken microphone) or your volume
needs to be checked. If you do not have an output similar to the one
above or, more specifically, if both Front Left and Front Right are 0%
or show an [off] tag at the end, then your microphone settings need to
be rectified.

In either case, try to run:

    $ alsamixer

and press F5 to show all channels. Using the arrow keys navigate all the
way to the end and increase Capture. If you do not see a left and right
channel for Capture, press the space bar. Doing this turns the left and
right channels on. Check that Input Source is set to the correct value
(e.g. [Front Mic]): navigate through the values with up and down arrow
keys. If your microphone is an array built into your monitor, or you
have a similar setup, make sure to increase the volume for the Digital
column too. If you have multiple microphones, you may have to play
around with the Mic Jack channel to get your desired setting.

You may want to save your mixer settings with:

    # alsactl -f /var/lib/alsa/asound.state store

> No incoming video stream

If skype shows a black square for the video preview, but something else
(like xawtv -c /dev/video0) shows video correctly, you might need to
start skype with:

    export XLIB_SKIP_ARGB_VISUALS=1 && skype

Another possible workaround is to preload v4l1compat.so

    LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so skype

> Low sound in Skype, but works everywhere else

If you are sure your microphone is configured correct in ALSA (try
recording with a 3rd-party-utility to determent whether it is an ALSA,
or Skype problem), it is most likely because Skype is controlling your
volume levels. Simply disable this feature in the voice settings page in
the Skype configuration window.

This may also help if your microphone input is automatically lowered
until 0.

> Monster/low-octave "growling" distortion over mic

Some users with newer kernels are experiencing a monster-like growling
distortion of their sound stream on the other end of Skype. This can be
fixed by creating a dummy ALSA device or by removing
~/.Skype/shared.xml. See
https://bbs.archlinux.org/viewtopic.php?pid=819500#p819500 for more
information.

> Skype can only see pulseaudio, but not ALSA devices

    Turn PulseAudio autospawn off, normally: $ echo "autospawn = no" > ~/.pulse/client.conf
    Kill PulseAudio: $ killall pulseaudio
    Shut down and restart Skype

> Crackling / Noisy sound (mainly using 64-bit OS)

Edit /etc/pulse/default.pa and change the following line

    load-module module-udev-detect

to

    load-module module-udev-detect tsched=0

See also: PulseAudio#Glitches.2C_skips_or_crackling.

> Problem with Audio Playback on x86_64

See Pulseaudio#Skype (x86_64 only), even if you are not using
PulseAudio.

> Skype sounds stops media player or other sound sources

You can try commenting out the following modules in
/etc/pulse/default.pa

    #module-cork-music-on-phone
    #module-role-cork

If that does not help, you can try changing flat-volumes to no in
/etc/pulse/daemon.conf.

    flat-volumes = no

Retrieved from
"https://wiki.archlinux.org/index.php?title=Skype&oldid=254700"

Categories:

-   Audio/Video
-   Telephony and Voice
