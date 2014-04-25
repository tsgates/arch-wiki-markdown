Dropbox
=======

Related articles

-   Backup Programs

Dropbox is a file sharing system that recently introduced a GNU/Linux
client. Use it to transparently sync files across computers and
architectures. Simply drop files into your ~/Dropbox folder, and they
will automatically sync to your centralized repository.

Contents
--------

-   1 Installation
    -   1.1 Optional packages
    -   1.2 Automatically starting Dropbox
-   2 Alternative to install: use the web interface
-   3 Run as daemon with systemd
    -   3.1 Run as a daemon with systemd user
-   4 Securing your Dropbox
    -   4.1 Setup EncFS with Dropbox
-   5 Multiple Dropbox instances
-   6 Dropbox on laptops
    -   6.1 Using netctl
    -   6.2 Using NetworkManager
    -   6.3 Using wicd
-   7 Troubleshooting
    -   7.1 Dropbox keeps saying Downloading files
    -   7.2 Change the Dropbox location from the installation wizard
    -   7.3 Context menu entries in file manager do not work
    -   7.4 Connecting...
    -   7.5 Dropbox does not start - "This is usually because of a
        permission error"
        -   7.5.1 Check permissions
        -   7.5.2 Re-linking your account
        -   7.5.3 Errors caused by running out of space
        -   7.5.4 Locale caused errors
        -   7.5.5 Filesystem monitoring problem
    -   7.6 Proxy settings
-   8 Troubleshooting
    -   8.1 Hack to stop Auto Update

Installation
------------

dropbox can be installed from the AUR. Alternatively,
dropbox-experimental is also available.

1.  After installing the package, you can start Dropbox from your
    application menu or run dropboxd from the command-line. The client
    icon will appear in the system tray.
2.  A pop-up will notify you that Dropbox is running from an unsupported
    location. Click on Don't ask again since you know that you have
    installed it from AUR rather than from the official homepage.
3.  Eventually a pop-up will ask you to log in to your Dropbox account
    or create a new account. Enter your credentials.
4.  After some time you will see a "Welcome to Dropbox" pop-up, which
    will give you the opportunity to view a short tour of Dropbox.
5.  Press the "Finish and go to My Dropbox".

For KDE users, no further steps are required (it is enough to install
the above dropbox package from the AUR), as KDE saves running
applications when logging out and restarts them automatically. Similarly
for Xfce users, dropbox will be restarted automatically next time you
login since the dropbox.desktop file be placed in ~/.config/autostart.

> Optional packages

-   For a command-line interface, install dropbox-cli from the AUR.
-   For integration with Nautilus, install nautilus-dropbox from the
    AUR. The Nautilus plugin will start Dropbox automatically.
-   For integration with Nemo, install nemo-dropbox-git from the AUR.
-   For integration with Thunar, install thunar-dropbox from the AUR.
-   For KDE users, there is a KDE client available: kfilebox from the
    AUR.

> Automatically starting Dropbox

Dropbox can be automatically started by adding dropboxd to ~/.xinitrc
(or ~/.config/openbox/autostart, depending on your setup).
Alternatively, you can start it as a daemon.

Alternative to install: use the web interface
---------------------------------------------

If all you need is basic access to the files in your Dropbox, you can
use the web interface at https://www.dropbox.com/ to upload and download
files to your Dropbox. This can be a viable alternative to running a
Dropbox daemon and mirroring all the files on your own machine.

Run as daemon with systemd
--------------------------

Recent versions of Dropbox come with a systemd service file. By default
running Dropbox as a daemon does not give you an icon in the system
tray, but syncs your files and folders in the background. If you want to
have tray support, create /etc/systemd/system/dropbox@.service to
override the provided service file and specify the environment variable
DISPLAY:

    /etc/systemd/system/dropbox@.service

    .include /usr/lib/systemd/system/dropbox@.service
    [Service]
    Environment=DISPLAY=:0

Finally, to enable the daemon for your user, so that it will start at
login:

    # systemctl enable dropbox@<user>

Note that you have to manually start Dropbox the first time after
installation, so that it runs through the login and setup screen.
Further, you need to uncheck the option Start Dropbox on system startup
in order to prevent Dropbox from being started twice. The daemon can
then be used subsequently.

> Run as a daemon with systemd user

If you have followed the systemd/User wiki page, you probably want to
start dropbox only when you log in or launch your WM/DE. The solution in
that case is to create a service in your home directory instead of using
the sysadmin account:

    $HOME/.config/systemd/user/dropbox@.service

    [Unit]
    Description=Dropbox as a systemd service
    After=xorg.target

    [Service]
    ExecStart=/home/your_user/.dropbox-dist/dropbox
    ExecReload=/bin/kill -HUP $MAINPID
    Environment=DISPLAY=%i

    [Install]
    WantedBy=mystuff.target

They you can start or enable it with:

    $ systemctl --user {start|enable} dropbox@:0.service

That way you can easily start it in your main display (likely :0) or in
another one, without having to hard code it.

