awesome
=======

  Summary
  ----------------------------------------------------------------------------------
  A guide on how to install, use, configure, and customize awesome window manager.

From the awesome website:

"awesome is a highly configurable, next generation framework window
manager for X. It is very fast, extensible and licensed under the GNU
GPLv2 license.

It is primarly targeted at power users, developers and any people
dealing with every day computing tasks and who want to have fine-grained
control on its graphical environment."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Run awesome                                                        |
|     -   2.1 Without login manager                                        |
|     -   2.2 With login manager                                           |
|         -   2.2.1 KDM                                                    |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Creating the configuration file                              |
|     -   3.2 More configuration resources                                 |
|     -   3.3 Debugging rc.lua                                             |
|     -   3.4 Changing Keyboard Layout                                     |
|                                                                          |
| -   4 Themes                                                             |
|     -   4.1 Setting up your wallpaper                                    |
|         -   4.1.1 Random Background Image                                |
|                                                                          |
| -   5 Tips & Tricks                                                      |
|     -   5.1 Use awesome as GNOME's window manager                        |
|     -   5.2 Expose effect like compiz                                    |
|     -   5.3 Hide / show wibox in awesome 3                               |
|     -   5.4 Enable printscreens                                          |
|     -   5.5 Dynamic tagging                                              |
|     -   5.6 Space Invaders                                               |
|     -   5.7 Naughty for popup notification                               |
|     -   5.8 Popup Menus                                                  |
|     -   5.9 More Widgets in awesome                                      |
|     -   5.10 Transparency                                                |
|         -   5.10.1 ImageMagick                                           |
|                                                                          |
|     -   5.11 Autorun programs                                            |
|     -   5.12 Passing content to widgets with awesome-client              |
|     -   5.13 Using a different panel with awesome                        |
|     -   5.14 Fix Java (GUI appears gray only)                            |
|     -   5.15 Prevent Nautilus from displaying the desktop (Gnome3)       |
|     -   5.16 Transitioning away from Gnome3                              |
|     -   5.17 Prevent the mouse scroll wheel from changing tags           |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 LibreOffice                                                  |
|     -   6.2 Mod4 key                                                     |
|         -   6.2.1 Mod4 key vs. IBM ThinkPad users                        |
|                                                                          |
|     -   6.3 Eclipse: cannot resize/move main window                      |
|     -   6.4 YouTube: fullscreen appears in background                    |
|     -   6.5 Starting console clients on specific tags                    |
|     -   6.6 Redirecting console output to a file                         |
|                                                                          |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install awesome from the official repositories.

For pre-release versions, an awesome-git build is in the AUR. These
versions are not considered stable and may have a different
configuration syntax.

Run awesome
-----------

> Without login manager

To run awesome without a login manager, simply add exec awesome to the
startup script of your choice (e.g. ~/.xinitrc.)

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

You can also start awesome as preferred user without even logging in.
See Start X at Login.

> With login manager

To start awesome from a login manager, see this article.

KDM

Create as root:

    /usr/share/apps/kdm/sessions/awesome.desktop

    [Desktop Entry]
    Name=Awesome
    Comment=Tiling Window Manager
    Type=Application
    Exec=/usr/bin/awesome
    TryExec=/usr/bin/awesome

Configuration
-------------

Awesome includes some good default settings right out of the box, but
sooner or later you'll want to change something. The lua based
configuration file is at ~/.config/awesome/rc.lua.

> Creating the configuration file

First, run the following to create the directory needed in the next
step:

    $ mkdir -p ~/.config/awesome/

Whenever compiled, awesome will attempt to use whatever custom settings
are contained in ~/.config/awesome/rc.lua. This file is not created by
default, so we must copy the template file first:

    $ cp /etc/xdg/awesome/rc.lua ~/.config/awesome/

The syntax of the configuration often changes when awesome updates. So,
remember to repeat the command above when you get something strange with
awesome, or you'd like to modify the configuration.

