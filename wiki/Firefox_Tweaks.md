Firefox Tweaks
==============

> Summary

This page contains advanced Firefox configuration options and
performance tweaks.

> Related

Firefox

Browser Plugins

Firefox Ramdisk

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Performance                                                        |
|     -   1.1 Advanced Firefox options                                     |
|         -   1.1.1 Network settings                                       |
|         -   1.1.2 Turn off anti-phishing                                 |
|         -   1.1.3 Stop urlclassifier3.sqlite from being created again    |
|         -   1.1.4 Improve font rendering by disabling pango              |
|                                                                          |
|     -   1.2 Other modifications                                          |
|         -   1.2.1 Reduce load time by compressing the Firefox binary     |
|             with UPX                                                     |
|         -   1.2.2 Defragment the profile's SQLite databases              |
|         -   1.2.3 Cache the entire profile into RAM via tmpfs            |
|                                                                          |
| -   2 Appearance                                                         |
|     -   2.1 Fonts                                                        |
|         -   2.1.1 Configure the DPI value                                |
|         -   2.1.2 Default font settings from Microsoft Windows           |
|                                                                          |
|     -   2.2 General user interface CSS settings                          |
|         -   2.2.1 Change the font                                        |
|         -   2.2.2 Hide button icons                                      |
|         -   2.2.3 Hiding various tab buttons                             |
|         -   2.2.4 Horizontal tabs                                        |
|         -   2.2.5 Auto-hide Bookmarks Toolbar                            |
|         -   2.2.6 Remove sidebar width restrictions                      |
|                                                                          |
|     -   2.3 Web content CSS settings                                     |
|         -   2.3.1 Block certain parts of a domain                        |
|         -   2.3.2 Add [pdf] after links to PDF files                     |
|         -   2.3.3 Show URLs at the bottom of the screen when hovering a  |
|             link                                                         |
|         -   2.3.4 Firefox 4 New Menu Bar/Firefox Button                  |
|         -   2.3.5 Block ads                                              |
|                                                                          |
| -   3 Miscellaneous                                                      |
|     -   3.1 Mouse wheel scroll speed                                     |
|     -   3.2 Change the order of search engines in the Firefox Search Bar |
|     -   3.3 How to open a *.doc automatically with Abiword or            |
|         LibreOffice Writer                                               |
|     -   3.4 Secure DNS with DNSSEC validator                             |
|     -   3.5 Adding magnet protocol association                           |
|     -   3.6 Prevent accidental closing                                   |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Performance
-----------

Improving Firefox's performance is divided into parameters that can be
inputted while running Firefox or otherwise modifying its configuration
as intended by the developers, and advanced procedures that involve
foreign programs or scripts.

Note:Always use the latest version of Firefox.

> Advanced Firefox options

This section contains advanced Firefox options for performance tweaking.
For additional information see these Mozillazine forum posts.

Network settings

Advanced network settings can be found on the about:config page (try
searching for network).

  Key                                                  Value   Description
  ---------------------------------------------------- ------- ----------------------------------------------------------
  network.http.pipelining                              true    Enable pipelining for normal connections
  network.http.proxy.pipelining                        true    Enable pipelining for proxy connections
  network.http.pipelining.maxrequests                  8       Maximum HTTP requests per pipeline
  network.http.max-connections                         64      Maximum number of total HTTP connections
  network.http.max-connections-per-server              16      Maximum number of any type of connections per server
  network.http.max-persistent-connections-per-proxy    16      Maximum number of keep-alive type connections per proxy
  network.http.max-persistent-connections-per-server   8       Maximum number of keep-alive type connections per server
  network.dns.disableIPv6                              true    Disable IPv6 support

  :  Recommended values for a 1.5Mb connection

Note:These settings need to be configured based on your connection.

Turn off anti-phishing

Note:Deleting files from your profile folder is potentially dangerous,
so it is recommended that you back it up first.

The anti-phishing features of Firefox may cause Firefox to become slow
to start or exit. The problem is that Firefox maintains an Sqlite
database that can grow quite big which makes reading and writing slower
after repeated use. If you feel that you do not need Firefox to tell you
which sites may be suspect you can disable this feature:

-   Turn off the following options under the security tab in
    preferences: "Block reported attack sites" and "Block reported web
    forgeries".

-   Delete all files beginning with urlclassifier in your profile folder
    (~/.mozilla/firefox/<profile_dir>/):

    $ rm -i ~/.mozilla/firefox/<profile_dir>/urlclassifier*

