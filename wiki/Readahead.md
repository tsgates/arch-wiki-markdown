Readahead
=========

Readahead is a tool that can prefetch files into system memory before
being needed. Readahead-list is a profiling tool that helps you build a
list of applications while your system loads. This list can then be used
by readahead to help you accelerate program loading.

This wiki page describes using Readahead in two parts: 1) Bootup - all
the files/daemons, etc. that load during your system's boot process. 2)
Desktop - all the files that get called when you log into your desktop
(gdm, kdm, etc.).

Note:Systemd comes with its own readahead implementation. See
Systemd#Readahead.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Credit Where Credit is Due                                         |
| -   2 Using Readahead on Arch Linux                                      |
|     -   2.1 Installing Readahead                                         |
|     -   2.2 Profiling Your System                                        |
|         -   2.2.1 The Boot Process                                       |
|         -   2.2.2 The Desktop Process                                    |
|                                                                          |
|     -   2.3 Enabling Readahead on Your Profiled System                   |
|     -   2.4 Periodically Update Your Boot and Desktop Profiles           |
|                                                                          |
| -   3 User Experiences with Readahead                                    |
|     -   3.1 Comment 1                                                    |
|                                                                          |
| -   4 Copy of Peterw's Blog Entry on Readahead                           |
+--------------------------------------------------------------------------+

Credit Where Credit is Due
--------------------------

This entire wiki page is based on and uses content from Peterw’s blog
wherein he has made an excellent guide for readahead on archlinux. Find
his original blog posting here: Install readahead-list on ArchLinux

In case his blog goes down, a copy of it has been included at the end of
this wiki page.

Note that you do not need to run Readahead in both modes if you do not
want to do so.

Using Readahead on Arch Linux
-----------------------------

> Installing Readahead

There is a nice package in the AUR based on Peterw's instructions -
readahead-list.

> Profiling Your System

The Boot Process

