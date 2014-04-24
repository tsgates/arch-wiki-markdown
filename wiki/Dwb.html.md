dwb
===

dwb is an extremely fast, lightweight and flexible web browser using the
webkit engine. It is customizable through its web interface and fully
usable with keyboard shortcuts.

Contents
--------

-   1 Installation
-   2 Basic usage
    -   2.1 dwb-specific
    -   2.2 vim-like
    -   2.3 Notes
-   3 Configuration
    -   3.1 Search engines
    -   3.2 Custom keybinds
-   4 Extensions
    -   4.1 Adblock
-   5 Userscripts
    -   5.1 defer-loading
    -   5.2 fast-forward
    -   5.3 open-firefox
    -   5.4 startup-noautoreload
    -   5.5 toggle-stylesheet
    -   5.6 youtube-player
    -   5.7 rocker gestures
-   6 Stylesheet
-   7 Troubleshooting
    -   7.1 HTML5 audio and video does not work
    -   7.2 Search engines search for undefined
    -   7.3 Fuzzy font in Github
-   8 dwb-git
    -   8.1 Plugin Support
        -   8.1.1 Flash Support
        -   8.1.2 Java Support
    -   8.2 Improved Ability to Display Websites

Installation
------------

The dwb package can be found in the official repositories and can be
installed with pacman. There are also other versions in the AUR:
dwb-git, dwb-gtk3, and dwb-gtk3-git.

Basic usage
-----------

Starting from a fresh configuration, use Sk to open the Keys page. As
you can see from there, most bindings are borrowed from Vim and Emacs.

Use : to access the command prompt. You can use Tab to auto-complete.

Read the man page for more details and enable the auto-completion option
in the settings to help you learn the bindings.

    $ man dwb

> dwb-specific

    o        = enter url
    O        = enter url in new tab
    f        = spawn hints. Use arrow keys to browse the hints while displaying their URI, or use the hint letters.
    F        = spawn hints in new tab
    ;b       = spawn hints in new background tab
    ;r       = follow multiple background links rapidly
    H        = back
    L        = forward
    J        = go to next tab
    K        = go to previous tab
    'n'+T    = goto 'n' tab
    d        = close tab
    u        = undo close tab
    ctrl+s   = stop
    r        = reload
    R        = reload ignoring cache
    gi       = go to the first input field and enter insert mode
    ctrl+e   = open editable field in external editor. Useful for forums and wikis.
    ;d       = download via hints
    M        = save bookmark (bookmarks are saved in ~/.config/dwb/default/bookmarks)
    xb       = show/hide status bar
    gf       = toggle source view
    +        = zoom_in
    -        = zoom_out
    =        = reset to 100%

> vim-like

    i        = toggle_insert_mode   (Esc works to go back to normal mode much like Vim)
    Esc      = back to normal mode (ctrl+n works too)
    j        = scroll down
    k        = scroll up
    h        = scroll left
    l        = scroll right
    gg       = go to top
    G        = go to bottom
    /        = find in page
    n        = repeat find forward
    ZZ       = save session and exit

> Notes

Press v to switch to caret browsing, then press space to toggle between
caret and visual mode. Press Esc one or two times to go back to normal
mode. While in caret browsing, you can use the arrow keys to browse the
different parts of the page. Hold Shift to select text. Press Enter to
follow links.

Configuration
-------------

The configuration files are stored in $XDG_CONFIG_HOME/dwb/ (usually
 ~/.config/dwb/) and can be easily accessed through the web interface.
Type Ss to open the Settings page.

> Search engines

Open your favorite search engine, type gs to select the web page's first
input field, and then enter a keyword associated with it.

Now you can use the keyword in the URI prompt to search directly on the
corresponding website. Typing queries directly in the address bar will
search with the default search engine, which is the first entry in
$XDG_CONFIG_HOME/dwb/searchengines.

You can also add more by editing the configuration files. This may help
for tricky sites like rfc-editor.org.

.config/dwb/settings to

    searchengine-submit-pattern=XXX

.config/dwb/searchengines

    sp https://startpage.com/do/search?q=XXX
    wp https://en.wikipedia.org/w/index.php?search=XXX&title=Special:Search
    aw https://wiki.archlinux.org/index.php?title=Special:Search&search=XXX
    rfc http://www.rfc-editor.org/search/rfc_search_detail.php?rfc=&title=XXX

> Custom keybinds

You can create custom key bindings by editing file custom_keys in the
profile directory. This is ~/.config/dwb/default by default. All keysyms
which do not emit (multi)byte characters, must be enclosed in @. One
keybind can execute multiple dwb commands. These commands execute in
same order as they are defined in bind, and must be separated by ;;
separator. If the keybind's chord is already bound by dwb, it might be
ignored (behaviour is not consistent). In such case one can try to
check, whether there is collison with binds defined in
~/.config/dwb/keys and try to unbind the chord there (eg set it to
nothing). Any running dwb instance will owerwrite keys file on exit, so
remember to do your modifications while dwb is not runing or use default
dwb interface (Sk).

    ~/.config/dwb/default/custom_keys

    Control w           :close_tab
    Control @Page_Up@   :focus_prev
    Control @Page_Down@ :focus_next

