Conky
=====

Conky is a system monitor software for the X Window System. It is
available for GNU/Linux and FreeBSD. It is free software released under
the terms of the GPL license. Conky is able to monitor many system
variables including CPU, memory, swap, disk space, temperature, top,
upload, download, system messages, and much more. It is extremely
configurable, however, the configuration can be a little hard to
understand. Conky is a fork of torsmo.

Contents
--------

-   1 Installation and configuration
-   2 AUR packages
-   3 Tips and tricks
    -   3.1 Enable real transparency in KDE4 and Xfce4
    -   3.2 Autostart with Xfce4
    -   3.3 Prevent flickering
    -   3.4 Custom colors
    -   3.5 Dual Screen
    -   3.6 Do not minimize on Show Desktop
    -   3.7 Integrate with Gnome 3
    -   3.8 Integrate with KDE
    -   3.9 Integrate with Razor-qt
    -   3.10 Display package update information
    -   3.11 Display weather forecast
    -   3.12 Display RSS feeds
    -   3.13 Display Distrowatch Arch Linux ranking
    -   3.14 Display rTorrent stats
    -   3.15 Display your WordPress blog stats
    -   3.16 Display number of new emails (Gmail)
        -   3.16.1 Other Methods
    -   3.17 Display new emails (IMAP + SSL)
    -   3.18 Fix scrolling with UTF-8 multibyte characters
-   4 User-contributed configuration examples
    -   4.1 Graysky
    -   4.2 A sample rings script with nvidia support
-   5 A note about symbolic fonts
-   6 Fonts appear smaller than they should
-   7 Universal method to enable true transparency
-   8 See also

Installation and configuration
------------------------------

-   Install the conky package which is available in the official
    repositories.
-   Edit the ~/.conkyrc config file using an example configuration file
    from homeproject-screenshot

When editing your config file, you will see immediately the effect of
any change as soon as you save it. There is no need to log out/log in
your X session. So best is to test all kind of options, one by one, save
the configuration file and see the change on your conky window, and
correct if your change is unappropriated.

-   Alternatively, you can use the default config at
    /etc/conky/conky.conf:

    $ cp /etc/conky/conky.conf ~/.conkyrc

Best is to use a local ~/.conkyrc config. As many apps, conky will first
try to look for a local .conkyrc file. If this one doesn't exist, then
it will read the default one in /etc/conky.

In case you store your configuration locally, e.g. in your home
directory, you will not be able to read any log files unless you do some
changes. One of the nice features of conky is to pipe to your desktop
some /var/log/ files to read all kinds of log messages. Most of these
files can only be read by root, and you will thus need to sudo conky.
Starting conky as root is not recommended, so you will need to make this
following changes:

    $ usermod -aG log username

You add username to the log group. Now username can read log files, and
you will be able to redirect log messages with conky on your desktop.

-   If conky does not accept changes -- e.g. minimum_size -- you made to
    ~/.conkyrc make sure you cleared /etc/conky/conky.conf or commented
    out the relevant section.Best is to remove files in /etc/conky/, as
    conky will keep reading them and this can give you some Xorg error
    messages.

AUR packages
------------

In addition to the basic conky package, there are various AUR packages
available with extra compile options enabled:

-   conky-cli — Conky without X11 dependencies

|| conky-cli

-   conky-lua — Conky with Lua support

|| conky-lua

-   conky-lua-nv — Conky with both Lua and Nvidia support

|| conky-lua-nv

-   conky-nvidia — Conky with Nvidia support

|| conky-nvidia

Tips and tricks
---------------

> Enable real transparency in KDE4 and Xfce4

Since version 1.8.0, Conky suppports real transparency. To enable it add
this line to ~/.conkyrc:

    own_window_transparent yes

The above option is not desired with the OWN_WINDOW_ARGB_VISUAL yes
option. This replaces the feh method described below.

> Autostart with Xfce4

In .conkyrc file:

    background yes

This variable will fork Conky to your background. If you want to make
your window always visible on your desktop, sticky across all workspaces
and not showing in your taskbar, add these arguments:

    own_window yes
    own_window_type override

The override option makes your window out of control of your window
manager.

