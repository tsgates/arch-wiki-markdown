GNOME Tips
==========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with GNOME.      
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Configuration tips
    -   1.1 Add/edit GDM eessions
    -   1.2 GDM appearance
        -   1.2.1 GDM wallpaper
    -   1.3 Default applications
    -   1.4 Fonts seem skewed
    -   1.5 Change the default background color, opacity, etc.
    -   1.6 Disable confirmation window when closing gnome-terminal
    -   1.7 Start application with another language
-   2 Miscellaneous tips
    -   2.1 Nautilus tips
        -   2.1.1 Change browser mode (spatial view)
        -   2.1.2 Music information columns in list view (bit rate,
            etc.)
        -   2.1.3 Thumbnails
        -   2.1.4 Turn off Authentication needed to mount internal drive
            in Nautilus
    -   2.2 Speed up panel autohide
        -   2.2.1 panel_show_delay / panel_hide_delay
        -   2.2.2 Panel animation_speed
    -   2.3 GNOME menu tips
        -   2.3.1 Speed tweak
        -   2.3.2 Menu editing
            -   2.3.2.1 User menus
            -   2.3.2.2 Group menus, System menus
        -   2.3.3 Change the GNOME foot icon to an Arch icon
        -   2.3.4 Change the GNOME foot icon to an Arch icon (without
            root access)
        -   2.3.5 Custom icon using gconf-editor
        -   2.3.6 Removing default icons from desktop
    -   2.4 Disabling scroll in taskbar
    -   2.5 Custom transitioning background
        -   2.5.1 Manual
        -   2.5.2 Automatic
        -   2.5.3 GUI
    -   2.6 Change default size of gnome-terminal
        -   2.6.1 Method 1
        -   2.6.2 Method 2
    -   2.7 Install a cursor theme
    -   2.8 Autostart programs
-   3 gnome-screensaver
    -   3.1 Leave message feature in gnome-screensaver
    -   3.2 Change gnome-screensaver background
-   4 Toolbar style in GTK+ applications
-   5 Missing icons in System Menu
-   6 Nautilus location entry
-   7 See also

Configuration tips
------------------

> Add/edit GDM eessions

Each session is a .desktop file located at /usr/share/xsessions/.

To add a new session:

1. Copy an existing .desktop file to use as a template for a new
session:

    $ cd /usr/share/xsessions
    # cp gnome.desktop other.desktop

2. Modify the template *.desktop file to open the required window
manager:

    # nano other.desktop

Alternatively, you can open the new session in KDM which will create the
*.desktop file. Then return to using GDM and the new session will be
available.

> GDM appearance

You can use gdm3setup from the AUR.

GDM wallpaper

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: these scripts    
                           were recovered from [1]  
                           and may require testing. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

These scripts assist in setting up the GDM wallpaper and are an addition
to GNOME#Login screen. Place these files in a suitable location and make
them executable. An example of running these scripts appears below.

    /usr/local/bin/prep-gdm-vars

    #  This script must be run using '.' or 'source'
    $(dbus-launch | sed "s/^/export /")

    /usr/local/bin/show-avail-gdm-bkgd

    #!/bin/bash
    #  Usage:  show-avail-gdm-bkgd  [folder]
    #  Specify any folder within /usr/share/backgrounds.
    #  If you omit the folder, you'll be shown available choices.
    file_part="/usr/share/backgrounds/"
    if ! [ $1 ]; then
      echo -en \\n  Please specify one of these directories:\\n\\n\\040
      ls $file_part; echo; exit 1; fi
    ls ${file_part}/$1

    /usr/local/bin/revise-gdm-bkgd

    #!/bin/bash
    #  Usage:  revise-gdm-bkgd gnome/filename.jpg
    #  Specify any file path within /usr/share/backgrounds.
    org_part="org.gnome.desktop.background picture-uri"
    file_full="/usr/share/backgrounds/$1"
    # Trap when argument is: missing, a mere directory, a bad filename.
    if ( ! [ $1 ] || [ -d $file_full ] ); then
      echo -en \\n Specify a file.  Use this example:
      echo -e \ \ revise-gdm-bkgd \ gnome/TwoWings.jpg\\n; exit 1; fi
    if ! [ -r $file_full ]; then
      echo -e \\n Specifed file does not exist or is not readable.\\n; exit 2; fi
    GSETTINGS_BACKEND=dconf gsettings set $org_part "file://${file_full}"

