rxvt-unicode
============

rxvt-unicode is a highly customizable terminal emulator forked from
rxvt. Commonly known as urxvt, rxvt-unicode can be daemonized to run
clients within a single process in order to minimize the use of system
resources. Developed by Marc Lehmann, some of the more outstanding
features of rxvt-unicode include international language support through
Unicode, the ability to display multiple font types and support for Perl
extensions.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Creating ~/.Xresources
    -   2.2 True transparency
    -   2.3 Native transparency
    -   2.4 Scrollbar
    -   2.5 Scrollback Position
    -   2.6 Font Declaration Methods
    -   2.7 Set icon
    -   2.8 Set as Login Shell
    -   2.9 Use urxvt as application launcher
    -   2.10 Font spacing
-   3 Perl extensions
    -   3.1 Clickable URLs
    -   3.2 Yankable URLs (No Mouse)
    -   3.3 Simple tabs
    -   3.4 Advanced tab management
    -   3.5 Fullscreen
    -   3.6 Scrollwheel Support
    -   3.7 Changing font size on the fly
    -   3.8 Disabling Perl extensions
-   4 Colors
-   5 Improving Performance
    -   5.1 Daemon-Client setup through systemd
-   6 Cut and Paste
    -   6.1 Default Key Bindings
    -   6.2 Clipboard Management
    -   6.3 Automatic Script Management
-   7 Improved Kuake-like Behavior in Openbox
    -   7.1 Scriptlets
    -   7.2 urxvtq with tabbing
        -   7.2.1 Tab control
    -   7.3 Openbox configuration
    -   7.4 Further configuration
    -   7.5 Related scripts
-   8 Troubleshooting
    -   8.1 ~/.Xresources is not being sourced
    -   8.2 Transparency not working after upgrade to v9.09
    -   8.3 Remote Hosts
    -   8.4 Using rxvt-unicode as gmrun terminal
    -   8.5 My numerical keypad acts weird and generates differing
        output? (e.g. in vim)
    -   8.6 Pseudo-tty
-   9 External resources

Installation
------------

rxvt-unicode is available in the official repositories and includes 256
color support.

rxvt-unicode-patched is available in the AUR and includes a fix for the
font width bug.

Configuration
-------------

See the rxvt-unicode reference page for the complete list of available
setting and values.

> Creating ~/.Xresources

The look, feel, and function of rxvt-unicode is controlled by
command-line arguments and/or X resources. X resources can be set using
~/.Xresources and xrdb (xorg-xrdb), see the wiki page for details.

Append commented list of all rxvt resources to your ~/.Xresources file

     urxvt --help 2>&1| sed -n '/:  /s/^ */! URxvt*/gp' >> ~/.Xresources

Or for a commented list + helpful descriptions

    TERM=dump command man -Pcat urxvt | sed -n '/depth: b/,/^BA/p'|sed '$d'|sed '/^       [a-z]/s/^ */^/g'|sed -e :a -e 'N;s/\n/@@/g;ta;P;D'|sed 's,\^\([^@]\+\)@*[\t ]*\([^\^]\+\),! \2\n! URxvt*\1\n\n,g'|sed 's,@@\(  \+\),\n\1,g'|sed 's,@*$,,g'|sed '/^[^!]/d'|tr -d "'\`" >> ~/.Xresources

Note:Command-line arguments override, and take precedence over resource
settings

> True transparency

To use true transparency, you need to be using a window manager that
supports compositing or a separate compositor.

From the command-line:

    $ urxvt -depth 32 -bg rgba:3f00/3f00/3f00/dddd

Using the configuration file:

    ~/.Xresources

    URxvt.depth: 32
    URxvt.background: rgba:1111/1111/1111/dddd

or

    ~/.Xresources

    URxvt.depth: 32
    URxvt.background: [95]#000000

where '95' is the opacity level in percentage and '#000000' is the
background color.

To use a color i.e. #302351 with the rgba:rrrr/gggg/bbbb/aaaa syntax it
would be rgba:3000/2300/5100/ee00. "ee00" (the alpha value) to make it
nicely transparent.

