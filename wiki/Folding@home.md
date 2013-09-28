Folding@home
============

From the AUR package page: "Folding@home is a distributed computing
project which studies protein folding, misfolding, aggregation, and
related diseases."

Please see the Folding@home site for a fuller description.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: foldingathome    
                           Version 7 (Discuss)      
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Multi-Core CPUs and Folding@home                                   |
|     -   3.1 A Quick Note On Hyperthreading                               |
|     -   3.2 Multiple Folding@home Installs                               |
|         -   3.2.1 Editing Init Scripts                                   |
|         -   3.2.2 Maintenance                                            |
|         -   3.2.3 Alternative: Single Init Script                        |
|                                                                          |
|     -   3.3 Folding@home SMP Support                                     |
|         -   3.3.1 Migrating                                              |
|         -   3.3.2 Troubleshooting                                        |
|             -   3.3.2.1 Cannot find ./mpiexec                            |
|             -   3.3.2.2 SMP client not doing any work / stalling (       |
|                 NNODES=4 )                                               |
|             -   3.3.2.3 Work Unit progress sitting at 100%               |
|             -   3.3.2.4 Invalid pointer glibc error at client launch     |
|                                                                          |
| -   4 GPU Client                                                         |
| -   5 Monitoring Work-Unit Progress                                      |
| -   6 External Resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

Note:There are multiple versions of folding@home in the AUR. One is the
i686 package, named foldingathome, which is used in the example below.
The other is foldingathome-smp, which is the x86_64 client and uses
symmetric multi-processing, a more efficient method. There is also an
nVidia GPU client named foldingathome-gpu-nvidia which is the fastest of
the three, if your system supports it.

Folding@home is no longer in the community repository due to licensing
issues. However, it is still possible to build it from AUR. If you are
familiar with PKGBUILDs and AUR then build it and skip to configuration.

To install manually, first download the tarball at the Folding@home AUR
page. Open a console and untar the tarball. cd to the resulting
directory and:

    $ makepkg

and if there are no errors you will be left with a package called
foldingathome-version-number.pkg.tar.gz.

Run

    # pacman -U foldingathome-version-number.pkg.tar.gz

being sure to replace version-number first ;)

If all went well, Folding@home should now be installed.

Configuration
-------------

Firstly, you will want to open your /etc/conf.d/foldingathome
configuration file, with your editor of choice.

    # nano /etc/conf.d/foldingathome

The config is self explanatory, if you wish to have Folding@home run as
a user other than root (handy on single user systems, probably more
secure on multi-user systems), or in a different group, then change
these values.

Now run the Folding@home process for the first time with

    # systemctl start foldingathome

Or, for Initscripts:

    # /etc/rc.d/foldingathome start

Remember, this is foldingathome-smp for the SMP client.

give it a few seconds and then run

    # systemctl stop foldingathome

Or for initscripts:

    # /etc/rc.d/foldingathome stop

You will find under your /opt/fah/ directory, either new files or a new
folder, if you set the user variable in /etc/conf.d/foldingathome. You
will find a file called client.cfg, either in the /opt/fah dir or the
/opt/fah/FAH_USER folder.

    # nano /opt/fah/client.cfg

or

    $ nano /opt/fah/FAH_USER/client.cfg  # Replace FAH_USER first

The most important settings here are:

-   username, username associated to the work-units you return (not
    related to the FAH_USER variable in /etc/conf.d/foldingathome).

-   team, the team number you wish to contribute points to (earned for
    work units returned), you will of course want to fill in 45032, the
    arch-linux team number.

-   bigpackets, defines whether you will accept memory intensive work
    loads. If you have no problem with Folding@home using up more of
    your RAM, then set this to big. Other settings are normal and small.

-   machineid, covered in the Multi-Core section.

After editing that, run

    # systemctl start foldingathome

Or:

    # /etc/rc.d/foldingathome start

again, to start Folding@home up.

Assuming it all ran correctly, you will want to start it when the system
boots:

    # systemctl enable foldingathome

Or for initscripts, put it in /etc/rc.conf:

    # nano /etc/rc.conf

