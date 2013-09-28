Dropbox
=======

Dropbox is a file sharing system that recently introduced a GNU/Linux
client. Use it to transparently sync files across computers and
architectures. Simply drop files into your ~/Dropbox folder, and they
will automatically sync to your centralized repository.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Optional packages                                            |
|     -   1.2 Automatically Starting Dropbox                               |
|                                                                          |
| -   2 Alternative to install: use the web interface                      |
| -   3 Run as daemon with systemd                                         |
|     -   3.1 Run as a daemon with systemd user                            |
|                                                                          |
| -   4 Without Nautilus (Another Way)                                     |
| -   5 Securing Your Dropbox                                              |
|     -   5.1 Setup EncFS With Dropbox                                     |
|                                                                          |
| -   6 Multiple Dropbox Instances                                         |
| -   7 Dropbox on Laptops                                                 |
| -   8 Known Issues                                                       |
|     -   8.1 Dropbox keeps saying Downloading files                       |
|     -   8.2 Change the Dropbox location from the installation wizard     |
|     -   8.3 Context menu entries in file manager do not work             |
|     -   8.4 Connecting...                                                |
|     -   8.5 Dropbox does not start - "This is usually because of a       |
|         permission error"                                                |
|         -   8.5.1 Check permissions                                      |
|         -   8.5.2 Re-linking your account                                |
|         -   8.5.3 Errors caused by running out of space                  |
|         -   8.5.4 Locale caused errors                                   |
|         -   8.5.5 Filesystem monitoring problem                          |
|                                                                          |
|     -   8.6 Proxy Settings                                               |
|                                                                          |
| -   9 Alternatives                                                       |
+--------------------------------------------------------------------------+

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

> Automatically Starting Dropbox

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
have tray support, then you have to copy the service file to
/etc/systemd/system/dropbox@.service and add the environment variable.

    # echo ".include /usr/lib/systemd/system/dropbox@.service
    [Service]
    Environment=DISPLAY=:0" > /etc/systemd/system/dropbox@.service

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

They you can start/enable it with:

    systemctl --user {start|enable} dropbox@:0.service

That way you can easily start it in your main display (likely :0) or in
another one, without having to hard code it.

Note:After a lot of trial and error I found that using /usr/bin/dropboxd
didn't start the service and it didn't show any error either (even when
running it directly from the terminal worked fine). I believe it has to
do that starting it that way systemd doesn't know which user is actually
running the daemon.

Without Nautilus (Another Way)
------------------------------

Another way to use Dropbox without Nautilus but with another file
manager like Thunar or Pcmanfm is described below:

1. Create a fake Nautilus script that will launch Thunar:

    $ sudo touch /usr/bin/nautilus && sudo chmod +x /usr/bin/nautilus && sudo nano /usr/bin/nautilus

2. Insert this text into the file, then save and exit:

    #!/bin/bash
    exec thunar $2
    exit 0

3. Launch Dropbox

    $ dropboxd

4. Click on the Dropbox tray icon to open your Dropbox folder in Thunar.

Note:In this way there is no need to create a Dropbox daemon in
/etc/rc.d/ and to start it at boot via /etc/rc.conf or to make it start
via your session manager: just leave the "Start Dropbox on system
startup" option flagged in the Preferences window.

Note:If you already have Nautilus installed but do not want to use it,
don't modify the existing file under /usr/bin, just change the /usr/bin
for /opt/dropbox in the step 2 above, like this:
$ sudo touch /opt/dropbox/nautilus && sudo chmod +x /opt/dropbox/nautilus && sudo nano /opt/dropbox/nautilus.
Dropbox will look in this path first!

Securing Your Dropbox
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

> Setup EncFS With Dropbox

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
EncFS wiki here:
https://wiki.archlinux.org/index.php/EncFS#User_friendly_mounting