Some of these files might be recreated by Firefox, but they won't grow
any larger than their initial size.

Stop urlclassifier3.sqlite from being created again

If you did remove all the urlclassifier* files as mentioned above, you
may find out that urlclassifier3.sqlite keeps growing again after a
certain time. Here is a simple solution to avoid it for now and ever.

    $ cd ~/.mozilla/firefox/<profile_dir>
    $ echo "" > urlclassifier3.sqlite
    $ chmod 400 urlclassifier3.sqlite

This effectively makes the file empty and then read-only so Firefox
cannot write to it anymore.

Improve font rendering by disabling pango

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: What is this     
                           supposed to improve?     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

To disable Pango font handling in Firefox, add:

    export MOZ_DISABLE_PANGO=1

to the ~/.profile or to /etc/profile or to a shell configuration file
(e.g. .bashrc) and re-login for the change to take place.

Note:Exporting the setting may also fix font issues for the entire
Mozilla suite.

> Other modifications

This section contains some other modifications that may increase
Firefox's performance.

Reduce load time by compressing the Firefox binary with UPX

UPX is an executable packer that supports very fast decompression and
induces no memory overhead. It can be installed with the upx package,
availalble in the official repositories.

Before using upx to compress the Firefox executable, make a backup of
the binary:

    # cp /usr/lib/firefox/firefox /usr/lib/firefox/firefox.backup

Finally, invoke upx, applying the best possible compression level:

    # upx --best /usr/lib/firefox/firefox

Defragment the profile's SQLite databases

Warning:This procedure may damage the databases in such a way that
sessions are not saved properly.

In Firefox 3.0, bookmarks, history, passwords are kept in an SQLite
databases. SQLite databases become fragmented over time and empty spaces
appear all around. But, since there are no managing processes checking
and optimizing the database, these factors eventually result in a
performance hit. A good way to improve start-up and some other bookmarks
and history related tasks is to defragment and trim unused space from
these databases.

profile-cleaner in the AUR does just this.

  SQLite database         Size Before   Size After    % change
  ----------------------- ------------- ------------ -----------
  urlclassifier3.sqlite   37 M          30 M         19 %
  places.sqlite           16 M          2.4 M        85 %

  :  Sample size differences comparison

Cache the entire profile into RAM via tmpfs

If the system has memory to spare, tmpfs can be used to cache the entire
profile directory, which might result in increased Firefox
responsiveness.

Appearance
----------

> Fonts

See the main article: Font Configuration

Configure the DPI value

Modifying the following value can help improve the way fonts looks in
Firefox if the system's DPI is below 96. Firefox, by default, uses 96
and only uses the system's DPI if it is a higher value. To force the
system's DPI regardless of its value, type about:config into the address
bar and set layout.css.dpi to 0.

In Xfce, the above method only affects the Firefox user interface's DPI
settings, but web page contents still use a DPI value of 96, which may
look ugly. A solution is to change layout.css.devPixelsPerPx to system's
DPI divided by 96. For example, if your system's DPI is 142, then the
value to add is 142/96 = 1.48. Changing layout.css.devPixelsPerPx to
1.48 makes web page contents use a DPI of 142, which looks much better.

Default font settings from Microsoft Windows

Below are the default font preferences when Firefox is installed in
Microsoft Windows. Many web sites use the Microsoft fonts.

    Proportional: Serif Size (pixels): 16
    Serif: Times New Roman
    Sans-serif: Arial
    Monospace: Courier New Size (pixels): 13

> General user interface CSS settings

Firefox's user interface can be modified by editing the userChrome.css
and userContent.css files in ~/.mozilla/firefox/<profile_dir>/chrome/
(profile_dir is of the form hash.name, where the hash is an 8 character,
seemingly random string and the profile name is usually default).

Note:The chrome/ folder and userChrome.css/userContent.css files may not
necessarily exist, so you have to create them.

This section only deals with the userChrome.css file which modifies
Firefox's user interface, and not web pages.

Change the font

The setting effectively overrides the global GTK+ font preferences, and
does not affect webpages, only the user interface itself:

    ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css

    * {
        font-family: "FONT_NAME";
    }

Hide button icons

Enables text-only buttons:

    ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css

    .button-box .button-icon {
        display: none;
    }

Hiding various tab buttons