and add @foldingathome to your DAEMONS array (the @ causes it to start
in the background, so as not to slow startup, see Daemons).

Note:Ensure that the nscd daemon appears before foldingathome in the
DAEMONS array of /etc/rc.conf, otherwise starting foldingathome will
fail with segmentation faults.

Folding@home is now installed and running.

Multi-Core CPUs and Folding@home
--------------------------------

> A Quick Note On Hyperthreading

If you have a single-core hyperthreading CPU, you may be tempted to
follow the multi-core instructions. It is highly recommenced that you do
not do this as the Folding@home team prefers fewer results quickly, than
more results slowly. There is also a time-limit on work-units, so if it
runs slower, your work-units may not be returned in time, and so
distributed to another user. If you have one core, run one folding
process.

> Multiple Folding@home Installs

It is very simple to set up an extra install, although after each (rare)
upgrade of the Folding@home package, you will have to perform some
maintenance, unless you wish to build separate packages with custom
PKGBUILDS / scripts (beyond the scope of this tutorial). This method
should also scale to however many cores/processors you have.

First, stop Folding@home if it is running

    # /etc/rc.d/foldingathome stop

next

    # cp -r /opt/fah /opt/fah2

If you wish to call it something different, then by all means do. This
tutorial will assume you are using /opt/fah2 for your second install and
that you have the FAH_USER directory.

Now

    $ rm -rf /opt/fah2/FAH_USER/work  /opt/fah2/FAH_USER/queue.dat

if they exist, this way the new process will not start working on the
same work-unit as the original thread.

You now have to open up the configuration for the new process

    $ nano /opt/fah2/FAH_USER/client.cfg

and change the machineid to a number different to the one in
/opt/fah/client.cfg.

If you are using the bigpackets option in client.cfg, you should only
have it set to yes for one of your Folding@home processes as it can
overwhelm your system unless you have plenty of free RAM (1GB at least).

Editing Init Scripts

Now comes the fun part. A second init script needs to be created and a
little editing needs to be done, but this way you can turn each process
on and off as wanted and it is simpler than one script managing both.

  
 First, some initial editing has to be done to the current script and
saved under another name

    # nano /etc/rc.d/foldingathome

After

    . /etc/rc.conf
    . /etc/rc.d/functions
    . /etc/conf.d/foldingathome

Add

    FAH_VER=504

This is to cut down on later maintenance.

Next, change

    PID=`pidof -o %PPID /opt/fah/FAH504-Linux.exe`

to

    PID=`pgrep -f /opt/fah/FAH${FAH_VER}-Linux.exe -u $FAH_USER`

The reason for this is that pidof detects the first and second
Folding@home process as the same and so stopping one init script will
kill both processes. On the other hand, pgrep will find the process'
associated filename/location. The "-u $FAH_USER" part is tacked on as a
precaution, in case you are doing something strange with Folding@home
threads and users. You will also notice the FAH_VER has slipped in
there.

There should be two more instances of /opt/fah/FAH504-Linux.exe, change
them to

    /opt/fah/FAH${FAH_VER}-Linux.exe

Next, find the lines

    add_daemon foldingathome
    rm_daemon foldingathome 

and change them to something like

    add_daemon foldingathome1
    rm_daemon foldingathome1 
     

You can also change the

    stat_busy "Starting Folding@home"

    stat_busy "Stopping Folding@home"

lines to have some extra description such as "on Core 1" if you need to.

Now save the file as /etc/rc.d/foldingathome1 , this is to prevent it
being over-written by a package upgrade.

Make a copy of the script

    # cp /etc/rc.d/foldingathome1 /etc/rc.d/foldingathome2

Now you have to find and replace instances of /opt/fah with /opt/fah2 in
this script, double checking you are not getting any false positives
(there should not be any, but scripts change). Make sure you get the one
in the PID variable, otherwise the whole pgrep bit was a bit
pointless ;)

Also, find the lines

    add_daemon foldingathome1
    rm_daemon foldingathome1

again, and change them to something like

    add_daemon foldingathome2
    rm_daemon foldingathome2 

