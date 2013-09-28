BOINC
=====

BOINC website: "Use the idle time on your computer (Windows, Mac, or
Linux) to cure diseases, study global warming, discover pulsars, and do
many other types of scientific research. It's safe, secure, and easy."

Wikipedia: "The Berkeley Open Infrastructure for Network Computing
(BOINC) is a non-commercial middleware system for volunteer and grid
computing. It was originally developed to support the SETI@home project
before it became useful as a platform for other distributed applications
in areas as diverse as mathematics, medicine, molecular biology,
climatology, and astrophysics. The intent of BOINC is to make it
possible for researchers to tap into the enormous processing power of
personal computers around the world."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Headless Servers                                             |
|                                                                          |
| -   2 Using BOINC                                                        |
|     -   2.1 BOINC via the GUI                                            |
|         -   2.1.1 Projects using GPU                                     |
|                                                                          |
| -   3 Log files                                                          |
| -   4 Considerations when choosing a project                             |
|     -   4.1 Running on Arch64                                            |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 GPU missing                                                  |
|     -   5.2 Laptop overheating and battery duration reduction            |
|     -   5.3 Unable to download with World Community Grid                 |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the package boinc from the Official Repositories.

The name of the daemon is boinc.service. Start it and configure to
autostart on boot. Read Daemons for details.

BOINC is installed as a daemon and for security reasons will be run
under the newly created boinc user. We will add ourself to the boinc
group and create a link to the password file so that we can manage it
via the GUI.

> Headless Servers

If you're planning to run BOINC on a headless server, and would like to
avoid installing wkWidgets and GTK for a GUI that you won't use anyway,
consider installing boinc-nogui from the AUR.

Using BOINC
-----------

> BOINC via the GUI

By default, a password is created in /var/lib/boinc/gui_rpc_auth.cfg for
connecting to the daemon. To simplify connection of the GUI to the
daemon, cd to your home directory, create a link to the file, and change
permissions to allow read access to boinc group members.

    $ cd ~/
    $ ln -s /var/lib/boinc/gui_rpc_auth.cfg gui_rpc_auth.cfg
    # chmod 640 gui_rpc_auth.cfg

If you prefer a different password, or none at all, you can edit
/var/lib/boinc/gui_rpc_auth.cfg. Then restart BOINC daemon.

If you do not like the idea of having this file in your home directory,
there is an alternative approach. BOINC Manager will also look for a
readable gui_rpc_auth.cfg file in the current working directory. If you
make the file readable by the boinc group and ensure that the manager is
run with /var/lib/boinc as the working directory, you should find that
the client connects to the daemon automatically, as desired. This can
usually be achieved via the menu editor in your desktop environment of
choice.

To start the GUI, use the boincmgr command

    $ boincmgr

BOINC should now take you through the process of attaching to a project.
NB, some projects will let you create an account remotely via the GUI
while some may require you to first create an account via their website.
You can attach to multiple projects if you have the resources (disk
space, time, CPU power). Do this via menu option Tools / Attach to
project.

If BOINC did not ask you to connect to a project, then make sure you are
connected to the daemon. Go to menu option Advanced / Select computer,
choose your machine's name and enter the password. (To avoid this, make
sure the above steps regarding gui_rpc_auth.cfg have been done.)

Projects using GPU

If you want to use your GPU, you need the proprietary nvidia or amd
drivers. For ATI/AMD Cards you also need Catalyst driver for stock
kernel which you can get from AUR. For Nvidia, you also need the package
opencl-nvidia located in extra.

In addition, the boinc user should be in the video group:

    # gpasswd -a boinc video

The boinc user also needs to have access to your X session. Use this
command to accomplish this:

    xhost local:boinc

You may want to add that to a startup script.

Log files
---------

NB, BOINC places log files in /var/lib/boinc/

    /var/lib/boinc/stderrdae.txt
    /var/lib/boinc/stdoutdae.txt

Considerations when choosing a project
--------------------------------------

Projects have different minimum hardware requirements (CPU, disk space),
and different times to taken to run each work unit. If you do not finish
a work unit before the deadline it will sent out to someone else, but it
is better to look around to see what projects suit your machine and your
uptime patterns to avoid this happening.

Also, if it is important to you, check if the project makes the data and
results publicly available.

> Running on Arch64

Some projects provide only 32bit applications which may require 32bit
libraries to run work units or show graphics. You will find most of
these libraries in the [multilib] repository.

To run WUs (e.g. Climateprediction) 
    lib32-glibc, lib32-glib2
To show graphics (e.g. Several projects of WCG, Climateprediction) 
    lib32-pango, lib32-libxdamage, lib32-libxi, lib32-libgl,
    lib32-libjpeg6 (AUR), and lib32-libxmu

Troubleshooting
---------------

> GPU missing

If you get this error :

    GPU Missing

and the Work Unit does not start, you should restart the boinc.service
daemon.

This will happen if the BOINC daemon starts before the an X session is
fully initialized.

> Laptop overheating and battery duration reduction

If you run BIONC on a laptop with the ondemand governor (the default),
it will keep the CPUs at their maximum frequencies (over)heating them
and decreasing battery duration. The best way to fix this is to tell the
ondemand to not rise the CPU frequencies for BIONC:

    # echo 1 >/sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load

To do this on boot, create the following tmpfiles.d config:

    /etc/tmpfiles.d/ondemand-ignore-nice.conf

    w /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load - - - - 1

> Unable to download with World Community Grid

If you're unable to download new work units for the World Community Grid
project, the problem comes from openssl, so we need to rebuild a package
with a small fix in it to allow downloads.

First, we're going to get the sources for openssl using git:

    $ git clone git://projects.archlinux.org/svntogit/packages.git --single-branch --branch packages/openssl

This will give you four files in ./packages/trunk/, including a
PKGBUILD. The PKGBUILD is not the right one, so we need to get the
correct one which you can get here.

Now we just have to create the package:

    $ makepkg 

This sould give you a file ending in *.pkg.tar.xz, all that's left is to
install it, and restart the boinc service:

    # pacman -U openssl-1.0.1.c-1-x86_64.pkg.tar.xz
    # systemctl restart boinc

Your new work units should now be able to download. If you have any
trouble, the original thread on the forum can be seen here.

See also
--------

-   BOINC homepage
-   List of BOINC projects
-   Wikipedia entry

Retrieved from
"https://wiki.archlinux.org/index.php?title=BOINC&oldid=247742"

Category:

-   Mathematics and science
