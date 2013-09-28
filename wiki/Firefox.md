Firefox
=======

Summary

Installing and troubleshooting the Firefox browser and plugins

Related

Browser Plugins

Firefox Tweaks

Chromium

Opera

Firefox is a popular open-source graphical web browser from Mozilla.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Add-ons                                                            |
| -   3 Plugins                                                            |
|     -   3.1 GNOME Keyring integration                                    |
|     -   3.2 KDE integration                                              |
|     -   3.3 Dictionaries for spell checking                              |
|     -   3.4 Adding Firefox search engines                                |
|         -   3.4.1 arch-firefox-search                                    |
|                                                                          |
| -   4 Firefox derivatives                                                |
| -   5 Troubleshooting                                                    |
|     -   5.1 Setting your e-mail client                                   |
|     -   5.2 Open containing folder problems (GNOME 3)                    |
|     -   5.3 Open containing folder problems (KDE)                        |
|     -   5.4 Firefox keeps creating ~/Desktop even when this is not       |
|         desired                                                          |
|     -   5.5 Make plugins respect blocked pop-ups                         |
|     -   5.6 Middle-click errors                                          |
|     -   5.7 Backspace does not work as the 'Back' button                 |
|     -   5.8 Firefox does not remember login information                  |
|     -   5.9 Unreadable input fields with dark GTK+ themes                |
|     -   5.10 File association problems                                   |
|     -   5.11 "I'm Feeling Lucky" Mode                                    |
|     -   5.12 "Do you want Firefox to save your tabs for the next time it |
|         starts?" dialog does not appear                                  |
|     -   5.13 Firefox uses ugly fonts for its interface                   |
|     -   5.14 Firefox uses ugly fonts on certain web pages                |
|     -   5.15 Solve some Firefox font issues with Google Fonts            |
|     -   5.16 The menu cannot pop-up after updating to Firefox 13         |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

Firefox can be installed with the firefox package, available in the
official repositories.

There are a number of language packs available for Firefox, other than
the standard English. Language packs are usually named as
firefox-i18n-languagecode (where languagecode can be any language code,
such as de, ja, fr, etc.). For a list of available language packs see
this.

If Firefox does not anti-alias and/or hint your fonts, try to install
ttf-win7-fonts (preferred) or ttf-ms-fonts and take a look at Font
Configuration.

Add-ons
-------

Firefox is well known for its large library of add-ons which can be used
to add new features or modify the behavior of existing features of
Firefox. You can find new add-ons or manage installed add-ons with
Firefox's "Add-ons Manager."

For a list of popular add-ons, see Mozilla's add-on list sorted by
popularity.

Plugins
-------

See the main article: Browser Plugins

To find out what plugins are installed/enabled, enter:

    about:plugins

in the Firefox address bar or go to the Add-ons entry in the Firefox
Menu and select the Plugins tab.

> GNOME Keyring integration

Install firefox-gnome-keyring from the AUR to integrate Firefox with
GNOME Keyring.

> KDE integration

-   To use KDE's KPart technology with Firefox, by embedding different
    KDE file viewers into the browser, you can install kpartsplugin.

-   To get further integration with KDE's Oxygen theme, you can install
    Oxygen KDE, a very comprehensive theme that also has color scheme
    detection, support for Firefox's Persona themes, support for both
    the Oxygen and Faenza icons and various other customizations.

-   For integration with KDE’s mime type system and file dialogs, one
    can use a version of firefox with OpenSUSE’s patches applied.

> Dictionaries for spell checking

To enable spell checking for a specific language right click on any text
field and check the Check Spelling box. To select a language for spell
checking to you have right click again and select your language from the
Languages sub-menu.

To get more languages just click Add Dictionaries... and select the
dictionary you want to install from the list.

Alternatively, you can install the hunspell package, available in the
official repositories. You also need to install dictionaries for your
language, such as hunspell-fr (for the French language) or hunspell-he
(for Hebrew).

> Adding Firefox search engines

Search engines can be added to Firefox through normal add-ons, see this
page for a list of available search engines.

A very extensive list of search engines can be found here.

Also, you can use the add-to-searchbar extension to add a search to your
search bar from any web site, by simply right clicking on the site's
search field and selecting Add to Search Bar...

If you want a manual solution, take a look at
~/.mozilla/firefox/xxx.default/searchplugins/ (where xxx is your profile
ID).

arch-firefox-search

Install the arch-firefox-search package, available in the official
repositories, to add Arch-specific searches (AUR, wiki, forum, etc, as
specified by user) to the Firefox search toolbar.