For more information about configuring awesome, check out the
configuration page at awesome wiki

> More configuration resources

Note:The syntax of awesome configuration changes regularly, so you will
likely have to modify any file you download.

Some good examples of rc.lua would be as follows:

-   http://git.sysphere.org/awesome-configs/tree/ - Awesome 3.4
    configurations from Adrian C. (anrxc).
-   http://pastebin.com/f6e4b064e - Darthlukan's awesome 3.4
    configuration.
-   http://www.ugolnik.info/downloads/awesome/rc.lua - Awesome 3.1
    configuration with small titlebar and statusbar.
-   https://github.com/setkeh/Awesome - Setkeh's 3.4 Configuration.
-   https://github.com/setkeh/Awesome-Laptop-3.5 - Setkeh's 3.5
    Configuration.
-   http://awesome.naquadah.org/wiki/User_Configuration_Files -
    Collection of user configurations on the awesome homepage.

> Debugging rc.lua

Xephyr allows you to run X nested in another X's client window. This
allows you to debug rc.lua without breaking your current desktop. Start
by copying rc.lua into a new file (e.g. rc.lua.new), and modify it as
needed. Then run new instance of awesome in Xephyr, supplying rc.lua.new
as a config file like this:

    $ Xephyr :1 -ac -br -noreset -screen 1152x720 &
    $ DISPLAY=:1.0 awesome -c ~/.config/awesome/rc.lua.new

The advantage of this approach is that if you introduce bugs you do not
break your current awesome desktop, potentially crashing X apps and
losing work. Once you are happy with the new configuration, copy
rc.lua.new to rc.lua and restart awesome.

An alternative to Xepher is awmtt which provides the above functionality
and more.

> Changing Keyboard Layout

If it were necessary for someone to need a different keyboard layout
[qwerty -> dvorak] there are methods for such listed here on the awesome
wiki.

Themes
------

Beautiful is a lua library that allows you to theme awesome using an
external file, it becomes very easy to dynamically change your whole
awesome colours and wallpaper without changing your rc.lua.

The default theme is at /usr/share/awesome/themes/default. Copy it to
~/.config/awesome/themes/default and change theme_path in rc.lua.

    beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")

More details here

A few sample themes

> Setting up your wallpaper

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: With version 3.5 
                           Awesome no longer        
                           provides a awsetbg       
                           command, instead it has  
                           a gears module. You can  
                           find how to use it in    
                           default config (Discuss) 
  ------------------------ ------------------------ ------------------------

Beautiful can handle your wallpaper, thus you do not need to set it up
in your .xinitrc or .xsession files. This allows you to have a specific
wallpaper for each theme. If you take a look at the default theme file
you'll see a wallpaper_cmd key, the given command is executed when
beautiful.init("path_to_theme_file") is run. You can put here you own
command or remove/comment the key if you do not want Beautiful to
interfere with your wallpaper business.

For instance, if you use awsetbg to set your wallpaper, you can write in
the theme.lua page that you just selected:

    theme.wallpaper_cmd = { "awsetbg -f .config/awesome/themes/awesome-wallpaper.png" }

Note:For awsetbg to work you need to have a program that can manage
desktop backgrounds installed. For example Feh.

Random Background Image

