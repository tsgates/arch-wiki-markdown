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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Installing jaNET                                             |
|         -   1.1.1 Using Yaourt                                           |
|         -   1.1.2 Manual Installation                                    |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Festival Configuration                                       |
|     -   2.2 Simon Configuration                                          |
|     -   2.3 jaNET Configuration                                          |
|         -   2.3.1 Configuring Alerts                                     |
|         -   2.3.2 Configuring Bluetooth Device                           |
|         -   2.3.3 Configuring Weather Updates                            |
|                                                                          |
| -   3 Creating your own Commands                                         |
|     -   3.1 Number of Arch Package Updates                               |
|         -   3.1.1 Configuring Simon for Arch Updates                     |
|                                                                          |
| -   4 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

jaNET requires festival, simon and mono to run:

    yaourt -Sy monodevelop festival simon

Note:x86_64 users need to edit the PKGBUILD and add x86_64 to the arch
line - IT DOES COMPILE PROPERLY

> Installing jaNET

Using Yaourt

Yaourt package is now available!

    su -c 'yaourt -Sy janet'

Manual Installation

You can grab the source here if you wish to develop; however, we are
going to use the latest binary.

    wget http://sourceforge.net/projects/project-janet/files/Binaries/Bin.tar.gz
    as root:
    mkdir -p /usr/share/janet/scripts
    tar -xvf Bin.tar.gz -C /usr/share/janet

We will make a launcher for jaNET now:

    as root:
    cat <<EOF >>/usr/bin/janet
    #!/bin/sh
    /usr/bin/mono /usr/share/janet/jaNET.exe "$@"
    EOF
    chmod a+x /usr/bin/janet

Configuration
-------------

jaNET is now installed however it and it's dependencies needs to be
configured!

> Festival Configuration

In order to get the female voice of "janet":

    cd ~/Desktop
    wget -c "http://www.speech.cs.cmu.edu/cmu_arctic/packed/cmu_us_slt_arctic-0.95-release.tar.bz2"
    tar -xvjf cmu_us_slt_arctic-0.95-release.tar.bz2
    as root:
    mkdir /usr/share/festival/voices/us
    mv ~/Desktop/cmu_us_slt_arctic /usr/share/festival/voices/us/cmu_us_slt_arctic_clunits

You need to edit /usr/share/festival/voices.scm and add
cmu_us_slt_arctic_clunits to the default list on the top.

Test this by: (You should hear a female voice)

    echo "Hello world." | festival --tts

> Simon Configuration

Open Simon program and go to Settings > Configure Simon > Model Settings
and choose Static Model and load the HMM definition, Tiedlist, Macros
and Stats. Those models can be found here.

Then go to Vocabulary and import a Shadow Vocabulary using dictionary
type HTK Lexicon and import the VoxForgeDict from the HTK Accoustic
Model we previously downloaded.

We also need jaNET scenarios, so in Simon go to Manage Scenarios >
Import/Download search for jaNET and Install. Then click Commands tab
and select Program-Janet-Edit and change jaNET's path with
/usr/bin/janet.

Note:You should perhaps also change the terminal to xterm -e instead of
gnome-terminal since you may not have it installed.

Those scencarios did not work for me however, so I have uploaded a
working copy of the scenarios for jaNET with this configuration used
here.

> jaNET Configuration

The main file used to configure jaNET is /usr/share/janet/AppConfig.xml

Configuring Alerts

In AppConfig.xml in the Settings Sub-Tree: Settings > Alerts sets the
email, and sms alerts that jaNET will send.

Configuring Bluetooth Device

See bluetooth in order to set up your bluetooth device. You will need
the mac address:

    hcitool scan

In AppConfig.xml in the Settings Sub-Tree: Settings > Bluetooth:

-   change the id to match your bluetooth device mac address

Settings > Bluetooth > name:

-   change this to your bluetooth device. Ex "Samsung 1234"

Settings > Bluetooth > macAddr

-   change this to match your bluetooth device mac address

You can also change the behavior when you enter and exit the area in the
found and lost sections.

-   Example: adding an InstructionSet command to automatically sync your
    phonebook everytime you enter! Never lose all your contacts again!

Configuring Weather Updates

In AppConfig.xml in the Settings Sub-Tree: Settings > Other >
YahooForecastFeed

Go to http://weather.yahoo.com/ and enter your city/zip code. Click on
the RSS feed and copy this link. Replace the YahooForecastFeed with this
and update the InstructionSets that relate to weather with the
appropriate city name.

Creating your own Commands
--------------------------

Creating new commands for jaNET is easy! In order to configure simon you
will need htk installed and using the adapted base model from
definitions earlier used.

Note:I have not been able to compile htk on x86_64 yet

Note:I have successfully compile htk on x86_64 with gcc-multilib

jaNET allows you to run external commands and use the output in it's
replies! A walk-through of creating a package updates command:

> Number of Arch Package Updates

You should have a /usr/share/festival/scripts directory if you followed
this wiki, if not, create it.

First we need pacman to update its cache every so often so we can find
new updates. Create /etc/cron.hourly/pacmanupdate and place this inside:

    pacman -Syy

Next we need to create the script for jaNET to use. Create
/usr/share/janet/archlinux_updates.sh with the following:

    #!/bin/bash

    echo "$(pacman -Qu | wc -l)"

Now all we need to do is add the new InstructionSets so that we can use
this with jaNET! Edit your AppConfig.xml and add the following within
the Instructions Sub-Tree.

    <InstructionSet id="*archupdates">bash /usr/share/janet/scripts/archlinux_updates.sh</InstructionSet>
    <InstructionSet id="archupdates">There are *archupdates available updates sir.</InstructionSet>

jaNET can now tell you how many updates you have!

    janet 'archupdates;qexit'

Configuring Simon for Arch Updates

TODO - Cannot do this currently without htk properly installed.

External Links
--------------

-   http://sites.google.com/site/projectjanet/home
-   http://simon-listens.org/index.php?id=284&L=1

  

* * * * *

--platinummonkey 00:28, 4 January 2011 (EST)

Retrieved from
"https://wiki.archlinux.org/index.php?title=JaNET&oldid=206948"

Category:

-   Applications