Here is a session showing how a user might change the GDM wallpaper
using the scripts listed above. It starts with a normal user's terminal
and assumes he is able to open a bash session as root. The root user
then opens a session as "gdm" and changes the wallpaper.

    # xhost +
    access control disabled, clients can connect from any host
    # su - gdm -s /bin/bash

    -bash-4.2$ . prep-gdm-vars   #  Must use . to execute this script!
    access control disabled, clients can connect from any host

    -bash-4.2$ show-avail-gdm-bkgd gnome
    Aqua.jpg            FreshFlower.jpg  Spaceflare-nova.jpg       Terraform-green.jpg   YellowFlower.jpg
    Blinds.jpg          Garden.jpg       Spaceflare-supernova.jpg  Terraform-orange.jpg
    BlueMarbleWest.jpg  GreenMeadow.jpg  SundownDunes.jpg          TwoWings.jpg
    FootFall.png        Spaceflare.jpg   Terraform-blue.jpg        Wood.jpg

    -bash-4.2$ revise-gdm-bkgd gnome/GreenMeadow.jpg

    -bash-4.2$ logout

    # logout

Script revise-gdm-bkgd may also be used to change your normal user
background from the command prompt. Admittedly, the script name does not
quite fit when used for that purpose.

> Default applications

You may want to configure system-wide default applications and file
associations. This is extremely useful when you have some KDE
applications installed, but still prefer a GNOME ones to be launched by
default.

To do that you can install gnome-defaults-list from the AUR. It will
place your configuration file at /etc/gnome/defaults.list.

If you want to do everything manually, create
/usr/share/applications/defaults.list with the following format:

    [Default Applications]
     application/pdf=evince.desktop
     image/jpeg=eog.desktop
     ...

> Fonts seem skewed

You can alter the DPI of your fonts in GNOME with right-click on the
desktop > Change desktop background > Fonts > Details > Resolution.

> Change the default background color, opacity, etc.

The default background color is green. You might want to change it if
you're using a transparent PNG as background.

    $ sudo gconf-editor

Go to File > New Defaults Window and edit the keys

    /desktop/gnome/background/primary_color

and

    /desktop/gnome/background/secondary_color

You can also find keys for opacity, shading style, etc.

> Disable confirmation window when closing gnome-terminal

The terminal always prompts a confirmation window when trying to close
the window while one is logged in as root. To avoid this confirmation
start gconf-editor and disable confirmation_window_close variable in
/apps/gnome-terminal/global. Please note that although this setting is
not set via dconf-editor it also works in the GNOME Shell.

> Start application with another language

If you want to start an application with another language as the
system's default one, you can change the application's desktop file in
~/.local/share/applications'' for yourself or in /usr/share/applications
for everyone like shown below.

Find the desktop file of the application which you want to start with
another language. Go to theExec row: (here for Empathy):

    Exec=empathy %f

and change it to:

    Exec=env LANG=de_DE.UTF-8 empathy %f

From now on that application will start with the chosen language.

Miscellaneous tips
------------------

> Nautilus tips

Get a certain path in spatial view? Just press Ctrl+l.

Change browser mode (spatial view)

1.  Start gconf-editor
2.  Browse to apps/nautilus/preferences
3.  Change the value of "always_use_browser" (it's a yes/no value and
    should be visible as a checkbox or say "false", for the later change
    the value to "true")

Or you can do this through the preferences:

1.  In a Nautilus window go to Edit > Preferences
2.  Change to the Behaviour tab
3.  Check (or uncheck) Always Open in Browser Windows

Music information columns in list view (bit rate, etc.)

Nautilus lacks the ability to display metadata for music files in list
view mode. A Python script was written to add columns for:

-   Artist
-   Album
-   Track Title
-   Bit Rate

First, install the mutagen and python-nautilus-git.