Extensions
----------

dwb features an extension manager as a separate executable, dwbem. To
list all officially available extensions, use:

    dwbem -a

       Available extensions:      Mainstream equivalent:
       - adblock_subscriptions    Adblock
       - autoquvi                 Video DownloadHelper
       - contenthandler           (Handle requests based on MIME type, filename extension or URI scheme)
       - downloadhandler          (Handle downloads based on mimetype or filename extension, useful if 'download-no-confirm' is set)
       - formfiller               LastPass, Lazarus (Save form data and fill forms with previously saved data, also with gpg-support)
       - googlebookmarks          GBookmarks, GMarks (Add bookmarks to google bookmarks with a shortcut)
       - googledocs               Open with Google Docs, Google Docs Viewer
       - grabscrolling            (Adobe Acrobat style grab and drag mouse scrolling)
       - multimarks               (Bookmark multiple urls to a single quickmark)
       - navtools                 Opera Fast Forward, IE 10 Flip Ahead
       - perdomainsettings        (Change webkit-settings automatically on domain or url basis)
       - pwdhash                  PwdHash
       - requestpolicy            RequestPolicy, Disconnect, Ghostery
       - simplyread               Readability, Clearly
       - speeddial                Speed Dial
       - supergenpass             (Generate domain-based passwords; compatible with the bookmarklet supergenpass but with additional options)
       - unique_tabs              (Remove duplicate tabs or avoid duplicate tabs by autoswitching to tabs with same url)
       - userscripts              GreaseMonkey/Stylish
       - whitelistshortcuts       (Whitelist webkit settings for certain domains with a shortcut)

For more details, use dwbem -I <extension> and read the dwb and dwbem
man pages.

Below is a list of popular extensions (or add-ons) for which dwb has a
built-in alternative:

-   NoScript/Flashblock: dwb blocks flash by default and can block
    javascript.
-   Omnibar: just like Chrome, dwb's address gives quick access to
    search, history, and bookmarks.
-   Download Statusbar: dwb's displays downloads in a neat status bar by
    default.
-   IE Tab: dwb can open a page in any external browser with a simple
    userscript.
-   Session Manager: dwb uses its built-in session manager by default.
-   Private browsing: add xpp:toggle enable-private-browsing to
    custom_keys to toggle privacy mode by typing xpp.

> Adblock

dwb features an Adblock extension. Install it with

    $ dwbem -i adblock_subscriptions

Restart dwb, enable adblocker with :set adblocker true, use the
adblock_subscribe command and choose your favorite filter (avoid using
more than one filter to prevent duplicate entries that make the
adblocker much slower).

Userscripts
-----------

dwb can execute .js or .sh scripts put in ~/.config/dwb/userscripts/.
Make sure they are executable:

    chmod +x ~/.config/dwb/userscripts/myscript.js

Below are some example scripts, see dwb userscripts snippets for more:

> defer-loading

Prevents tabs from last session to load all at once at startup.

    ~/.config/dwb/userscripts/defer-loading.js

    //!javascript
    if (settings.loadOnFocus === false) {
        execute('local_set load-on-focus true');
    }
    Signal.connect('navigation', function(webview) {
        if (webview == tabs.current) {
            execute('local_set load-on-focus false');
            this.disconnect();
        }
    });

> fast-forward

Opera features a neat key binding which allows users to load to
next/previous logical page. This is very useful for forum threads,
documentation, and articles spread over several pages.

