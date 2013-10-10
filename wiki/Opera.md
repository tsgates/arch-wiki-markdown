Opera
=====

> Summary

Installing and configuration of the Opera browser and plugins.

> Related

Browser Plugins

Firefox

Chromium

Opera is a free of charge web browser developed since 1994 by the
Norwegian company Opera Software. It is known for being the first to
bring new browsing features to the world that have become common on all
web browsers, such as tabbed browsing and built-in search.

Opera continues to innovate with its integrated mail client, one-click
bookmarking, tab stacks (a way of organizing your tabs) and very good
support for HTML5 features.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Plugins                                                            |
|     -   2.1 Adobe Flash                                                  |
|     -   2.2 Java Support                                                 |
|     -   2.3 Adblock                                                      |
|                                                                          |
| -   3 Performance tweaks                                                 |
|     -   3.1 Disabling features and services                              |
|         -   3.1.1 Disable the e-mail client                              |
|         -   3.1.2 Disable ARGB, LIRC and mailto links                    |
|                                                                          |
|     -   3.2 Improving Flash performance                                  |
|         -   3.2.1 .xinitrc example                                       |
|         -   3.2.2 Command-line example                                   |
|                                                                          |
|     -   3.3 Profile in tmpfs                                             |
|                                                                          |
| -   4 Appearance                                                         |
|     -   4.1 Themes                                                       |
|     -   4.2 Tab modes                                                    |
|     -   4.3 Fonts                                                        |
|                                                                          |
| -   5 Private tabs                                                       |
| -   6 Accessibility Tips                                                 |
|     -   6.1 Disable text selection                                       |
|     -   6.2 Grab and scroll mode                                         |
|     -   6.3 Long pressing a link opens it in a background tab            |
|         (extension)                                                      |
|     -   6.4 Virtual On-Screen keyboard (extension)                       |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Slow scrolling on NVIDIA cards                               |
|     -   7.2 Horizontal mouse wheel scrolling                             |
|     -   7.3 Launching an external browser                                |
|     -   7.4 Opera crashes when starting or closing with GTK+ 2.24.7+     |
|     -   7.5 Unreadable input fields and address bar with dark GTK+       |
|         themes                                                           |
|                                                                          |
| -   8 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Opera can be installed with the package opera, available in the official
repositories.

Development versions can be found in the AUR:

-   opera-beta - a beta release version.
-   opera-next - an alpha/development version.

Plugins
-------

Opera can use Netscape-based plugins that are supported by most major
browsers, like Firefox and Chromium. For details about different plugins
and installation instructions see Browser Plugins. In Opera, the plugin
path can be specified under Settings > Preferences... > Advanced >
Content > Plug-in Options.

> Adobe Flash

See the main article: Browser Plugins#Flash Player

> Java Support

See the main article: Browser Plugins#Java (IcedTea)

> Adblock

Install Adblock support using the opera-adblock-complete package from
the AUR.

Performance tweaks
------------------

Although Opera is quite fast on modern hardware, it can be tweaked even
more. For further examples, see the Opera wiki page on performance.

> Disabling features and services

One of the keys to maximizing application performance is to disable
undesired features and services through the native opera:config
Preferences Editor.

Some commonly disabled features are:

-   Systray Icon: uncheck Show Tray Icon under opera:config#UserPrefs.
-   BitTorrent: uncheck Enable under opera:config#BitTorrent.
-   Geolocation: uncheck Enable geolocation under
    opera:config#Geolocation.
-   Multimedia: unckeck desired options under opera:config#Multimedia.
-   Web Server: uncheck Enable under opera:config#Web Server.

To more easily find these options just write the respective path
(without spaces) in the address bar, for example
opera:config#UserPrefs|ShowTrayIcon or use the build-in search.

Disable the e-mail client

Additional command-line options are available for further control over
browser features and services. To start Opera without the default
internal e-mail client:

    $ opera -nomail

Alternatively, if you want to permanently disable the internal e-mail
client you can uncheck the Show E-mail Client option under
opera:config#UserPrefs.

Disable ARGB, LIRC and mailto links

To start Opera without ARGB (32-bit) visuals, LIRC infrared control
support and with mailto: links disabled:

    $ opera -noargb -nolirc -nomaillinks 

