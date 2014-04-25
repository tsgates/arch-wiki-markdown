Configure virtual console colors
================================

The colors in the Linux virtual console running on the framebuffer can
be changed. This is done by writing the escape code \\e]PXRRGGBB where X
is the hexadecimal index of the color from 0-F, and RRGGBB is a
traditional hexadecimal RGB code.

Reusing ~/.Xdefaults settings
-----------------------------

To reuse the color configuration from ~/.Xdefaults, add the following
snippet to the shell init script (.bashrc/.zshrc/...).

    if [ "$TERM" = "linux" ]; then
        _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
        for i in $(sed -n "$_SEDCMD" $HOME/.Xdefaults | \
                   awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
            echo -en "$i"
        done
        clear
    fi

Virtual Console Login Screen
----------------------------

Changing the default Virtual Console Login screen. Take a backup of your
original /etc/issue like mv /etc/issue /etc/issue.bak. Make a new file
called issue in your /etc/ folder and input the following below.

    echo -e '\e[H\e[2J' > issue
    echo -e '                                                            \e[1;30m| \e[34m\\s \\r' >> issue
    echo -e '       \e[36;1m/\\\\                      \e[37m||     \e[36m| |                   \e[30m|' >> issue
    echo -e '      \e[36m/  \\\\                     \e[37m||     \e[36m|     _               \e[30m| \e[32m\\t' >> issue
    echo -e '     \e[1;36m/ \e[0;36m.. \e[1m\\\\   \e[37m//==\\\\\\\\ ||/= /==\\\\ ||/=\\\\  \e[36m| | |/ \\\\ |  | \\\\ /     \e[30m| \e[32m\\d' >> issue
    echo -e '    \e[0;36m/ .  . \\\\  \e[37m||  || ||   |    ||  || \e[36m| | |  | |  |  X      \e[1;30m|' >> issue
    echo -e '   \e[0;36m/  .  .  \\\\ \e[37m\\\\\\\\==/| ||   \\\\==/ ||  || \e[36m| | |  | \\\\_/| / \\\\     \e[1;30m| \e[31m\\U' >> issue
    echo -e '  \e[0;36m/ ..    .. \\\\   \e[0;37mA simple, lightweight linux distribution.  \e[1;30m|' >> issue
    echo -e ' \e[0;36m/_\x27        `_\\\\                                             \e[1;30m| \e[35m\\l \e[0mon \e[1;33m\\n' >> issue
    echo -e ' \e[0m' >> issue
    echo -e  >> issue

Save the file, then chmod +x issue and your done.

To restore your original issue just run the following:
mv /etc/issue /etc/issue.old && mv /etc/issue.bak /etc/issue.

Credits & Original thread can be found here:
https://bbs.archlinux.org/viewtopic.php?pid=386429#p386429

Retrieved from
"https://wiki.archlinux.org/index.php?title=Configure_virtual_console_colors&oldid=218424"

Category:

-   Eye candy

-   This page was last modified on 17 August 2012, at 13:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