Firefox derivatives
-------------------

-   Iceweasel — A fork of Firefox that is being developed by Debian. The
    main difference is that it does not include any trademarked Mozilla
    artwork.

http://wiki.debian.org/Iceweasel || iceweasel

Note:For some more information about Iceweasel's existance see this blog
post.

-   GNU IceCat — A web browser distributed by the GNU Project. It is
    made entirely of free software and is compatible with the GNU/Linux
    operating system and almost all of Firefox's addons.

http://www.gnu.org/software/gnuzilla/ || icecat

-   Firefox KDE — A version of Firefox that incorporates an OpenSUSE
    patch for better KDE integration than is possible through simple
    Firefox plugins.

http://gitorious.org/firefox-kde-opensuse || firefox-kde-opensuse

Troubleshooting
---------------

> Setting your e-mail client

Firefox is usually set to open mailto links with a web application such
as Gmail or Yahoo Mail. To set your e-mail client in Firefox to use with
mailto links, go to Preferences > Applications and modify the action
column corresponding to the mailto content type. You have set this to
the exact location of your e-mail client (e.g. /usr/bin/kmail for
Kmail).

> Open containing folder problems (GNOME 3)

If you expect Firefox to launch Nautilus when using the "Open Containing
Folder" option in the Downloads manager, but Thunar or Wine Explorer
launches instead, check these two lines in your user's
~/.local/share/applications/defaults.list:

     inode/directory=<someprogram>.desktop
     x-directory/normal=<someprogram>.desktop

If <someprogram> is not nautilus, change them to be so.

> Open containing folder problems (KDE)

If Firefox launches something other than your preferred file manager
when using the "Open Containing Folder" option in the Downloads manager,
make sure you select your file manager of choice (e.g. Dolphin) in KDE's
System Settings under Workspace Appearance and Behavior > Default
Applications > File Manager.

If Firefox is still not opening your file manager of choice, modify your
user's ~/.local/share/applications/defaults.list to include these two
lines:

    x-directory/normal=kde4-dolphin.desktop;kde4-kfmclient_dir.desktop;
    inode/directory=kde4-dolphin.desktop;kde4-kfmclient_dir.desktop;kde4-gwenview.desktop;kde4-filelight.desktop;kde4-cervisia.desktop;

> Firefox keeps creating ~/Desktop even when this is not desired

Firefox uses ~/Desktop as the default place for download and upload
files. To set it to another folder, create ~/.config/user-dirs.dirs and
add:

    XDG_DESKTOP_DIR="/home/<user>/"
    XDG_DOWNLOAD_DIR="/home/<user>/<dir>"
    XDG_TEMPLATES_DIR="/home/<user>/<dir>"
    XDG_PUBLICSHARE_DIR="/home/<user>/<dir>"
    XDG_DOCUMENTS_DIR="/home/<user>/<dir>"
    XDG_MUSIC_DIR="/home/<user>/<dir>"
    XDG_PICTURES_DIR="/home/<user>/<dir>"
    XDG_VIDEOS_DIR="/home/<user>/<dir>"

Change <user> and <dir> to the actual directory.

> Make plugins respect blocked pop-ups

Some plugins can misbehave and bypass the default settings, such as the
Flash plugin. You can prevent this by doing the following:

1.  Type about:config into the address bar.
2.  Right-click on the page and select New and then Integer.
3.  Name it privacy.popups.disable_from_plugins.
4.  Set the value to 2.

The possible values are:

-   0: Allow all popups from plugins.
-   1: Allow popups, but limit them to dom.popup_maximum.
-   2: Block popups from plugins.
-   3: Block popups from plugins, even on whitelisted sites.

> Middle-click errors

A common error message you can get while using the middle mouse button
in Firefox is:

    The URL is not valid and cannot be loaded.

Another symptom is that middle-clicking results in unexpected behavior,
like accessing a random web page.

The reason stems from the use of the middle mouse buttons in UNIX-like
operating systems. The middle mouse button is used to paste whatever
text has been highlighted/added to the clipboard. Then there is the
possibly conflicting feature in Firefox, which defaults to loading the
URL of the corresponding text when the button is depressed. This can be
easily disabled by going to about:config and setting the
middlemouse.contentLoadURL option to false.

Alternatively, having the traditional scroll cursor on middle-click
(default behavior on Windows browsers) can be achieved by searching for
general.autoScroll and setting it to true.

> Backspace does not work as the 'Back' button

