Folding@home
============

From the project home page:

Help Stanford University scientists studying Alzheimer's, Huntington's,
Parkinson's, and many cancers by simply running a piece of software on
your computer. The problems we are trying to solve require so many
calculations, we ask people to donate their unused computer power to
crunch some of the numbers. In just 5 minutes... Add your computer to
over 333,684 others around the world to form the world's largest
distributed supercomputer.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 The graphical way
    -   2.2 The terminal way
-   3 Multi-Core CPUs and Folding@home
    -   3.1 A quick note on hyperthreading
    -   3.2 Multiple Folding@home installs
-   4 Monitoring work-unit progress
-   5 See also

Installation
------------

Install foldingathome from the AUR.

Configuration
-------------

Run /opt/fah/FAHClient --configure as root to generate a configuration
file at /opt/fah/config.xml. (the Arch Linux team number is 45032)
Alternately, you can write opt/fah/config.xml by hand and use
/opt/fah/sample-config.xml as a reference. With a config file in place,
you can start the daemon, check it's status, and make the daemon
automatically start at boot time.

    $ cd /opt/fah
    # ./FAHClient --configure
    # systemctl start foldingathome
    $ systemctl status foldingathome
    # systemctl enable foldingathome

> The graphical way

You can manage the daemon by opening a web browser and heading to
http://localhost:7396/. Alternately, you can install fahcontrol and use
the FAHControl program.

The daemon can also be controlled remotely. Instructions for doing so
are listed in /opt/fah/sample-config.xml. Remember to open firewall
ports if necessary.

> The terminal way

To see the current progress of foldingathome, simply
$ tail /opt/fah/log.txt.

The behaviour of foldingathome can be customized by editing
/opt/fah/config.xml. Some options that can be specified:

-   bigpackets, defines whether you will accept memory intensive work
    loads. If you have no problem with Folding@home using up more of
    your RAM, then set this to big. Other settings are normal and small.
-   passkey, to uniquely identify you. Though not needed, it provides
    some measure of security. For details, see [1]

    <passkey v='passkey'/>

-   Slots for CPU or GPU

    <slot id='0' type='CPU'/>

Multi-Core CPUs and Folding@home
--------------------------------

As of version 7.x, multi-core CPUs no longer require any special
configuration. If you are using version 6.x, read on.

> A quick note on hyperthreading

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: "Hyperthreading  
                           is usually enabled in    
                           the BIOS by default, and 
                           we recommend that it     
                           stays enabled, as the    
                           SMP cores can use it to  
                           process Work Units       
                           faster." [2] (Discuss)   
  ------------------------ ------------------------ ------------------------

If you have a single-core hyperthreading CPU, you may be tempted to
follow the multi-core instructions. It is highly recommenced that you do
not do this as the Folding@home team prefers fewer results quickly, than
more results slowly. There is also a time-limit on work-units, so if it
runs slower, your work-units may not be returned in time, and so
distributed to another user. If you have one core, run one folding
process.

> Multiple Folding@home installs

Multiple installations of FAH on a single machine are useless, as in v7,
you can use slots for every workload. The software is uniform now for
GPU and CPU.

Monitoring work-unit progress
-----------------------------

There are several ways of monitoring the progress of your FAH clients,
both on the command line and by GUI.

The FAHControl software distributed by folding at home provides you with
efficient means to control remote hosts. Just add another client with
the corresponding button "Add" and enter the name, ip address, port and
password (if you set one) and hit save. The software should now try to
establish a connection to the remote host and show you the progress in a
seperate client tab.

In AUR there is fahmon, which provides a GUI with the ability to watch
multiple clients and get info on the work-unit itself. Fahmon has a
dedicated site at http://www.fahmon.net/

On the CLI, you can add a command to your shell configuration file (e.g:
.bashrc or .zshrc). Replace fah_user with the actual user first.

    fahstat() {
            echo
            echo $(date)
            echo
            cat /opt/fah/fah_user/unitinfo.txt
    }

Or for multiple clients :

     fahstat() {
             echo
             echo $(date)
             echo
             echo "Core 1:";cat /opt/fah/fah_user/unitinfo.txt
             echo
             echo "Core 2:";cat /opt/fah2/fah_user/unitinfo.txt
     }

Also, replacing cat with tail -n1 will give just the percentage of work
unit complete.

On foldingathome-smp 6.43, the unitinfo.txt file is not placed inside
the user folder. The correct directory would be
/opt/fah-smp/unitinfo.txt.

See also
--------

-   Folding@home site
-   Folding@home FAQ
-   Folding@home Configuration Guide
-   Folding@home SMP Client FAQ
-   Arch Folding@home team page
-   Extended Arch team statistics in extremeoverclocking.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Folding@home&oldid=284759"

Category:

-   Mathematics and science

-   This page was last modified on 27 November 2013, at 00:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
