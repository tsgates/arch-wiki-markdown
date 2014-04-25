GNU Screen
==========

GNU Screen is a wrapper that allows separation between the text program
and the shell from which it was launched. This allows the user to, for
example, start a text program in a terminal in X, kill X, and continue
to interact with the program. Here are a couple of tips and tricks you
may be interested in.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 Common Commands
    -   2.2 Command Prompt Commands
    -   2.3 Named sessions
-   3 Tips and tricks
    -   3.1 Change the escape key
    -   3.2 Start at window 1
    -   3.3 Nested Screen Sessions
    -   3.4 Use 256 colors
    -   3.5 Use 256 Colors with Rxvt-Unicode (urxvt)
    -   3.6 Informative statusbar
    -   3.7 Turn welcome message off
    -   3.8 Turn your hardstatus line into a dynamic urxvt|xterm|aterm
        window title
    -   3.9 Use X scrolling mechanism
    -   3.10 Attach an existing running program to screen
    -   3.11 Add a GRUB entry to boot into Screen
    -   3.12 Setting a different bash prompt while in screen
    -   3.13 Turn off visual bell
-   4 Troubleshooting
    -   4.1 Fix Midnight Commander hard hang when starting in screen
    -   4.2 Fix for residual editor text
-   5 See Also

Installation
------------

GNU Screen can be installed using the screen package found in the
official repositories.

Usage
-----

Commands are entered pressing ctrl+a and then the key binding.

> Common Commands

-   ctrl+a ? Displays commands and its defaults (VERY important)
-   ctrl+a : Enter to the command prompt of screen
-   ctrl+a " Window list
-   ctrl+a 0 opens window 0
-   ctrl+a A Rename the current window
-   ctrl+a a Sends ctrl+a to the current window
-   ctrl+a c Create a new window (with shell)
-   ctrl+a S Split current region into two regions
-   ctrl+a tab Switch the input focus to the next region
-   ctrl+a ctrl+a Toggle between current and previous region
-   ctrl+a Esc Enter Copy Mode (use enter to select a range of text)
-   ctrl+a ] Paste text
-   ctrl+a Q Close all regions but the current one
-   ctrl+a X Close the current region
-   ctrl+a d Detach from the current screen session, and leave it
    running. Use screen -r to resume

> Command Prompt Commands

-   ctrl+a :quit Closes all windows and closes screen session
-   ctrl+a :source ~/.screenrc Reloads screenrc configuration file (can
    alternatively use /etc/screenrc)

> Named sessions

To create a named session, run screen with the following command:

    $ screen -S session_name

To prints a list of pid.tty.host strings identifying your screen
sessions:

    $ screen -list

To attach to a named screen session, run this command:

    $ screen -x session_name

Tips and tricks
---------------

> Change the escape key

The escape key can be changed with the escape option in ~/.screenrc. For
example:

    escape ``

sets the escape key to `.

> Start at window 1

By default, the first screen window is 0. If you'd rather never have a
window 0 and start instead with 1, add the following lines on your
configuration:

    ~/.screenrc

    bind c screen 1
    bind ^c screen 1
    bind 0 select 10                                                            
    screen 1

> Nested Screen Sessions

It is possible to get stuck in a nested screen session. A common
scenario: you start an ssh session from within a screen session. Within
the ssh session, you start screen. By default, the outer screen session
that was launched first responds to ctrl+a commands. To send a command
to the inner screen session, use ctrl+a a, followed by your command. For
example:

-   ctrl+a a d Detaches the inner screen session.
-   ctrl+a a K Kills the inner screen session.

> Use 256 colors

By default, screen uses an 8-color terminal emulator. Use the following
line to enable more colors, which is useful if you are using a
more-capable terminal emulator:

    ~/.screenrc

    term screen-256color

If this fails to render 256 colors in xterm, try the following instead:

    ~/.screenrc

    attrcolor b ".I"    # allow bold colors - necessary for some reason
    termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'   # tell screen how to set colors. AB = background, AF=foreground
    defbce on    # use current bg color for erased chars

> Use 256 Colors with Rxvt-Unicode (urxvt)

If you are using rxvt-unicode from the official repositories, you may
need to add this line in your ~/.screenrc to enable 256 colors while in
screen.

    ~/.screenrc

    terminfo rxvt-unicode 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'

> Informative statusbar

The default statusbar may be a little lacking. You may find this one
more helpful:

    ~/.screenrc

    hardstatus off
    hardstatus alwayslastline
    hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W} %c %{g}]'

> Turn welcome message off

    ~/.screenrc

    startup_message off

> Turn your hardstatus line into a dynamic urxvt|xterm|aterm window title

This one is pretty simple; just switch your current hardstatus line into
a caption line with notification, and edit accordingly:

    ~/.screenrc

    backtick 1 5 5 true
    termcapinfo rxvt* 'hs:ts=\E]2;:fs=\007:ds=\E]2;\007'
    hardstatus string "screen (%n: %t)"
    caption string "%{= kw}%Y-%m-%d;%c %{= kw}%-Lw%{= kG}%{+b}[%n %t]%{-b}%{= kw}%+Lw%1`"
    caption always