As per this article, the feature has been removed in order to fix a bug.
To re-introduce the original behavior go to about:config and set the
browser.backspace_action option to 0 (zero).

> Firefox does not remember login information

It may be due to a corrupted cookies.sqlite file in Firefox's profile
folder. In order to fix this, just rename or remove cookie.sqlite while
Firefox is not running.

Open a terminal of choice and type the following:

    $ cd ~/.mozilla/firefox/xxxxxxxx.default/
    $ rm -f cookies.sqlite

Note:xxxxxxxx represents a random string of 8 characters.

Restart Firefox and see if it solved the problem.

> Unreadable input fields with dark GTK+ themes

When using a dark GTK+ theme, one might encounter Internet pages with
unreadable input and text fields (e.g. Amazon can have white text on
white background). This can happen because the site only sets either
background or text color, and Firefox takes the other one from the
theme.

A work around is to explicitly setting standard colors for all web pages
in ~/.mozilla/firefox/xxxxxxxx.default/chrome/userContent.css.

The following sets input fields to standard black text / white
background; both can be overridden by the displayed site, so that colors
are seen as intended:

    input {
        -moz-appearance: none !important;
        background-color: white;
        color: black;
    }

    textarea {
        -moz-appearance: none !important;
        background-color: white;
        color: black;
    }

    select {
        -moz-appearance: none !important;
        background-color: white;
        color: black;
    }

This will force the colors ("Allow pages to choose their own colors..."
checkbox in the Preferences > Content > Color dialog):

    input {
        -moz-appearance: none !important;
        background-color: pink !important;
        color: green !important;
    }

    textarea {
        -moz-appearance: none !important;
        background-color: pink !important;
        color: green !important;
    }

    select {
        -moz-appearance: none !important;
        background-color: pink !important;
        color: green !important;
    }

Change color values to suit, or use an add-on like Stylish.

> File association problems

For non-GNOME users, Firefox may not associate file types properly or at
all (in the "Open With" part of the download dialog). Installing
libgnome from the official repositories amends the problem.

If you are using KDE you can also do the following:

    ln -s ~/.local/share/applications/mimeapps.list ~/.local/share/applications/mimeinfo.cache

From now on Firefox should use the applications which are explicitly set
in KDE.

> "I'm Feeling Lucky" Mode

Some search engines have a feeling lucky feature. For example Google has
"I'm Feeling Lucky" and DuckDuckGo has "I'm Feeling Ducky".

To activate them:

1.  Type about:config in the address bar.
2.  Search for the string keyword.url.
3.  Modify its value (if any) to the URL of the search engine.

For Google, set it to:

    http://www.google.com/search?btnI=I%27m+Feeling+Lucky&q=

For DuckDuckGo, set it to:

    https://duckduckgo.com/?q=\

> "Do you want Firefox to save your tabs for the next time it starts?" dialog does not appear

From the Mozilla Support site:

1.  Type about:config in the address bar.
2.  Set browser.warnOnQuit to true.
3.  Set browser.showQuitWarning to true.

> Firefox uses ugly fonts for its interface

If the fonts in the menu bar look ugly to you, chances are you're
missing better looking fonts for Firefox to use. As a quick remedy, just
install Type 1 fonts from the xorg-fonts-type1 package, available in the
official repositories.

> Firefox uses ugly fonts on certain web pages

When Firefox uses bitmap fonts, it can happen that on certain web pages
the fonts are very ugly (compared to Google Chrome for example):

http://i.imgur.com/SMVdi.png vs http://i.imgur.com/jNmxU.png

To fix that, just disable bitmap fonts for X:

    $ sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

> Solve some Firefox font issues with Google Fonts

Some Firefox font issues may also be solved by installing the Google
Fonts via the AUR packages ttf-google-fonts-hg or ttf-google-fonts-git.
These fonts may greatly improve the appearance of Google Drive apps.

> The menu cannot pop-up after updating to Firefox 13

This problem is most probably related to this bug and it may affect any
user that sets

    GTK_IM_MODULE=xim

while configuring their input method.

It appears to happen especially to those who are using Fcitx 4.0.x (at
that time Fcitx only supported XIM). With newer version of Fcitx, XIM is
discouraged and you should set:

    GTK_IM_MODULE=fcitx

For more information see the Fcitx page.

See also
--------

-   Official Website
-   Mozilla Foundation
-   Firefox Wiki
-   Firefox Add-ons
-   Firefox Persona Themes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Firefox&oldid=255442"

Category:

-   Web Browser
