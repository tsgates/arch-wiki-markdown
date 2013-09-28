Herbstluftwm
============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Herbstluftwm is a manual tiling window manager for X11 using Xlib and
Glib.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 First steps                                                        |
| -   3 Configuration                                                      |
|     -   3.1 Autostart file                                               |
|     -   3.2 Commands                                                     |
|     -   3.3 Multi-Monitor Support                                        |
|     -   3.4 Scripts                                                      |
|         -   3.4.1 Script to switch to the next empty tag                 |
|         -   3.4.2 Script to cycle though paddings (or other settings)    |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Herbstluftwm can be installed with the package herbstluftwm, available
in the Arch User Repository.

First steps
-----------

Read carefully herbstluftwm and herbstclient man pages in your favorite
terminal emulator or online (herbstluftwm, herbstclient). Also actually
read them, they contain a lot of information from an explanation of the
binary tree in which the layout is kept to config file options and
possible values.

Configuration
-------------

Copy /etc/xdg/herbstluftwm/autostart file to
$HOME/.config/herbstluftwm/autostart. You can edit that file for your
needs. Make sure the autostart file is executable, else you'll probably
end up without keybindings!

Autostart file

# sample autostart file

    #!/bin/bash

    # this is a simple config for herbstluftwm

    function hc() {
        herbstclient "$@"
    }

    hc emit_hook reload

    xsetroot -solid '#5A8E3A'

    # remove all existing keybindings
    hc keyunbind --all

    # keybindings
    Mod=Mod4
    hc keybind $Mod-Shift-q quit
    hc keybind $Mod-Shift-r reload
    hc keybind $Mod-Shift-c close
    hc keybind $Mod-u spawn urxvt

    #herbstclient load ${TAG_NAMES[0]} '(clients max:0)'

    # tags
    TAG_NAMES=( {1..4} )
    TAG_KEYS=( {1..4} 0 )

    hc rename default "${TAG_NAMES[0]}" || true
    for i in ${!TAG_NAMES[@]} ; do
        hc add "${TAG_NAMES[$i]}"
        key="${TAG_KEYS[$i]}"
        if ! [ -z "$key" ] ; then
            hc keybind "$Mod-$key" use "${TAG_NAMES[$i]}"
            hc keybind "$Mod-Shift-$key" move "${TAG_NAMES[$i]}"
        fi
    done

    # layouting
    hc keybind $Mod-r remove
    hc keybind $Mod-space cycle_layout 1
    hc keybind $Mod-v split vertical 0.5
    hc keybind $Mod-h split horizontal 0.5
    hc keybind $Mod-s floating toggle
    hc keybind $Mod-f fullscreen toggle
    hc keybind $Mod-p pseudotile toggle

    ## resizing
    RESIZESTEP=0.05
    hc keybind $Mod-Control-Left resize left +$RESIZESTEP
    hc keybind $Mod-Control-Down resize down +$RESIZESTEP
    hc keybind $Mod-Control-Up resize up +$RESIZESTEP
    hc keybind $Mod-Control-Right resize right +$RESIZESTEP

    ## mouse
    hc mousebind $Mod-Button1 move
    hc mousebind $Mod-Button2 resize
    hc mousebind $Mod-Button3 zoom

    ## focus
    hc keybind $Mod-Tab        cycle_all +1
    hc keybind $Mod-Shift-Tab  cycle_all -1
    hc keybind $Mod-c cycle
    #
    hc keybind $Mod-Left  focus left
    hc keybind $Mod-Down  focus down
    hc keybind $Mod-Up    focus up
    hc keybind $Mod-Right focus right
    #
    hc keybind $Mod-Shift-Left  shift left
    hc keybind $Mod-Shift-Down  shift down
    hc keybind $Mod-Shift-Up    shift up
    hc keybind $Mod-Shift-Right shift right

    ## colors
    hc set frame_border_active_color '#49351D'
    hc set frame_border_normal_color '#73532D'
    hc set frame_bg_normal_color '#BD9768'
    hc set frame_bg_active_color '#BD8541'
    hc set frame_border_width 2
    hc set window_border_width 2
    hc set window_border_normal_color '#AE8451'
    hc set window_border_active_color '#F6FF00'
    hc set always_show_frame 1
    hc set default_frame_layout 2
    hc set snap_distance 5
    hc set snap_gap 5

    ## rules
    hc unrule -F
    #hc rule class=XTerm tag=3 # move all xterms to tag 3
    hc rule focus=off # normally do not focus new clients
    # give focus to most common terminals
    hc rule class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on
    hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' pseudotile=on
    hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
    hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK)' manage=off
    #
    hc rule class=Opera tag=2
    hc rule class~'(MPlayer|Vlc)' tag=3 fullscreen=on

    ## if you want to start a panel, do so here
    hc pad 0 "" "" 18
    $XDG_CONFIG_HOME/herbstluftwm/restartpanels.sh
    # tint2 &

