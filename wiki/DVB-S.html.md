DVB-S
=====

Related articles

-   DVB-T
-   MythTV Walkthrough

This article describes the setup and use of DVB-S (sat TV) cards on Arch
Linux.

Warning:This was only tested with the Pinnacle PCTV Sat, and may not
work or will not help you with different cards.

Contents
--------

-   1 Load required Modules
    -   1.1 Pinnacle PCTV Sat
    -   1.2 Additional modules: S2-liplianin
        -   1.2.1 Setup
-   2 Setup Permissions
-   3 Scanning channels
    -   3.1 Using scan
    -   3.2 Using w_scan
        -   3.2.1 DiSEqC switch scanning (AKA multiple satellite LNB)
-   4 Switching channels
-   5 Software
    -   5.1 Kaffeine
        -   5.1.1 Importing channel list
    -   5.2 Me-tv
    -   5.3 Klear
    -   5.4 Xine
-   6 Additional Resources
    -   6.1 TV Cards in general

Load required Modules
---------------------

You have to lookup the chipset of your specific card; tools like lshwd
may help you.

> Pinnacle PCTV Sat

This card uses bt878 and cx24110 as chipset.

Load them (under root) with:

    # modprobe dvb-bt8xx
    # modprobe cx24110

If you want Arch to boot them on startup, add both modules to MODULES in
/etc/rc.conf.

> Additional modules: S2-liplianin

However, there is not a working kernel module for all (especially newer)
devices.

Igor M. Liplianin manages some additional modules at his mercurial
repository.

Setup

First of all, you have to download and prepare the source code.

    $ hg clone https://pikacode.com/liplianin/s2-liplianin

If you don't have installed mercurial, you will get an error message:
hg: command not found

You can either download the package mercurial and try the obove command
again or download the source code from here and extract it manually.

After obtaining the code, change the working directory to the extracted
folder:

    $ cd s2-liplianin

Unfortunately not all modules of liplianin are compatible with recent
kernels and cause some trouble if you want to compile them hence you
have to exclude these modules from the build process (if you do not need
them). You can choose which modules you want to build by executing:

    $ make config

which will create a config file: v4l/.config.

Note:If you want to edit the config file with another interface, take a
look at the 'Module selection rules' section within the file Install.

After that, you have to build the chosen modules:

    $ make

Note:It is very likely, that some modules will not compile. Try to
exclude them (one step earlier) and run 'make' again.

If all configured modules were compiled successfully, you can install
the modules at the kernel's default modules directory by executing:

    # make install

After that, reboot your machine.

Setup Permissions
-----------------

To use your DVB-S card as user add him to the video group:

    # gpasswd -a [username] video

Scanning channels
-----------------

Note: You can skip this part if you use Kaffeine.

Most applications like szap or xine are needing a channel list created
by scan, which is part of dvb-utils. You will find the dvb-utils package
under the name linuxtv-dvb-apps in the Community-Repo.

Install it with:

    # pacman -S linuxtv-dvb-apps

> Using scan

scan needs an channel to initialize scanning. In /usr/share/dvb/dvb-s/
are some files which contain these channels; you will need that one that
fits the satellite you are watching from.

The following command will scan all channels and save them to
channels.conf:

    $ scan -x0 -t1 -s1 /usr/share/dvb/dvb-s/[your satellite] | tee channels.conf

Note: The channel file does not have to be called channels.conf but it
is more convenient as you will see later.

Note: Depending on your satellite dish setup you may have to try other
arguments.

> Using w_scan

w_scan allows for automatic scanning of channels without configuration.
Install it then issue:

    # w_scan -c [your country] > ~/someChannels.conf

Alternatively you can also scan using the satellite position like 19.5E
for Astra 1. Scans like that can be done as follows:

    # w_scan -fs -s S19E5 > ~/someChannels.conf

You can also add the -X flag to generate tzap/czap/xine output instead
of vdr output.

    # w_scan -X -c AU > ~/AustraliaChannels.conf

DiSEqC switch scanning (AKA multiple satellite LNB)

If you have a LNB with a DiSEqC switch in it you can manually select
that using the -D option like so:

    # w_scan -fs -s S23E5 -D 1c > ~/someChannels.conf

The above line should work but not all found channels where actually
saved. The line below worked perfectly for me:

    # w_scan -fs -s S23E5 -a 0 -D 1c -o 7 -e 2 > ~/someChannels.conf

Warning:I did found out that when using a LNB with a DiSEqC switch it is
way more convenient to use -X ouptut which you can use in for example
mplayer. Just append "-X" before the ">" that you see above.

Switching channels
------------------

Note: szap only works with satellite TV.

By using zap, which comes with dvb-utils, you can switch channels, so
you do not have to rely on the abilities of your player.

szap needs the channel file we created earlier; it will try
~/.szap/channels.conf by default. You can move the channels.conf there
or you can use the "-c" command-line option.

Switching channels works like this:

    $ szap -r [channel]

Note: szap needs to keep running.

You can list all available channels with:

    $ szap -q

Now you can watch the stream for example with xine:

    $ xine -g stdin://mpeg2 < /dev/dvb/adapter0/dvr0

or with mplayer:

    $ mplayer /dev/dvb/adapter0/dvr0

or with mplayer, but using DVB directly:

    $ mplayer "dvb://RTL Television"

You can find all the channel names by running szap -q (assuming the
channel list is also in ~/.szap/channels.conf).

Software
--------

> Kaffeine

Kaffeine is a really nice player; it supports EPG, time-shifting, and
recording. Additionally Kaffeine has built-in channel-searching.

Install it with:

    # pacman -S kaffeine

-   More Information
-   Project page

Importing channel list

-   Linosaw.de provides channels.conf files for VDR
-   conv2conf converts these files into kaffeine channel list format

> Me-tv

Me-tv is a simple but powerfull dvb-viewer, supporting EPG, recording
and channel-searching with a light-weight gui.

-   It is in the official repository:

     # pacman -S me-tv

-   SVN version in the AUR:
    https://aur.archlinux.org/packages.php?ID=27065

> Klear

Klear is also a really nice player, but more than 4 years old (last
release 2006). It supports EPG, time-shifting, and recording, videotext.
Channel-searching is still missing. Install it from AUR:

-   AUR package
-   Project page

> Xine

Copy your channel file to ~/.xine/channels.conf.

Watch a specific channel with following command:

    $ xine dvb://[channel]

or use the playlist editor in Xine

Additional Resources
--------------------

> TV Cards in general

-   Ubuntuusers.de-Wiki (german)

Retrieved from
"https://wiki.archlinux.org/index.php?title=DVB-S&oldid=292373"

Category:

-   Audio/Video

-   This page was last modified on 11 January 2014, at 09:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