Now, create a directory called python-extensions in ~/.nautilus. Place
the following script, named bsc.py, in this newly created folder. You
may download the script here: [bsc.py] (please drop --stefanwilkens a
line if this goes down)

Mirror: [bsc.py]

bas-v2.py adds fixes and more media support (link at bottom of 4th
post).

Mirror: bsc-v2.py

Restart nautilus. You can now configure this new functionallity in Edit
-> Preferences -> List Columns

Thumbnails

You will need a tool for creating thumbnails, such as ffmpegthumbnailer.
Make sure the necessary codecs are installed.

In a command line, enter these two lines:

    gconftool-2 -s "/desktop/gnome/thumbnailers/video@mpeg/enable" -t boolean "true"
    gconftool-2 -s "/desktop/gnome/thumbnailers/video@mpeg/command" -t string "/usr/bin/ffmpegthumbnailer -s %s -i %i -o %o -c png -f -t 10"

You can replace 'video@mpeg' in that line with any filetype that ffmpeg
can open - just right-click > Properties on a file in Nautilus and look
at the bit in brackets in the 'Type:' field (don't forget to replace the
forward slash with an @ symbol). Some common filetypes are video@mpeg,
video@x-matroska, video@x-ms-wmv, video@x-flv, video@x-msvideo,
video@mp4; which are usually .mpg, .mkv, .wmv, .flv, .avi, .mp4
respectively.

Turn off Authentication needed to mount internal drive in Nautilus

In Ubuntu and other distros you are allowed to mount internal drives by
clicking on them without the need for entering a password. To get this
behaviour in stock GNOME, just create the following JavaScript rule:

    /etc/polkit-1/rules.d/10-auth.rules

    polkit.addRule(function(action, subject) {
                   if (action.id="org.freedesktop.udisks2.filesystem-mount-system" && subject.isInGroup("storage")) {
                           return polkit.Result.YES;
                       }
                   }
               );

Note: this adds very broad permissions. To only add the same permissions
for internal filesystems as for external filesystems, use
https://gist.github.com/grawity/3886114#file-udisks2-allow-mount-internal-js

Older Polkit versions will require the following file in PolicyKit Local
Authority instead:

    /etc/polkit-1/localauthority/50-local.d/50-filesystem-mount-system-internal.pkla

    [Mount a system-internal device]
    Identity=*
    Action=org.freedesktop.udisks2.filesystem-mount-system
    ResultActive=yes

> Speed up panel autohide

panel_show_delay / panel_hide_delay

If you find that your panels are taking too long to appear/disappear
when using the Panel Autohide feature, try this;

1.  Start gconf-editor
2.  Browse to /apps/panel/global
3.  Set panel_hide_delay and panel_show_delay to more sensible (integer)
    values. Note that these values represent milliseconds!

The default panel_hide_delay of 500 works well in most cases, but the
panel_show_delay default of 500 is horribly slow. After experimenting, a
panel_show_delay between 100-200 seems much better.

Panel animation_speed

Now that the panel show/hide delay has the panels beginning to appear in
a reasonable length of time, why does it take the panel so long to
actually pop up? There is one more setting you need to add/change to
make the panel behavior crisp. The setting animation_speed: ihis setting
can be applied globally or on a per-panel basis just like the
panel_show_delay and panel_hide_delay. The official description is:

The speed in which panel animations should occur. Possible values are
slow, medium and fast. This key is only relevant if the
enable_animations key is true.

To apply globally, just add or change the animation_speed key as a
(string) value in:

-   /apps/panel/global

To apply the setting on a per-panel basis, just add/change the key in,
for example:

-   /apps/panel/toplevels/bottom_panel_screen0/ (usually the default
    name for the bottom panel)
-   /apps/panel/toplevels/panel_0/ (usually the default name for the
    first additional panel)

{Note|The key panel_amination_speed is deprecated, use:
animation_speed.}}

> GNOME menu tips

Speed tweak

You can remove the delay in GNOME menus by appending
"gtk-menu-popup-delay = 0" to ~/.gtkrc-2.0.

However, this setting is reported to crash Banshee, and possibly other
programs.

Menu editing

