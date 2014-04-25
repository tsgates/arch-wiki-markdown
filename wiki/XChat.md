XChat
=====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

XChat is a multi-platform IRC chat program.

Gnome 3
-------

To use the new Notifications and messaging tray, activate the following
options in Settings > Preferences > Chatting > Alerts:

-   Show tray balloons
-   Blink tray icon (optional)
-   Enable system tray icon: unchecked (the icon appears automatically
    if you have pending notifications)

Spell Check
-----------

You can enable spell check as-you-type in the preferences, but you might
notice that the red squiggly lines never appear, no matter how hard you
try to write badly. To enable it completely, you need to install not
just the optional dependency enchant, but also the correct dictionary.
Find your correct dictionary by searching for hunspell.

    $ pacman -Ss hunspell

Pick out the correct one and install it, eg for English you'll need
hunspell-en. You may need to restart XChat after this.

Additional Resources
--------------------

-   Toxin XChat Theme Installer Script

Retrieved from
"https://wiki.archlinux.org/index.php?title=XChat&oldid=302676"

Categories:

-   Internet applications
-   Internet Relay Chat

-   This page was last modified on 1 March 2014, at 04:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
