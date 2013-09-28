Bluetooth Headset
=================

This article describes how to set up a bluetooth headset with Arch
Linux. Before you get started, you have to make sure that bluetooth is
set up and working, especially that the dbus and hcid (started with the
bluetooth start scriptlet) daemons are running.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 ALSA-BTSCO method                                                  |
|     -   1.1 Connecting the headset                                       |
|         -   1.1.1 Pairing the headset with your computer                 |
|             -   1.1.1.1 Using bluez-gnome                                |
|             -   1.1.1.2 Using passkey-agent                              |
|                                                                          |
|     -   1.2 Headset and Alsa Devices                                     |
|     -   1.3 Headset's multimedia buttons                                 |
|                                                                          |
| -   2 PulseAudio method                                                  |
|     -   2.1 Troubleshooting                                              |
|         -   2.1.1 Audio sink fails                                       |
|         -   2.1.2 Page timeout issue                                     |
|                                                                          |
| -   3 Switch between HSV and A2DP setting                                |
|     -   3.1 A2DP not working with pulseaudio                             |
|                                                                          |
| -   4 Links                                                              |
+--------------------------------------------------------------------------+

ALSA-BTSCO method
-----------------

It is much easier to set up your bluetooth headset today, with bluez >=
3.16. You may wanna try the out-of-box python script in this blog (you
need edit the script to work with gconftool-2). There's also a piece of
equivalent bash script here.

The following method is out-of-date and obsoleted.

NOTE: This method is also outdated as with newer versions of BlueZ.

You need your headset's bdaddr. It is of the form 12:34:56:78:9A:BC.
Either find it in the documentation of your headset, on the headset
itself or with the hcitool scan command.

Install btsco from AUR.

To load the kernel module, type

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

1. First if you have not already, install bluez

    # pacman -S bluez

2. Scan for your device

    $ hcitool (-i <optional hci#>***) scan

3. Pair your headset with your device

    $ bluez-simple-agent (optional hci# ***) XX:XX:XX:XX:XX:XX
      and put in your pin (0000 or 1234, etc)

4. Add this to your/etc/asound.conf file

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

5. Check to see if it has been added to alsa devices

    $ aplay -L

6. Now play with aplay:

    $ aplay -D btheadset /path/to/audio/file
      

or Mplayer:

    $ mplayer -ao alsa:device=btheadset /path/to/audio/or/video/file

-   -   -   To find hci# for a usb dongle, type in

    $ hcitool dev

> Headset's multimedia buttons

In order to get your bluetooth headset's multimedia buttons (play,
pause, next, previous) working you need to add uinput to MODULES section
in /etc/rc.conf:

    MODULES=(fuse ipw2200 ... uinput)

PulseAudio method
-----------------

This one`s much easier and more elegant. PulseAudio will seamlessly
switch between output devices when the headset is turned on. If you have
ALSA as the sound server, you need the following packages installed:

    # pacman -S pulseaudio pulseaudio-alsa

Now, to configure the audio output to use bluetooth, just install and
run pavucontrol to configure the audio output:

    # pacman -S pavucontrol
    $ pavucontrol

That`s it!

See [this blog] for futher explanations. Make sure to take a look at the
PulseAudio wiki entry for setting up PulseAudio, especially if you are
running KDE.

> Troubleshooting

Audio sink fails

Bluetooth headset is connected, but ALSA/PulseAudio fails to pick up the
connected device. You'll get "Audio sink fails". According to gentoo
wiki, you have to verify than in /etc/bluetooth/audio.conf there is
Enable=Socket under the [General] section heading.

Just do a #rc.d restart bluetooth to apply it.

Page timeout issue

If you receive this error whilst trying to pair your headset with your
system using bluez-simple-agent, then you can try to restart your system
and use the graphical bluez applet of your desktop environment.

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

Links
-----

Alternative method of connecting a BT headset to Linux:

-   GaBlog - Connect a bluetooth headset to linux

  
 See also:

-   Bluetooth

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth_Headset&oldid=251786"

Categories:

-   Sound
-   Bluetooth