> Improving Flash performance

To improve Flash performance you can set the following environment
variables before starting Opera, or export the entries in xinitrc, or
~/.bash_profile, or for system-wide changes, to /etc/profile:

     OPERAPLUGINWRAPPER_PRIORITY=0
     OPERA_KEEP_BLOCKED_PLUGIN=1

Another environment variable which may help resolve Flash issues:

    GDK_NATIVE_WINDOWS=1

See the blog article Flash problems on Linux? for additional details.

.xinitrc example

    ~/.xinitrc

    ...
    export OPERAPLUGINWRAPPER_PRIORITY=0
    export OPERA_KEEP_BLOCKED_PLUGIN=0
    ...

Command-line example

To use the variables from the command line call Opera as:

    $ OPERAPLUGINWRAPPER_PRIORITY=0 OPERA_KEEP_BLOCKED_PLUGIN=1 opera &

> Profile in tmpfs

Relocate the browser profile to a tmpfs filesystem, including /tmp for
improvements in application response as the entire profile is now stored
in RAM. Another benefit is a reduction in disk read and write
operations, of which SSDs benefit the most.

There are currently two ways of doing this:

-   using Profile-sync-daemon, that automatically detects and relocates
    the Opera profile to tmpfs.
-   using the -pd command-line flag to tell Opera where to store its
    profile data:

    $ opera -pd /tmp/opera

Appearance
----------

> Themes

Although Opera is cross-platform, it can be made to integrate very well
into various Linux desktop environments.

 Qt
    To make the menus look integrated with Qt, install your preferred Qt
    theme and apply it by using qtconfig.
 KDE
    To make Opera use KDE icons, you can install a theme such as this
    one.
 GTK+
    A nice GTK+ skin that uses the Tango icon theme can be found here.

  

> Tab modes

Opera has native support for tab cascading and tiling mode. Appropriate
buttons can be found by activating the "Main" toolbar or by dragging and
dropping the buttons anywhere desired, found in Menu > Appearance >
Buttons > Browser.

> Fonts

Fonts can be configured under Settings > Preferences... > Advanced >
Fonts.

If the ttf-ms-fonts package has been installed before running Opera for
the first time, Opera will use those fonts by default, regardless of
what is specified by local GTK+ options, GNOME or KDE font management.
To force existing installations of Opera to use the options set by your
system:

-   Close all running instances of Opera.
-   Un-install the ttf-ms-fonts package.
-   Move the existing profile folder: mv -i ~/.opera ~/.opera.bak
-   Run an instance of Opera and verify that your font manager settings
    have been applied.
-   Restore bookmarks and desired filter files from ~/.opera.bak to
    ~/.opera except for the operaprefs.ini file.
-   Re-install the ttf-ms-fonts package, if desired.

Private tabs
------------

To browse without leaving obvious traces of the Web sites you visit, you
can use a private tab. When you close a private tab, the following data
related to the tab is deleted:

-   Cache
-   Cookies
-   History
-   Logins

This is similar to the --incognito option in Chrome/Chromium and
PrivateBrowsing in Firefox.

To open a private tab from the command-line use:

    $ opera -newprivatetab

To ensure only private tabs are used throughout the duration of the
browsing session:

-   Set Settings > Preferences... > General > Startup > Start without
    open tabs.
-   Clear any entries in Settings > Preferences... > General > Home page
    option.
-   Enable Settings > Preferences... > Advanced > Tabs > Additional tab
    options... > Allow windows with no tabs.

To open a new window for private browsing when already running Opera you
can just press Ctrl+Shift+N or look under Menu > New Tabs and Windows >
New Private Window. All subsequent opened tabs with be private as well.

Accessibility Tips
------------------

> Disable text selection

It is possible to disable text selection in Opera. However, text
selection through JavaScript will still work (for example in forms,
etc.). To get to the setting follow the link bellow:

    opera:config#System|DisableTextSelect

> Grab and scroll mode

Besides setting text selection off, grab and scroll mode makes page
scrolling possible with mouse dragging. It is very useful, especially
when you have a touchscreen. Copy and paste the link bellow to get to
the mentioned setting.

    opera:config#UserPrefs|ScrollIsPan