add this to your rc.lua(for awesome >= 3.5 ):

    -- configuration - edit to your liking
    wp_index = 1
    wp_timeout  = 10
    wp_path = "/path/to/wallpapers/"
    wp_files = { "01.jpg", "02.jpg", "03.jpg" }
     
    -- setup the timer
    wp_timer = timer { timeout = wp_timeout }
    wp_timer:connect_signal("timeout", function()
     
      -- set wallpaper to current index
      gears.wallpaper.maximized( wp_path .. wp_files[wp_index] , s, true)
     
      -- stop the timer (we don't need multiple instances running at the same time)
      wp_timer:stop()
     
      -- get next random index
      wp_index = math.random( 1, #wp_files)
     
      --restart the timer
      wp_timer.timeout = wp_timeout
      wp_timer:start()
    end)
     
    -- initial start when rc.lua is first run
    wp_timer:start()

To rotate the wallpapers randomly, just comment the wallpaper_cmd line
above, and add a script into your .xinitrc with the codes below(for
awesome <= 3.4 ):

    while true;
    do
      awsetbg -r <path/to/the/directory/of/your/wallpapers>
      sleep 15m
    done &

Tips & Tricks
-------------

Feel free to add any tips or tricks that you would like to pass on to
other awesome users.

> Use awesome as GNOME's window manager

GNOME has the advantage of being very "ready to use" and integrating.
You can set up GNOME to use awesome as the visual interface, but have
GNOME work in the background for your pleasure. If you are using GNOME
3, you can simply install the awesome-gnome package, then when logging
in with GDM, choose the session type "Awesome GNOME". See the awesome
wiki for details.

> Expose effect like compiz

Revelation brings up a view of all your open clients; left-clicking a
client pops to the first tag that client is visible on and
raises/focuses the client. In addition, the Enter key pops to the
currently focused client, and Escape aborts.

http://awesome.naquadah.org/wiki/Revelation

> Hide / show wibox in awesome 3

To map Modkey-b to hide/show default statusbar on active screen (as
default in awesome 2.3), add to your globalkeys in rc.lua:

    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

> Enable printscreens

To enable printscreens in awesome through the PrtScr button you need to
have a screen capturing program. Scrot is a easy to use utility for this
purpose and is available in Arch repositories.

Just type:

    # pacman -S scrot

and install optional dependencies if you feel that you need them.

Next of we need to get the key name for PrtScr, most often this is named
"Print" but one can never be too sure.

Start up:

    # xev

And press the PrtScr button, the output should be something like:

     KeyPress event ....
         root 0x25c, subw 0x0, ...
         state 0x0, keycode 107 (keysym 0xff61, Print), same_screen YES,
         ....

In my case as you see, the keyname is Print.

Now to the configuration of awesome!

Somewhere in your globalkeys array (doesn't matter where) type:

Lua code:

     awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end),

Also, this function saves screenshots inside ~/screenshots/, edit this
to fit your needs.

> Dynamic tagging

Eminent is a small lua library that monkey-patches awful to provide you
with effortless and quick wmii-style dynamic tagging. Unlike shifty,
eminent does not aim to provide a comprehensive tagging system, but
tries to make dynamic tagging as simple as possible. In fact, besides
importing the eminent library, you do not have to change your rc.lua at
all, eminent does all the work for you.

Shifty is an Awesome 3 extension that implements dynamic tagging. It
also implements fine client matching configuration allowing YOU to be
the master of YOUR desktop only by setting two simple config variables
and some keybindings!

> Space Invaders

Space Invaders is a demo to show the possibilities of the Awesome Lua
API.

Please note that it is no longer included in the Awesome package since
the 3.4-rc1 release.

> Naughty for popup notification

See the awesome wiki page on naughty.

> Popup Menus

There's a simple menu by default in awesome3, and customed menus seem
very easy now. However, if you're using 2.x awesome, have a look at
awful.menu.

If you want a freedesktop.org menu, you could take a look at
awesome-freedesktop .

An example for awesome3:

    myawesomemenu = {
       { "lock", "xscreensaver-command -activate" },
       { "manual", terminal .. " -e man awesome" },
       { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
       { "restart", awesome.restart },
       { "quit", awesome.quit }
    }

    mycommons = {
       { "pidgin", "pidgin" },
       { "OpenOffice", "soffice-dev" },
       { "Graphic", "gimp" }
    }

    mymainmenu = awful.menu.new({ items = { 
                                            { "terminal", terminal },
                                            { "icecat", "icecat" },
                                            { "Editor", "gvim" },
                                            { "File Manager", "pcmanfm" },
                                            { "VirtualBox", "VirtualBox" },
                                            { "Common App", mycommons, beautiful.awesome_icon },
                                            { "awesome", myawesomemenu, beautiful.awesome_icon }
                                           }
                                 })

> More Widgets in awesome

Widgets in awesome are objects that you can add to any widget-box
(statusbars and titlebars), they can provide various information about
your system, and are useful for having access to this information, right
from your window manager. Widgets are simple to use and offer a great
deal of flexibility. -- Source Awesome Wiki: Widgets.

There's a widely used widget library called Wicked (compatible with
awesome versions prior to 3.4), that provides more widgets, like MPD
widget, CPU usage, memory usage, etc. For more details see the Wicked
page.

As a replacement for Wicked in awesome v3.4 check Vicious, Obvious and
Bashets. If you pick vicious, you should also take a good look at
vicious documentation.

> Transparency

Awesome has support for true transparency through a compositing manager
such as xcompmgr(xcompmgr-git), compton(compton-git) or
cairo-compmgr-git.

To use xcompmgr, add this to your ~/.xinitrc:

    xcompmgr &

See man xcompmgr or xcompmgr for more options.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Awesome 3.5 has  
                           come and add_signal API  
                           has changed to           
                           connect_signal (Discuss) 
  ------------------------ ------------------------ ------------------------

In awesome 3.4, window transparency can be set dynamically using
signals. For example, your rc.lua could contain the following:

    client.add_signal("focus", function(c)
                                  c.border_color = beautiful.border_focus
                                  c.opacity = 1
                               end)
    client.add_signal("unfocus", function(c)
                                    c.border_color = beautiful.border_normal
                                    c.opacity = 0.7
                                 end)

If you got error messages about add_signal, using connect_signal
insteaded.

Note that if you are using conky, you must set it to create its own
window instead of using the desktop. To do so, edit ~/.conkyrc to
contain:

    own_window yes
    own_window_transparent yes
    own_window_type desktop

Otherwise strange behavior may be observed, such as all windows becoming
fully transparent. Note also that since conky will be creating a
transparent window on your desktop, any actions defined in awesome's
rc.lua for the desktop will not work where conky is.

As of Awesome 3.1, there is built-in pseudo-transparency for wiboxes. To
enable it, append 2 hexadecimal digits to the colors in your theme file
(~/.config/awesome/themes/default, which is usually a copy of
/usr/share/awesome/themes/default), like shown here:

    bg_normal = #000000AA

where "AA" is the transparency value.

To change transparency for the actual selected window by pressing Modkey
+ PageUp/PageDown you can also use tansset-df available through the
community package repository and the following modification to your
rc.lua:

    globalkeys = awful.util.table.join(
        -- your keybindings
        [...]
        awful.key({ modkey }, "Next", function (c)
            awful.util.spawn("transset-df --actual --inc 0.1")
        end),
        awful.key({ modkey }, "Prior", function (c)
            awful.util.spawn("transset-df --actual --dec 0.1")
        end),
        -- Your other key bindings
        [...]
    )

ImageMagick

You may have problems if you set your wallpaper with imagemagick's
display command, it doesn't work well with xcompmgr. Please note that
awsetbg may be using display if it doesn't have any other options.
Installing habak, feh, hsetroot or whatever should fix the problem (grep
-A 1 wpsetters /usr/bin/awsetbg to see your options).

> Autorun programs

See also the Autostart page on the Awesome wiki.

awesome doesn't run programs set to autostart by the Freedesktop
specification like GNOME or KDE. However, awesome does provide a few
functions for starting programs (in addition to the Lua standard library
function os.execute). To run the same programs on startup as GNOME or
KDE, you can install dex from the AUR and then run that in your rc.lua:

    os.execute"dex -a -e Awesome"

If you just want to set up a list of apps for awesome to launch at
startup, you can create a table of all the commands you want to spawn
and loop through it:

    do
      local cmds = 
      { 
        "swiftfox",
        "mutt",
        "consonance",
        "linux-fetion",
        "weechat-curses",
        --and so on...
      }

      for _,i in pairs(cmds) do
        awful.util.spawn(i)
      end
    end

(You could also run calls to os.execute with commands ending in '&', but
it's probably a better idea to stick to the proper spawn function.)

To run a program only if it is not currently running, you can spawn it
with a shell command that runs the program only if pgrep doesn't find a
running process with the same name:

    function run_once(prg)
      awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg .. ")")
    end

So, for example, to run parcellite only if there is not a parcellite
process already running:

    run_once("parcellite")

> Passing content to widgets with awesome-client

You can easily send text to an awesome widget. Just create a new widget:

     mywidget = widget({ type = "textbox", name = "mywidget" })
     mywidget.text = "initial text"

To update the text from an external source, use awesome-client:

     
     echo -e 'mywidget.text = "new text"' | awesome-client

Don't forget to add the widget to your wibox.

> Using a different panel with awesome

If you like awesome's lightweightness and functionality but do not like
the way its default panel looks, you can install a different panel. Just
install xfce4-panel by issuing:

    sudo pacman -S xfce4-panel

Of course any other panel will do as well. Then add it to autorun
section of your rc.lua (how to do that is written elsewhere on this
wiki). You can also comment out the section which creates wiboxes for
each screen (starting from "mywibox[s] = awful.wibox({ position = "top",
screen = s })" ) but it isn't necessary. Any way do not forget to check
your rc.lua for errors by typing

    awesome -k rc.lua

Also you should change your "modkey+R" keybinding, in order to start
some other application launcher instead of built in awesome. Xfrun4,
bashrun, etc. Check the Application launchers section of Openbox article
for examples. Don't forget to add

          properties = { floating = true } },
        { rule = { instance = "$yourapplicationlauncher" },

to your rc.lua.

> Fix Java (GUI appears gray only)

Guide taken from [1].

1.  Install wmname from community
2.  Run the following command or add it to your .xinitrc:

        wmname LG3D

> Note:

If you use a non-reparenting window manager and Java 6, you should
uncomment the corresponding line in /etc/profile.d/openjdk6.sh

If you use a non-reparenting window manager and Java 7, you should
uncomment the corresponding line in /etc/profile.d/jre.sh

> Prevent Nautilus from displaying the desktop (Gnome3)

Run dconf-editor. Navigate to org->gnome->desktop->background and
uncheck "draw-background" as well as "show-desktop-icons" for good
measure. That's it!

Another option is moving /usr/bin/nautilus to a new location and
replacing it with a script that runs 'nautilus --no-desktop' passing any
arguments it receives along.

    #!/bin/sh
    /usr/bin/nautilus-real --no-desktop $@

> Transitioning away from Gnome3

Run 'gnome-session-properties' and remove programs that you won't be
needing anymore (e.g Bluetooth Manager, Login Sounds, etc).

If you'd like to get rid of GDM, make sure that your rc.conf DAEMONS
list includes "dbus" (and "cupsd" if you have a printer). It's advisable
to get a different login manager (like SLiM), but you can do things
manually if you wish. That entails setting up your .xinitrc properly and
installing something like devmon (AUR).

If you want to keep a few convenient systray applets and your GTK theme,
append this to your rc.lua;

    function start_daemon(dae)
    	daeCheck = os.execute("ps -eF | grep -v grep | grep -w " .. dae)
    	if (daeCheck ~= 0) then
    		os.execute(dae .. " &")
    	end
    end

    procs = {"gnome-settings-daemon", "nm-applet", "kupfer", "gnome-sound-applet", "gnome-power-manager"}
    for k = 1, #procs do
    	start_daemon(procs[k])
    end

> Prevent the mouse scroll wheel from changing tags

In your rc.lua, change the Mouse Bindings section to the following;

    -- {{{ Mouse bindings
    root.buttons(awful.util.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end)))
    -- }}}

