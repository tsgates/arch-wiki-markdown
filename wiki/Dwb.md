dwb
===

  Summary
  ----------------------------------------------------------------------
  This article addresses the steps necessary to run and configure dwb.

dwb is an extremely fast, lightweight and flexible web browser using the
webkit engine. It is customizable through its web interface and fully
usable with keyboard shortcuts.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Basic usage                                                        |
| -   3 Configuration                                                      |
|     -   3.1 Search engines                                               |
|     -   3.2 Custom keybinds                                              |
|                                                                          |
| -   4 Extensions                                                         |
|     -   4.1 Adblock                                                      |
|                                                                          |
| -   5 Userscripts                                                        |
|     -   5.1 startup-noautoreload                                         |
|     -   5.2 youtube-mplayer                                              |
|                                                                          |
| -   6 Stylesheets                                                        |
| -   7 Troubleshooting                                                    |
|     -   7.1 HTML5 audio and video does not work                          |
|     -   7.2 Search engines always search for undefined                   |
|     -   7.3 Fuzzy font in Github                                         |
+--------------------------------------------------------------------------+

Installation
------------

The dwb package can be found in the official repositories and can be
installed with pacman.

    # pacman -S dwb

There are also other versions in the AUR: dwb-hg, dwb-gtk3, and
dwb-gtk3-hg.

Basic usage
-----------

Starting from a fresh configuration, use Sk to open the Keys page. As
you can see from there, most bindings are borrowed from Vim and Emacs.

Use : to access the command prompt. You can use Tab to auto-complete.

Read the man page for more details.

    $ man dwb

Configuration
-------------

Almost everything can be configured from the Settings page. You can
access it with Ss by default.

The configuration files are stored in $XDG_CONFIG_HOME/dwb/ (usually
 ~/.config/dwb/).

> Search engines

Use gs to create a search engine from the first input field on the web
page. Use Tab to switch between fields. Then enter a keyword.

Now you can use the keyword in the URI prompt to search directly on the
corresponding website.

The first entry in $XDG_CONFIG_HOME/dwb/searchengines will be the
default search engine.

> Custom keybinds

You can create custom key bindings by editing file custom_keys in the
profile directory. This is ~/.config/dwb/default by default. All keysyms
which don't emit (multi)byte characters, must be enclosed in @. One
keybind can execute multiple dwb commands. These commands execute in
same order as they are defined in bind, and must be separated by ;;
separator. If the keybind's chord is already bound by dwb, it might be
ignored (behaviour is not consistent). In such case one can try to
check, whether there is collison with binds defined in
~/.config/dwb/keys and try to unbind the chord there (eg set it to
nothing). Any running dwb instance will owerwrite keys file on exit, so
remember to do your modifications while dwb is not runing or use default
dwb interface (S k).

    ~/.config/dwb/default/custom_keys

    Control w           :close_tab
    Control @Page_Up@   :focus_prev
    Control @Page_Down@ :focus_next

Extensions
----------

dwb features an extension manager as a separate executable, dwbem. To
list all officially available extensions, use:

    $ dwbem -a

Read the man page for more details.

> Adblock

dwb features an Adblock extension. Install it with

    $ dwbem -i adblock_subscriptions

Restart dwb, use the adblock_subscribe command and choose your favorite
lists of filters.

Userscripts
-----------

dwb can execute .js or .sh scripts put in ~/.config/dwb/userscripts/.
Make sure they are executable:

    chmod +x ~/.config/dwb/userscripts/myscript.js

Below are some example scripts:

> startup-noautoreload

Prevents previously-opened tabs from reloading all at once after a
restart.

    ~/.config/dwb/userscripts/startup-noautoreload.js

    //!javascript
    // prevents previously-opened tabs from reloading all at once after a restart.
    execute("set load-on-focus true");

    var sigId = signals.connect("navigation", function(wv) {
            if (wv == tabs.current)
            {
                        execute("set load-on-focus false");
                                signals.disconnect(sigId);
                                    }
    });

> youtube-mplayer

Opens YouTube videos with mplayer (requires mplayer and youtube-dl).

    ~/.config/dwb/userscripts/youtube-mplayer.js

    //!javascript 
    // opens YouTube videos with mplayer.
    var regex = new RegExp("http(.*)://www.youtube.com/watch\\?(.*&)*v=.*");

    signals.connect("navigation", function (wv, frame, request) {
      if (wv.mainFrame == frame && regex.test(request.uri)) 
        system.spawn("sh -c 'mplayer \"$(youtube-dl -g " + request.uri + ")\"'");
      return false;
    });

Stylesheets
-----------

Stylesheets can be defined in the Settings page under
user-stylesheet-uri file:///home/tux/.config/dwb/stylesheet.css

Troubleshooting
---------------

> HTML5 audio and video does not work

Make sure you have the following GStreamer packages installed:

    # pacman -S --needed gstreamer0.10 gstreamer0.10-bad gstreamer0.10-bad-plugins gstreamer0.10-base gstreamer0.10-base-plugins gstreamer0.10-good gstreamer0.10-good-plugins gstreamer0.10-ugly gstreamer0.10-ugly-plugins

> Search engines always search for undefined

If you are always searching for undefined even with the
searchengine-submit-pattern option set, then you should edit
$XDG_CONFIG_HOME/dwb/searchengines and adapt the URIs to match your
searchengine-submit-pattern.

> Fuzzy font in Github

Add this in your ~/.config/fontconfig/fonts.conf inside the
fontconfig-tags:

     <selectfont>
       <rejectfont>
         <pattern>
           <patelt name="family">
             <string>Clean</string>
           </patelt>
         </pattern>
       </rejectfont>
     </selectfont>

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dwb&oldid=255579"

Category:

-   Web Browser
