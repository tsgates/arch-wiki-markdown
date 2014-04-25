Bluetooth Headset
=================

Related articles

-   Bluetooth
-   Bluez4

Before you get started, you have to make sure that bluetooth is set up
and working.

Contents
--------

-   1 ALSA-BTSCO method
    -   1.1 Connecting the headset
        -   1.1.1 Pairing the headset with your computer
            -   1.1.1.1 Using bluez-gnome
            -   1.1.1.2 Using passkey-agent
    -   1.2 Headset and Alsa Devices
    -   1.3 Headset's multimedia buttons
-   2 PulseAudio method
    -   2.1 Troubleshooting
        -   2.1.1 Audio sink fails
        -   2.1.2 Page timeout issue
-   3 ALSA, bluez5 and PulseAudio method
    -   3.1 Install Software Packages
        -   3.1.1 Install ALSA and associated libraries
        -   3.1.2 Install Bluez5
        -   3.1.3 Install PulseAudio
        -   3.1.4 Install Audacious
    -   3.2 Procedure
        -   3.2.1 Miscellaneous Configuration Files
            -   3.2.1.1 ALSA /etc/asound.conf
            -   3.2.1.2 /etc/dbus-1/system.d/bluetooth.conf
            -   3.2.1.3 Tested applications
-   4 Switch between HSV and A2DP setting
    -   4.1 A2DP not working with pulseaudio
-   5 Tested Headsets
-   6 See also

ALSA-BTSCO method
-----------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Instructions     
                           rely on bluez4.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

It is much easier to set up your bluetooth headset today, with bluez >=
3.16. You may want to try the out-of-box python script in this blog (you
need edit the script to work with gconftool-2). There is also a piece of
equivalent bash script here.

You need your headset's bdaddr. It is of the form 12:34:56:78:9A:BC.
Either find it in the documentation of your headset, on the headset
itself or with the hcitool scan command.

Install btsco.

To load the kernel module, type:

    # modprobe snd-bt-sco

There will now be an extra audio device. Use alsamixer -cN (where N is
most likely 1) to set the volume. You can access the device with any
alsa-capable application by choosing the device BT headset, or with any
OSS application by using /dev/dspN as the audio device.

But to actually get any sound, you have to connect your headset to the
computer first.

> Connecting the headset

If you connect your headset for the first time, read the section about
pairing first. To connect to your headset to the computer, use the
command

    $ btsco -f <bdaddr>

for example

    $ btsco -f 12:34:56:78:9A:BC

Pairing the headset with your computer

The first time you connect the headset, you have to pair it with the
computer. To do this, you need your headset's PIN. Depending on your
headset you may have to reset the headset and repeat the pairing
everytime you used the headset with another bluetooth device.

There are two ways to pair your headset with the computer:

Using bluez-gnome

Install the bluez-gnome package from the community repository. Then
start the bt-applet program. Once you try to connect to the headset, a
window will open and ask for the PIN.

Using passkey-agent

Before connecting to the headset, enter the command

    $ passkey-agent --default <pin>

where <pin> is your headset's PIN. Then try to connect to the headset.

> Headset and Alsa Devices

1. First if you have not already, install bluez from the official
repositories.