Troubleshooting
---------------

> LibreOffice

If you encounter UI problems with libreoffice install libreoffice-gnome.

> Mod4 key

The Mod4 is by default the Win key. If it's not mapped by default, for
some reason, you can check the keycode of your Mod4 key with

    $ xev

It should be 115 for the left one. Then add this to your ~/.xinitrc

    xmodmap -e "keycode 115 = Super_L" -e "add mod4 = Super_L"
    exec awesome

The problem in this case is that some xorg installations recognize
keycode 115, but incorrectly as the 'Select' key. The above command
explictly remaps keycode 115 to the correct 'Super_L' key.

Mod4 key vs. IBM ThinkPad users

IBM ThinkPads do not come equipped with a Window key (although Lenovo
have changed this tradition on their ThinkPads). As of writing, the Alt
key is not used in command combinations by the default rc.lua (refer to
the Awesome wiki for a table of commands), which allows it be used as a
replacement for the Super/Mod4/Win key. To do this, edit your rc.lua and
replace:

    modkey = "Mod4"

by:

    modkey = "Mod1"

Note: Awesome does a have a few commands that make use of Mod4 plus a
single letter. Changing Mod4 to Mod1/Alt could cause overlaps for some
key combinations. The small amount of instances where this happens can
be changed in the rc.lua file.