Note:To make these settings universal for all forms of URxvt, you may
add a wildcard. For example, URxvt.depth would become URxvt*.depth.

> Native transparency

If there is no need for true transparency, or if compositing uses too
many resources on your system, you can get transparency working in the
following way:

    ~/.Xresources

    ! Xresources file

    URxvt*.transparent: true
    ! URxvt*.shading: 0 to 99 darkens, 101 to 200 lightens
    URxvt*.shading: 110

Using the URxvt*background setting exemplified above instead of
URxvt*.shading will also work.

Note:Avoid using shading if you have a URxvt.tintColor set. Use a
different tintColor instead.

> Scrollbar

The look of the scrollbar can be chosen through this entry in
~/.Xresources:

    ! scrollbar style - rxvt (default), plain (most compact), next, or xterm
    URxvt.scrollstyle: rxvt

The scrollbar can also be completely deactivated like so:

    URxvt.scrollBar: false

> Scrollback Position

By default, when shell output appears the scrollback view will
automatically jump to the bottom of the buffer to display new output. If
in cases where you want to see previous output (e.g., compiler
messages), set the following options in ~/.Xresources:

    ! do not scroll with output
    URxvt*scrollTtyOutput: false

    ! scroll in relation to buffer (with mouse scroll or Shift+Page Up)
    URxvt*scrollWithBuffer: true

    ! scroll back to the bottom on keypress
    URxvt*scrollTtyKeypress: true

> Font Declaration Methods

    URxvt.font: 9x15

is the same as:

    URxvt.font: -misc-fixed-medium-r-normal--15-140-75-75-c-90-iso8859-1

And, for the same font in bold:

    URxvt.font: 9x15bold

is the same as:

    URxvt.font: -misc-fixed-bold-r-normal--15-140-75-75-c-90-iso8859-1

The complete list of short names for X core fonts can be found in
/usr/share/fonts/misc/fonts.alias (there's also some fonts.alias files
in some of the other subdirectories of /usr/share/fonts/, but as they
are packaged separately from the actual fonts, they may list fonts you
do not actually have installed). It is worth noting that these short
aliases select for ISO-8859-1 versions of the fonts rather than
ISO-10646-1 (Unicode) versions, and 75 DPI rather than 100 DPI versions,
so you're probably better off avoiding them and choosing fonts by their
full long names instead.

Note:The above paragraph is only for bitmap fonts. Other fonts can be
used through Xft using the following format:

    URxvt.font: xft:monaco:size=10

Or

    URxvt.font: xft:monaco:bold:size=10

Note:If there is a hyphen(-) in an Xft font name, it must be escaped
with backslash(\) twice. It's different from the usage of urxvt -fn
option and the result that fc-list returns, where backslash present only
once

> Set icon

Note:Because of a bug report[1] complaining that the rxvt-unicode
package had too many dependencies, you must now install the AUR package
rxvt-unicode-pixbuf in order to use the icon option.

By default URxvt does not feature a taskbar icon. However, this can be
easily changed by adding the following line to ~/.Xresources and
pointing to the desired icon:

    URxvt.iconFile:    /usr/share/icons/Clarity/scalable/apps/terminal.svg

> Set as Login Shell

This will cause the shell to be started as a login shell, like the
option -ls.

    URxvt*loginShell: true

> Use urxvt as application launcher

urxvt can be used as a lightweight alternative to application launchers
such as gmrun. Run urxvt with the following configuration to imitate
look and behaviour of an application launcher or assign the command to a
custom alias:

    $ urxvt -geometry 80x3 -name 'bashrun' -e sh -c "/bin/bash -i -t"

> Font spacing

By default the distance between characters can feel too wide. It's
controlled by this entry:

    ~/.Xresources

    URxvt.letterSpace: -1

Here -1 decreases the spacing by one pixel, but can be adjusted as
needed.

Perl extensions
---------------

> Clickable URLs

You can make URLs in the terminal clickable using the matcher extension.
For example, to open links in Firefox add the following to .Xresources:

    URxvt.perl-ext-common: default,matcher
    URxvt.url-launcher: /usr/bin/firefox
    URxvt.matcher.button: 1

