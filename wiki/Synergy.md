Synergy
=======

Synergy lets you easily share a single mouse and keyboard between
multiple computers (even with different operating systems) without the
need for special hardware. It is intended for users with multiple
computers on their desk since each system uses its own monitor(s).

Redirecting the mouse and keyboard is as simple as moving the mouse off
the edge of your screen. Synergy also merges the clipboards of all the
systems into one, allowing cut-and-paste between systems. Furthermore,
it synchronizes screen savers so they all start and stop together and,
if screen locking is enabled, only one screen requires a password to
unlock them all.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Arch Linux                                                   |
|     -   1.2 Windows and Mac OS X                                         |
|                                                                          |
| -   2 Pre-configuration                                                  |
| -   3 Server configuration                                               |
|     -   3.1 Arch Linux                                                   |
|     -   3.2 Windows                                                      |
|     -   3.3 Mac OS X                                                     |
|     -   3.4 Configuration examples                                       |
|                                                                          |
| -   4 Clients configuration                                              |
|     -   4.1 Arch Linux                                                   |
|         -   4.1.1 Autostart                                              |
|                                                                          |
|     -   4.2 Windows                                                      |
|     -   4.3 Mac OS X                                                     |
|                                                                          |
| -   5 Known Issues                                                       |
| -   6 Troubleshooting                                                    |
|     -   6.1 Keyboard repeat                                              |
|     -   6.2 Keyboard mapping                                             |
|     -   6.3 messages.log being spammed with by synergyc                  |
|                                                                          |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

> Arch Linux

You can install the synergy package from the official repositories.

> Windows and Mac OS X

Download and run the newest installer from the official website.

Tip:You can also try the BETA versions of Synergy.

-   Read the official compiling help.

Pre-configuration
-----------------

First determine the IP addresses and host names for each machine and
make sure each has a correct hosts file.

-   Arch Linux - /etc/hosts
-   Windows - C:\WINDOWS\system32\drivers\etc\hosts
-   Mac OS X - How to Add Hosts to Local Hosts File.

    /etc/hosts

    10.10.66.1        archserver.localdomain       archserver
    10.10.66.100      archleft.localdomain         archleft
    10.10.66.105      archright.localdomain        archright

Note:Check that the clients can reach the server.

Server configuration
--------------------

In synergy, the computer with keyboard and mouse you want to share is
called server. See Synergy Configuration File Format for a detailed
description of all available sections and options.

> Arch Linux

The configuration file for Arch Linux is /etc/synergy.conf. If it does
not exist, create it using /etc/synergy.conf.example, whose comments
should give you enough information for a basic configuration; if you
need further reference, read the guide mentioned above.

Tip:You may also use either qsynergy from the official repositories or
quicksynergy from the AUR which provide a GUI to simplify the
configuration process.

To start the server daemon, run:

    # systemctl start synergys

If you experience problems and you wish to run the server in the
foreground, you can run the following command instead:

    # synergys -f

If you want to run the synergy server daemon every time Arch Linux boots
up,

    # systemctl enable synergys

> Windows

