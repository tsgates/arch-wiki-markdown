Musca
=====

Musca A simple dynamic window manager for X, with features nicked from
ratpoison and dwm.

Note:Musca development halted in 2009 and only received community
patches since then, so be prepared for small, medium and big bugs.

If some application does not work well try it in another window manager
like openbox.

herbstluftwm is a tiling window manager similar to musca, and it is
under active development.

Contents
--------

-   1 Installation
-   2 First start
-   3 Configuration
    -   3.1 Sample .musca_start file
    -   3.2 Commands
    -   3.3 Scripts
-   4 Troubleshooting
    -   4.1 Java Virtual Machine
    -   4.2 Application loses focus
    -   4.3 Known mistakes in .musca_start
-   5 See also

Installation
------------

Musca can be installed with the package musca, available in the Arch
User Repository.

First start
-----------

Read Musca tutorial for more information.

    $ man musca

Basic default bindings:

-   Mod4+t opens xterm
-   Mod4+k closes window
-   Mod4+x launches dmenu command input
-   Mod4+m launches dmenu Musca command input
-   Mod4+h splits frame horizontally
-   Mod4+v splits frame vertically
-   Mod4+movement key(Left,Right,Up,Down) changes focus to a frame in
    the specified direction
-   Mod4+w launches dmenu window switcher
-   Mod4+g launches dmenu group switcher
-   Mod4+s switches the current group between tiling and stacking window
    modes

Configuration
-------------

Whichever method you choose, you can either modify the config.h file in
the source or use a .musca_start file to set your keybindings and to
startup your applications. Using a .musca_start file has the advantage
of not having to keep changing the config file on every update.

Musca has quite detailed information on its webpage. This section is
only to highlight some of the important features that might not be
obvious. Only a subset of features are listed here. For more detailed
information, check the Musca webpage, especially the documentation which
lists all the Musca commands and keyboard controls etc.

Sample .musca_start file

    #unset all default Musca keybindings.
    bind off all

    #set Musca keybindings
    bind on Mod4+Shift+h hsplit 1/2
    bind on Mod4+Shift+v vsplit 1/2
    bind on Mod4+Shift+r remove
    bind on Mod4+Shift+o only
    bind on Mod4+Shift+k kill
    bind on Mod1+F4 kill
    bind on Mod4+Shift+c cycle
    bind on Mod1+Tab cycle
    bind on Mod4+Left focus left
    bind on Mod4+Right focus right
    bind on Mod4+Up focus up
    bind on Mod4+Down focus down
    bind on Mod4+Tab use (next)
    bind on Mod4+Shift+Tab use (prev)
    bind on Mod4+Shift+w switch window
    bind on Mod4+Shift+g switch group
    bind on Mod4+x shell
    bind on Mod4+Shift+x command
    bind on Mod4+Shift+d dedicate flip
    bind on Mod4+Shift+a catchall flip
    bind on Mod4+Shift+u undo
    bind on Mod4+Shift+s stack flip
    bind on Mod4+Shift+Left swap left
    bind on Mod4+Shift+Right swap right
    bind on Mod4+Shift+Up swap up
    bind on Mod4+Shift+Down swap down
    bind on Mod4+Control+Left resize left
    bind on Mod4+Control+Right resize right
    bind on Mod4+Control+Up resize up
    bind on Mod4+Control+Down resize down
    bind on Mod4+Shift+q quit
    bind on Mod4+Shift+b border flip
     
    #bindings to switch between groups
    bind on Mod4+0 use 0
    bind on Mod4+1 use 1
    bind on Mod4+2 use 2
    bind on Mod4+3 use 3
    bind on Mod4+4 use 4
    bind on Mod4+5 use 5
    bind on Mod4+6 use 6
    bind on Mod4+7 use 7
    bind on Mod4+8 use 8
    bind on Mod4+9 use 9

    bind on Mod4+Shift+0 move 0
    bind on Mod4+Shift+1 move 1
    bind on Mod4+Shift+2 move 2
    bind on Mod4+Shift+3 move 3
    bind on Mod4+Shift+4 move 4
    bind on Mod4+Shift+5 move 5
    bind on Mod4+Shift+6 move 6
    bind on Mod4+Shift+7 move 7
    bind on Mod4+Shift+8 move 8
    bind on Mod4+Shift+9 move 9
      
    # dmenu settings
    #set dmenu -b -i -nb '#333333' -nf '#a8a3f7' -fn 'terminus-10'
    set dmenu -b -i -nb grey20 -nf '#a1b5cd' -fn '-*-dina-medium-r-normal-*-*-*-*-*-*-*-*-*'
    #set dmenu -b -i -nb '#0A0A0A' -nf '#A0A0A0' -fn 'helvetica 9' -sb '#285577' -sf '#FFFFFF'
      
    manage off stalonetray
    manage off Conky 

    set window_open_frame empty
    set window_open_focus 0
    set group_close_empty 1 

    pad 0 0 0 16
    exec stalonetray
    exec xbindkeys
    exec conky 

    vsplit 40%
    hsplit 20%
    exec skype 

