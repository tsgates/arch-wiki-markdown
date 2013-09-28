Ratpoison
=========

Ratpoison is a minimalistic window manager which can be controlled 100%
through keyboard. It behaves like the terminal-multiplexer GNU screen.
Every window is maximized to fit the whole screen, no pixel is wasted on
stuff like borders or other decoration. The user can also "split" the
screen into two or more frames in order to display more than one window
at the time. For more information check the official homepage at
http://www.nongnu.org/ratpoison/.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Using ratpoison                                                    |
| -   4 Tips and tricks                                                    |
|     -   4.1 Multiple workspaces                                          |
|     -   4.2 urxvt and xterm                                              |
|     -   4.3 Launch on Startup                                            |
|     -   4.4 Wallpaper and Transparency                                   |
|                                                                          |
| -   5 Some more useful KeyCombos                                         |
| -   6 Ratpoison and display managers                                     |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Ratpoison can be installed with package ratpoison, available in official
repositories.

Configuration
-------------

To use ratpoison as your windowmanager, you have to create/edit the file
~/.xinitrc.

Example .xinitrc:

    # the black/white grid as background doesn't suit my taste.
    xsetroot -solid black &
    # ratpoison is compatible with xcompmgr! now you can have real transparency
    xcompmgr -c -f -D 5 &
    #fire up ratpoison!
    exec /usr/bin/ratpoison

Using ratpoison
---------------

After X11 starts up you will see a black screen and a little textbox on
the upper right of it that says "Welcome to Ratpoison" :) Now type
Ctrl+t and then ? to get a list of keybindings. If you are used to GNU
screen, you will feel at home very soon.

You are able to define custom keystrokes and even override existing ones
in ~/.ratpoisonrc

Example:

    # overriding CTRL+t 'c' to start aterm instead of xterm
    bind c exec aterm

    bind f exec firefox

So, if you type Ctrl+t and then f, ratpoison will fire up firefox.

Here is another .ratpoisonrc i'm using on my Computers:

    exec xsetroot -cursor_name left_ptr
    startup_message off

    escape C-z

    # make a screenshot
    alias sshot exec import -window root ~/screenshot-`date +%F`.jpg
    definekey top M-C-Print sshot

    #virtual desks
    gnewbg one
    gnewbg two

    definekey top M-l exec ratpoison -c "select -" -c "gprev" -c "next"
    definekey top M-h exec ratpoison -c "select -" -c "gnext" -c "next"

    #switch between windows
    definekey top M-j next
    definekey top M-k prev

    #apps
    unbind c
    bind c exec urxvt -tr
    #bind c exec aterm

    bind g exec gftp
    bind f exec firefox2

Tips and tricks
---------------

> Multiple workspaces

By default, ratpoison only has one workspace, but using a script called
rpws (installed by default) you can have more.

Just edit your .ratpoisonrc, and add:

    ~/.ratpoisonrc

    exec rpws -i
    exec /usr/bin/rpws init 6 -k

That creates 6 workspaces. By default, you can access to them by using
Alt+F1 to access the first, Alt+F2 to access the second, etc.

You can also add binds to them, like this:

    bind C-1 exec rpws 1
    bind C-2 exec rpws 2
    ...

That allows to access them with Ctrl+t Ctrl+1 (assuming Ctrl+t as your
escape key)

> urxvt and xterm

Urxvt and xterm would not resize to a fixed number of pixels. Instead,
it resize itself to multiples of its font's size, therefore, chances
that there are unfilled gaps are high. To correct this, we can use the
xterm/urxvt option internalBorder and set the border of ratpoison to 0.

A trial and error process must be done to find the exact number of
internalBorder for each combination of resolution and font size. (the
border of ratpoison must be set to 0 before doing the tests) The term
command line option -b can be used to test for the correct number and
then can be saved on the following files.

    ~/.Xresources

    urxvt*internalBorder: 8 #change urxvt to xterm if necessary. Using the font terminus in urxvt at 14px size, 8 is the correct number here.

    ~/.ratpoisonrc

    set border 0

If a combination cannot be found, you could try changing the font size
and the font family also. (that changes the required border number)

  

> Launch on Startup

Examples for launching programs when ratpoison starts. File
~/.ratpoisonrc is executed by ratpoison on startup.

    Launch urxvt with a tmux session

    exec urxvt -e bash -c "tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$USER@$HOSTNAME"

    Launch optimized chromium

    exec bash -c 'pidof chromium &>/dev/null || exec /usr/bin/chromium --disk-cache-dir=~/tmp/cache'

> Wallpaper and Transparency

Example for setting transparency using xcompmgr and nitrogen. First
start nitrogen and set the desired wallpaper. Then use this in your
.ratpoisonrc

    Wallpaper and transparency

    exec xcompmgr -c -f -D 5 &
    exec nitrogen --restore

Some more useful KeyCombos
--------------------------

Ctrl+t ! <Program Name> Start any program  
 Ctrl+t q Quit ratpoison  
 Ctrl+t ? Show key bindings  
 Ctrl+t c Start an X terminal  
 Ctrl+t n Switch to next window  
 Ctrl+t p Switch to previous window  
 Ctrl+t 1-9 Switch to windows 1-9  
 Ctrl+t k Close the current window  
 Ctrl+t Shift+k XKill the current application  
 Ctrl+t s,Shift+s Split the current frame into two vertical,horizontal
ones  
 Ctrl+t Tab, ←, ↑, →, ↓ Switch to the next, left. top, right, bottom
frame.  
 Ctrl+t Shift+q Make the current frame the only one  
 Ctrl+t : Execute a ratpoison command  

Ratpoison and display managers
------------------------------

Many display managers (e.g., lightdm) source the available sessions from
/usr/share/xsessions/ and most window managers and desktop environments
create .desktop files there. However ratpoison instead creates a
ratpoison.desktop file in /etc/X11/sessions/. To allow display managers
to find ratpoison one may need to copy the ratpoison.desktop file from
/etc/X11/sessions/ratpoison.desktop to
/usr/share/xsessions/ratpoison.desktop. If the /usr/share/xsessions
directory does not exist, create it as root.

See also
--------

-   The Ratpoison Wiki
-   X11 Keys in Ratpoison
-   Ratpoison config sample
-   Share your Ratpoison (experience) forum thread
-   Collection of scripts for the Ratpoison window manager
-   Stumpwm similar window manager but in Common lisp.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ratpoison&oldid=251747"

Category:

-   Tiling WMs
