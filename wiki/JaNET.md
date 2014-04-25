JaNET
=====

Project jaNET provides a framework that allows various components to
communicate, controlled interactively by the user. This procedure aim to
act like a digital life assistant (DLA) and it's inspired by Iron Man's
JARVIS.

The virtual she-butler comes to life through project jaNET, a platform
ready to host multiple creative and innovative pieces of code concerning
domestic everyday tasks.

jaNET provides a built in framework to fulfil most of our daily
information manners (like e-mail notification, weather conditions etc)
but it can also be extend by wrapping 3rd party applications, processes
or scripts in order to become a more flexible and smart system!

Contents
--------

-   1 Installation
    -   1.1 Manual installation
-   2 Configuration
    -   2.1 Festival configuration
    -   2.2 Simon configuration
    -   2.3 jaNET configuration
        -   2.3.1 Configuring alerts
        -   2.3.2 Configuring Bluetooth device
        -   2.3.3 Configuring weather updates
-   3 Creating your own commands
    -   3.1 Number of Arch package updates
        -   3.1.1 Configuring Simon for Arch updates
-   4 See also

Installation
------------

Install janet from the AUR.

Note:jaNET requires heavy-weight dependencies like festival, simon and
Mono.

> Manual installation

If you prefer manual installation, first install: monodevelop festival
simon.

You can grab the source here if you wish to develop; however, we are
going to use the latest binary.

    $ wget http://sourceforge.net/projects/project-janet/files/Binaries/Bin.tar.gz
    # mkdir -p /usr/share/janet/scripts
    # tar -xvf Bin.tar.gz -C /usr/share/janet

Create a launcher for jaNET now:

    /usr/local/bin/janet

    #!/bin/sh
    mono /usr/share/janet/jaNET.exe "$@"

Make it executable:

    # chmod a+x /usr/local/bin/janet

Configuration
-------------

jaNET is now installed however it and it's dependencies needs to be
configured!

> Festival configuration

In order to get the female voice of "janet":

    $ wget -c "http://www.speech.cs.cmu.edu/cmu_arctic/packed/cmu_us_slt_arctic-0.95-release.tar.bz2"
    $ tar -xvjf cmu_us_slt_arctic-0.95-release.tar.bz2
    # mkdir /usr/share/festival/voices/us
    # mv cmu_us_slt_arctic /usr/share/festival/voices/us/cmu_us_slt_arctic_clunits

You need to edit /usr/share/festival/voices.scm and add
cmu_us_slt_arctic_clunits to the default list on the top.

Test this by: (You should hear a female voice)

    $ echo "Hello world." | festival --tts

> Simon configuration

Open Simon program and go to Settings > Configure Simon > Model Settings
and choose Static Model and load the HMM definition, Tiedlist, Macros
and Stats. Those models can be found here.

Then go to Vocabulary and import a Shadow Vocabulary using dictionary
type HTK Lexicon and import the VoxForgeDict from the HTK Accoustic
Model we previously downloaded.

We also need jaNET scenarios, so in Simon go to Manage Scenarios >
Import/Download search for jaNET and Install. Then click Commands tab
and select Program > Janet > Edit and change jaNET's path with
/usr/local/bin/janet.

Note:You should perhaps change also the gnome-terminal string since you
may not have it installed, to use a terminal installed (e.g. xterm -e).

Those scencarios did not work for me however, so I have uploaded a
working copy of the scenarios for jaNET with this configuration used
here.

> jaNET configuration

The main file used to configure jaNET is /usr/share/janet/AppConfig.xml.

Configuring alerts

In {{ic|AppConfig.xml in the Settings Sub-Tree: Settings > Alerts sets
the email, and sms alerts that jaNET will send.

Configuring Bluetooth device

See Bluetooth in order to set up your bluetooth device. You will need
the MAC address:

    $ hcitool scan

In AppConfig.xml in the Settings sub-tree:

-   Settings > Bluetooth: Change the id to match your bluetooth device
    MAC address.
-   Settings > Bluetooth > name: Change this to your bluetooth device.
    E.g. "Samsung 1234".
-   Settings > Bluetooth > macAddr: Change this to match your bluetooth
    device MAC address.

You can also change the behavior when you enter and exit the area in the
found and lost sections.

-   Example: adding an InstructionSet command to automatically sync your
    phonebook everytime you enter! Never lose all your contacts again!

Configuring weather updates

In AppConfig.xml in the Settings sub-tree:

    Settings > Other > YahooForecastFeed

Go to http://weather.yahoo.com/ and enter your city/zip code. Click on
the RSS feed and copy this link. Replace the YahooForecastFeed with this
and update the InstructionSets that relate to weather with the
appropriate city name.

Creating your own commands
--------------------------

Creating new commands for jaNET is easy! In order to configure simon you
will need htk installed and using the adapted base model from
definitions earlier used.

> Note:

-   I have not been able to compile htk on x86_64 yet.
-   I have successfully compile htk on x86_64 with gcc-multilib.

jaNET allows you to run external commands and use the output in it's
replies! A walk-through of creating a package updates command.

> Number of Arch package updates

You should have a /usr/share/festival/scripts directory now. If not,
create it.

First we need pacman to update its cache every so often so we can find
new updates. Create /etc/cron.hourly/pacmanupdate and place this inside:

    pacman -Syy

Next we need to create the script for jaNET to use. Create
/usr/share/janet/archlinux_updates.sh with the following:

    #!/bin/bash
    echo "$(pacman -Qu 

Now all we need to do is add the new InstructionSets so that we can use
this with jaNET! Edit your AppConfig.xml and add the following within
the Instructions Sub-Tree.

    <InstructionSet id="*archupdates">bash /usr/share/janet/scripts/archlinux_updates.sh</InstructionSet>
    <InstructionSet id="archupdates">There are *archupdates available updates sir.</InstructionSet>

jaNET can now tell you how many updates you have!

    janet 'archupdates;qexit'

Configuring Simon for Arch updates

TODO - Cannot do this currently without htk properly installed.

See also
--------

-   http://sites.google.com/site/projectjanet/home - Project home page
-   http://simon-listens.org/index.php?id=284&L=1 - Simon home page

Retrieved from
"https://wiki.archlinux.org/index.php?title=JaNET&oldid=303792"

Category:

-   Applications

-   This page was last modified on 9 March 2014, at 14:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