This will give you something like screen (0 bash) in the title of your
terminal emulator. The caption supplies the date, current time, and
colorizes your screen window collection.

> Use X scrolling mechanism

The scroll buffer of GNU Screen can be accessed with ctrl+a [. However,
this is very inconvenient. To use the scroll bar of e.g. xterm or
konsole, add the following line:

    ~/.screenrc

    termcapinfo xterm* ti@:te@

> Attach an existing running program to screen

If you started a program outside screen, but now you would like it to be
inside, you can use reptyr to reparent the process from it's current tty
to one inside screen.

Install the package reptyr from the official repositories.

Get the PID of the process (you can use ps ax for that). Now just enter
the PID as argument to reptyr inside a screen window.

    $ reptyr <pid>

> Add a GRUB entry to boot into Screen

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Initscripts is   
                           deprecated, and the use  
                           of runlevels as well.    
                           Also, this instructions  
                           are for legacy GRUB      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you mostly use X but occasionally want to run a
Screen-as-window-manager session, here is one way to do it by adding a
GRUB entry for Screen on a virtual console (text terminal).

GRUB allows you to designate what runlevel you want so we will use
runlevel 4 for this purpose. Clone an appropriate GRUB entry and add a 4
to the kernel boot parameters list, like so:

    # (0) Arch Linux
    title  Arch Linux Screen
    root   (hd0,2)
    kernel /vmlinuz-linux root=/dev/disk/your_disk ro acpi_no_auto_ssdt irqpoll 4
    initrd /initramfs-linux.img

Add some entries to /etc/inittab to indicate what should happen on
runlevel 4, substituting your user name for <user>:

    # GNU Screen on runlevel 4
    scr2:4:respawn:/sbin/mingetty --autologin <user> tty1 linux

The above line uses mingetty to automatically login some user to a
virtual console on startup. The inittab line segments are separated by
colons. The first part (scr*) is simply an id. The second part is the
runlevel: This should only happen on runlevel 4 (which is not used in
any default setup - 3 is by default for a tty login and 5 is for X).
'Respawn' causes init to repeat the command (i.e. autologin) if the user
logs out. We will need to see that nothing else happens on virtual
console 1 when we use runlevel 4, so remove 4 from the the first of the
agetty lines:

    c1:235:respawn:/sbin/agetty -8 38400 vc/1 linux

Once we are logged in, we want to ensure that screen is started. Add the
following to the end of your ~/.bash_profile:

    vico="$(tty | grep -oE ....$)"
    case "$vico" in
       tty1) TERM=screen; exec /usr/bin/screen -R arch;;
    esac

This checks for the current runlevel and will launch a screen session
immediately after the automatic login if the runlevel is 4.

This can also be adapted to run screen on a virtual console next to X,
simply checking for the current tty instead of the current runlevel.
This checks to see if we are on virtual console 3:

    vico="$(tty | grep -oE ....$)"
    case "$vico" in
      vc/3) TERM=screen; exec /usr/bin/screen;;
    esac

Set inittab/mingetty to automatically log in to vc/3 on runlevel 5 and
you are set.

> Setting a different bash prompt while in screen

If you want a different bash prompt when in a screen session, add the
following to your .bashrc:

    if [ -z $STY ]
    then
            PS1="YOUR REGULAR PROMPT"
    else  
            PS1="YOUR SCREEN PROMPT"
    fi

[1]

> Turn off visual bell

With this setting, screen will not make an ugly screen flash instead of
a bell sound.

    ~/.screenrc

    vbell off

Troubleshooting
---------------

> Fix Midnight Commander hard hang when starting in screen

In some cases (need deeper inspection) old gpm bug gets alive. So, then
you try to run mc inside screen, you get a frozen screen window. Try to
kill gpm daemon before starting mc and/or disable it in /etc/rc.conf.

> Fix for residual editor text

When you open a text editor like nano in screen and then close it, the
text may stay visible in your terminal. To fix this, put the following:

    ~/.screenrc

    altscreen on

See Also
--------

-   MacOSX Hints - Automatically using screen in your shell
-   Gentoo Wiki - Tutorial for screen
-   Arch Forums - Regarding 256 color issue with urxvt
-   Arch Forums - .screenrc configs with screenshots
-   tmux, another multiplexer
-   Ratpoison - A window manager based on gnu screen
-   Xpra - An utility to detach/reattach X programs, in a way similar as
    screen does for command line based programs

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNU_Screen&oldid=301778"

Category:

-   System administration

-   This page was last modified on 24 February 2014, at 15:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