Multiple Dropbox Instances
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
                                                                                                             
     for dropbox in ${dropboxes[@]}                                                                          
     do                                                                                                      
         if ! [ -d $HOME/$dropbox ];then                                                                     
             mkdir $HOME/$dropbox                                                                            
         fi                                                                                                  
         HOME=$HOME/$dropbox/ /usr/bin/dropbox start -i                                                      
     done   

Dropbox on Laptops
------------------

Dropbox itself is pretty good at dealing with connectivity problems. If
you have a laptop and roam between different network environments,
Dropbox will have problems reconnecting if you do not restart it. The
easiest way to solve this with netcfg is to use POST_UP and PRE_DOWN.

In every network profile you use (or in the
Netcfg#Per-interface_configuration), add the appropriate commands:

    POST_UP="any other code; su -c 'DISPLAY=:0 /usr/bin/dropboxd &' your_user"
    PRE_DOWN="any other code; killall dropbox"

For netctl, use ExecUpPost and ExecDownPre respectively. Add '|| true'
to your command to make sure netctl will bring up your profile, although
Dropbox fails to start.

    ExecUpPost="any other code; su -c 'DISPLAY=:0 /usr/bin/dropboxd &' your_user || true"
    ExecDownPre="any other code; killall dropbox"

Obviously, your_user has to be edited and 'any other code;' can be
omitted if you do not have any. The above will make sure that Dropbox is
running only if there is a network profile active.

If you have connectivity problem with NetworkManager, this thread on
forum should be useful.

Known Issues
------------

> Dropbox keeps saying Downloading files

But in fact now files are synced with your box. This problem is likely
to appear when your Dropbox folder is located on a NTFS partition whose
mount path contains spaces. See more in the [forums]. To resolve the
problem pay attention to your entry in /etc/fstab. Avoid spaces in the
mount path and set write permissions:

    UUID=01CD2ABB65E17DE0 /run/media/username/Windows ntfs-3g uid=username,gid=users 0 0

> Change the Dropbox location from the installation wizard

Some users experience the problem during setting-up Dropbox that they
cannot select a Dropbox folder other than /home/username/Dropbox. In
this case when the window for changing the path is shown , hit CTRL+L,
enter the location (e.g. /mnt/data/Dropbox) and click on the 'Choose' or
'Open' button.

> Context menu entries in file manager do not work

Several file managers such as Thunar, Nautilus or its fork Nemo come
with extensions that provide context menu entries for files and folders
inside your Dropbox. Most of them will result in a browser action such
as opening the file or folder in dropbox.com or sharing the link. If you
experience these entries to not working, then you are likely to have not
set the $BROWSER variable which Dropbox requires. You can check that by

    echo $BROWSER

To set your $BROWSER variable open ~/.profile and replace chromium with
your default browser:

    if [ -n "$DISPLAY" ]; then
         BROWSER=chromium
    fi

> Connecting...

Note:It seems that this issue has been fixed in later versions of
dropbox (sometime before 1.6.0-2). It might be reasonable to test before
installing one of the following scripts

It may happen that Dropbox cannot connect successfully because it was
loaded before an Internet connection was established. To solve the
problem the content of the file /opt/dropbox/dropboxd needs to be
replaced with the following:

  

    #!/bin/sh

    # Copyright 2008 Evenflow, Inc., 2010 Dropbox
    #
    # Environment script for the dropbox executable.

    start_dropbox() {
    PAR=$(dirname $(readlink -f $0))
    OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
    LD_LIBRARY_PATH=$PAR:$LD_LIBRARY_PATH 

    TMP1=`ps ax|grep dropbox|grep -v grep`
    if [ -n "$TMP1" ]; then
      kill -9 $(pidof dropbox) >/dev/null 2>&1
    fi
    exec $PAR/dropbox $@ &
    }

    do_dropbox() {
    start_dropbox >/dev/null 2>&1
    while [ 1 ]; do
      sleep 5
      ERROR="$(net_test)"
      if [ -n "$ERROR" ]; then
        LAST_ERROR=1
      else
        if [ -n "$LAST_ERROR" ]; then
          # Connection seems to be up but last cycle was down
          LAST_ERROR=""
          start_dropbox >/dev/null 2>&1
        fi
      fi
    done

    }

    net_test() {
    TMP1="$(ip addr |grep "inet " |grep -v "127.0.0.1")"
    [ -z "$TMP1" ] && echo "error"
    }

    do_dropbox

Following is an alternative script that will check for an actual
Internet connection by using curl to check if any entry in a list of
hosts and IP addresses is available. If none of the specified hosts are
available, the script will wait and try again (albeit not forever). The
way the script increments the waiting time is quite messy, but the logic
goes like this:

Start with a wait time of 5 seconds.

Multiply by 1.5.

Do this as long as the wait time is less than 1500 seconds (25 minutes),
and the check_net() function returns non-zero values (failure).

    #!/bin/bash

    # Copyright 2008 Evenflow, Inc., 2010 Dropbox
    #
    # Environment script for the dropbox executable.

    WAIT_TIME=5 #initial time to wait between checking the internet connection
    #HOSTS="www.google.com www.wikipedia.org 8.8.8.8 208.67.222.222"
    HOSTS="www.google.com www.wikipedia.org "

    PAR=$(dirname $(readlink -f $0))
    OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
    LD_LIBRARY_PATH=$PAR${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH

    #non-zero exit code iff none of the hosts could be reached
    check_net() {
            local ret=1
            for i in $HOSTS; do
                    #ping -w2 -c2 $i > /dev/null 2>&1 && ret=0 && break
                    curl -o /dev/null $i > /dev/null 2>&1 && ret=0 && break
            done
            echo $ret
    }

    #if dropbox is running; kill it. Then start dropbox
    start_dropbox() {
    local tmp=`ps ax|grep -E "[0-9] $PAR/dropbox"|grep -v grep`
            if [ -n "$tmp" ]; then
                    kill -9 $(pidof dropbox) > /dev/null 2>&1
            fi
            exec $PAR/dropbox $@ > /dev/null 2>&1 &
    }

    #loop over: start dropbox iff check_net returns 0
    #loop (and with it, the entire script) terminates when dropbox has been restarted,
    #+ or the waiting time has exeeded 1500 seconds (it grows 50% with each iteration of the loop)
    attempt_startup() {
            while [ $WAIT_TIME -lt 1500  ] ; do
                    if [ $(check_net) -eq 0 ]; then
                            start_dropbox
                            exit
                    fi
                    sleep $WAIT_TIME
                    #WAIT_TIME=$(($WAIT_TIME+$WAIT_TIME/2))
                    let "WAIT_TIME += WAIT_TIME/2"
            done
    }

    start_dropbox
    attempt_startup &

Tip:When you update Dropbox via your preferred AUR helper, the file will
(usually) be reverted to the default one. You can prevent this with
chattr +i /opt/dropbox/dropboxd which will make the file immutable. To
reverse this action simply use chattr -i /opt/dropbox/dropboxd.

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

to /etc/sysctl.conf and restarting your computer.

> Proxy Settings

The easiest way to set Dropbox's proxy settings is by defining them
manually in the Proxies tab of the Preferences window. Alternatively,
you can also set it to 'Auto-detect' and then export your proxy server
to the http_proxy env variable prior to starting Dropbox (HTTP_PROXY is
also usable)

    env http_proxy=http://your.proxy.here:port /usr/bin/dropboxd

or

    export http_proxy=http://your.proxy.here:port
    /usr/bin/dropboxd

Take note, Dropbox will only use proxy settings of the form
http://your.proxy.here:port, not your.proxy.here:port as some other
applications do.

Alternatives
------------

-   Ubuntu One - ubuntuone-client
-   Spider Oak - spideroak
-   KFileBox - kfilebox
-   Wuala - wuala

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dropbox&oldid=255766"

Category:

-   Internet Applications