Since rxvt-unicode 9.14, it's also possible to use matcher to open and
list recent (currently limited to 10) URLs via keyboard:

    URxvt.keysym.C-Delete: perl:matcher:last
    URxvt.keysym.M-Delete: perl:matcher:list

To color all matching text in a blue color for quickly finding links,
use the following setting or any color in the form of #RRGGBB you like
instead.

    URxvt.colorUL: #4682B4

> Yankable URLs (No Mouse)

In addition, you can select and open URLs in your web browser without
using the mouse.

Install the urxvt-perls package from the official repositories and
adjust your .Xresources as necessary. An example is shown below:

    URxvt.perl-ext: default,url-select
    URxvt.keysym.M-u: perl:url-select:select_next
    URxvt.url-select.launcher: /usr/bin/firefox -new-tab
    URxvt.url-select.underline: true

Note:This extension replaces the Clickable URLs extension mentioned
above, so matcher can be removed from the URxvt.perl-ext list.

Key commands:

Tip:To change Alt+u to a more intuitive Ctrl+i, replace M-u by C-i
above.

Alt+u Enter selection mode. The last URL on your screen will be
selected. You can repeat Alt+u to select the next upward URL.

k Select next upward URL

j Select next downward URL

Return Open selected URL in browser and quit selection mode

o Open selected URL in browser without quitting selection mode

y Copy (yank) selected URL and quit selection mode

Esc Cancel URL selection mode

> Simple tabs

To add tabs to urxvt, add the following to your ~/.Xresources:

    URxvt.perl-ext-common: ...,tabbed,...

To control tabs use:

Shift+ ↓ new tab

Shift+ ← go to left tab

Shift+ → go to right tab

Ctrl+ ← move tab to the left

Ctrl+ → move tab to the right

Ctrl+D: close tab

You can change the colors of tabs with the following:

    URxvt.tabbed.tabbar-fg: 2
    URxvt.tabbed.tabbar-bg: 0
    URxvt.tabbed.tab-fg: 3
    URxvt.tabbed.tab-bg: 0

> Advanced tab management

Install the urxvt-tabbedex package from AUR, then add the tabbedex value
to the URxvt.perl-ext-common X resource in your ~/.Xresources:

    URxvt.perl-ext-common: ...,tabbedex,...

Note:If you have previously used the tabbed Perl extension and have
defined the tabbed value for the URxvt.perl-ext-common X resource,
please remove the tabbed value first to avoid conflict with tabbedex.

By default, the "[NEW]" button (which is rarely used and usable only
with the mouse) is disabled with tabbedex. You can reenable this feature
by setting the new-button to yes.

    URxvt.tabbed.new-button: true

Tabs can be named with Shift+ ↑ (Enter to confirm, Escape to cancel).

To automatically hide the tabs bar when only one tab is present, enable
the following resource:

    URxvt.tabbed.autohide: true

To prevent the last tab from closing Urxvt, enable the following
resource:

    URXvt.tabbed.reopen-on-close: yes

To start a new tab or cycle through tabs, use the following user
commands: tabbedex:(new|next|prev)_tab. Example of mappings:

    URxvt.keysym.Control-t: perl:tabbedex:new_tab
    URxvt.keysym.Control-Tab: perl:tabbedex:next_tab
    URxvt.keysym.Control-Shift-Tab: perl:tabbedex:prev_tab

To define your own key bindings to rename a tab or move a tab to the
right or to the left, use the following commands:
tabbedex:move_tab_(left|right) and tabbedex:rename_tab. Example of
mappings:

    URxvt.keysym.Control-Shift-Left: perl:tabbedex:move_tab_left
    URxvt.keysym.Control-Shift-Right: perl:tabbedex:move_tab_right
    URxvt.keysym.Control-Shift-R: perl:tabbedex:rename_tab

Note:Redefining the keys used for the user commands will not disable the
default mappings, you have to set the X resource no-tabbedex-keys for
that:

    URxvt.tabbed.no-tabbedex-keys: true

