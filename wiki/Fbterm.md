Fbterm
======

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Fbterm (Frame buffer terminal emulator) is standalone replacement of
Linux kernel terminal that can function outside of Xorg.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Features                                                           |
| -   2 Installation                                                       |
| -   3 Customization                                                      |
|     -   3.1 Fonts                                                        |
|     -   3.2 Input method support                                         |
|                                                                          |
| -   4 Tips and tricks                                                    |
|     -   4.1 Background image                                             |
|     -   4.2 White font color                                             |
+--------------------------------------------------------------------------+

Features
--------

From http://code.google.com/p/fbterm/:

FbTerm is a fast terminal emulator for linux with frame buffer device or
VESA video card. Features include:

-   mostly as fast as terminal of linux kernel while accelerated
    scrolling is enabled
-   select font with fontconfig and draw text with freetype2, same as
    Qt/Gtk+ based GUI apps
-   dynamically create/destroy up to 10 windows initially running
    default shell
-   record scroll-back history for every window
-   auto-detect text encoding with current locale, support double width
    scripts like Chinese, Japanese etc
-   switch between configurable additional text encodings with hot keys
    on the fly
-   copy/past selected text between windows with mouse when gpm server
    is running
-   change the orientation of screen display, a.k.a. screen rotation
-   lightweight input method framework with client-server architecture
-   background image for eye candy

Installation
------------

Fbterm is available in the package fbterm.

After installation, mind the additional instructions:

    ==> To run fbterm as a non-root user, do:
    sudo gpasswd -a YOUR_USERNAME video
    ==> To enable keyboard shortcuts for non-root users, do:
    sudo setcap 'cap_sys_tty_config+ep' /usr/bin/fbterm
    or
    sudo chmod u+s /usr/bin/fbterm

Customization
-------------

> Fonts

Fbterm uses fontconfig for a list of fonts, trying each sequentially
until it is able to render the characters.

To change the fonts that are used, use the --font-names option to select
favorites from the list given by fc-list.

> Input method support

Fbterm supports diverse input methods by acting as a client for an
independent input method framework server. Several such programs are
available for Arch, see Internationalization#Input methods.

Tips and tricks
---------------

> Background image

To use a background image, Fbterm can be set to take a screen shot of
the frame buffer device when it starts.

The following script (using the fbv image viewer) is recommended in the
man page:

    #!/bin/bash
    # fbterm-bi: a wrapper script to enable background image with fbterm
    # usage: fbterm-bi /path/to/image fbterm-options
    echo -ne "\e[?25l" # hide cursor
    fbv -ciuker "$1" << EOF
    q
    EOF
    shift
    export FBTERM_BACKGROUND_IMAGE=1
    exec fbterm "$@"

> White font color

By default, fbterm display the "white" text as a gray color, even using
the -f 7 switch. Its posible to get real white by doing an echo once
inside fbterm, like this

    echo -en "\e]P7ffffff"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fbterm&oldid=247151"

Category:

-   Terminal emulators