Most GNOME users complain about the menu. Changing menu entries
system-wide or for one or several users alone is poorly documented.

User menus

Older versions of GNOME (i.e. 2.22 or earlier) have a menu editor in
which you can de-select menu entires, but not add new menu entries.
Right-click on the menu panel and select Edit Menus. Unchecking the box
next to a entry will prevent it from displaying.

To add new menu entries, create a .desktop file in the
$XDG_DATA_HOME/applications directory (most likely $HOME/.local/share).
A sample .desktop file can be seen below, or take a look at the GNOME
documentation.

Or install Alacarte, which makes it easy to create, change and remove
menu entries with a GUI.

Group menus, System menus

You will find common GNOME menu entries as 'appname.desktop' objects
inside one of the $XDG_DATA_DIRS/applications directories (most likely
/usr/share/applications). To add new menu items for all users, create an
'appname.desktop' file in one of those directories.

-   Edit one of them to fit your needs for a new application, then save
    it.
-   Save it as a menu entry for all users   
     Most often, you will set this files permissions to 644 (root: rw
    group: r others: r), so all users can see it.
-   Save it as a menu entry for a group or user alone   
     You may also have different user permissions; for example, some
    menu entries should only be available for a group or for one user.

Here is an example how a Scite menu entry definition file could look:

    [Desktop Entry]
    Encoding=UTF-8
    Name=SciTE
    Comment=SciTE editor
    Type=Application
    Exec=/usr/bin/scite
    Icon=/usr/share/pixmaps/scite_48x48.png
    Terminal=false
    Categories=GNOME;Application;Development;
    StartupNotify=true

Change the GNOME foot icon to an Arch icon

Note:Thanks to arkham who posted this method in this forum post.

-   Download this Arch icon (filename is starthere.png)
-   Alternatively get the artwork package by installing
    archlinux-artwork, this puts all artwork in the /usr/share/archlinux
    directory, and resize your desired logo to 24x24px
-   Figure out which icon set you are using (right-click desktop >
    Change Background Image > Theme > Customize > Icon). For example,
    Crux, *GNOME, High Contrast, High Contrast Inverse, Mist, etc.)
-   Now make a backup of your current GNOME icon in the correct
    directory. In the example below, I am using the GNOME icons but
    adjust the directory structure accordingly for your icon set:

    # mv /usr/share/icons/gnome/24x24/places/start-here.png /usr/share/icons/gnome/24x24/places/start-here.png-virgin

-   Copy starthere.png you just downloaded to the same directory
    renaming it start-here.png

    # cp /path/to/starthere.png /usr/share/icons/gnome/24x24/places/start-here.png

-   Restart your gnome-panels and the new Arch logo should be displayed

    $ pkill gnome-panel

Change the GNOME foot icon to an Arch icon (without root access)

-   Figure out which icon set you're using (right-click on desktop >
    Change Background Image > Theme > Customize > Icon). For example,
    Crux, *GNOME, High Contrast, High Contrast Inverse, Mist, etc.)
-   Duplicate that icon set's directory structure for 24x24/places in
    your home directory under .icons

    $ mkdir -p ~/.icons/your_icon_set/24x24/places

-   Download this Arch icon into that directory as 'start-here.png'

    $ wget -O ~/.icons/your_icon_set/24x24/places/start-here.png http://img23.imageshack.us/img23/9679/starthere.png

-   Alternatively get the artwork package using archlinux-artwork
    package, this puts all artwork in the /usr/share/archlinux
    directory, and resize your desired logo to 24x24px and copy it into
    that directory as 'start-here.png'
-   Restart your gnome-panels and the new Arch logo should be displayed

    $ pkill gnome-panel

Custom icon using gconf-editor

1.  Open the configuration editor in GNOME (it should be in System Tools
    of your main menu) or run gconf-editor
2.  In the configuration editor go to apps > panel > objects > find the
    object for your menu (an easy way to spot the correct object is that
    it will have "Main Menu" in the tool tip section).
3.  Set the path to your icon in the "Custom_Icon" field.
4.  Check "Use_Custom_Icon" a little ways down.
5.  The panel should reload momemtarily, if not, open a terminal window
    and type:

    $ killall gnome-panel