1.  Open the Synergy program
2.  Select the option Server (share this computer's mouse and keyboard)
3.  Select Configure interactively
4.  Click the Configure Server... button
5.  This opens a window in which you can add screens depending on how
    many computers/screens you have: just drag the screen icon in the
    top-right corner to the screens area, and double-click it to edit
    its settings
6.  Click OK to close the screens window when you are ready, then click
    on Start to start the server

On Windows, configuration is saved by default in a synergy.sgc file, but
its name and location can of course be changed at pleasure.

If you want to start the Synergy server everytime Windows starts, you
have to launch the program as administrator, then go to Edit -> Services
and select Install in the Server section; note that at the following
reboot Synergy will indeed automatically start, but the tray icon will
not display automatically (at least for version 1.4.2 beta on Windows
7). To uninstall the service, do the same thing but obviously select
Uninstall.

If you want to start the server from the command-line, here is a Windows
command you can place in a .bat file or just run from cmd.exe:

    C:\Program Files\Synergy+\bin\synergys.exe  -f --debug ERROR --name left --log c:\windows\synergy.log -c C:/windows/synergy.sgc --address 10.66.66.2:24800

> Mac OS X

Mac OS X has a similar configuration as Unix: check the official
documentation for more information.

> Configuration examples

This is an example for a basic 3-computers setup:

    /etc/synergy.conf

    section: screens
    	server-fire:
    	archright-fire:
    	archleft-fire:
    end

    section: links
    	archleft-fire:
    		right = server-fire
    	server-fire:
    		right = archright-fire
    		left = archleft-fire
    	archright-fire:
    		left = server-fire
    end

This should be the example bundled with the Arch Linux package:

    /etc/synergy.conf

    section: screens
            # three hosts named:  moe, larry, and curly
            moe:
            larry:
            curly:
    end

    section: links
            # larry is to the right of moe and curly is above moe
            moe:
                    right = larry
                    up    = curly

            # moe is to the left of larry and curly is above larry.
            # note that curly is above both moe and larry and moe
            # and larry have a symmetric connection (they're in
            # opposite directions of each other).
            larry:
                    left  = moe
                    up    = curly

            # larry is below curly.  if you move up from moe and then
            # down, you'll end up on larry.
            curly:
                    down  = larry
    end

    section: aliases
            # curly is also known as shemp
            curly:
                    shemp
    end

The following is a more customized example:

    synergy.sgc

    section: screens
    	leftpc:
    		halfDuplexCapsLock = false
    		halfDuplexNumLock = false
    		halfDuplexScrollLock = false
    		xtestIsXineramaUnaware = false
    		switchCorners = none +top-left +top-right +bottom-left +bottom-right 
    		switchCornerSize = 0
    	rightpc:
    		halfDuplexCapsLock = false
    		halfDuplexNumLock = false
    		halfDuplexScrollLock = false
    		xtestIsXineramaUnaware = false
    		switchCorners = none +top-left +top-right +bottom-left +bottom-right 
    		switchCornerSize = 0
    end

    section: aliases
    leftpc:
    10.66.66.2
    rightpc:
    10.66.66.1
    end

    section: links
    	leftpc:
    		right = rightpc
    	rightpc:
    		left = leftpc
    end

    section: options
    	heartbeat = 1000
    	relativeMouseMoves = false
    	screenSaverSync = false
    	win32KeepForeground = false
    	switchCorners = none +top-left +top-right +bottom-left +bottom-right 
    	switchCornerSize = 4
    end

Clients configuration
---------------------

Note:This assumes a server has been set up and configured properly. Make
sure the server is already configured to accept the client(s) before
continuing.

> Arch Linux

In a console window, type:

    $ synergyc server-host-name

Or, to run synergy in the foreground:

    $ synergyc -f server-host-name

Here, server-host-name is the host name of the server.

Autostart

There exist several ways to automatically start the Synergy client, and
they are actually the same that can be used for every other application.

Note:In all of the following examples, you always have to substitute
server-host-name with the real server host name.

-   You can add the next line to your ~/.xinitrc:

    ~/.xinitrc

    ...

    #replace server-host-name with the real name
    synergyc server-host-name

The following is an alternative:

    ~/.xinitrc

    XINIT_CMD='/usr/bin/synergyc -d FATAL -n galileo-fire 10.66.66.2:24800'
    /usr/bin/pgrep -lxf "$XINIT_CMD" || ( ( $XINIT_CMD ) & )

-   Otherwise, if you are using a display manager (kdm, gdm, SLiM, ...),
    or a stand-alone window manager (Openbox, ...), you could exploit
    its start-up script and add the following:

    synergyc server-host-name

For example, using kdm you should edit /usr/share/config/kdm/Xsetup.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: this section     
                           does not work for        
                           systemd (Discuss)        
  ------------------------ ------------------------ ------------------------

-   You can even start synergyc in the init chain by adding the
    following to /etc/rc.local:

    /etc/rc.local

    ...

    echo "Starting Synergy client"
    #replace server-host-name with the real name
    synergyc server-host-name

-   A similar result can be obtained by creating a daemon and adding it
    to the daemons array in /etc/rc.conf; just create a file
    /etc/rc.d/synergyc with the following content, making sure to set
    its permissions to chmod 755:

    /etc/rc.d/synergyc

    #!/bin/bash
    . /etc/rc.conf
    . /etc/rc.d/functions

    #Put the server host name in the following line
    SERVERALIAS="server-host-name"

    PID=`pidof -o %PPID /usr/bin/synergyc`
    case "$1" in
     start)
       stat_busy "Starting Synergy Client"
       [ -z "$PID" ] && /usr/bin/synergyc "$SERVERALIAS"
       if [ $? -gt 0 ]; then
         stat_fail
       else
         /usr/bin/xset r on
         add_daemon synergyc
         stat_done
       fi
       ;;
     stop)
       stat_busy "Stopping Synergy Client"
       [ ! -z "$PID" ] && kill -9 $PID
       if [ $? -gt 0 ]; then
         stat_fail
       else
         rm_daemon synergyc
         stat_done
       fi
       ;;
     restart)
       $0 stop
       sleep 1
       $0 start
       ;;
     *)
       echo "usage: $0 {start|stop|restart}"
    esac
    exit 0

