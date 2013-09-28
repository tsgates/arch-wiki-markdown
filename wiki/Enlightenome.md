Enlightenome
============

  

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is a small tutorial for how to get GNOME running smoothly with the
Enlightenment Window Manager (WM).

I prefer the Enlightenment WM to Metacity, for all of the neat features
it has such as the pager, iconbox, and of course - menus galore. Yet, I
like GNOME for easy access to gdesklets, the GNOME panel, and other such
things. So, if you are like me, here is what you can do to customize
your desktop as well:

Dependencies
------------

-   A working X server (I used 6.8.x - pacman -S xorg)
-   Enlightenment WM (I used e16 - pacman -S enlightenment)
-   E17 - Enlightenment WM (under e17 - pacman -S e17-svn)
-   GNOME DE (I used 2.6 - pacman -S gnome)
-   GConf-Editor (pacman -S gconf-editor)

Doing it
--------

1.  Start GNOME regularly, metacity should be the default WM, and if you
    are not using metacity then you know how to change WMs so what are
    you reading this for?
2.  Go to the GNOME main menu on any panel, and select Applications ->
    Desktop Preferences -> Advanced -> Sessions.
3.  Under the "Current Sessions" tab, find Metacity. Set the Style to
    "Normal" rather than "Restart". Apply changes, and close the box.
4.  Open your favorite terminal, and log in as root. Type:
    killall metacity; enlightenment &
    Note:If you wish, you can stop here and you will have Enlightenment
    as your WM (otherwise continue to Step 5), but I do not like the
    ugly GNOME desktop menus. Plus, at this point the backgrounds may be
    a little screwy. GNOME will show a background wallpaper, but
    Enlightenment will be using a different one, which you can see in
    the pager at this point.
5.  Open your GConf-Editor by going to a terminal and typing:
    gconf-editor &
6.  Click the arrow next to /, then Apps, then nautilus. Remove the
    value for "add to session". (Mine was a check box, yours may be a
    boolean "true/false" type thing.) (For gnome 2.14, in gconf-editor
    follow this path instead: / -> apps -> nautilus -> preferences; and
    uncheck the background_set box)
7.  Close the GConf-Editor, and in your favorite terminal type:
    killall nautilus
    Note:You may need to set nautilus to "Normal" as described in Step
    3. If Step 7 does not work properly, repeat Step 3 for nautilus, and
    then resume Step 7.
8.  Enjoy your beautiful new Enlightenome setup!

Making it permanent
-------------------

1.  Under E17
2.  Go to System > Preferences > Sessions
3.  Under Initial Programs > click New > name = e17 > command =
    /opt/e17/bin/enlightenment_start
4.  Go to Session Options > check the "Save changes" box and close
5.  Now logout and login
6.  You may smile now!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Enlightenome&oldid=198081"

Categories:

-   Desktop environments
-   Eye candy