> Fullscreen

You can install the AUR package urxvt-fullscreen, and then set a key
binding to put urxvt fullscreen.

    ~/.Xresources

    ...
    URxvt.perl-ext-common: ..., fullscreen, ...
    URxvt.keysym.F11: perl:fullscreen:switch
    ...

> Scrollwheel Support

Install urxvt-vtwheel from the AUR and add it to your Perl extensions
within ~/.Xresources:

     URxvt.perl-ext-common:  ...,vtwheel,...

> Changing font size on the fly

Install urxvt-font-size-git from the AUR, add it to your Perl extensions
within ~/.Xresources

     URxvt.perl-ext-common:  ...,font-size,...

and add some key bindings, for example like this:

     URxvt.keysym.C-Up:     perl:font-size:increase
     URxvt.keysym.C-Down:   perl:font-size:decrease
     URxvt.keysym.C-S-Up:   perl:font-size:incglobal
     URxvt.keysym.C-S-Down: perl:font-size:decglobal

For the suggested Ctrl+Shift bindings to work, a default binding needs
to be disabled (see discussion here):

     URxvt.iso14755: false
     URxvt.iso14755_52: false

> Disabling Perl extensions

If you do not use the Perl extension features, you can improve the
security and speed by disabling Perl extensions completely.

    URxvt.perl-ext:
    URxvt.perl-ext-common:

Colors
------

Colors must be specified using color indexes: 0 to 15 correspond with
the colors from the rxvt manual "Colors and Graphics" Section.

    COLORS AND GRAPHICS

    If graphics support was enabled at compile-time, rxvt can be queried with ANSI escape sequences and can address individual pixels instead of text
    characters. Note the graphics support is still considered beta code.

    In addition to the default foreground and background colours, rxvt can display up to 16 colours (8 ANSI colours plus high-intensity bold/blink
    versions of the same). Here is a list of the colours with their rgb.txt names.

    color0 	(black) 	= Black
    color1 	(red) 	        = Red3
    color2 	(green) 	= Green3
    color3 	(yellow) 	= Yellow3
    color4 	(blue) 	        = Blue3
    color5 	(magenta) 	= Magenta3
    color6 	(cyan) 	        = Cyan3
    color7 	(white) 	= AntiqueWhite
    color8 	(bright black) 	= Grey25
    color9 	(bright red) 	= Red
    color10 (bright green) 	= Green
    color11 (bright yellow) = Yellow
    color12 (bright blue) 	= Blue
    color13 (bright magenta)= Magenta
    color14 (bright cyan) 	= Cyan
    color15 (bright white) 	= White
    foreground 		= Black
    background 		= White

    It is also possible to specify the colour values of foreground, background, cursorColor, cursorColor2, colorBD, colorUL as a number 0-15, as a
    convenient shorthand to reference the colour name of color0-color15.

    Note that -rv ("reverseVideo: True") simulates reverse video by always swapping the foreground/background colours. This is in contrast to xterm(1)
    where the colours are only swapped if they have not otherwise been specified. For example,

    rxvt -fg Black -bg White -rv
        would yield White on Black, while on xterm(1) it would yield Black on White.

Improving Performance
---------------------

-   Avoid the use of Xft fonts. If Xft fonts must be used, append
    :antialias=false to the setting value.[2]

-   Build rxvt-unicode with disabled support for unnecessary features,
    --disable-xft and --disable-unicode3 in particular.[3]

-   Limit the number of saveLines (option -sl) in the scrollback buffer
    to reduce memory usage.[4]
    -   Use tmux for scrollback buffer and set saveLines to 0

-   Disable perl

-   Consider running urxvtd as a daemon accepting connections from
    urxvtc clients.

Daemon-Client setup through systemd

    /etc/systemd/system/urxvtd@.service

    [Unit]
    Description=RXVT-Unicode Daemon

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    User=%i
    ExecStart=/usr/bin/urxvtd -q -f -o

    [Install]
    WantedBy=multi-user.target

Pass the username when starting the service:

    # systemctl enable urxvtd@username.service