Add a ~/.config/autostart/conky.desktop:

    [Desktop Entry]
    Encoding=UTF-8
    Version=0.9.4
    Type=Application
    Name=conky
    Comment=
    Exec=conky -d
    StartupNotify=false
    Terminal=false
    Hidden=false

> Prevent flickering

Conky needs Double Buffer Extension (DBE) support from the X server to
prevent flickering because it cannot update the window fast enough
without it. It can be enabled in /etc/X11/xorg.conf with Load "dbe" line
in Section "Module". The xorg.conf file has been replaced (1.8.x patch
upwards) by /etc/X11/xorg.conf.d which contains the particular
configuration files. DBE is loaded automatically.

To enable double-buffer check to have in ~/.conkyrc:

    # Place below the other options, not below TEXT or XY
    double_buffer yes

> Custom colors

Aside the classic preset colors (white, black, yellow...), you can set
your own custom color using the color name code. To determine the code
of a color, use a color selector app. The basic gcolor2 package in the
official repositories will give you the color name. It is made of six
hexadecimal digits (0-9, A-F). Add this line in your configuration file
for a custom color:

    color1     Colorname1
    color2     Colorname2

Then, when editing the TEXT section, use custom color number previously
defined.

> Dual Screen

When using a dual screen configuration, you will need to play with two
options to place your conky window. Let's say you are running a
1680X1050 pixels resolution, and you want the window on middle top of
your left monitor, you will use this:

    alignment top_left
    gap_X 840

The alignment option is trivial, and gap_X option is the distance, in
pixels, from the left border of your screen.

> Do not minimize on Show Desktop

Using Compiz: If the 'Show Desktop' button or key-binding minimizes
Conky along with all other windows, start the Compiz configuration
settings manager, go to "General Options" and uncheck the "Hide Skip
Taskbar Windows" option.

If you do not use Compiz, try editing ~/.conkyrc and adding/changing the
following line:

    own_window_type override

or

    own_window_type desktop

Refer to conkys man page for the exact differences. But the latter
option enables you to snap windows to conkys border using resize
key-binds in e.g. Openbox, which the first one does not.

> Integrate with Gnome 3

Some have experienced problems with Conky showing up under Gnome 3.

-   Add these lines to ~/.conkyrc:

    own_window yes
    own_window_type conky
    own_window_transparent yes
    own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager

If you still experience problems with transparency. You could add these
lines.

    own_window_argb_visual yes
    own_window_argb_value 255

> Integrate with KDE

Conky with screenshot configuration generate problems with icons
visualization. So there are some steps to follow.

-   Add these lines to ~/.conkyrc:

    own_window yes
    own_window_type normal
    own_window_transparent yes
    own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager

-   If this setting is on, comment it out or delete the line:

    minimum_size

-   To automatically start Conky, create this symlink:
    -   KDE4:

    $ ln -s /usr/bin/conky ~/.kde4/Autostart/conkylink

-   -   KDE3:

    $ ln -s /usr/bin/conky ~/.kde/share/autostart/conkylink

-   Install the feh package which is available in the official
    repositories.
-   Make a script to allow transparency with the desktop

In KDE4 edit ~/.kde4/Autostart/fehconky:

    #!/bin/bash
    feh --bg-scale "$(sed -n 's/wallpaper=//p' ~/.kde4/share/config/plasma-desktop-appletsrc)"

In KDE3 edit ~/.kde/share/autostart/fehconky:

    #!/bin/bash
    feh --bg-scale $(dcop kdesktop KBackgroundIface currentWallpaper 1)

use --bg-center if you use a centered wallpaper.

-   Make it executable:
    -   KDE4:

    $ chmod +x ~/.kde4/Autostart/fehconky

-   -   KDE3:

    $ chmod +x ~/.kde/share/autostart/fehconky

-   Instead of using a script, you can add the corresponding line to the
    bottom of ~/.conkyrc
    -   For KDE4

    ${exec feh --bg-scale "$(sed -n 's/wallpaper=//p' ~/.kde4/share/config/plasma-desktop-appletsrc)"}

-   -   For KDE3

    ${exec feh --bg-scale $(dcop kdesktop KBackgroundIface currentWallpaper 1)}

> Integrate with Razor-qt

