Lotus Notes in 32bit Chroot
===========================

IBM Lotus Notes does not have a native 64bit package to date. This
article will discuss the installation of Lotus Notes on 64 bit Arch
Linux inside a 32bit chroot environment. This method will use the rpm
versions of the Notes packages; .deb files are available but the author
has not tried them.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Obtaining Lotus Notes and FixPacks                                 |
|     -   2.1 Obtaining Lotus Notes                                        |
|     -   2.2 Downloading FixPacks                                         |
|                                                                          |
| -   3 Create 32bit Chroot (x86_64)                                       |
|     -   3.1 Important steps to remember                                  |
|                                                                          |
| -   4 Installing Dependencies                                            |
| -   5 Installing Lotus Notes                                             |
|     -   5.1 Creating a shortcut                                          |
|     -   5.2 Installing on a 32bit System                                 |
|     -   5.3 Additional Steps on 8.5[.1]                                  |
|     -   5.4 Troubleshooting                                              |
|                                                                          |
| -   6 Post Install                                                       |
+--------------------------------------------------------------------------+

Introduction
------------

Lotus Notes is an email, calendaring, todo, notetaking, and
collaboration application developed by IBM. It is used most commonly in
corporate settings as it contains fairly powerful features that surpass
those offered by more traditional email/calendar applications like
Outlook or Thunderbird. Specifically, Lotus Notes features database
functionality that allows for the storage of user input from various
forms (e.g. surveys). While the email and scheduling functionality is
quite similar to that of other applications in this family, the database
functionality is difficult to understand without firsthand use.

For those who use Linux in a corporate setting in which Lotus Notes is
the default client, installation of this application is a necessity.
While this is trivial on 32bit systems (such as Arch 686), Lotus Notes
has not yet been released for 64bit Linux. As this is the case, those
using Arch64 will need to install Notes inside a 32bit chroot. It may be
possible to use a multi-lib setup, but the author of this article has no
experience with that method and from his reading considers the chroot
environment to be cleaner and simpler (easier to start over or remove
altogether if functionality is no longer needed).

Obtaining Lotus Notes and FixPacks
----------------------------------

You will at least need a Lotus Notes rpm package. The FixPacks that IBM
releases are also recommended. The main author of this entry has
experience with Notes 8.0 and 8.5[.1 and .2] on 64bit Arch.

Note: The IBM site can be confusing. For almost all downloads, multiple
languages, versions, and OS choices are available. Make sure you
download files with the following characteristics:

-   For Lotus Notes Client and not for Domino. Notes is the
    email/calendar client; Domino is the server application
-   For Linux (obvious) for rpm install (not deb)

> Obtaining Lotus Notes

-   If you have a corporate ID with IBM, you may use the IBM Lotus Notes
    site for official download
-   Optionally, visit the IBM Lotus Notes Trials site for free trial
    versions that expire after 90 days
-   You may also contact your company administrator for a copy of Lotus
    Notes for Linux

The trials provided change frequently. For example, as of 10-21-2010,
trials of both 8.5 and 8.5.2 were available. As of 03-07-2011, only
8.5.2 is available. Check the Lotus Notes trials page frequently:

> Downloading FixPacks

-   Visit the IBM Fix Central site to find FixPacks
-   Input Product Group=Lotus, Product=Lotus Notes, the version you
    have, and Platform=Linux for the four fields
-   At the next page click Continue at the bottom of the page to see all
    possible FixPacks
-   Download the correct one