Commands

There is a tab-completion for the parameters for herbstclient. Try
herbstclient list_commands to show all parameters.

Right now there's no error message if you use wrong parameters on a
command, but only a non-zero return value. If you don't show the return
value of a command anyway (e.g. in your $SHELL-prompt), you might want
to echo $? to find the return value of the last command.

Multi-Monitor Support

Herbstluftwm supports multiple monitors independent of the monitors
reported by xrandr, but instead by taking care of monitors itself. While
this may seem tedious or clumsy at first, it brings a lot of flexibility
and gives the user more control over his/her monitor-arrangement. To
make a region of your monitor known to herbstluftwm as new display use
the add_monitor command: herbstclient add_monitor 1920x1080+1280+0 4 to
add your external monitor with a resolution of 1920x1080 right of you
laptop display with a resolution of 1280x800 and display tag 4 on the
external monitor.

To resize/move a herbstluftwm-monitor use the move_monitor command. A
list of all currently defined monitors can be shown by list_monitors and
removing monitors is done by remove_monitor. The manpage gives
additional detail and examples.

> Scripts

The main way to control herbstluftwm is though commands to herbstclient.
Since herbstclient can be called from any script, you have great
flexibility in controlling herbstluftwm this way.

Script to switch to the next empty tag

The following ruby script allows you to switch to the (next or previous)
(full or empty) tag. Call it with the arguments (+1 or -1) and (full or
empty). For example, if you save the script to herbst-move.rb, then

    ruby herbst-move.rb +1 full

will move you to the next full tag. I use the following key bindings.

    hc keybind $Mod-Left  spawn ruby /home/carl/Ruby/herbst-move.rb -1 empty
    hc keybind $Mod-Right spawn ruby /home/carl/herbst-move.rb +1 empty
    hc keybind $Mod-Up spawn ruby /home/carl/Ruby/herbst-move.rb -1 full
    hc keybind $Mod-Down spawn ruby /home/carl/Ruby/herbst-move.rb +1 full

And here is the script.

    #!/usr/local/bin/ruby

    incr, type = ARGV

    d = incr.to_i
    if type == 'full'
      ch = '.'
    else
      ch = ':'
    end

    array = `herbstclient tag_status 0`.scan(/[:\.\#][^\t]*/)
    len = array.length
    orig = array.find_index{|e| e[0] == '#'}

    i = (orig+d) % len
    while 
      array[i][0] == ch
      i = (i+d) % len
    end

    if i != orig
      system "herbstclient use_index #{i}"
    end

Script to cycle though paddings (or other settings)

Here is a ruby script to cycle through a set of paddings, although you
can modify it to cycle though any collection of settings. The script
knows the previous layout by looking for the presence of two dummy files
in /tmp.

    #!/usr/bin/ruby

    file1 = "/tmp/herbst-padding-1"
    file2 = "/tmp/herbst-padding-2"

    pad1 = 'pad 0 0 0 0 0'
    pad2 = 'pad 0 0 20 0 200'
    pad3 = 'pad 0 0 0 0 150'

    files = [file1, file2].map{|f| File.exist? File.expand_path(f)}

    if files == [false, false]  # 0 files
      system "herbstclient #{pad2}"
      system "touch #{file1}"
    elsif files == [true, false]  # 1 file
      system "herbstclient #{pad1}"
      system "touch #{file2}"
    else           # 2 files
      system "herbstclient #{pad3}"
      system "rm #{file1} #{file2}"
    end

See also
--------

-   The herbstwm homepage
-   The herbstluftwm thread
-   /usr/share/doc/herbstluftwm/examples/ - various scripts
-   /usr/share/doc/herbstluftwm/BUGS - bugs
-   A herbstluftwm thread on the CrunchBang Forums
-   Screenshots and configuration files: on ArchLinux Forum, on
    DotShare.it
-   #herbstluftwm - IRC channel at the irc.freenode.net

Retrieved from
"https://wiki.archlinux.org/index.php?title=Herbstluftwm&oldid=252756"

Category:

-   Tiling WMs