Cut and Paste
-------------

Note:With the use of a VDT multiplexer, urxvt (or any VDT emulator)
CLIPBOARD integration will not be effective, since it will not be
possible to select all of the desired text in a straightforward fashion
or at all, in some cases (e.g., when the active multiplexed terminal is
changed to another one and then back to the original one, and one
selects text beyond what is visible, which causes text from the other
terminal to be displayed). Obviously this is due to the fact that the
VDT emulator lacks the ability to distinguish between multiplexed
terminals. Therefore, it would be effectively redundant for one who
always uses a VDT multiplexer capable of maintaining a scrollback buffer
and integrating with CLIPBOARD (e.g., tmux with customized key bindings)
to integrate CLIPBOARD with urxvt.

For users unfamiliar with Xorg data transfer methods, the exchange of
information to and from rxvt-unicode can become a burden. Suffice to say
that rxvt-unicode uses cut buffers which are typically loaded into the
current PRIMARY selection by default.[5] Users are urged to review
Wikipedia:X Window selection for additional information.

Default Key Bindings

Default X key bindings will still work for copying and pasting. After
selecting the text Ctrl+Insert can be used to copy and Shift+Insert to
paste.

Clipboard Management

-   Parcellite is a GTK+ clipboard manager which can also run in the
    background as a daemon.

-   autocutsel provides command line and daemon interfaces to
    synchronize PRIMARY, CLIPBOARD and cut buffer selections.

-   Glipper is a GNOME panel applet with older versions available for
    use in environments other than GNOME.

-   Clipman (xfce-clipman-plugin) is a GUI clipboard manager plugin for
    the Xfce panel (xfpanel).

-   xclip is a lightweight, command-line based interface to the
    clipboard.

Automatic Script Management

Skottish[6] created a Perl script to automatically copy any selection in
rxvt-unicode to the X clipboard. Save the following as
/usr/lib/urxvt/perl/clipboard:

    #! /usr/bin/perl

    sub on_sel_grab {
        my $query=quotemeta $_[0]->selection;
        $query=~ s/\n/\\n/g;
        $query=~ s/\r/\\r/g;
        system( "echo -en " . $query . " | xsel -i -b -p" );
    }

Xyne has also created his own variation of Skottish's script named
urxvt-clipboard which is available in the AUR that allows the user to
paste the selection with Ctrl+V instead of only with a middle mouse
click:

    #! /usr/bin/perl

    sub on_sel_grab
    {
      my $query = $_[0]->selection;
      open (my $pipe,'|-','xsel -ib') or die;
      print $pipe $query;
      close $pipe;
      open (my $pipe,'|-','xsel -ip') or die;
      print $pipe $query;
      close $pipe;
    }

It also requires xsel and needs to be enabled in the *perl-ext-common or
*perl-ext field in ~/.Xresources. For example:

    URxvt.perl-ext-common: default,clipboard

The AUR package urxvt-perls-git is another option one can use.
urxvt-perls-git includes the same functionality as urxvt-clipboard, in
addition to the keyboard-select and url-select Perl extensions.

Improved Kuake-like Behavior in Openbox
---------------------------------------

This was originally posted on the forum by Xyne[7], and it relies on the
xdotool found in the official repositories.

> Scriptlets

Save this scriptlet from the urxvtc man page somewhere on your system as
urxvtc (e.g., in ~/.config/openbox):

    #!/bin/sh
    urxvtc "$@"
    if [ $? -eq 2 ]; then
       urxvtd -q -o -f
       urxvtc "$@"
    fi

and save this one as urxvtq:

    #!/bin/bash

    wid=$(xdotool search --classname urxvtq)
    if [ -z "$wid" ]; then
      /path/to/urxvtc -name urxvtq -geometry 80x28
      wid=$(xdotool search --classname urxvtq | head -1)
      xdotool windowfocus "$wid"
      xdotool key Control_L+l
    else
      if [ -z "$(xdotool search --onlyvisible --classname urxvtq 2>/dev/null)" ]; then
        xdotool windowmap "$wid"
        xdotool windowfocus "$wid"
      else
        xdotool windowunmap "$wid"
      fi
    fi