It is also possible to change this setting on the fly by dragging and
dropping the appropriate Opera button into a toolbar. The button can be
found in Menu > Appearance > Buttons > Browser View.

> Long pressing a link opens it in a background tab (extension)

It is possible to open up any long-clicked link in a new background tab
by installing this extension.

> Virtual On-Screen keyboard (extension)

There is an extension which allows the use of an on-screen virtual
keyboard. Further details and installation link can be found here.

Troubleshooting
---------------

> Slow scrolling on NVIDIA cards

Try running the following command:

    $ nvidia-settings -a InitialPixmapPlacement=2

On some computers, http://helion.pl works extremely slow without this
hack, making it a perfect site for testing.

> Horizontal mouse wheel scrolling

Check Settings > Preferences... > Advanced > Shortcuts > Mouse >
Middle-Click Options... > Enable horizontal panning.

or

-   Highlight Settings > Preferences... > Advanced > Shortcuts > Mouse >
    Opera Standard.
-   Duplicate Settings > Preferences... > Advanced > Shortcuts > Mouse >
    Opera Standard.
-   Edit... Settings > Preferences... > Advanced > Shortcuts > Mouse >
    Copy of Opera Standard.
-   Search the Forward and Back input contexts and edit the appropriate
    button shortcuts to scroll left and scroll right.
-   Rename Settings > Preferences... > Advanced > Shortcuts > Mouse >
    Copy of Opera Standard as desired.

> Launching an external browser

If Opera does not display a site well, a workaround is to launch the
currently displayed page in an external browser.

Note:The following method appears to be deprecated in favor of the
built-in Open With menu accessed via the right mouse button.

-   Set the following line under [Site Navigation Toolbar.content] in
    $HOME/.opera/toolbar/standard_toolbar.ini:

    Button0, "Chromium"="Execute program, "chromium, "%u", , "Chromium""

-   If Firefox is desired, or preferred:

    Button0, "Firefox"="Execute program, "firefox", "%u", , "Firefox""

-   Any number of command-line options may be included in the string:

    Button0, "Chromium"="Execute program, "chromium --block-nonsandboxed-plugins --disable-java --incognito --safe-plugins --start-maximized --user-data-dir=/tmp/.chromium", "%u", , "Chromium""

> Opera crashes when starting or closing with GTK+ 2.24.7+

If this crash occurs, you can work around it by changing the
DialogToolkit option to 4:

    opera:config#FileSelector|DialogToolkit

This will disable GTK+ styling support and hence avoid the issue.

> Unreadable input fields and address bar with dark GTK+ themes

When using a dark GTK theme, one might encounter Opera address bar and
Internet pages with unreadable input and text fields (e.g. Amazon can
have black text on black text field background). This can happen because
the site only sets either background or text color, and Opera takes the
other one from the theme.

Using an installed clear theme and a command help to work around the
problem:
env GTK2_RC_FILES=/usr/share/themes/<light-theme-name/gtk-2.0/gtkrc opera

to turn it as default, use a prefered text editor and edit the file
/usr/bin/opera. e.g. using Opera 12.14:

    sudo gedit /usr/bin/opera
    ...
    #!/bin/sh
    export OPERA_DIR=${OPERA_DIR:-/usr/share/opera}
    export OPERA_PERSONALDIR=${OPERA_PERSONALDIR:-$HOME/.opera}
    exec /usr/lib/opera/opera "$@"

edit the file and follow the example changing to...

    /usr/bin/opera
    ...
    #!/bin/sh
    export OPERA_DIR=${OPERA_DIR:-/usr/share/opera}
    export OPERA_PERSONALDIR=${OPERA_PERSONALDIR:-$HOME/.opera}
    env GTK2_RC_FILES=/usr/share/themes/Clearlooks/gtk-2.0/gtkrc /usr/lib/opera/opera "$@"

this will make the browser use a clear theme that you set in the file
/usr/bin/opera that was used in the above example the theme "Clearlooks"
and the problems will be solved.

See Also
--------

-   Opera Wiki
-   Opera Knowledge Base
-   Opera For UNIX Forums
-   Opera Bug Report
-   Opera Tips
-   Opera Documentation
-   Opera Help

Retrieved from
"https://wiki.archlinux.org/index.php?title=Opera&oldid=250533"

Category:

-   Web Browser