With Conky's default configuration, its window might disappear from the
desktop when you click on the latter. Add these lines to:

    ~/.conkyrc

    own_window yes
    own_window_class Conky
    own_window_type normal
    own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager
    own_window_transparent yes

> Display package update information

-   Paconky - Displays package update information in a user-defined
    format. The output of this program can be included in Conky with the
    ${execpi} command.
-   Scrolling Notifications - Prints scrolling update notifications.
    From the author of Paconky.
-   Perl Script - Simpler and earlier script from the author of Paconky.
    Prints only the number of packages needing an update.
-   Python Script - Fairly configurable update notification program in
    Python.
-   Bash Script - Bash script for users that have enabled ShowSize.

> Display weather forecast

See this thread.

> Display RSS feeds

Conky has the ability to display RSS feeds natively without the need for
an outside script to run and output into Conky. For example, to display
the titles of the ten most recent Planet Arch updates and refresh the
feed every minute, you would put this into your ~/.conkyrc in the TEXT
section:

    ${rss https://planet.archlinux.org/rss20.xml 1 item_titles 10 }

If you want to display Arch Forum rss feed, add this line:

    ${rss https://bbs.archlinux.org/extern.php?action=feed&type=rss 1 item_titles 4}

where 1 is in minutes the refresh interval (15 mn is default),4 the
number of items you wish to show.

> Display Distrowatch Arch Linux ranking

See this thread.

> Display rTorrent stats

See this thread.

> Display your WordPress blog stats

This can be achieved by using the in python written extension named
ConkyPress.

> Display number of new emails (Gmail)

Create a file named gmail.py in a convenient location (this example uses
~/.scripts/) with the following Python code:

    gmail.py

    #!/usr/bin/env python

    from urllib.request import FancyURLopener

    email = 'your email' # @gmail.com can be left out
    password  = 'your password'

    url = 'https://%s:%s@mail.google.com/mail/feed/atom' % (email, password)

    opener = FancyURLopener()
    page = opener.open(url)

    contents = page.read().decode('utf-8')

    ifrom = contents.index('<fullcount>') + 11
    ito   = contents.index('</fullcount>')

    fullcount = contents[ifrom:ito]

    print(fullcount + ' new')

You can also use Python's urllib as follows.

    gmail.py

    #! /usr/bin/env python

    import urllib.request
    from xml.etree import ElementTree as etree

    # Enter your username and password below within quotes below, in place of ****.
    # Set up authentication for gmail
    auth_handler = urllib.request.HTTPBasicAuthHandler()
    auth_handler.add_password(realm='New mail feed',
                              uri='https://mail.google.com/',
                              user= '****',
                              passwd= '****')
    opener = urllib.request.build_opener(auth_handler)
    # ...and install it globally so it can be used with urlopen.
    urllib.request.install_opener(opener)

    gmail = 'https://mail.google.com/gmail/feed/atom'
    NS = '{http://purl.org/atom/ns#}'
    with urllib.request.urlopen(gmail) as source:
        tree = etree.parse(source)
    fullcount = tree.find(NS + 'fullcount').text

    print(fullcount + ' new')

Add the following string to your ~/.conkyrc in order the check your
Gmail account for new email every five minutes (300 seconds) and
display:

    ${execpi 300 python ~/.scripts/gmail.py}

Other Methods

The same way, but with using curl, grep and sed:

    $ curl -s -u email:password https://mail.google.com/mail/feed/atom | grep fullcount | sed 's/<[^0-9]*>//g'

replace email and password with your data.

Alternatively, you can use stunnel which is provided by the stunnel
package.

The following configuration is taken from Conky's FAQ

Modify /etc/stunnel/stunnel.conf as follows, and then start the stunnel
daemon:

    # Service-level configuration for TLS server
    [imap]
    client = yes
    accept  = 143
    connect = imap.gmail.com:143
    protocol = imap
    sslVersion = TLSv1
    # Service-level configuration for SSL server
    [imaps]
    client = yes
    accept  = 993
    connect = imap.gmail.com:993

The only thing left is our ~/.conkyrc:

    imap localhost username * -i 120 -p 993
    TEXT
    Inbox: ${imap_unseen}/${imap_messages}

Here I used * as the password for Conky to ask for it at start, but you
do not have to do it.

> Display new emails (IMAP + SSL)

Conky has built in support for IMAP accounts but does not support SSL.
This can be provided using this script from this forum post. This
requires the Perl/CPAN Modules Mail::IMAPClient and IO::Socket::SSL
which are in the perl-mail-imapclient and perl-io-socket-ssl packages

Create a file named imap.pl in a location to be read by Conky. In this
file, add (with the appropriate changes):

    #!/usr/bin/perl

    # gimap.pl by gxmsgx
    # description: get the count of unread messages on imap

    use strict;
    use Mail::IMAPClient;
    use IO::Socket::SSL;

    my $username = 'example.username'; 
    my $password = 'password123'; 

    my $socket = IO::Socket::SSL->new(
      PeerAddr => 'imap.server',
      PeerPort => 993
     )
     or die "socket(): $@";

    my $client = Mail::IMAPClient->new(
      Socket   => $socket,
      User     => $username,
      Password => $password,
     )
     or die "new(): $@";

    if ($client->IsAuthenticated()) {
       my $msgct;

       $client->select("INBOX");
       $msgct = $client->unseen_count||'0';
       print "$msgct\n";
    }

    $client->logout();

Add to ~/.conkyrc:

    ${execpi 300 ~/.conky/imap.pl} 

or wherever you saved the file.

If you use Gmail you might need to generate an application specific
password.

Alternatively, you can use stunnel as shown above: Conky#How to display
the number of new emails (Gmail) in Conky

> Fix scrolling with UTF-8 multibyte characters

The current version of conky (1.9.0) suffers from a bug
(http://sourceforge.net/p/conky/bugs/341/) where scrolling text
increments by byte, not by character, resulting in text containing
multibyte characters to disappear and reappear while scrolling. A
package with a patch fixing this bug can be found in the AUR:
conky-utfscroll

User-contributed configuration examples
---------------------------------------

> Graysky

[Screenshot].

[Here] it is - modify to fit your system. Optimized for a quad core chip
w/ several hdds (although one of them is not connected for this
screenshot) and an nvidia graphics card. You can easily modify this to a
dual or single core system with one or whatever number of hdds.

> A sample rings script with nvidia support

    # -- Conky settings -- #
    background no
    update_interval 1

    cpu_avg_samples 2
    net_avg_samples 2

    override_utf8_locale yes

    double_buffer yes
    no_buffers yes

    text_buffer_size 2048
    imlib_cache_size 0

    # -- Window specifications -- #

    own_window yes
    own_window_type normal
    own_window_transparent yes
    own_window_hints undecorate,sticky,skip_taskbar,skip_pager,below

    border_inner_margin 0
    border_outer_margin 0

    minimum_size 320 800
    maximum_width 320

    alignment bottom_right
    gap_x 0
    gap_y 0

    # -- Graphics settings -- #
    draw_shades no
    draw_outline no
    draw_borders no
    draw_graph_borders yes

    # -- Text settings -- #
    use_xft yes
    xftfont MaiandraGD:size=24
    xftalpha 0.4

    uppercase no

    default_color 888888

    # -- Lua Load -- #
    lua_load ~/conky/lua/lua.lua
    lua_draw_hook_pre ring_stats

    TEXT
    ${alignr}${voffset 53}${goto 90}${font MaiandraGD:size=11}${time %A, %d %B %Y}


    ${voffset 5}${goto 164}${font MaiandraGD:size=16}${time %H:%M}



    ${voffset -40}${goto 100}${font MaiandraGD:size=9}Kernel:${offset 70}Uptime:
    ${goto 90}${font MaiandraGD:size=9}$kernel${offset 40}$uptime
    ${voffset 57}${goto 117}${font snap:size=8}${cpu cpu0}%
    ${goto 117}${cpu cpu1}%
    ${goto 117}CPU
    ${voffset 19}${goto 145}${memperc}%
    ${goto 145}$swapperc%
    ${goto 145}MEM
    ${voffset 25}${goto 170}${nvidia gpufreq}
    ${goto 170}${nvidia memfreq}
    ${goto 170}GPU
    ${voffset 27}${goto 198}${totaldown ppp0}
    ${goto 198}${totalup ppp0}
    ${goto 205}NET
    ${voffset 21}
    ${goto 222}${fs_used /home}
    ${goto 230}DISK

And the required lua.lua script:

    --[[
     Ring Meters by londonali1010 (2009)

     This script draws percentage meters as rings. It is fully customisable; all options are described in the script.

     IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this does not happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num > 5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num > 3; conversely if you update Conky every 0.5s, you should use update_num > 10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

     To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
             lua_load ~/scripts/rings-v1.2.1.lua
             lua_draw_hook_pre ring_stats
      
     Changelog:
     + v1.2.1 -- Fixed minor bug that caused script to crash if conky_parse() returns a nil value (20.10.2009)
     + v1.2 -- Added option for the ending angle of the rings (07.10.2009)
     + v1.1 -- Added options for the starting angle of the rings, and added the "max" variable, to allow for variables that output a numerical value rather than a percentage (29.09.2009)
     + v1.0 -- Original release (28.09.2009)
     ]]
     
     settings_table = {
             {
                     -- Edit this table to customise your rings.
                     -- You can create more rings simply by adding more elements to settings_table.
                     -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
                     name='time',
                     -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use .
                     arg='%I.%M',
                     -- "max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
                     max=12,
                     -- "bg_colour" is the colour of the base ring.
                     bg_colour=0x888888,
                     -- "bg_alpha" is the alpha value of the base ring.
                     bg_alpha=0.3,
                     -- "fg_colour" is the colour of the indicator part of the ring.
                     fg_colour=0x888888,
                     -- "fg_alpha" is the alpha value of the indicator part of the ring.
                     fg_alpha=0.5,
                     -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
                     x=191, y=145,
                     -- "radius" is the radius of the ring.
                     radius=32,
                     -- "thickness" is the thickness of the ring, centred around the radius.
                     thickness=4,
                     -- "start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
                     start_angle=0,
                     -- "end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger (e.g. more clockwise) than start_angle.
                     end_angle=360
             },
             {
                     name='time',
                     arg='%M.%S',
                     max=60,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=191, y=145,
                     radius=37,
                     thickness=4,
                     start_angle=0,
                     end_angle=360
             },
             {
                     name='time',
                     arg='%S',
                     max=60,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=191, y=145,
                     radius=42,
                     thickness=4,
                     start_angle=0,
                     end_angle=360
             },
             {
                     name='cpu',
                     arg='cpu0',
                     max=100,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=140, y=300,
                     radius=26,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='cpu',
                     arg='cpu1',
                     max=100,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=140, y=300,
                     radius=20,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='memperc',
                     arg=,
                     max=100,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=170, y=350,
                     radius=26,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='swapperc',
                     arg=,
                     max=100,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=170, y=350,
                     radius=20,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='time',
                     arg='%d',
                     max=31,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=191, y=145,
                     radius=50,
                     thickness=5,
                     start_angle=-140,
                     end_angle=-30
             },
             {
                     name='time',
                     arg='%m',
                     max=12,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=191, y=145,
                     radius=50,
                     thickness=5,
                     start_angle=30,
                     end_angle=140
             },
     --      {
     --              name='fs_used_perc',
     --              arg='/',
     --              max=100,
     --              bg_colour=0x888888,
     --              bg_alpha=0.3,
     --              fg_colour=0x888888,
     --              fg_alpha=0.5,
     --              x=260, y=503,
     --              radius=26,
     --              thickness=5,
     --              start_angle=-90,
     --              end_angle=180
     --      },
             {
                     name='fs_used_perc',
                     arg='/home',
                     max=100,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=260, y=503,
                     radius=20,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='totalup',
                     arg='ppp0',
                     max=2,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=230, y=452,
                     radius=20,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='totaldown',
                     arg='ppp0',
                     max=2,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=230, y=452,
                     radius=26,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
             {
                     name='nvidia',
                     arg='gpufreq',
                     max=475,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=200, y=401,
                     radius=26,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
     {
                     name='nvidia',
                     arg='memfreq',
                     max=700,
                     bg_colour=0x888888,
                     bg_alpha=0.3,
                     fg_colour=0x888888,
                     fg_alpha=0.5,
                     x=200, y=401,
                     radius=20,
                     thickness=5,
                     start_angle=-90,
                     end_angle=180
             },
     }
     
     require 'cairo'
     
     function rgb_to_r_g_b(colour,alpha)
             return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
     end
     
     function draw_ring(cr,t,pt)
             local w,h=conky_window.width,conky_window.height
     
             local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
             local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']
     
             local angle_0=sa*(2*math.pi/360)-math.pi/2
             local angle_f=ea*(2*math.pi/360)-math.pi/2
             local t_arc=t*(angle_f-angle_0)
     
             -- Draw background ring
     
             cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
             cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
             cairo_set_line_width(cr,ring_w)
             cairo_stroke(cr)
     
             -- Draw indicator ring
     
             cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
             cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
             cairo_stroke(cr)
     end
     
     function conky_ring_stats()
             local function setup_rings(cr,pt)
                     local str=
                     local value=0
     
                     str=string.format('${%s %s}',pt['name'],pt['arg'])
                     str=conky_parse(str)
     
                     value=tonumber(str)
                     if value == nil then value = 0 end
                     pct=value/pt['max']
     
                     draw_ring(cr,pct,p<nowiki>Insert non-formatted text hereBold text</nowiki>t)
             end
     
             if conky_window==nil then return end
             local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_w    indow.height)
     
             local cr=cairo_create(cs)
     
             local updates=conky_parse('${updates}')
             update_num=tonumber(updates)
     
             if update_num>5 then
                     for i in pairs(settings_table) do
                             setup_rings(cr,settings_table[i])
                     end
             end
     end

A note about symbolic fonts
---------------------------

Many of the more decorated .conkyrc's use the fonts PizzaDude Bullets
and Pie Charts for Maps. They are available from the AUR as
'ttf-pizzadude-bullets' and 'ttf-piechartsformaps' respectively, or they
can be found and downloaded with a quick search and manually installed
using the instructions in Fonts.

Fonts appear smaller than they should
-------------------------------------

If you notice that your conky fonts appear smaller than they should, or
they don't align properly, it could be caused by a default setting in
the infinality freetype2 patch. This setting can cause some programs to
display fonts at 72 DPI instead of 96 even if the rest of your system is
set to 96. If you notice a problem open
/etc/fonts/infinality/infinality.conf search for the section on DPI and
change 72 to 96.

Universal method to enable true transparency
--------------------------------------------

Transparency is a strange beast in Conky, but there is a way to
universally apply true transparency with any environment or window
manager by using xcompmgr and transset-df. Install xcompmgr from [extra]
and transset-df from [community] with pacman -S xcompmgr transset-df.
These packages both have the same 3 dependencies, so this is the
lightest method for composition available, for those of you using
standalone window managers in order to achieve the leanest setup you can
manage (or whatever reason you have :D)

NOTE: This may conflict with any other compositing manager you are
already using.

Check xcompmgr documentation to help you decide which compositing
options you would like to enable. The following is a common standard
command.

    $ xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &

Make sure conky is running with conky &. Use transset-df to enable
transparency on the Conky window. Set '.5' to any value in the range 0 -
1.

    $ transset-df .5 -n Conky

This should give your conky window true transparency. If you get an
error like,

    $ transset-df .5 -n Conky

    No Window matching Conky exists!

Verify that conky is running, and use xprop and click on the conky
window to find the name you should pass to transset-df.

    $ xprop | grep WM_NAME

    WM_NAME(STRING) = "Conky (ArchitectLinux)"

In this case, "Conky" is right, but for you it may be different, so be
sure to use your output instead. If ~/.conkyrc has own_window_type panel
then this xprop invocation may show now output. Try using any of the
following options instead.
own_window_type {dock,normal,override,desktop}

Use this in ~/.xinitrc to have transparent conky run when you startx.

    xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
    conky -d; sleep 1 && transset-df .5 -n Conky

See also
--------

-   Official Conky Configuration Settings
-   Conky Configs on arch forums
-   Official website
-   Conky on Freshmeat
-   Conky on SourceForge
-   #conky IRC chat channel on freenode
-   FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=Conky&oldid=305724"

Category:

-   Status monitoring and notification

-   This page was last modified on 20 March 2014, at 01:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