A previous version of xdotool introduced a bug which disabled
recognition of visible windows and thus led some users to use the
following scriptlet in place of the previous one. This is no longer
necessary as of xdotool >= 1.20100416.2809, but it has been left here
for future reference.

    #!/bin/bash

    wid=$(xprop -name urxvtq | grep 'WM_COMMAND' | awk -F ',' '{print $3}' | awk -F '"' '{print $2}')
    if [ -z "$wid" ]; then
      /path/to/urxvtc -name urxvtq -geometry 200x28
      wid=$(xprop -name urxvtq | grep 'WM_COMMAND' | awk -F ',' '{print $3}' | awk -F '"' '{print $2}')
      xdotool windowfocus "$wid"
      xdotool key Control_L+l
    else
      if [ -z "$(xprop -id "$wid" | grep 'window state: Normal' 2>/dev/null)" ]; then
        xdotool windowmap "$wid"
        xdotool windowfocus "$wid"
      else
        xdotool windowunmap "$wid"
      fi
    fi

Make sure that you change /path/to/urxvtc to the actual path to the
urxvtc scriptlet that you saved above. We will be using urxvtc to launch
both regular instances of urxvt and the kuake-like instance.

> urxvtq with tabbing

If you want to have tabs in your kuake-like urxvtc (here called urxvtq)
just replace the third line in your urxvtq:

    wid=$(xdotool search --name urxvtq)

with:

    wid=$(xdotool search --name urxvtq | grep -m 1 "" )

To activate tab support, you can either replace the fifth line of your
urxvtq:

    /path/to/urxvtc -name urxvtq -geometry 80x28

with:

    /path/to/urxvtc -name urxvtq -pe tabbed -geometry 80x28

or replace this line of your ~/.Xresources file:

    URxvt.perl-ext-common: default,matcher

with

    URxvt.perl-ext-common: default,matcher,tabbed

Tab control

Shift+ ←: Switch to the tab left of the current one

Shift+ →: Switch to the tab right of the current one

Shift+ ↓: Create a new tab

You can also use your mouse to switch the tabs by clicking the wished
one and create a new tab by clicking on [NEW].\\

To close a tab just enter exit like you would to normally close a
terminal.

> Openbox configuration

Now add the following lines to the <applications> section of
~/.config/openbox/rc.xml:

    <application name="urxvtq">
       <decor>no</decor>
       <position force="yes">
         <x>center</x>
         <y>0</y>
       </position>
       <desktop>all</desktop>
       <layer>above</layer>
       <skip_pager>yes</skip_pager>
       <skip_taskbar>yes</skip_taskbar>
       <maximized>Horizontal</maximized>
    </application>

and add these lines to the <keyboard> section:

    <keybind key="W-t">
      <action name="Execute">
        <command>/path/to/urxvtc</command>
      </action>
    </keybind>
    <keybind key="W-grave">
      <action name="Execute">
        <execute>/path/to/urxvtq</execute>
      </action>
    </keybind>