2. Scan for your device

    $ hcitool (-i <optional hci#>***) scan

3. Pair your headset with your device:

    $ bluez-simple-agent (optional hci# ***) XX:XX:XX:XX:XX:XX

and put in your pin (0000 or 1234, etc)

4. Make sure your /etc/bluetooth/audio.conf allows A2DP Audio Sinks.
Place this line just bellow the [Genera] heading:

    Enable=Source,Sink,Media,Socket

5. Add this to your /etc/asound.conf file:

    #/etc/asound.conf

    pcm.btheadset {
       type plug
       slave {
           pcm {
               type bluetooth
               device XX:XX:XX:XX:XX:XX 
               profile "auto"
           }   
       }   
       hint {
           show on
           description "BT Headset"
       }   
    }
    ctl.btheadset {
      type bluetooth
    }  

6. Check to see if it has been added to alsa devices

    $ aplay -L

7. Now play with aplay:

    $ aplay -D btheadset /path/to/audio/file

or Mplayer:

    $ mplayer -ao alsa:device=btheadset /path/to/audio/or/video/file

Tip:To find hci# for a usb dongle, type in

    $ hcitool dev

> Headset's multimedia buttons

In order to get your bluetooth headset's multimedia buttons (play,
pause, next, previous) working you need to create
/etc/modprobe.d/uinput.conf containing uinput.

PulseAudio method
-----------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Instructions     
                           rely on bluez4           
                           (references to           
                           /etc/bluetooth/audio.con 
                           f                        
                           and bluez-simple-agent). 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This one is much easier and more elegant. PulseAudio will seamlessly
switch between output devices when the headset is turned on. If you have
ALSA as the sound server, you need the following packages installed:
pulseaudio and pulseaudio-alsa.

Now, to configure the audio output to use bluetooth, just install
pavucontrol and run it to configure the audio output:

    $ pavucontrol

See this blog for further explanations. Make sure to take a look at the
PulseAudio wiki entry for setting up PulseAudio, especially if you are
running KDE.

> Troubleshooting

Audio sink fails

Bluetooth headset is connected, but ALSA/PulseAudio fails to pick up the
connected device. You will get "Audio sink fails". According to gentoo
wiki, you have to verify than in /etc/bluetooth/audio.conf there is
Enable=Socket under the [General] section heading.

Just do a # systemctl restart bluetooth to apply it.

Page timeout issue

If you receive this error whilst trying to pair your headset with your
system using bluez-simple-agent, then you can try to restart your system
and use the graphical bluez applet of your desktop environment.

ALSA, bluez5 and PulseAudio method
----------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Describes two    
                           different methods, see   
                           the talk page for        
                           details. (Discuss)       
  ------------------------ ------------------------ ------------------------

ALSA, bluez5, and PulseAudio work together to allow a wireless Bluetooth
headset to play audio. The following method works with a Lenovo T61p
laptop and SoundBot SB220 wireless bluetooth headset. The required
software stack is extensive and failure to include all components can
produce errors which are difficult to understand. The following list of
software packages might not be the minimum required set and needs to be
examined more closely.

Bluez5 has a regression causing HSP/HFP Telephone profile to not be
available. This regression is documented in the draft release notes for
Pulseaudio 5.0 which say (in "Notes for packagers"): "PulseAudio now
supports BlueZ 5, but only the A2DP profile. BlueZ 4 is still the only
way to make HSP/HFP work." (from here)

> Install Software Packages

The core software components are ALSA, Bluez5, Pulseaudio. However there
are additional libraries which are required. As well as a player which
can play audio files. The following section lists the software packages
installed in order to connect the headset and play audio over the
headset.

Install ALSA and associated libraries

ALSA works with the linux kernel to provide audio services to user mode
software. The following packages are used with the Bluetooth headset:
alsa-utils, alsa-plugins, alsa-tools.

Install Bluez5

Bluez5 is the latest Bluetooth stack. It is required for PulseAudio to
interface with wireless headsets. Required packages: bluez, bluez-utils,
bluez-libs.

Install PulseAudio

PulseAudio interfaces with ALSA, Bluez and other user mode programs. The
pulseaudio-git package from AUR has capabilities not provided by the
stock pulseaudio package. The additional capabilities are required by
Bluez5. More info regarding the differences between Bluez5 and
PulseAudio are here.

Required packages: pulseaudio-git, pavucontrol.

Install Audacious

Audacious is a program which plays audio files. It can work directly
with ALSA or with PulseAudio. Required packages: audacious,
audacious-plugins.

> Procedure

Once the required packages are installed, use this procedure to play
audio with a bluetooth headset. The high level overview of the procedure
is to pair the headset, connect the headset, configure the player and
pulse audio controller and then play audio.

Start the bluetooth service as root or use sudo

    # systemctl start bluetooth

Verify Bluetooth is started

    # systemctl status bluetooth
    bluetooth.service - Bluetooth service
      Loaded: loaded (/usr/lib/systemd/system/bluetooth.service; disabled)
      Active: active (running) since Sat 2013-12-07 12:31:14 PST; 12s ago
        Docs: man:bluetoothd(8)
    Main PID: 3136 (bluetoothd)
      Status: "Running"
      CGroup: /system.slice/bluetooth.service
              └─3136 /usr/lib/bluetooth/bluetoothd

    Dec 07 12:31:14 t61p systemd[1]: Starting Bluetooth service...
    Dec 07 12:31:14 t61p bluetoothd[3136]: Bluetooth daemon 5.11
    Dec 07 12:31:14 t61p systemd[1]: Started Bluetooth service.
    Dec 07 12:31:14 t61p bluetoothd[3136]: Starting SDP server
    Dec 07 12:31:14 t61p bluetoothd[3136]: Bluetooth management interface 1.3 i...ed
    Hint: Some lines were ellipsized, use -l to show in full.

Start the pulseaudio daemon. This must be done after X windows is
started and as a normal user.

    $ pulseaudio -D

Verify the pulseaudio daemon is running.

    $ pulseaudio --check -v
    I: [pulseaudio] main.c: Daemon running as PID 3186

Start up bluetoothctl as root and pair and connect your headset. As a
regular user, bluetoothctl will pair but not connect. Perhaps this is
related to the config file (shown below) which is setup for what appears
to be the root user. Note: the procedure shown below is for an initial
pair and connect of the headphone. If the headset is already paired,
then the procedure below can be shortened to: power on, agent on,
default-agent, connect <mac address>. The mac address can be seen from
the devices command output.

     $ bluetoothctl 
     [NEW] Controller 00:1E:4C:F4:98:5B t61p-0 [default]
     [NEW] Device 00:1A:7D:12:36:B9 SoundBot SB220
     [bluetooth]# show
     Controller 00:1E:4C:F4:98:5B
           Name: t61p
           Alias: t61p-0
           Class: 0x000000
           Powered: no
           Discoverable: no
           Pairable: yes
           UUID: PnP Information           (00001200-0000-1000-8000-00805f9b34fb)
           UUID: Generic Access Profile    (00001800-0000-1000-8000-00805f9b34fb)
           UUID: Generic Attribute Profile (00001801-0000-1000-8000-00805f9b34fb)
           UUID: A/V Remote Control        (0000110e-0000-1000-8000-00805f9b34fb)
           UUID: A/V Remote Control Target (0000110c-0000-1000-8000-00805f9b34fb)
           UUID: Audio Source              (0000110a-0000-1000-8000-00805f9b34fb)
           UUID: Audio Sink                (0000110b-0000-1000-8000-00805f9b34fb)
           Modalias: usb:v1D6Bp0246d050B
           Discovering: no
     [bluetooth]# power on
     [CHG] Controller 00:1E:4C:F4:98:5B Class: 0x0c010c
     Changing power on succeeded
     [CHG] Controller 00:1E:4C:F4:98:5B Powered: yes
     [bluetooth]# agent on
     Agent registered
     [bluetooth]# default-agent
     Default agent request successful

<power on your headset in pairing mode. Eventually you will see what
appears to be a mac address.>

     [bluetooth]# scan on
     Discovery started
     [CHG] Controller 00:1E:4C:F4:98:5B Discovering: yes
     [CHG] Device 00:1A:7D:12:36:B9 RSSI: -61
     [bluetooth]# pair 00:1A:7D:12:36:B9
     Attempting to pair with 00:1A:7D:12:36:B9
     [CHG] Device 00:1A:7D:12:36:B9 Connected: yes
     [CHG] Device 00:1A:7D:12:36:B9 UUIDs has unsupported type
     [CHG] Device 00:1A:7D:12:36:B9 Paired: yes
     Pairing successful
     [bluetooth]# connect 00:1A:7D:12:36:B9
     [CHG] Device 00:1A:7D:12:36:B9 Connected: yes
     Connection successful
     [bluetooth]# info 00:1A:7D:12:36:B9
     Device 00:1A:7D:12:36:B9
           Name: SoundBot SB220
           Alias: SoundBot SB220
           Class: 0x240404
           Icon: audio-card
           Paired: yes
           Trusted: no
           Blocked: no
           Connected: yes
           LegacyPairing: yes
           UUID: Headset                   (00001108-0000-1000-8000-00805f9b34fb)
           UUID: Audio Sink                (0000110b-0000-1000-8000-00805f9b34fb)
           UUID: A/V Remote Control Target (0000110c-0000-1000-8000-00805f9b34fb)
           UUID: A/V Remote Control        (0000110e-0000-1000-8000-00805f9b34fb)
           UUID: Handsfree                 (0000111e-0000-1000-8000-00805f9b34fb)

Start up alsamixer, for simplicity un-mute all your outputs. Oddly
enough some can be muted though. The ones I had muted during playback
were:

-   Headphones
-   SPIDF

Start up audacious. Use the menu to select pulseaudio as your output.
Somewhere I read that bluez5 requires pulseaudio-git and this jives with
my experience.

Start up pavucontrol in a terminal. In the Outputs tab select the
bluetooth headset.

screenshot of application settings

Miscellaneous Configuration Files

For reference these settings were also done.

ALSA /etc/asound.conf

The settings shown at the top of this page was used, but the additional
modification for intel laptop soundcards.

    pcm.btheadset {
      type plug
      slave {
        pcm {
          type bluetooth
          device 00:1A:7D:12:36:B9
          profile "auto"
        }
      }
      hint {
        show on
        description "BT Headset"
      }
    }
    ctl.btheadset {
      type bluetooth
    }
    options snd-hda-intel model=laptop

/etc/dbus-1/system.d/bluetooth.conf

The settings here seem to be enabled for root only. See the policy
user="root" section. However, if a regular user is specified here, the
system fails to start. Someone with more knowledge could explain why.

    /etc/dbus-1/system.d/bluetooth.conf

    <!-- This configuration file specifies the required security policies for Bluetooth core daemon to work. -->

    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
      "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>

      <!-- ../system.conf have denied everything, so we just punch some holes -->

      <policy user="root">
        <allow own="org.bluez"/>
        <allow send_destination="org.bluez"/>
        <allow send_interface="org.bluez.Agent1"/>
        <allow send_interface="org.bluez.MediaEndpoint1"/>
        <allow send_interface="org.bluez.MediaPlayer1"/>
        <allow send_interface="org.bluez.ThermometerWatcher1"/>
        <allow send_interface="org.bluez.AlertAgent1"/>
        <allow send_interface="org.bluez.Profile1"/>
        <allow send_interface="org.bluez.HeartRateWatcher1"/>
        <allow send_interface="org.bluez.CyclingSpeedWatcher1"/>
      </policy>

      <policy at_console="true">
        <allow send_destination="org.bluez"/>
      </policy>

      <!-- allow users of lp group (printing subsystem) to communicate with bluetoothd -->
      <policy group="lp">
        <allow send_destination="org.bluez"/>
      </policy>

      <policy context="default">
        <deny send_destination="org.bluez"/>
      </policy>

    </busconfig>

Tested applications

As noted above this will work easily with audacious. Youtube videos with
chromium and flashplayer will work on some videos. If the video has ads
it will not work, but if the video does not have ads it will work. Just
make sure that after audacious is working with bluetooth headset, start
chromium and navigate to youtube. Find a video without leading ads and
it should play the audio. If the settings icon has the a menu with two
pulldown combo boxes for Speed and Quality it will play.

Switch between HSV and A2DP setting
-----------------------------------

This can easily be achieved by the following command where 2 needs to be
changed with the correct device number.

    pacmd set-card-profile 2 a2dp

> A2DP not working with pulseaudio

If pulseaudio fails when changing the profile to A2DP with bluez 4.1+
and pulseaudio 3.0+, you can try disabling the Socket interface from
/etc/bluetooth/audio.conf by removing the line Enable=Socket and adding
line Disable=Socket

    Disable=Socket

Tested Headsets
---------------

The following Bluetooth headsets have been tested with Arch Linux

-   Philips SHB9100 - Confirmed NOT TO WORK well. Have tried everything
    after a while they cut out. Pause and resume too is flakky and
    basically the whole wireless bluetooth experience is horrible. The
    following forum post[1] explains an underlying issue and describes a
    temporary solution which can be used to improve the audio quality
    pending a proper fix.
-   Parrot Zik - Confirmed to work out of the box with firmware 1.04!
    The MIC however is detected, but does not work at all. Sometimes it
    can lag behind (not stutter) but most of the times it is not
    noticeable unless you playing a game, in which case I would switch
    to wired which resolves the issue.
-   Sony DR-BT50 works for a2dp both with bluez4 and bluez5
    (instructions here[2], subject to change). Adapter: D-Link DBT-120
    USB dongle.
-   SoundBot SB220 works with bluez5 and pulseaudio-git.
-   Auna Air 300 works well with bluez5, pulseaudio-git, and e.g. also
    mocp when running the latter through padsp. For some reason, a few
    restarts and re-tries were required, and eventually it just started
    working.
-   Sennheiser MM 400-X works out of the box with bluez5 and pulseaudio
    4.0-6
-   Audionic BlueBeats (B-777) works out of the box with bluez5 and
    pulseaudio 4.0-6
-   Logitech Wireless Headset (part number PN 981-000381, advertised for
    use with iPad) works with bluez 5.14 and pulseaudio-git.
-   HMDX Jam Classic Bluetooth works with bluez, pulseaudio-git and
    pavucontrol
-   PT-810 - Generic USB-Powered Bluetooth Audio Receiver with 3.5mm
    headset jack and a2dp profile. Widely available as "USB Bluetooth
    Receiver." IDs as PT-810. Works with bluez 5.14 and pulseaudio-git.
-   Philips SHB4000WT works out of the box with bluez5 and pulseaudio
    5.0

See also
--------

Alternative method of connecting a BT headset to Linux:

-   GaBlog - Connect a bluetooth headset to linux

Using the same device on Windows and Linux without pairing the device
over and over again

-   Dual booting with a bluetooth keyboard

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth_Headset&oldid=304266"

Categories:

-   Sound
-   Bluetooth

-   This page was last modified on 13 March 2014, at 11:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
