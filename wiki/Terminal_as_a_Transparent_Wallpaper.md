Terminal as a Transparent Wallpaper
===================================

There are two popular ways of configuring a Linux terminal to work
transparently over a wallpaper, without any borders, menu bars or
toolbars. This is very popular among developers because of its practical
and coolness factor. Example: for use it to view source-code or get an
interactive process status of the system with htop. Something like
conky, but not quite.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The Easy Way                                                       |
| -   2 The Professional Way                                               |
|     -   2.1 Openbox, Compiz and alike                                    |
|     -   2.2 Gnome                                                        |
|         -   2.2.1 Step 1                                                 |
|         -   2.2.2 Step 2                                                 |
|         -   2.2.3 Step 3                                                 |
|         -   2.2.4 Step 4                                                 |
|         -   2.2.5 Step 5                                                 |
|                                                                          |
|     -   2.3 Xfce4                                                        |
+--------------------------------------------------------------------------+

The Easy Way
------------

Tilda is a highly customizable Linux terminal window. The author is
inspired by classical terminals featured in first person shooter games,
Quake, Doom and Half-Life to name a few, where the terminal has no
border and is hidden from the desktop till a key or keys are pressed. In
our example we will install it and give a basic terminal.

    # pacman -S tilda

In Gnome you can locate it under Applications –> Accessories –> Tilda.

To achieve our desired look we will need to edit the default
configurations:

    Under General tab, uncheck "Always on Top".

    Under Appearance you can edit the height and width to your liking, but make sure you check "Enable Transparency" and make the "Level of Transparency" 100%.

    Under Colors tab, chose "Green on Black" or "Personalize".
     
    Under Scrolling you must select "Disabled".

That's all you need, to run Tilda go to Applications –> Accessories –>
Tilda and you should see it right there. The reason its not what I use
for my transparent terminal because this is an easy fix and not very
stable and crashes quite often (at least for me), while I know others
who are quite happy with Tilda. Other reason is that not allways stay as
wallpaper, if you use the "pulldown key" (F1) it comes to front.

The Professional Way
--------------------

> Openbox, Compiz and alike

With versatile WindowManagers like Openbox it's easy to create a
terminal on your Desktop. Since tilda brings lot's of easy configuration
per GUI, it might be your terminal of choice, if you don't know how to
create a transparent terminal otherwise. Right-click on tilda and
configure the size to your needs, then set transparency to 100%, uncheck
the option to start tilda hidden.

Now you only have to set tilda as "below" according to your
WindowManager. For Compiz, this is done by the "Rules for
Windows"-plugin, for Openbox, you'll have to add to the
"applications"-section of your a rc.xml the following code.

    <application name="tilda">
    <layer>below</layer>
    </application>

Et voila, you got a transparent terminal the size of your choice on your
Desktop, that won't appear in your tasklist and is permanently below.

> Gnome

With the use of devilspie we will have more control over the placement
and the behavior over the terminal window. What is Devilspie? Devil's
Pie can be configured to detect windows as they are created, and match
the window to a set of rules. If the window matches the rules, it can
perform a series of actions on that window. For example, I can make all
windows created by X-Chat appear on all workspaces, and the main
Gkrellm1 window does not appear in the pager or task list.

Step 1

Install devilspie on Arch:

    # pacman -S devilspie

Step 2

Make a hidden directory on your home folder:

    $ mkdir ~/.devilspie

Make a configuration file with the extension .ds, inside devilspie
folder. This is where devilspie looks for config file by default when it
starts up. Edit the config file with your favorite editor, to dress up
the terminal window the way you want it to look like.

    $ nano ~/.devilspie/DesktopConsole.ds

My config file looks like this:

    (if
    (matches (window_name) "DesktopConsole_1")
    (begin
    (stick)
    (below)
    (undecorate)
    (skip_pager)
    (skip_tasklist)
    (wintype "dock")
    (geometry "+240+250")
    (geometry "954×680")
    )
    )

For a complete list of options with devilspie configuration options
check out, the comprehensive list of options

Step 3

Open a gnome-terminal window go to Edit –> Profile –> New. Name it
DesktopConsole_1.

Edit the Profile, to achieve our desired look we will need to edit the
default configurations:

    Under General tab, uncheck "Show menubar by default in new terminals".

    Under Colors tab, choose "Green on Black" (choose whatever you like, i like this).

    Under Effects tab, choose "Transparent background". Make sure the scroll is set to "None".

    Under Scrolling tab, select "Disabled".

Step 4

In this step we will setup devilspie and our custom terminal profile to
load on bootup.

Go to Systems –> Preferences –> Sessions.

Add a new session by using the + sign. The first one we will put,
"devilspie", in both name and command.

The second session we will put "gnome-terminal", under name and
"gnome-terminal --window-with-profile=DesktopConsole_1
--title=DesktopConsole_1", under command. Here we are basically calling
gnome-terminal with the custom profile we created earlier.

Note:if you have trouble with the window position you can specify the
geometry in the command options here.

Step 5

Logout/login and you should have your desired look.

You can customize more to fit your needs and style, have more than one
terminal; I will leave it to your imagination.

> Xfce4

Using wmctrl this can be achieved with the default xfce4-terminal's
command line options. The sample script below is rather
self-explanatory...

    #!/bin/bash
    xfce4-terminal --hide-borders --hide-toolbars --hide-menubar --title=desktopconsole --geometry=130x44+0+0 &
    sleep 5
    wmctrl -r desktopconsole -b add,below,sticky
    wmctrl -r desktopconsole -b add,skip_taskbar,skip_pager

Note:A more revised version of this script can be found here
https://bbs.archlinux.org/viewtopic.php?id=154094

By naming the the terminal with --title one can easily identify it's
window and add/remove properties through wmctrl accordingly. Setting the
size and possition with the --geometry option follows this rule:
(Width-in-characters)x(height-in-charactors)+x+y where x and y are the
position in pixels offset from the upper-left corner of the display
(which starts at +0+0). transparency and disabling the scrollbar can be
set through the terminal's preferences menu under the appearance and
general tabs. Once the user has the script customized to their needs or
wants they can simply mark it as executable (or chmod a+x
/path/to/script.sh) then add it to their startup under Applications Menu
> Settings > Session and Startup > Applications Autostart.

Note:Wmctrl is intended for use with Window managers which meet the
EWMH/NetWM specifications. The following was tested only on Xfce4 with
Xfwm4 so it is unconfirmed whether it will work with other desktop
environments/window managers correctly as of this writing. For a list on
environments which wmctrl may work with visit
http://en.wikipedia.org/wiki/Wmctrl

Retrieved from
"https://wiki.archlinux.org/index.php?title=Terminal_as_a_Transparent_Wallpaper&oldid=248737"

Categories:

-   Eye candy
-   Terminal emulators