These settings hide the arrows that appear to the horizontal edges of
the tab bar, the button that toggles the "all tabs" drop-down list, and
the plus sign button that creates a new tab.

    ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css

    /* Tab bar */

    .tabbrowser-strip *[class^="scrollbutton"] {
        /* Hide tab scroll buttons */
        display: none;
    }

    .tabbrowser-strip *[class^="tabs-alltabs"] {
        /* Hide tab drop-down list */
        display: none;
    }

    .tabbrowser-strip *[class^="tabs-newtab-button"] {
        /* Hide new-tab button */
        display: none;
    }

Horizontal tabs

To place the tab bar horizontally stacked along the sides of the browser
window:

    ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css

    /* Display the tabbar on the left */
    #content > tabbox {
        -moz-box-orient: horizontal;
    }

    .tabbrowser-strip {
        -moz-box-orient: vertical;
        /*
         * You can set this to -moz-scrollbars-vertical instead,
         * but then the scrollbar will *always* be visible.  this way
         * there is never a scrollbar, so it behaves like the tab bar
         * normally does
         */
         overflow: -moz-scrollbars-none;
    }

    .tabbrowser-tabs {
        -moz-box-orient: horizontal;
        min-width: 20ex;   /* You may want to increase this value */
        -mox-box-pack: start;
        -moz-box-align: start;
    }

    .tabbrowser-tabs > hbox {
        -moz-box-orient: vertical;
        -moz-box-align: stretch;
        -moz-box-pack: start;
    }

    .tabbrowser-tabs > hbox > tab {
        -moz-box-align: start;
        -moz-box-orient: horizontal;
    }

Auto-hide Bookmarks Toolbar

    ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css

    #PersonalToolbar {
        visibility: collapse !important;
    }

    #navigator-toolbox:hover > #PersonalToolbar {
        visibility: visible !important;
    }

Remove sidebar width restrictions

    ~/.mozilla/firefox/<profile_dir>/chrome/userChrome.css

    /* remove maximum/minimum  width restriction of sidebar */
    #sidebar {
        max-width: none !important;
        min-width: 0px !important;
    }

> Web content CSS settings

This section deals with the userContent.css files in which you can add
custom CSS rules for web content. You can import other CSS files by
adding to the file:

    ~/.mozilla/firefox/<profile_dir>/chrome/userContent.css

    @import url("./imports/some_file.css");

Block certain parts of a domain

    ~/.mozilla/firefox/<profile_dir>/chrome/userContent.css

    @-moz-document domain(example.com) {
        div#header {
            background-image: none !important;
        } 
    }

Add [pdf] after links to PDF files

    ~/.mozilla/firefox/<profile_dir>/chrome/userContent.css

    /* add '[pdf]' next to links to PDF files */
    a[href$=".pdf"]:after {
        font-size: smaller;
        content: " [pdf]";
    }

Show URLs at the bottom of the screen when hovering a link

    ~/.mozilla/firefox/<profile_dir>/chrome/userContent.css

    a[href]:hover {
        text-decoration: none !important;
    }

    a[href]:hover:after {
        content: attr(href);
        position: fixed; left: 0px; bottom: 0px;
        padding: 0 2px !important;
        max-width: 95%; overflow: hidden;
        white-space: nowrap; text-overflow: ellipsis;
        font:10pt sans-serif !important;
        background-color: black  !important;
        color: white !important;
        opacity: 0.7;
        z-index: 9999;
    }</nowiki>

Firefox 4 New Menu Bar/Firefox Button

To toggle between the new Firefox button and the classic menu bar:

-   if the button is active, check Preferences > Menu Bar, or right
    click in the toolbar area and check Menu Bar.
-   if the menu bar is active, uncheck View > Toolbars > Menu Bar, or
    right click in the toolbar area and uncheck Menu Bar.

In GNU/Linux, you will just get a plain grey button instead of the new
orange one from Windows. However you can change this to either a Firefox
icon or the icon followed by the "Firefox" text.

Adding the following to your
~/.mozilla/firefox/userprofile/chrome/userChrome.css file will place the
icon before the text:

    #appmenu-toolbar-button {
      list-style-image: url("chrome://branding/content/icon16.png");
    }

Adding the following to the same file will remove the "Firefox" text:

    #appmenu-toolbar-button > .toolbarbutton-text,
    #appmenu-toolbar-button > .toolbarbutton-menu-dropmarker {
      display: none !important;
    }

  
 This userChrome.css configuration copies the default Windows Firefox 4+