Now, save this script and open up /etc/rc.conf and add @foldingathome1
and @foldingathome2 to the DAEMONS variable. Start up the two processes

    # /etc/rc.d/foldingathome1 start
    # /etc/rc.d/foldingathome2 start

and if all goes well, you have got 2 Folding@home processes running!

Maintenance

When upgrading the Folding@home package, it is recommended you stop both
Folding@home init-scripts first

    # /etc/rc.d/foldingathome1 stop
    # /etc/rc.d/foldingathome2 stop

On upgrading, /opt/fah/FAH504-Linux.exe will be replaced with a new
version, this needs to be copied into your /opt/fah2 directory and the
old executable deleted.

You then just have to change the FAH_VER variable in both scripts to
reflect the new version number. You can then restart both scripts with

    # /etc/rc.d/foldingathome1 start
    # /etc/rc.d/foldingathome2 start

It may also be worth checking that there have been no other significant
changes to the updated original script.

Alternative: Single Init Script

I could not get the above method to work with the current (6.02) version
of the client. I found an old script on the forums and modified it
slightly which works just fine on my system.

    #!/bin/bash
    #/etc/rc.d/foldingathome
    #
    # Starts the Folding@home client in the background

    . /etc/rc.d/functions

    case "$1" in
      start)
        stat_busy "Starting Folding@home"
        cd /opt/fah/
        /opt/fah/fah6 > /opt/fah/myfah.log &
        cd /opt/fah2/
        /opt/fah2/fah6 > /opt/fah2/myfah.log &
        stat_done
        ;;
      stop)
        stat_busy "Stopping Folding@home"
        killall fah6
        stat_done
        ;;
      restart)
        stop
        start
        ;;
      *)
        echo $"Usage: $0 {start|stop|restart}"
        RETVAL=1

    esac
    exit 0

Just make sure you do not forget to follow the first section under
"Setting up Multiple Folding@home installs".

> Folding@home SMP Support

There is now a Folding@home client available for 64-bit multi-processor
or multi-core computers (aka SMP). The creators of Folding@home suggest
the SMP client runs best on quad core machines but many people run it on
dual cores with no trouble. This client is definitely NOT recommended
for single-core CPUs with Hyperthreading. So, if your machine meets the
requirements (Arch 64-bit, true multi-core/processor) you may want to
give the SMP client a try instead of running two of the standard client!

  
 Setup is identical to that of the standard client EXCEPT for the
following:

-   the name of the package in the AUR is foldingathome-smp
-   lib32-glibc is required to install and run the client (this is
    reflected as a dependency in the PKGBUILD)
-   the package installs to /opt/fah-smp
-   the configuration script in /etc/conf.d is foldingathome-smp
-   the daemon that should be added to /etc/rc.conf is foldingathome-smp

  

Migrating

When migrating from the standard FAH client/s to SMP, you may wish to
finish off the work units currently running but without the FAH client
downloading new ones. This is possible through the init-scripts as long
as you make sure to check the status of the current work-unit before
shutting down / rebooting.

This may seem a bit over the top and whether you do it depends on how
committed you are to returning all work-units sent to your box. At the
worst, your work-unit will be distributed to someone else after the
cut-off date.

  
 To do this, stop the folding client/s

    # /etc/rc.d/foldingathome1 stop
    # /etc/rc.d/foldingathome2 stop

open up your /etc/rc.d/foldingathome file/s and change

    su $FAH_USER -c "/opt/fah/FAH504-Linux.exe -verbosity 9 > /opt/fah/$FAH_USER/myfah.log" &

to

    su $FAH_USER -c "/opt/fah/FAH504-Linux.exe -oneunit -verbosity 9 > /opt/fah/$FAH_USER/myfah.log" &

This will force the FAH client to only finish its current work-unit and
upload it without downloading a new one. The problem arises in that if
you reboot (or restart the init-scripts) after it is finished and sent
back the work-unit, it will download a new one to finish and send back.
You will just have to monitor the status of the work-unit before you
restart, and if it is at 100% and the end of
/opt/fah/FAH_USER/FAHlog.txt says the work-unit has been returned, you
can remove that script from the DAEMONS= line in /etc/rc.conf.