Note:After a lot of trial and error I found that using /usr/bin/dropboxd
didn't start the service and it didn't show any error either (even when
running it directly from the terminal worked fine). I believe it has to
do that starting it that way systemd doesn't know which user is actually
running the daemon.

Securing your Dropbox
---------------------

If you want to store sensitive data in your Dropbox, you should encrypt
it before. Syncing to Dropbox is encrypted, but all files are (for the
time being) stored on the server unencrypted just as you put them in
your Dropbox.

-   Dropbox works with TrueCrypt, and after you initially uploaded the
    TrueCrypt volume to Dropbox, performance is quite okay, because
    Dropbox has a working binary diff.

-   Another possibility is to use EncFS, which has the advantage that
    all files are encrypted separately, i.e. you do not have to
    determine in advance the size of the content you want to encrypt and
    your encrypted directory grows and shrinks while you
    add/delete/modify files in it. You can also mount an encrypted
    volume at startup using the -S option of encfs to avoid having to
    input the passphrase, but note that your encrypted files are not
    secure from someone who has direct access to your computer.

> Setup EncFS with Dropbox

Follow the Wiki instructions to install EncFS.

Assuming you have set your Dropbox directory as ~/Dropbox:

Create a folder. Files you want synced to Dropbox will go in here.

    $ mkdir ~/Private

Run the following and enter a password when asked:

    $ encfs ~/Dropbox/Encrypted ~/Private

Your secure folder is ready for use; creating any file inside ~/Private
will automatically encrypt it into ~/Dropbox/Encrypted, which will then
be synced to your cloud storage.

To mount your EncFS folder on every boot, follow the instructions in the
EncFS wiki page.

Tip:Consider using the ENCFS6_CONFIG variable and moving the .encfs6.xml
file to another location (like a USB stick), to help ensure that your
encrypted data and the means to realistically decrypt it do not exist
together online.

Multiple Dropbox instances
--------------------------

If you need to separate or distinguish your data, personal and work
usage for example, you can subscribe to Dropbox with different email
addresses and have multiple directories synced to different instances.

The basic principle and general how-to are described in the Dropbox
Wiki.

Note:When dealing with multiple instances you have to select the Dropbox
destination folder, which the Dropbox installer asks in the last step;
usage examples may be /home/dropbox-personal, /home/dropbox-work, and so
on.

For convenience, here is a script that I use to accomplish the task:
just add a dir in the "dropboxes" list to have another instance of
Dropbox, referring to the dir, loaded at script startup.

    #!/bin/bash

     #*******************************
     # Multiple dropbox instances
     #*******************************

     dropboxes=(.dropbox-personal .dropbox-work)
                                                                                                             
     for dropbox in ${dropboxes[@]}; do
         if ! [ -d $HOME/$dropbox ];then
             mkdir $HOME/$dropbox
         fi
         HOME=$HOME/$dropbox/ /opt/dropbox/dropbox start -i &
     done

Dropbox on laptops
------------------

Dropbox itself is pretty good at dealing with connectivity problems. If
you have a laptop and roam between different network environments,
Dropbox will have problems reconnecting if you do not restart it. Try
one of the methods described below first, if for some reason the problem
remains, you may try one of these hackish solutions: [1], [2].

Note:When using any of these methods, you need to prevent Dropbox from
doing a standard autostart by unchecking Dropbox - Preferences - General
- Start Dropbox on system startup. This prevents Dropbox from creating
the ~/.config/autostart/dropbox.desktop file and thus from starting
twice.

> Using netctl

For netctl, use ExecUpPost and ExecDownPre respectively in every network
profile you use, or for example in /etc/netctl/interfaces/wlan0 to start
Dropbox automatically whenever profile on wlan0 is active. Add '|| true'
to your command to make sure netctl will bring up your profile, although
Dropbox fails to start.

    ExecUpPost="any other code; su -c 'DISPLAY=:0 /usr/bin/dropboxd &' your_user || true"
    ExecDownPre="any other code; killall dropbox"

Obviously, your_user has to be edited and any other code; can be omitted
if you do not have any. The above will make sure that Dropbox is running
only if there is a network profile active.

> Using NetworkManager

If you have connectivity problem with NetworkManager, try using a
dispatcher script: networkmanager-dispatcher-dropbox or
networkmanager-dispatcher-dropbox-systemd.

> Using wicd

Create /etc/wicd/scripts/postconnect/dropbox:

    #!/usr/bin/env bash
    su -c 'DISPLAY=:0 /usr/bin/dbus-launch dropboxd &' your_username

or, if you use dropbox with systemd:

    #!/usr/bin/env bash
    systemctl restart dropbox@<user>

Create /etc/wicd/scripts/postdisconnect/dropbox:

    #!/usr/bin/env bash
    killall dropbox

or, if you use dropbox with systemd:

    #!/usr/bin/env bash
    systemctl stop dropbox@<user>