Here too you need to change the /path/to/* lines to point to the scripts
that you saved above. Save the file and then reconfigure Openbox. You
should now be able to launch regular instances of urxvt with Super+T,
and toggle the kuake-like console with Super+` (the grave key also known
as the backtick).

> Further configuration

The advantage of this configuration over the urxvt kuake Perl script is
that Openbox provides more keybinding options such as modifier keys. The
kuake script hijacks an entire physical key regardless of any modifier
combination. Review the Openbox bindings documentation for the full
range or possibilities.

The Openbox per-app settings can be used to further configure the
behavior of the kuake-like console (e.g. screen position, layer, etc.).
You may need to change the "geometry" parameter in the urxvtq scriptlet
to adjust the height of the console.

> Related scripts

-   hbekel has posted a generalized version of the urxvtq here which can
    be used to toggle any application using xdotool.

-   http://www.jukie.net/~bart/blog/20070503013555 - A script for
    opening URLs with your keyboard instead of mouse with urxvt.

Troubleshooting
---------------

> ~/.Xresources is not being sourced

In some cases where urxvt does not acknowledge ~/.Xresources, you may
need to add xrdb -merge ~/.Xresources to your ~/.xinitrc file. See X
resources for more information.

> Transparency not working after upgrade to v9.09

The rxvt-unicode developers removed compatibility code for a lot of non
standard wallpaper setters with this update. Using a non compatible
wallpaper setter will break transparency support. Recommended wallpaper
setters:

-   feh
-   hsetroot
-   esetroot

To make true transparency work, make sure to comment URxvt.tintColor and
URxvt.inheritPixmap.

> Remote Hosts

If you are logging into a remote host, you may encounter problems when
running text-mode programs under rxvt-unicode. This can be fixed by
copying /usr/share/terminfo/r/rxvt-unicode from your local machine to
your host at ~/.terminfo/r/rxvt-unicode. Same for rxvt-unicode-256color.

Some remote systems do not change title automatically unless you specify
TERM=xterm. To fix the issue add this line to .bashrc on the remote
machine:

    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD}\007"'

> Using rxvt-unicode as gmrun terminal

Unlike some other terminals, urxvt expects the arguments to -e to be
given separately, rather than grouped together with quotes. This causes
trouble with gmrun, which assumes the opposite behavior. This can be
worked around by putting an "eval" in front of gmrun's "Terminal"
variable in .gmrunrc:

    Terminal = eval urxvt
    TermExec = ${Terminal} -e

(gmrun uses /bin/sh to execute commands, so the "eval" is understood
here.) The "eval" has the side-effect of "breaking up" the argument to
-e in the same way that $@ does in Bash, making the command intelligible
to urxvt.

> My numerical keypad acts weird and generates differing output? (e.g. in vim)

Some Debian GNU/Linux users seem to have this problem, although no
specific details were reported so far. It is possible that this is
caused by the wrong TERM setting, although the details of whether and
how this can happen are unknown, as TERM=rxvt should offer a compatible
keymap. See the answer to the previous question, and please report if
that helped.

However, using the xmodmap program (xorg-xmodmap), you can re-map your
number pad keys back.

1. Check the keycode that your numerical keypad (numpad) generates using
xev program.

-   Start the xev program
-   Press your number pad keys and look for ... keycode xxx ... in xev's
    output. For example, numpad 1 in my keyboard is also "End" key, that
    have a 'keycode 87'.

2. Create or modify your xmodmap file, usually ~/.Xmodmap, with the
content representing your keycode.

Example of xmodmap file with number pad keycode,

    keycode 63 = KP_Multiply
    keycode 79 = Home KP_7
    keycode 80 = Up KP_8
    keycode 81 = Prior KP_9
    keycode 82 = KP_Subtract
    keycode 83 = Left KP_4
    keycode 84 = KP_5
    keycode 85 = Right KP_6
    keycode 86 = KP_Add
    keycode 87 = End KP_1
    keycode 88 = Down KP_2
    keycode 89 = Next KP_3
    keycode 90 = Insert KP_0
    keycode 91 = Delete KP_Decimal
    keycode 112 = Prior
    keycode 117 = Next

3. Load your xmodmap file at X session start-up.

For example, in ~/.xinitrc file add,

    ...
    xmodmap ~/.Xmodmap
    ...

> Pseudo-tty

The following error is likely caused by /dev/pts having been mounted
with the wrong options.

    urxvt: can't initialize pseudo-tty, aborting.

Remove /dev/pts from /etc/fstab and fix the current mount options with:

    sudo mount -o remount,gid=5,mode=620 /dev/pts

See also [8], FS#36548, and [9].

External resources
------------------

-   rxvt-unicode - Official site
-   Source Code - Browseable CVS
-   rxvt-unicode FAQ - Official FAQ
-   rxvt-unicode Reference - Official manual page
-   urxvtperl - Official Perl extension reference

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rxvt-unicode&oldid=303673"

Category:

-   Terminal emulators

-   This page was last modified on 9 March 2014, at 00:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