Removing default icons from desktop

I like to keep my desktop clean, and perhaps someone else too. So here
is how to remove home folder, computer and trash from desktop:

1.  Open terminal
2.  On terminal type: gconf-editor
3.  Configuration Editor opens. From there navigate to: apps > nautilus
    > desktop
4.  Untick all the icons you dont want to see
5.  You are done, the icons should disappear immediately

> Disabling scroll in taskbar

For years there is a "bug" in the GNOME taskbar: the mouse scroll
switches the windows. The annoying feature if you have a good mice turns
to be a real pain if you have the touchpad. It is impossible to scroll
precisely using touchpad, so if you accidentally touch it when your
mouse is on the taskbar, then all the windows will flash/switch wildly.
There is no setting in gconf/preferences, that can disable this
functionality. This is true for KDE 3, I do not know if problem persist
in KDE 4. The solution was to install xfce4-panel, which hasn't
scrolling at all and looks like default GNOME panel. The bug is better
described here [2].

This bug will be probably never fixed, but we have the Arch Build
System, so we can build custom software. Install abs (+70Mb), then

    cp -r /var/abs/extra/libwnck ~/Desktop/somewhere

Navigate to that directory, then

    makepkg --nobuild

This will download and extract the sources. Go to
src/libwnck-{version}/libwnck. Edit tasklist.c, search for
"scroll-event". You will see somethign like

    g_signal_connect(obj, "scroll-event", G_CALLBACK(wnck_tasklist_scroll_cb), NULL);

This line enables scroll-event handler, comment the line out (place /*
before and */ after the line). Now go back to ~/Desktop/somewhere and

    makepkg --noextract --syncdeps

You will need sudo to be able to install missing dependencies
(intltool), but you can always install them separately if you do not
want --syncdeps automatically. The --noextract option tells makepkg to
not extract sources and use existing src/

    pacman -U libwnck-{version}.pkg.tar.gz

Then log out, log back in, and enjoy. Delete dir with the sources from
you desktop, you may also uninstall abs if you want. Next step will be
to add gconf option, but I will leave this for GNOME gurus. I just do
not need this "feature", not even if I use the mouse (Alt+Tab is better
anyway).

> Custom transitioning background

This will create a transitioning background similiar to the "cosmos"
background found in the gnome-backgrounds package. There are three ways
to do this.

Note:The image filenames must not have spaces in them.

Manual

You can create an XML file similiar to the one created by
gnome-backgrounds in /usr/share/backgrounds/cosmos/.

    <background>
      <starttime>
        <hour>00</hour>
        <minute>00</minute>
        <second>01</second>
      </starttime>
    <!-- The first section set an arbitrary start time. -->
      <static>
        <duration>1795.0</duration>
        <file>/path/to/background1.jpg</file>
      </static>
      <transition>
        <duration>5.0</duration>
        <from>/path/to/background1.jpg</from>
        <to>/path/to/background2.jpg</to>
      </transition>
      <static>
        <duration>1795.0</duration>
        <file>/path/to/background2.jpg</file>
      </static>
      <transition>
        <duration>5.0</duration>
        <from>/path/to/background2.jpg</from>
        <to>/path/to/background1.jpg</to>
      </transition>
    </background>

Note that the <duration> tag sets each image as the background for 1795
seconds, or 29 minutes and 55 seconds, and the <transition> then takes 5
seconds. You can add any number of images as long as the last one
transitions back to the first (if you want a full loop). Once completed,
the XML file can be added to GNOME under System > Preferences >
Appearance > Background tab > Add.

Automatic