Note:If you use PCManFM as your file manager, Dropbox will use
'xdg-open' calls pcmanfm to open the Dropbox folder.However, without a
dbus session, you can not use Trash in PCManFM. You should refer to Dbus
and General Troubleshooting#Session permissionsto edit your ~/.xinitrc
based on /etc/skel/.xinitrc to start a D-Bus session before your launch
any other program in ~/.xinitrc. Do use 'dbus-launch dropboxd' instead
of just 'dropboxd' in wicd postconnect script. otherwise pcmanfm
launched by clicking dropbox icon can not use the Trash.

Troubleshooting
---------------

> Dropbox keeps saying Downloading files

But in fact now files are synced with your box. This problem is likely
to appear when your Dropbox folder is located on a NTFS partition whose
mount path contains spaces, or permissions are not set for that
partition. See more in the [forums]. To resolve the problem pay
attention to your entry in /etc/fstab. Avoid spaces in the mount path
and set write permissions with the "default_permissions" option:

    UUID=01CD2ABB65E17DE0 /run/media/username/Windows ntfs-3g uid=username,gid=users,default_permissions 0 0

> Change the Dropbox location from the installation wizard

Some users experience the problem during setting-up Dropbox that they
cannot select a Dropbox folder other than /home/username/Dropbox. In
this case when the window for changing the path is shown , hit Ctrl+l,
enter the location (e.g. /mnt/data/Dropbox) and click on the '"Choose"
or "Open" button.

> Context menu entries in file manager do not work

Several file managers such as Thunar, Nautilus or its fork Nemo come
with extensions that provide context menu entries for files and folders
inside your Dropbox. Most of them will result in a browser action such
as opening the file or folder in dropbox.com or sharing the link. If you
experience these entries not working, then it is likely you have not set
the $BROWSER variable which Dropbox requires. See Environment variables
for details.

> Connecting...

It may happen that Dropbox cannot connect successfully because it was
loaded before an internet connection was established. This can happen on
wireless connections, or fast loading machines on wired networks. The
best solution to this problem, for wired and wireless connections, is
#Dropbox on laptops which will ensure that Dropbox is started only after
the connection is established.

An alternative solution, for those not using netctl or NetworkManager,
is to delay the startup of dropbox:

-   cp ~/.config/autostart/dropbox.desktop ~/.config/autostart/dropbox-delayed.desktop
-   Prevent dropbox from doing a standard autostart by unchecking
    Dropbox - Preferences - General - Start Dropbox on system startup.
    This removes ~/.config/autostart/dropbox.desktop.
-   Edit ~/.config/autostart/dropbox-delayed.desktop and replace
    Exec=dropboxd with Exec=bash -c "sleep timeout && dropboxd". Tweak
    the timeout parameter, the value of 3 is a good start.

> Dropbox does not start - "This is usually because of a permission error"

Check permissions

Make sure that you own Dropbox's directories before running the
application. This includes

-   ~/.dropbox - Dropbox's configuration directory
-   ~/Dropbox - Dropbox's download directory (default)

You can ensure this by changing their owner with chown -R.

This error could also be caused by /var being full.

Re-linking your account

Dropbox's FAQ suggests that this error may be caused by misconfiguration
and is fixed by (re)moving the current configuration folder

    # mv ~/.dropbox ~/.dropbox.old

and restarting Dropbox.

Errors caused by running out of space

A common error that might happen is that there is no more available
space on your /tmp and /var partitions. If this happens, Dropbox will
crash on startup with the following error in its log:

    Exception: Not a valid FileCache file

A detailed story of such an occurrence can be found in the forums. Make
sure there is enough space available before launching Dropbox.

Another case is when the root partition is full:

    OperationalError: database or disk is full

Check to see the available space on partitions with df.

Locale caused errors

Try starting dropboxd with this code:

    LANG=$LOCALE
    dropboxd

(You can also use a different value for LANG; it must be in the format
"en_US.UTF-8") This helps when running from a Bash script or Bash shell
where /etc/rc.d/functions has been loaded

Filesystem monitoring problem

If you have a lot of files to sync in your Dropbox folder, you might get
the following error:

    Unable to monitor filesystem
    Please run: echo 100000 | sudo tee /proc/sys/fs/inotify/max_user_watches and restart Dropbox to correct the problem.

This can be fixed easily by adding

    fs.inotify.max_user_watches = 100000

to /etc/sysctl.d/99-sysctl.conf and then reload the kernel parameters

    # sysctl --system

> Proxy settings

The easiest way to set Dropbox's proxy settings is by defining them
manually in the Proxies tab of the Preferences window. Alternatively,
you can also set it to 'Auto-detect' and then export your proxy server
to the http_proxy env variable prior to starting Dropbox (HTTP_PROXY is
also usable)

    env http_proxy=http://your.proxy.here:port /usr/bin/dropboxd

or

    export http_proxy=http://your.proxy.here:port
    /usr/bin/dropboxd

Note:Dropbox will only use proxy settings of the form
http://your.proxy.here:port, not your.proxy.here:port as some other
applications do.

Troubleshooting
---------------

> Hack to stop Auto Update

    rm -rf ~/.dropbox-dist
    install -dm0 ~/.dropbox-dist

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dropbox&oldid=304590"

Category:

-   Internet applications

-   This page was last modified on 15 March 2014, at 10:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