If you do not like to change the awesome standards, you might like to
remap a key. For instance the caps lock key is rather useless (for me)
adding the following contents to ~/.Xmodmap

    clear lock 
    add mod4 = Caps_Lock

and (re)load the file. This will change the caps lock key into the mod4
key and works nicely with the standard awesome settings. In addition, if
needed, it provides the mod4 key to other X-programs as well.

Not confirmed, but if recent updates of xorg related packages break
mentioned remapping the second line can be replaced by (tested on a
DasKeyboard with no left Super key):

    keysym Caps_Lock = Super_L Caps_Lock

> Eclipse: cannot resize/move main window

If you get stuck and cannot move or resize the main window (using mod4 +
left/right mouse button) edit the workbench.xml and set
fullscreen/maximized to false (if set) and reduce the width and height
to numbers smaller than your single screen desktop area.

Note:workbench.xml can be found in:
<eclipse_workspace>/.metadata/.plugins/org.eclipse.ui.workbench/ and the
line to edit is <window height="xx" maximized="true" width="xx" x="xx"
y="xx">.

> YouTube: fullscreen appears in background

[2] If YouTube videos appear underneath your web browser when in
fullscreen mode, or underneath the panel with controls hidden, add this
to your rc.lua

       { rule = { instance = "plugin-container" },
         properties = { floating = true } },