Following the instructions in Peterw's blog, first bang-out the display
manager (DM) daemon in your daemons array (eg: gdm or kde or whatever
you're using). In my example, it is gdm:

    DAEMONS=(preload syslog-ng network netfs @crond @alsa @hal @fam @powernowd cupsd !gdm)

Now edit your /etc/rc.sysinit adding the following lines to profile your
system's boot process between the top and the part that starts with ".
/etc/rc.conf" like this:

    #!/bin/bash
    #
    # /etc/rc.sysinit
    #

    # uncomment the next three lines to profile the boot process
    # be sure you disable gdm from starting before you reboot
    # add a bang character to gdm in the daemons array in rc.conf

    echo "starting readahead-watch..."
    /usr/sbin/readahead-watch -o /etc/readahead/boot
    echo "readahead is watching..."

    . /etc/rc.conf
    . /etc/rc.d/functions

Now reboot your machine and allow the boot profiling to take place. It
should take extra time (1-2 min is normal). When the system does finally
displays your text login screen (remember you disabled your DM), login
as root and manually kill readahead # pkill readahead.

This just generated your boot profile located in /etc/readahead/boot

Now comment out the lines in your /etc/rc.sysinit to prevent the
profiling again:

    # echo "starting readahead-watch..."
    # /usr/sbin/readahead-watch -o /etc/readahead/boot
    # echo "readahead is watching..."

Remove the bang from your DM in your daemons array in /etc/rc.conf

    DAEMONS=(preload syslog-ng network netfs @crond @alsa @hal @fam @powernowd cupsd gdm)

The Desktop Process

Just as you did profiling the boot process, you will now profile the
desktop process. First add the the daemon readahead-watch-desktop to
your daemons array in /etc/rc.conf. Place it before your WM (gdm in my
case) like this:

    DAEMONS=(preload syslog-ng network netfs @crond @alsa @hal @fam @powernowd cupsd readahead-watch-desktop gdm)

Now reboot your system again and login via graphical login. It is
recommended that you launch whatever programs you want included in the
profile such as your web browser, email program, whatever you use on a
regular basis. When you are ready to stop the profiling process, either
open a shell (remember this action will also be included in the desktop
profile) or if you do not want the shell getting profiled for some
reason, drop into another tty (Ctrl+Alt+F3 for example), login there and
again kill readahead as you have done with the boot profiling:
# pkill readahead.

This generated your desktop profile located in /etc/readahead/desktop

> Enabling Readahead on Your Profiled System

Now that you have generated both the /etc/readahead/boot and
/etc/readahead/desktop it's time to activate them. The easiest place to
start readahead for your boot process is again in the /etc/rc.sysinit
file. Add a line to it below the ones you commented out for the
profiling process like this (new lines are shown in bold text):

    #!/bin/bash
    #
    # /etc/rc.sysinit
    #

    # uncomment the next threee lines to profile the boot process
    # be sure you disable gdm from starting before you reboot
    # add a bang character to gdm in the daemons array in rc.conf

    # echo "starting readahead-watch..."
    # /usr/sbin/readahead-watch -o /etc/readahead/boot
    # echo "readahead is watching..."

    # this starts readahead with your boot profile
    /usr/sbin/readahead-list /etc/readahead/boot

    . /etc/rc.conf
    . /etc/rc.d/functions

Now add the readahead-list-desktop daemon to your daemons array BEFORE
THE GRAPHICAL STARTUP (gdm in my case) in /etc/rc.conf it is recommended
that you background it (prefix it with an @ symbol):

    DAEMONS=(preload syslog-ng network netfs @crond @alsa @hal @fam @powernowd cupsd @readahead-list-desktop gdm)

Now you can reboot and enjoy readahead!

> Periodically Update Your Boot and Desktop Profiles

If you make major changes to your boot or desktop processes, repeat the
above profiling steps to keep them current in readahead's lists. You get
the idea.

User Experiences with Readahead
-------------------------------

Please post your experiences with readahead in this section. Include
some hardware specs to give others an idea what kind of system is being
used.

Comment 1

I installed readhead via the package mentioned above in the AUR and
followed the instructions for profiling my system from Peter's blog.
Here is a summary of the results; times were measured using bootchart:

    Before doing anything: 26 sec
    Using only the boot profile: 25 sec
    Using only the desktop profile: 20 sec
    Using both the boot and desktop profile: 27 sec

Hardware specs: X3360 @ 3.40 GHz, 8 gigs of DDR2 @ 1,000 MHz, HDDs are
both Seagate SATA-II 640 gig 7200.11 series.

Make sure both your readahead-list* processes have been backgrounded
with the @ symbol in rc.conf. No need for these to be in sequence. Also,
it adds a second on to my laptops boot time as well, but there is a
tradeoff. Archlinux is already a pretty lean OS, so this is probably the
wrong way to further optimize, and bootchart stops recording once the
bootup sequence has stopped. It doesn't take into account other metrics,
like time-to-firefox. That extra second I've added makes the whole
desktop startup quickly, and improves the feel of speed if not the
actual speed. --Peterw 12:41, 30 January 2011 (EST)

Copy of Peterw's Blog Entry on Readahead
----------------------------------------

Again, you can read Peterw's Blog from its [native URL] but for
posterity's sake, I have taken the liberty of pasting it below in case
his server goes down or whatever.

Install readahead-list on ArchLinux

According to freshmeat:

"Readahead-list allows users to load files into the page cache before
they are needed, to accelerate program loading. It improves on the
existing readahead by taking the name of a file with the items to load,
instead of requiring the arguments being passed as parameters.
Additionally, it contains a tool (filelist-order) to optimize the order
of the file list in several possible ways."

I am picking the source file from ubuntu/debian because it also includes
a tool to “record filesystem events” and generate the list of files to
load. Grab the source and the diff here from launchpad

extract it:

    gzip -d readahead-list*.diff.gz
    tar -xzf readahead-list*.tar.gz

patch it:

    patch -p1 < readahead-list*.diff
    cd readahead-list*/

Be sure to apply all the patches in the patches directory:

    patch -p1 < ../debian/patches/05*
    patch -p1 < ../debian/patches/10*
    patch -p1 < ../debian/patches/50*
    patch -p1 < ../debian/patches/51*

compile:

    #please choose the appropriate prefix:
    ./configure --prefix=/usr
    make
    #(as root)
    make install

Hopefully everything is compiled. There might be some error messages,
but as long as the process did not error out, everything should be ok.

Now for the system setup. The way I think it ought to go is record the
startup in two parts, the boot, and the desktop. The boot part will
record and load all files related to general startup. The desktop part
will load everything from after the system startup (including graphical
login manager) to when the default session type is loaded (i.e. kde
desktop). The following files and directories need to be created:

    #technically, this contents might make this directory better place in /var but /etc will do
    mkdir /etc/readahead
    touch /etc/readahead/boot
    touch /etc/readahead/desktop
    #the following can be duplicated for each section, if you want it handled by rc
    touch /etc/rc.d/readahead-list-desktop
    touch /etc/rc.d/readahead-watch-desktop

To record the first part, we need to stop the graphical login manager
from loading, so we login via the command line interface. This is done
by editing the DAEMONS section of /etc/rc.conf by adding an ! before
kdm, or gdm, etc. Then we need to start the record as early as we can in
the boot process. This is technically done by creating a script, and
then using the init= parameter on the kernel line of grub. For this
tutorial, we will put the lines of code in /etc/rc.sysint. Insert some
lines to make the top of the file look like this:

    #!/bin/bash
    #
    # /etc/rc.sysinit
    #

    echo "starting readahead-watch..."
    /usr/sbin/readahead-watch -o /etc/readahead/boot
    echo "readahead is watching..."

    #echo "reading files..."
    #/usr/sbin/readahead-list /etc/readahead/boot &

    . /etc/rc.conf
    . /etc/rc.d/functions

Line 7 is the import one above. This will record all files loaded after
the command is run, on any device and save the list to the specified
file. After you login, to kill the process run:

    ps ax | grep readahead
    #as root
    kill $PID

The boot section has now been recorded. Now the files /etc/rc.d/ will
look like:

    #!/bin/bash
    #readahead-watch-desktop
    /usr/sbin/readahead-watch -o /etc/readahead/desktop

    #!/bin/bash
    #readahead-list-desktop
    /usr/sbin/readahead-list /etc/readahead/desktop

With these files in place, edit the daemon section in the rc.conf to
include readahead-watch-desktop before the login manager, and do NOT
background it. Reboot the computer, and kill the process in the same was
as before after you have logged in (Note: this will record a terminal
instance in the file. You can avoid this by hitting something like
ALT-F6 to login textually). After you have stopped the recording, edit
the daemons section to instead start readahead-list-desktop.

Here are my results.

The results are kind of dismal in the pure timing end, as observable by
bootchart only two seconds shorter. But I have never seen my desktop
load faster! If I didn’t have the resource heavy services such as
klipper, guidance-power-manager or network-manager it would load in a
blink.

Play around with the placement of the readahead-list command, just make
sure you start a recording from the same place. This placement of the
rc.d file is kind of cheating, because it relies on the lag in response
time of the user login to load files in the background, but it still
makes a heck of a difference. Also, if you always start up firefox or
something when you login, record that too and it will start a little
faster.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Readahead&oldid=240515"

Category:

-   Boot process
