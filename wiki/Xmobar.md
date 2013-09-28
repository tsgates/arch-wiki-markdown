Xmobar
======

xmobar is a lightweight, text-based, status bar written in Haskell. It
was originally designed to be used together with Xmonad, but it is also
usable with any other Window Manager. While xmobar is written in
Haskell, no knowledge of the language is required to install and use it.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running xmobar                                                     |
| -   3 Configuration                                                      |
| -   4 Tips and tricks                                                    |
|     -   4.1 Gmail integration                                            |
|     -   4.2 MPD integration                                              |
|     -   4.3 Conky-Cli integration                                        |
|     -   4.4 Simple conky-cli integration                                 |
|                                                                          |
| -   5 More resources                                                     |
+--------------------------------------------------------------------------+

Installation
------------

xmobar is in the community repository and can be installed with pacman:

    # pacman -S xmobar

The development version xmobar-git and the gmail monitoring version
xmobar-gmail-darcs can be found in the AUR.

Running xmobar
--------------

If the configuration file is saved as ~/.xmobarrc:

    $ xmobar &

Alternatively, the path to a configuration file can be specified:

    $ xmobar /path/to/config &

The following is an example of how to configure xmobar using command
line options:

    $ xmobar -B white -a right -F blue -t '%LIPB%' -c '[Run Weather "LIPB" [] 36000]' &

This will run xmobar right-aligned, with white background and blue text,
using the Weather plugin. Note that the output template must contain at
least one command. Read the following section for further explanation of
options.

Configuration
-------------

The configuration for xmobar is normally defined in ~/.xmobarrc or by
specifying a set of command line options when launching xmobar. Any
given command line option will override the corresponding option in the
configuration file. This can be useful to test new configurations
without having to edit a configuration file.

  
 Following is an example ~/.xmobarrc file, followed by a description of
each option. Note that each option has a corresponding command line
option.

    Config { font = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
           , bgColor = "black"
           , fgColor = "grey"
           , position = Top
           , lowerOnStart = True
           , commands = [ Run Weather "EGPF" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                        , Run Network "eth0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                        , Run Network "eth1" ["-L","0","-H","32","--normal","green","--high","red"] 10
                        , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                        , Run Memory ["-t","Mem: <usedratio>%"] 10
                        , Run Swap [] 10
                        , Run Com "uname" ["-s","-r"] "" 36000
                        , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                        ]
           , sepChar = "%"
           , alignSep = "}{"
           , template = "%cpu% | %memory% * %swap% | %eth0% - %eth1% }{ <fc=#ee9a00>%date%</fc>| %EGPF% | %uname%"
           }

-   font - The name of the font to use. If XFT fonts are enabled, prefix
    XFT font names with "xft:".

Example:

    font = "xft:Bitstream Vera Sans Mono:size=8:antialias=true"

-   fgColor - The colour of the font, takes both colour names like black
    and hex colours like #000000.
-   bgColor - The colour of the bar, takes both colour names like red
    and hex colours like #ff0000.
-   position - The position of the bar. Keywords are:
    Top/Bottom, TopW/BottomW and Static.
    -   Top/Bottom - The top/bottom of the screen.
    -   TopW/BottomW - The top/bottom of the screen with a fixed width.
        TopW/BottomW takes 2 arguments:
        -   Alignment: Left, Center or Right aligned.
        -   Width: An integer for the width of the bar in percentage.

    -   Static - A fixed position on the screen, with a fixed width.
        Static takes 4 arguments:
        -   xpos: Horisontal position in pixels, starting at the upper
            left corner.
        -   ypos: Vertical position in pixels, starting at the upper
            left corner.
        -   width: The width of the bar in pixels.
        -   height: The height of the bar in pixels.

Example - centered at the bottom of the screen, with a width of 75% of
the screen:

    position = BottomW C 75

Example - top left of the screen, with a width of 1024 pixels and height
of 15 pixels:

    position = Static { xpos = 0 , ypos = 0, width = 1024, height = 15 }

-   commands For setting the options of the programs to run. Commands is
    a comma seperated list of commands, optionally specified with
    options.

Example - runs the Memory plugin, with the specified template and the
Swap plugin, with default args. Both updates every second:

    commands = [Run Memory ["-t","Mem: <usedratio>%"] 10, Run Swap [] 10]

-   sepChar - The character to be used for indicating commands in the
    output template. Default character is "%".
-   alignSep - A string of characters for aligning text in the output
    template. The text before the first character will be left aligned,
    the text between them will be centered, and the text to the right of
    the last character will be right aligned. Default string is "}{".
-   template - The output template is a string containing the text and
    commands that will be displayed. It contains the alias for a
    %command%, written text and color tags that sets the colour of text.

Example:

    template = "%StdinReader%}{%cpu% %memory% <fc=#ffaaff>battery:</fc> %battery% %date%"

Tips and tricks
---------------

There are various plugins that can be used with xmobar - to name a few,
there are plugins for disk usage, ram, cpu, battery status, weather
report and network activity. A detailed description of each plugin, its
dependencies and how to configure it is on the project website.

> Gmail integration

Assuming you have xmobar-gmail-darcs installed, you can configure
.xmobarrc as follows. Add the gmail plugin to the commands list:

    , Run GMail "gmail.username" "GmailPassword" ["-t", "Mail: <count>"] 3000

Then add the command to the template

    , template = "... %gmail.username% ..."

> MPD integration

Assuming you have xmobar-git installed (with haskell-libmpd), there is a
plugin to pull information to display on the status bar about the
currently playing song. To add a simple plugin displaying the artist and
song of the current track, add this line to your commands list in your
~/.xmobarrc:

    , Run MPD ["-t", "<state>: <artist> - <track>"] 10

Finally, you will need to place the plugin some place in your template,
as follows:

    , template = "%StdinReader% }{ ... %mpd% ..."

> Conky-Cli integration

It is possible to utilize the features of conky-cli such as disk space,
top and system messages, by piping the information from conky into a
text file and read the contents from it. Following is a bash script to
use with xmobar for this purpose.

    #!/bin/bash
    # Filename: ~/.xmonad/conkyscript
    conky -c ~/.conkyclirc -i1 -q > conkystat &
    sleep 4
    killall -q conky
    cat conkystat
    rm conkystat

Add the following line to the commands section in ~/.xmobarrc.

    , Run Com ".xmonad/conkyscript" ["&"] "conky" 300

This makes the script run every 30 seconds.

Then add the following to your .xinitrc before the exec xmonad entry.

    .xmonad/conkyscript &
    sleep 6 && xmobar &

Then add %conky% to your template section.

> Simple conky-cli integration

Just place this code:

    Run Com "conky" ["-q", "-i", "1"] "conky" 600

in your .xmobarrc.

More resources
--------------

-   xmobar hackage
-   xmobar project
-   dzen and xmobar hacking thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xmobar&oldid=222353"

Categories:

-   Eye candy
-   Application launchers
