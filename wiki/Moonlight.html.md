Moonlight
=========

Moonlight was a free and open source implementation of Silverlight,
primarily for Linux and other Unix/X11 based operating systems.
Moonlight 1.0 was released on January 20, 2009 and 2.0 on December 17,
2009. The preview release of Moonlight 4.0 was released in early 2011.

Note:Since 2011 the project has been discontinued (from Wikipedia):  
 "In December 2011 Miguel de Icaza announced that work on Moonlight had
stopped with no future plans. He explained that, although there was
always some bloat, complication and over-engineering in the Silverlight
vision, Microsoft had "cut the air supply" to it by omitting
cross-platform components, making it a web-only plugin, and including
Windows-only features. He advised developers to separate user interface
code from the rest of their application development to ensure "a great
UI experience on every platform (Mac, Linux, Android, iOS, Windows and
Web)" without being dependent on third party APIs."

Contents
--------

-   1 Installation
    -   1.1 Mozilla Firefox
    -   1.2 Google Chrome
-   2 Tips and tricks
-   3 See also

Installation
------------

> Mozilla Firefox

There are two options for installing Moonlight in Firefox.

From the AUR: Install the firefox-moonlight package.

Manually: Go to the download page of the Moonlight website and download
and install the .xpi file.

> Google Chrome

From the AUR: Install the google-chrome-extension-moonlight package.

Manually: Installing extensions from outside the Chrome Web Store is a
hidden since Chrome v21.

1.  Download the Moonlight package for Chrome.
2.  Make sure no page is currently opened inside Chrome that is trying
    to load Silverlight/Moonlight.
3.  Go to the extensions page.
4.  Enable "Developer mode" (top right).
5.  Now drag and drop the extension file to the extensions page.
6.  You can turn off "Developer mode" if you wish.

Tip:An alternative download link, in case the Moonlight web site isn't
responding.

Tips and tricks
---------------

You may trick the Moonlight plugin to play supposedly unsupported
content by editing the version number in libmoonpluginxpi.so.

For Google Chrome:

    sed -i 's/4.0.51204.0/4.0.60831.0/g' ~/.config/google-chrome/Default/Extensions/ldjmcjaammmjjilbjpacphekcgfnmdlk/3.99.0.3_?/moonlight/libmoonpluginxpi.so

For Mozilla Firefox:

    sed -i 's/4.0.51204.0/4.0.60831.0/g' ~/.mozilla/firefox/$(sed -n 's/^Path=//p' ~/.mozilla/firefox/profiles.ini)/extensions/moonlight@novell.com/plugins/moonlight/libmoonpluginxpi.so

The command $(sed -n 's/^Path=//p' ~/.mozilla/firefox/profiles.ini)
finds out the default profile as stated in
~/.mozilla/firefox/profiles.ini.

Note:DRM protected content is not supported, look at Pipelight for that.

See also
--------

-   Moonlight project
-   Get Moonlight

Retrieved from
"https://wiki.archlinux.org/index.php?title=Moonlight&oldid=278846"

Category:

-   Audio/Video

-   This page was last modified on 16 October 2013, at 19:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