With Chromium add

       { rule = { instance = "exe" },
         properties = { floating = true } },

> Starting console clients on specific tags

It does not work when the console application is invoked from a GTK
terminal (e.g. LXTerminal). URxvt is known to work.

> Redirecting console output to a file

Some GUI application are very verbose when launched from a terminal. As
a consequence, when started from Awesome, they output everything to the
TTY from where Awesome was started, which tend to get messy. To remove
the garbage output, you have to redirect it. However, the
awful.util.spawn function does not handle pipes and redirections very
well as stated in the official FAQ.

As example, let's redirect Luakit output to a temporary file:

    awful.key({ modkey, }, "w", function () awful.util.spawn_with_shell("luakit 2>>/tmp/luakit.log") end),

External Links
--------------

-   http://awesome.naquadah.org/wiki/FAQ - FAQ
-   http://www.lua.org/pil/ - Programming in Lua (first edition)
-   http://awesome.naquadah.org/ - The official awesome website
-   http://awesome.naquadah.org/wiki/Main_Page - the awesome wiki
-   http://www.penguinsightings.org/desktop/awesome/ - A review
-   http://compsoc.tardis.ed.ac.uk/wiki/AwesomeWM_guide - Awesome guide
-   https://bbs.archlinux.org/viewtopic.php?id=88926 - share your
    awesome!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Awesome&oldid=254933"

Categories:

-   Dynamic WMs
-   Tiling WMs