There is also a script which automates this process:

     sed 's/^\<[^ ]*\>//')
      if [ "$(echo $xmlfile 

Copy the code for the script above into a file called mkwlppr (short for
"make wallpaper"). Make the script executable by typing:

    sudo chmod 711 mkwlppr

Move the file so that you can run it from any directory by just using
its name:

    sudo mv mkwlppr /usr/local/bin

Execute the script; it will tell you what input it requires from you.
Use the script with input to create as many wallpaper XML files as you
want.

> Note:

Since this script is not interactive, you can use Unix's wildcards with
it if you want to use all files in a directory and/or if you do not care
about the order of the images. You can specify paths relative to your
current directory, and the script will put the files' absolute paths
into the XML file for you; so you can create the XML file anywhere you
want and move it afterward without rendering it useless. If you want to
run the script inside the /usr/share/backgrounds/ directory, you might
have problems with permissions unless you run the command with sudo like
this: sudo mkwlppr -parameters If you do not know what duration to
specify for the images, simply do not provide a number in the input, and
the progam will use the default values of 29 minutes and 55 seconds per
image and a 5 second transition. For more information, please see this
page.

GUI

If you prefer using a GUI, you can use Wallpapoz or install crebs from
the AUR, which are apps for creating background slideshows for GNOME.

> Change default size of gnome-terminal

Method 1

The terminal emulator gnome-terminal does neither allow the set a
default size nor does remember the last size. In order to set the
default size consider the following steps:

1.  Change the following line in /usr/share/vte/termcap/xterm
    accordingly:

    :co#80:it#8:li#24:

Here 80 stands for the number of columns (i.e. width in characters) and
24 for the number of lines (i.e. height in characters). 2. To prevent
pacman from overwriting this file when upgrading the package vte, make
enter the following in /etc/pacman.conf:

    NoUpgrade = usr/share/vte/termcap/xterm

3. Terminate all gnome-terminal processes to let the changes take
effect.

Method 2

Another option is to simply use the --geometry switch when starting
gnome-terminal (can be done via a right-click/properties on the
launcher, then enter the following in the "Command" field:
gnome-terminal --geometry 105x25+100+20).

> Install a cursor theme

The default cursor theme of Xorg looks pretty outdated. See X11 Cursors
for easy instructions on installing new cursor themes. Then go to to the
desktop > right click > Change background > Theme tab > customise >
cursor to apply them.

> Autostart programs

You can place .desktop files in the ~/.config/autostart directory (which
you might need to create) to have them started automatically after
starting a GNOME session.

gnome-screensaver
-----------------

> Leave message feature in gnome-screensaver

This is a cool feature provided by gnome-screensaver 2.20, somebody can
leave a message for you when you are not at your desk. Please install
notification-daemon to make this work.

> Change gnome-screensaver background

There is no option to change the screensaver's default background. The
only way is do as root:

    # cd /usr/share/pixmaps/backgrounds/gnome
    # rm background-default.jpg
    # ln -s /home/user/my_background.jpg background-default.jpg

Note:You can save your wallpaper to a static path like
/home/user/wall.jpg and configure gdm, gnome-desktop and
gnome-screensaver to point at it. This way you can have the same
wallpaper on each of them.

Toolbar style in GTK+ applications
----------------------------------

The default setting in GNOME 2.30 displays text next to icons in the
toolbar of GTK+ applications. This means labels will only appear near
buttons that the developer marks as "important". To have labels always
show under the buttons in the toolbar:

    gconftool-2 --set --type string  /desktop/gnome/interface/toolbar_style both

Possible values are:

-   both (text is always displayed below the button's icon)
-   both-horiz (default, text is only displayed next to "important"
    buttons)
-   text (only labels on buttons, no icons)
-   icons (only icons on buttons, no labels)

Missing icons in System Menu
----------------------------

The default setting under 2.30 does not display the usual icons under
the System menu. In the 2.28 version, they could be enabled from System
> Preferences > Appearance > Interface. This case is not possible
anymore. Now this can be enabled from:

    gconftool-2 --set --type boolean  /desktop/gnome/interface/menus_have_icons true

Nautilus location entry
-----------------------

Since GNOME 2.30, Nautilus does not have an icon to switch the location
type between using a text input entry and of a pathbar. Since pathbar is
enabled by default, to change to text input entry do:

    gconftool-2 --set --type boolean /apps/nautilus/preferences/always_use_location_entry true

See also
--------

-   GNOME

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNOME_Tips&oldid=294515"

Category:

-   GNOME

-   This page was last modified on 26 January 2014, at 11:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