If you are using Lotus Notes 8.5.1, there is a dedicated page for
incremental FixPack installers. There are currently 5 FixPacks released
(as of 03-07-20110. Just download Notes_851FP5_Standard_RPMInstall_Linux
(5th FixPack, rpm format for Linux) since each FixPack encompasses the
previous versions. The page for the 8.5.2 fixpack is here.

Create 32bit Chroot (x86_64)
----------------------------

If using i686, skip to #Installing Dependencies

The Arch Wiki already has a fantastic article on creating a 32bit chroot
environment on a 64bit system: Install_bundled_32-bit_system_in_Arch64.
Use the instructions there to do the following:

-   Create /opt/arch32, setup pacamn, and sync
-   Install base and base-devel
-   Create the arch32 daemon script
-   Link/copy the necessary files in /etc from the 64bit system to the
    chroot
-   Start the daemon

> Important steps to remember

Having been through this process many, many times, there are some steps
that are quite common to forget. Please remember to:

-   run the xhost command after starting the daemon:

     xhost +SI:localuser:usernametogiveaccesstogoeshere

-   chroot into /opt/arch32 with:

     # linux32 chroot /opt/arch32

-   edit your /etc/pacman.conf (from the chroot; the actual location is
    /opt/arch32/etc/pacman.conf)
    -   uncomment at least one mirror
    -   also, edit the line at the top of /etc/pacman.conf from:

     Architecture = auto

to:

     Architecture = i686

-   Be sure to uncomment a mirror in /etc/pacman.d/mirrorlist as well
-   sync pacman to ensure that everything is working properly:

     # pacman -Syy

-   lastly, run this to generate your locale files:

     # locale-gen

Installing Dependencies
-----------------------

IBM has published a list of System Requirements as well as a list of
Linux Packages that are required to run Lotus Notes. When attempting to
install an rpm on a non-rpm based distro, rpm will also complain about
missing packages if the --nodeps option is not provided. IBM's list and
the errors from an rpm attempt were used by the author of this article
(by repeatedly running 'pacman -Qo filename') to painstakingly generate
a minimum list of packages that would pull in all of the Lotus Notes
dependencies. The list below are the "top level" packages, and will pull
all the rest along with them. Run this from the chroot:

    # pacman -S gdb tcsh libart-lgpl alsa-lib atk libbonobo libbonoboui gconf gtk2 libgnome libgnomecanvas libgnomeprint \
    libgnomeprintui libgnomeui gvfs libice libjpeg orbit2 pango libpng libsm libx11 libxcursor libxext libxft libxi libxkbfile libxml2 \
    libxrender libxss libxt libxtst font-bh-ttf audiofile esound gnome-menus libgail-gnome startup-notification gnome-desktop \
    gtk-xfce-engine xterm

Note:xterm is only required to get through the license agreement. When
you run Notes for the first time, an xterm window will ask you to accept
the license agreement. Once you do this and setup your Lotus Notes
account, you can remove xterm if you wish.

Installing Lotus Notes
----------------------

While still in the chroot environment, do the following:

-   unpack the tar file you downloaded (fictional file name, use
    whatever you have):

     $ tar -xvf /path/to/ibm_lotus_notes-8.5.2.tar

This should unpack the following:

-   ibm_lotus_activities-8.5.2.i586.rpm
-   ibm_lotus_cae-8.5.2.i586.rpm
-   ibm_lotus_feedreader-8.5.2.i586.rpm
-   ibm_lotus_notes-8.5.2.i586.rpm
-   ibm_lotus_sametime-8.5.2.i586.rpm
-   ibm_lotus_symphony-8.5.2.i586.rpm
-   license.tar
-   pub_ibm_lotus_notes.gpg
-   smartupgrade.sh

Ensure that your archive package is accessible from within your 32-bit
chrooted environment. If you followed all the instructions in the
previous document about creating a 32-bit environment within arch,
particularly up to linking file/folders, a link to your home folder will
exist in the /opt/arch32 folder. If you downloaded lotus notes off of a
website in the 64-bit environment, there is a good chance it will exist
in your download folder within your home folder in the 32-bit
environment as well.

Now install the lotus notes RPM using the following command (Note: You
may need to have rpm-org installed from the AUR):

     # rpm -ivh --nodeps ibm_lotus_notes-8.5.2.i586.rpm

When that completes, you may install any fixpacks with:

     # rpm --ivh --nodeps ibm_lotus_notes_fixpack-8.5.2.i586.rpm

Now run Lotus Notes for the first time with:

     $ /opt/ibm/lotus/notes/notes

Note: To run the above command, you must not be root. If you installed
as root, switch back to your user account with:

     # su username

A splash screen should appear, shortly followed by an xterm window
asking you to accept the license agreement. Type "1" (the digit, one)
and then press enter. Lotus Notes should prompt its configuration screen
and ask you for your name, server, user.id file, etc. When this
completes, it will bring you to the Lotus Notes interface and you can
revel in your accomplishment!

You can repeat the above process with any of the other RPM files
included in the bundle if you would like as well (sametime, symphony,
cae, activities, etc.). Perhaps archive the original tar file somewhere
in case you need it again, and then delete the unpacked files you do not
need/want.

> Creating a shortcut

Now it is not unlikely that you will quickly get tired of monotonously
using chroot and entering a long path every time you want to start
notes. Fortunately, creating a seamless shortcut in your 64-bit
environment is easy.

If you installed schroot, as mentioned in the article about creating a
32-bit environment within arch, you can place an extensionless shell
script titled 'notes' into /usr/bin containing the following:

     schroot -- /opt/ibm/lotus/notes/notes

Ensure that you are listed as one of the users who can use schroot at
the bottom of the /etc/schroot/schroot.conf file by uncommenting and
adding your username to the 'Users' segment.

You should now be able to start notes by typing 'notes' and hitting
enter in the terminal.

> Installing on a 32bit System

I'm not sure why this is even covered because it's so simple, but just
to have a mention of this somewhere in the Arch Wiki, just follow the
procedure above for installation of the rpms. The additional reference
this should provide is a list of required packages above, which I have
not seen elsewhere. Hopefully this helps. The next section on
troubleshooting should help as well.

> Additional Steps on 8.5[.1]

If you are running 8.5 or 8.5.1, you may need to replace some libraries.
This was mentioned several times in the IBM Developer forums in Ubuntu
how-tos. One site that references it, along with two sources for these
libraries is here

> Troubleshooting

-   Notes on Gnome 3 Compatibility: Recently, gtk and Gnome related
    libraries underwent a transition to version 3. This caused a severe
    breakage in Lotus Notes. Reverting to gtk2/Gnome 2 libraries fixed
    things temporarily. A post was made to the IBM Notes community which
    suggested the fix presented on this blog. In summary, the fix
    suggests the following:
    -   Download tar.gz from
        https://github.com/sgh/lotus-notes_gtk2.23.3 and extract
    -   Edit the Makefile, inserting -m32 so that it reads: "gcc -Wall
        -Wextra -m32 `pkg-config..."
    -   Compile by running "make"
    -   Copy both libnotesgtkfix.so and notes-wrapper to
        /opt/ibm/lotus/notes/
    -   From now on, to start Lotus Notes, run
        /opt/ibm/lotus/notes/notes-wrapper (instead of
        /opt/ibm/lotus/notes/notes, as before)

-   Recently on a fresh install of Arch and a fresh chroot, I could not
    get Lotus Notes even put up the xterm window for license acceptance,
    and in looking at the logs in ~/lotus/notes/data/workspace/logs
    noticed the error-log was complaining about the file in
    /opt/ibm/lotus/notes/framework/rcp/plugin_customization.ini. The
    error was about proper permissions. I chmodded did the following:

     # chmod 755 /opt/ibm/lotus/notes/framework/rcp/plugin_customization.ini
     # chown username:users /opt/ibm/lotus/notes/framework/rcp/plugin_customization.ini

-   Typically, after the license agreement step, Lotus Notes immediately
    brings up the configuration setup process. The last time I installed
    8.5.2 from a scratch system/chroot, however, this was not happening.
    I got a license agreement page but nothing else. In looking at the
    output of top, the notes2 process would just vanish. In a fluke
    attempt, I just ran /opt/ibm/lotues/notes again... and it went right
    to the configuration process. I had several additional packages
    installed, but wiped out ~/lotus, removed them all, and re-tried and
    can reproduce the behavior. If you got a license agreement but
    nothing more, perhaps try to run Notes again.

-   In my last fresh install, I had issues using rpm on the 8.5.2
    fixpack as well as with trying to remove Lotus Notes 8.5.2 (not that
    you'd want to, but I wanted to know why the fixpack was not
    working). I received errors like this for the fixpack:

     %pre scriptlet failed error status: 85

and when trying to remove Lotus Notes with 'rpm -ev --nodeps pkd' I got:

     glibc detected **Double Linked List**

For some reason, using the aur package rpm-org worked perfectly for both
installation and trial removal of Lotus Notes 8.5.2, and installation of
the 8.5.2 fixpack. While perhaps not the "best" method, to clean up
everything after uninstalling rpm and installing rpm-org, I ran (from
the chroot):

     # pacman -Rsc rpm
     # rm -r /var/lib/rpm
     # rm -r /opt/ibm

Then I proceeded to install rpm-org with yaourt and repeated the steps
above to install Lotus Notes and the fixpack.

Post Install
------------

-   Fonts: As included above in the dependencies list, make sure you
    have the font-bh-ttf package installed. One user has reported that
    this was still producing ugly fonts. He has since confirmed that
    installing the ttf-ms-fonts package fixed this issue.
-   Theme/Icons: Your default icons and theme may not look right. Copy
    over your applicable folders from /usr/share/themes and
    /usr/share/icons and configure your chroot environment with those
    same themes/icons. I have noticed that even if Notes uses my proper
    cursor icon, it changes to an ugly basic one on certain
    links/buttons and am not sure how to fix this.
-   Mail Preview Pane Glitch: In either 8.5 or 8.5.1, I had issues with
    the mail preview pane locking up or creating multiple adjustment
    bars. I believe setting the option "Disable embedded browser for
    MIME email" was what fixed this issue.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lotus_Notes_in_32bit_Chroot&oldid=206895"

Categories:

-   Arch64
-   Email Client
-   Internet Applications