This feature can be implemented with a simple javascript function and
bound to custom keys } and {:

    ~/.config/dwb/default/custom_keys

    }:exja (function(){var e=document.querySelector("[rel='next']");if(e){location=e.href;}else{var f=document.getElementsByTagName("a");var i=f.length;while((e=f[--i])){if(e.text.search(/(\bnext\b|^>$|^(>>|»)$|^(>|»)|(>|»)$|\bmore\b)/i)>-1){location=e.href; break;}} location.href=location.href.replace(/(\d+)([^\/\d]*)$/, function(a,b,c){return ++b+c})}})();
    {:exja (function(){var e=document.querySelector("[rel='prev']");if(e){location=e.href;}else{var f=document.getElementsByTagName("a");var i=f.length;while((e=f[--i])){if(e.text.search(/(\b(prev|previous)\b|^<$|^(<<|«)$|^(<|«)|(<|«)$)/i)>-1){location=e.href;break;}} location.href=location.href.replace(/(\d+)([^\/\d]*)$/, function(a,b,c){return --b+c})}})();

Alternatively, the navtools extension provides the same functionality
and more, such as going up one directory, or loading the root URI.

> open-firefox

Opens current page in Firefox with xf (uses firefox and libnotify).

    ~/.config/dwb/userscripts/open-firefox.sh

    #!/bin/bash
    # dwb: xf
    firefox $DWB_URI &
    notify-send -u low "Firefox opening $DWB_URI" #optional notification

> startup-noautoreload

Prevents previously-opened tabs from reloading all at once after a
restart.

    ~/.config/dwb/userscripts/startup-noautoreload.js

    //!javascript
    // prevents previously-opened tabs from reloading all at once after a restart.
    execute("set load-on-focus true");

    var sigId = Signal.connect("navigation", function(wv) {
            if (wv == tabs.current)
            {
                        execute("set load-on-focus false");
                                Signal.disconnect(sigId);
                                    }
    });

> toggle-stylesheet

Toggles between 2 global stylesheets with xg.

    ~/.config/dwb/userscripts/toggle-stylesheet.sh

    #!/bin/bash
    # dwb:xg

    CURRENT_STYLESHEET="$(dwbremote get setting user-stylesheet-uri)"

    STYLESHEET_1="file://$HOME/.config/dwb/stylesheets/foo.css"
    STYLESHEET_2="file://$HOME/.config/dwb/stylesheets/bar.css"

    if [[ "${CURRENT_STYLESHEET}" = ${STYLESHEET_1} ]]; then
        dwbremote :local_set user-stylesheet-uri "$STYLESHEET_2"
    else 
        dwbremote :local_set user-stylesheet-uri "$STYLESHEET_1"
    fi

> youtube-player

Opens YouTube videos with MPlayer (uses mplayer and youtube-dl).

    ~/.config/dwb/userscripts/youtube-mplayer.js

    //!javascript 
    // opens YouTube videos with mplayer.
    var regex = new RegExp("http(.*)://www.youtube.com/watch\\?(.*&)*v=.*");

    signals.connect("navigation", function (wv, frame, request) {
      if (wv.mainFrame == frame && regex.test(request.uri)) 
        system.spawn("sh -c 'mplayer \"$(youtube-dl -g " + request.uri + ")\"'");
      return false;
    });

> rocker gestures

Enables Opera-like rocker gestures for navigating the history. Disable
the context menu in the settings first.

    ~/.config/dwb/userscripts/rocker.js

    //!javascript
    var LMB = 1, MMB=2, RMB = 3, UNKNOWN = 10, DOWN = 11, UP = 12;

    var buttonStates = [UNKNOWN, UNKNOWN, UNKNOWN, UNKNOWN, UNKNOWN, UNKNOWN];
    var bp = new Signal("onButtonPress", function(wv, result, ev) {
            var mouseButton = ev.button;

            buttonStates[mouseButton] = DOWN;

            if (mouseButton == LMB && buttonStates[RMB] == DOWN) {
                    execute("history_back");
            } else if (mouseButton == RMB && buttonStates[LMB] == DOWN) {
                    execute("history_forward");
            }
    });
    var br = new Signal("onButtonRelease", function(wv, result, ev) {
            buttonStates[ev.button] = UP;
    });

    bp.connect();
    br.connect();

Stylesheet
----------

a global stylesheet can be defined in the Settings, under
user-stylesheet-uri (i.e. file:///home/tux/.config/dwb/stylesheet.css)

If you browse with the status bar hidden and are annoyed by the the link
previews that appear while hovering over links with the mouse, add this
to the stylesheet: #dwb_hover_element { display:none!important; }

Troubleshooting
---------------

> HTML5 audio and video does not work

Make sure you have the following GStreamer packages installed:

    # pacman -S --needed gstreamer0.10 gstreamer0.10-bad gstreamer0.10-bad-plugins gstreamer0.10-base gstreamer0.10-base-plugins gstreamer0.10-good gstreamer0.10-good-plugins gstreamer0.10-ugly gstreamer0.10-ugly-plugins gstreamer0.10-ffmpeg

> Search engines search for undefined

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

dwb-git
-------

dwb-git offers many improvements over the stable version. Most the most
notable of which are listed below.

> Plugin Support

Browser Plugins can be enabled and disabled through the new [dwb:plugins
dwb:plugins] settings page. Other Browser plugins may be supported as
well, but these two alone will make your dwb experience much more
enjoyable.

Flash Support

dwb-git has built in support for the flashplugin. Dwb should auto-detect
and enabled the plugin after it is installed. Alternatively, you can
install gnash-gtk and it will be detected as well.

Java Support

dwb-git has built in support for the icedtea-web-java7. Dwb should
auto-detect and enable the plugin after it is installed.

> Improved Ability to Display Websites

If you are having problems with they layout of websites not loading
correctly then give dwb-git a shot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dwb&oldid=305199"

Category:

-   Web Browser

-   This page was last modified on 16 March 2014, at 19:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