look and adds an orange background to the button, with a purple
background in Private Browsing mode:

    #main-window:not([privatebrowsingmode]) #appmenu-toolbar-button {
        -moz-appearance: none !important;
        color: #FEEDFC !important;
        background: -moz-linear-gradient(hsl(34,85%,60%), hsl(26,72%,53%) 95%) !important;
        border: 1px solid #000000 !important;
    }

    #main-window:not([privatebrowsingmode]) #appmenu-toolbar-button:hover:not(:active):not([open]) {
        -moz-appearance: none !important;
        color: #FEEDFC !important;
        background: -moz-linear-gradient(hsl(26,72%,53%), hsl(34,85%,60%) 95%) !important;
        border: 1px solid #000000 !important;
    }


    #main-window:not([privatebrowsingmode]) #appmenu-toolbar-button:hover:active,
    #main-window:not([privatebrowsingmode]) #appmenu-toolbar-button[open] {
        -moz-appearance: none !important;
        color: #FEEDFC !important;
        background: -moz-linear-gradient(hsl(26,72%,53%), hsl(26,72%,53%) 95%) !important;
        border: 1px solid #000000 !important;
    }

    #appmenu-toolbar-button {
        -moz-appearance: none !important;
        color: #FEEDFC !important;
        background: -moz-linear-gradient(hsl(279,70%,46%), hsl(276,75%,38%) 95%) !important;
        border: 1px solid #000000 !important;
    }


    #main-window #appmenu-toolbar-button:hover:not(:active):not([open]) {
        -moz-appearance: none !important;
        color: #FEEDFC !important;
        background: -moz-linear-gradient(hsl(276,75%,38%), hsl(279,70%,46%) 95%) !important;
        border: 1px solid #000000 !important;
    }


    #main-window #appmenu-toolbar-button:hover:active,
    #main-window #appmenu-toolbar-button[open] {
        -moz-appearance: none !important;
        color: #FEEDFC !important;
        background: -moz-linear-gradient(hsl(276,75%,38%), hsl(276,75%,38%) 95%) !important;
        border: 1px solid #000000 !important;
    }

Note:You need to create both the chrome directory and userChrome.css, if
they do not already exist.

Block ads

See floppymoose.com for an example of how to use userContent.css as a
basic ad-blocker.

Miscellaneous
-------------

Other tips and tweaks.

> Mouse wheel scroll speed

To modify the default values (i.e. speed-up) of the mouse wheel scroll
speed, go to about:config and search for mousewheel.acceleration. This
will show the available options, modifying the following:

-   Set mousewheel.acceleration.start to -1.
-   Set mousewheel.acceleration.factor to the desired number (10 to 20
    are common values).

Alternatively you can install the SmoothWheel add-on.

> Change the order of search engines in the Firefox Search Bar

To change the order search engines are displayed in:

-   Open the drop-down list of search engines and click Manage Search
    Engines... entry.
-   Highlight the engine you want to move and use Move Up or Move Down
    to move it. Alternatively, you can use drag-and-drop.

> How to open a *.doc automatically with Abiword or LibreOffice Writer

Go to Preferences > Applications and search for Word Document (or Word
2007 Document for *.docx). After finding it, click the drop-down list
and select Use other.... From there you have to specify the exact path
to the Abiword or Writer executable (i.e./usr/bin/abiword or
/usr/bin/lowriter).

> Secure DNS with DNSSEC validator

You can enable DNSSEC support for safer browsing.

> Adding magnet protocol association

In about:config set network.protocol-handler.expose.magnet to false.

The next time you open a magnet link, you will be prompted with a
Launch Application dialogue. From there simply select your chosen
torrent client. This technique can also be used with other protocols.

> Prevent accidental closing

The Disable Ctrl-Q Shortcut extension can be installed to prevent
unwanted closing of the browser.

An alternative is to add a rule in your window manager configuration
file. For example in openbox add:

     <keybind key="C-q">
       <action name="Execute">
         <execute>false</execute>
       </action>
     </keybind>

in the <keyboard> section of your rc.xml file.

See also
--------

-   MozillaZine Wiki
-   about:config Entries Explained
-   Top Fox: Completing the Feel of Firefox
-   Firefox: Defining font type and size

Retrieved from
"https://wiki.archlinux.org/index.php?title=Firefox_Tweaks&oldid=254990"

Category:

-   Web Browser