The above .musca_start uses "Mod4+Shift+key" as the default keybinding
so that "Mod4+key" can be used to start applications or for anything
else. You can change the default keybindings to anything that you
prefer.

Commands

1) run any Musca command on the fly.

-   single Musca command:

     $ musca -c "catchall flip"

-   multiple Musca commands:

    $ echo -e "hsplit 2/3\nfocus right\nvsplit 2/3\nfocus down" | musca -i

2) "hook" - This can be extremely useful for chaining Musca commands
together or firing off scripts on certain events. For eg.

    hook on ^add pad 0 0 0 16

The above will always run the 'pad' command whenever a new group is
added using the 'add' command.  
 Therefore, when you 'add' a new group, it will automatically pad it
with the given values.

Hooking multiple Musca commands:

    hook on ^(add|use) pad 0 0 0 16

3) Musca has a list of settings that can be altered on the fly using the
following command:

    set <name> <value>

Scripts

Using musca -c as mentioned above, you can get information from Musca
and control it through a script written in your favorite language. For
example, here is a ruby script to cycle through a set of layouts. The
script knows the previous layout by looking for the presence of two
dummy files in /tmp.

    #!/usr/bin/ruby

    file1 = "/tmp/musca-layout-1"
    file2 = "/tmp/musca-layout-2"

    def musca_run f
      system "musca -c \"#{f}\""
    end

    files = [file1, file2].map{|f| File.exist? File.expand_path(f)}

    if files == [false, false]  # 0 files
      # -> hsplit, add one file
      musca_run "only"
      musca_run "hsplit 1/2"
      system "touch #{file1}"
    elsif files == [true, false]  # 1 file
      # -> vsplit, add second file
      musca_run "only"
      musca_run "vsplit 1/2"
      system "touch #{file2}"
    else           # any other number of files
      # -> only, delete all files
      musca_run "only"
      system "rm #{file1} #{file2}"
    end

To read information from Musca, use the command musca -c "show ..." or
musca -c "dump ..." where you should replace ... with an option from the
commands documentation.

Troubleshooting
---------------

Java Virtual Machine

There are various workarounds by empty and gray windows:

-   Motif-based Integration (jre)

    $ export AWT_TOOLKIT=MToolkit

Note:This workaround does not work on 64bit operating system.

-   WMNAME utility (wmname)

    $ wmname LG3D

Note:This section may be of some use:
Xmonad#Problems_with_Java_applications.

Application loses focus

-   Switch to another group and go back to previous group
    ["use (other)"]
-   Cycle over windows ["cycle prev" and "cycle next"]
-   Check for hidden dialog windows
-   Use mouse click
-   Try xdotool , example:

    $ xdotool search -name tv-browser windowactivate --sync mousemove 500 500 click 1

Known mistakes in .musca_start

-   Commenting after "bind on" command

    bind on Mod4+3 raise 2 # raise third window

-   Binding commands to same shortcut

    bind on Mod4+3 raise 2
    ...
    bind on Mod4+3 use 2

-   Misspelling

    bind on Mod4+3 rase 2

See also
--------

-   The Musca thread
-   #musca - IRC channel located at the irc.freenode.net

Retrieved from
"https://wiki.archlinux.org/index.php?title=Musca&oldid=286815"

Category:

-   Tiling WMs

-   This page was last modified on 7 December 2013, at 09:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