If you know how, you can probably find a way of stopping it from doing
this, maybe with a check in the init-script which stops it running when
the work-unit file is no longer in the /opt/fah/FAH_USER/work directory.

If you are currently on i686 arch, you will also need to migrate to
X86_64 arc, and it would be a good idea to read the Arch64_FAQ

Troubleshooting

Cannot find ./mpiexec

If you are using the $FAH_USER variable, you will find on starting the
smp client that it cannot find ./mpiexec, this is because it is in the
/opt/fah-smp/ directory and not your local one. Copy it to
/opt/fah-smp/$FAH_USER and it should run fine.

SMP client not doing any work / stalling ( NNODES=4 )

( This is adapted from the folding@home SMP FAQ )

If you run

    # /etc/rc.d/foldingathome-smp start

from the console, you will get some output. If this output stalls with a

    NNODES=4 

line and top/htop shows the smp-client running but with no CPU usage,
you will need to check your local network settings. Check that your
/etc/hosts file is set up with 127.0.0.1 linked to the hostname you set
up in /etc/rc.conf.

Work Unit progress sitting at 100%

If your Work Unit progress is sitting at 100%, there is usually a delay
in uploading. If your client is running non-backgrounded, there will
usually be a prompt to press 'c' to upload the data to the server.
However, if you run your client backgrounded, you will want to enable
automatic uploading of work data. This can be done by editing client.cfg
in your Folding@Home directory (usually /opt/foldingathome/ for i686 or
/opt/fah-smp/ for x86_64) and changing the settings line 'asknet=yes' to
'asknet=no'. This will allow Folding@Home to upload data automatically,
rather than waiting for user input to upload.

Invalid pointer glibc error at client launch

If you start foldingathome and get an error similar to

    *** glibc detected *** ./fah6: free(): invalid pointer: 0xf756c3b8 ***

try running export MALLOC_CHECK_=1, then start the client again (ex.
rc.d start foldingathome). You should only need to start the
folding@home client once with this environment variable set, so adding
MALLOC_CHECK_=1 to your profile is unnecessary.

GPU Client
----------

The GPU client does not currently have a native build, and so the AUR
package downloads the Windows build and runs it through wine. The
package on AUR is designed for 64-bit systems but requires the 32-bit
CUDA libraries. If you want to install it on a i686 system, it may still
work, but you will have to edit the PKGBUILD to change the required
libraries to the correct versions.

Monitoring Work-Unit Progress
-----------------------------

There are several ways of monitoring the progress of your FAH client/s,
both on the command line and by GUI.

In AUR there is silent blades fahmon, which provides a GUI with the
ability to watch multiple clients and get info on the work-unit itself.
Fahmon has a dedicated site at http://www.fahmon.net/

On the CLI, you can add a command to your .bashrc , .zshrc or
.whateverrc :

    fahstat() {
    	echo
    	echo `date`
    	echo
    	cat /opt/fah/FAH_USER/unitinfo.txt   #(replacing FAH_USER first)
    }

Or for multiple clients :

    fahstat() {
            echo
            echo `date`
            echo
            echo "Core 1:";cat /opt/fah/FAH_USER/unitinfo.txt      #(replace FAH_USER first)
            echo
            echo "Core 2:";cat /opt/fah2/FAH_USER/unitinfo.txt     #(replace FAH_USER first)
    }

Also, replacing cat with tail -n1 will give just the percentage of work
unit complete.

On foldingathome-smp 6.43, the unitinfo.txt file is not placed inside
the user folder. The correct directory would be
/opt/fah-smp/unitinfo.txt.

External Resources
------------------

-   Folding@home Site
-   Folding@home FAQ
-   Folding@home Configuration FAQ
-   SMP Client in the AUR
-   Folding@home SMP Client FAQ
-   Arch Folding@home team page
-   Extended Arch team statistics in extremeoverclocking.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Folding@home&oldid=245013"

Category:

-   Mathematics and science