Automatically starting Synergy is also documented in its official
reference page.

> Windows

After installation, open the Synergy program, select the option Client
(use another computer's keyboard and mouse) and type the host name of
the server computer in the text box, then click Start to start the
client.

Note:You can use the tray icon to stop the client.

If you want to start the Synergy client every time Windows starts, you
have to launch the program as an administrator, then go to Edit ->
Services and select Install in the Client section.

If you want to start the client from the command-line, here is a Windows
command you can place in a .bat file or just run from cmd.exe. This
points to a configuration file in C:\synergy.sgc and runs in the
background like a service.

    START /MIN /D"C:\Program Files\Synergy+\bin" synergys.exe -d ERROR -n m6300 -c C:\synergy.sgc -a 10.66.66.2:24800

> Mac OS X

Locate the synergyc program in the synergyc folder and drag it onto the
terminal window: the full path will appear in the terminal. Now append
the host name of the server, so that the complete command will look like
this:

    /path/to/synergyc/synergyc server-host-name

Then press Enter.

Known Issues
------------

If Arch is being used as a client in a Synergy installation, the server
may not be able to wake the client monitor. There are some workarounds,
such as executing the following via SSH, if ACPI is enabled (see:
Modifying DPMS and ScreenSaver settings with xset):

    # xset dpms force on

Troubleshooting
---------------

The official documentation has a FAQ and also a troubleshooting page.

> Keyboard repeat

If you experience problems with your keyboard repeat on the client
machine (Linux host), simply type:

    # /usr/bin/xset r on

in any console.

> Keyboard mapping

If you experience problems with the keyboard mapping when using the
server's keyboard in a client window (e.g a terminal) then re-setting
the X key map after starting synergyc may help. The following command
sets the keymap to its current value:

    # setxkbmap $(setxkbmap -query | grep "^layout:" | awk -F ": *" '{print $2}')

> messages.log being spammed with by synergyc

If you run synergyc as described above then your /var/log/messages.log
file will get spammed with messages like these:

     May 26 22:30:46 localhost Synergy 1.4.6: 2012-05-26T22:30:46 INFO: entering screen
             /build/src/synergy-1.4.6-Source/src/lib/synergy/CScreen.cpp,103
     May 26 22:30:47 localhost Synergy 1.4.6: 2012-05-26T22:30:47 INFO: leaving screen
             /build/src/synergy-1.4.6-Source/src/lib/synergy/CScreen.cpp,121

To prevent this run synergyc with the -d WARNING option. This debug
level option tells synergy to only log messages if they are level
WARNING or above.

     synergyc -d WARNING server-host-name

You can also edit the line that calls synergyc if you use a
/etc/rc.d/synergyc file.

        [ -z "$PID" ] && /usr/bin/synergyc -d WARNING "$SERVERALIAS"

External Links
--------------

-   Synergy website: http://synergy-foss.org
-   Official documentation: http://synergy-foss.org/docs
-   Gentoo Wiki Synergy Setup: http://en.gentoo-wiki.com/wiki/Synergy

Retrieved from
"https://wiki.archlinux.org/index.php?title=Synergy&oldid=244719"

Category:

-   Input devices
