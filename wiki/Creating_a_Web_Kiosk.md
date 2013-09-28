Creating a Web Kiosk
====================

  Summary
  ---------------------------------------------------
  Detailed instructions on the setup of a Web Kiosk

A Web Kiosk is useful in a public location such as a hotel lobby or
library. This article will detail how to set up and secure a kiosk that
will allow restricted web browsing but not access to the system
underneath. This can be done with various Window Managers and Web
Browsers. The article will be as general as possible while using
specific examples. Many of the ideas for this article were inspired by
this website.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What to Install                                                    |
| -   2 Creating Users                                                     |
| -   3 Automation                                                         |
|     -   3.1 automatic login and x-windows startup                        |
|         -   3.1.1 with initscripts                                       |
|         -   3.1.2 with systemd                                           |
|                                                                          |
|     -   3.2 (re)start the browser automatically                          |
|                                                                          |
| -   4 Locking Down the System                                            |
|     -   4.1 the boot sequence                                            |
|         -   4.1.1 BIOS                                                   |
|         -   4.1.2 GRUB                                                   |
|                                                                          |
|     -   4.2 user rights                                                  |
|     -   4.3 the window manager                                           |
|     -   4.4 the browser                                                  |
|                                                                          |
| -   5 Other Things to Check                                              |
|     -   5.1 the window manager                                           |
|     -   5.2 the browser                                                  |
|     -   5.3 will it break                                                |
|                                                                          |
| -   6 Chrome (not the Browser) ;-)                                       |
|     -   6.1 boot splash                                                  |
+--------------------------------------------------------------------------+

What to Install
---------------

After Arch is installed, get X-windows running. You can use the
Beginners' Guide.

Now install your preferred Window Manager (we'll use Openbox) and your
preferred Web Browser (we'll use Midori) as well as openssh for remote
administration and rsync for syncing the kiosk home directory later.

    pacman -S openbox midori openssh rsync

The various procedures for configuration will be detailed and can be
mapped, to one extent or another, to other WMs and Browsers by digging
in the documentation. Remember, {Generic, Web-Crawling Search Engine} is
your friend ;-)

Creating Users
--------------

You'll need to create at least two users.

1.  You don't want to be logging in as root, so create an administrator
    user (we'll call ours admin) using useradd admin.
    -   Set an appropriately secure password using passwd admin. Someone
        can sit at a kiosk for a long time trying passwords before
        anyone will notice ;-)
    -   Consider setting up sudo for ease of administration

2.  Create a second user called kiosk which will be used for the actual
    kiosk login.

Automation
----------

> automatic login and x-windows startup

with initscripts

Follow the directions in Start X at Login and Automatic login to virtual
console

with systemd

Since we don't need console-kit or pam just create a service file
according to These instructions. In a way this is good, because there
will be no su or sudo access even if the user could access a terminal.

then, as root, run:

    systemctl enable graphical.target

If you want to do things the "right" way, you can try these instructions
instead.

> (re)start the browser automatically

The next step involves making an X-Windows session script. This is a
.xinitrc script that starts the window manager session and ensures that
the kiosk user can't log out of the session because the session will
always restart.

First copy the kiosk home directory to /opt

    cp -r /home/kiosk /opt/

now set the /opt/kiosk/ directory to read only for everyone except the
owner

    cd /opt/kiosk/
    chmod -R a+r .

create a new .xinitrc file and set it to executable.

    touch .xinitrc
    chmod a+x .xinitrc

Now add the following to the .xinitrc that was created:

    xset s off
    xset -dpms
    openbox-session &
    while true; do
       rsync -qr --delete --exclude='.Xauthority' /opt/kiosk/ $HOME/
       midori http://{web_server}/{home-page}
    done

-   The xset lines will disable the screen blanking and monitor shutoff
    that would normally happen.
-   The & after the window manager is very important because the script
    won't continue otherwise.
-   The rsync does a nice job of replacing the session with the saved
    one while deleting any files that were added since the last time it
    was run.
-   Notice that there is no & after the web browser line. This means
    that the script won't continue until the browser exits.
-   The while loop ensures that when the browser does exit, rsync will
    run and then the browser will start right back up.

Finally copy the new .xinitrc to /home/kiosk

Locking Down the System
-----------------------

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> the boot sequence

BIOS

It's usually a good idea to set a BIOS password and disable booting from
anything but the local harddisk.

GRUB

Follow the directions in the GRUB wiki page.

> user rights

> the window manager

> the browser

Other Things to Check
---------------------

> the window manager

> the browser

> will it break

Chrome (not the Browser) ;-)
----------------------------

> boot splash

Retrieved from
"https://wiki.archlinux.org/index.php?title=Creating_a_Web_Kiosk&oldid=245059"

Category:

-   Getting and installing Arch
