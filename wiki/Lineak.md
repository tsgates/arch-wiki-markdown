Lineak
======

  
 Have you ever wanted to get your multimedia keys to work under linux?
If so; then Lineak is the perfect program for you because it does
exactly this, Plus more (if needed). Lineak is a utility designed to
enable the use and configuration of those special keys on Internet, Easy
Access and Multimedia keyboards in Linux.

Note:Lineak is not really an active project, you are encouraged to use
keytouch instead or, even better, do not use any third-party program and
see Extra Keyboard Keys for the universal way of mapping your keys.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Check to see if Lineak supports your keyboard                      |
| -   2 Software Installation                                              |
|     -   2.1 GUI Tools                                                    |
|                                                                          |
| -   3 Configuring Your Specific Keyboard                                 |
| -   4 Share it                                                           |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Check to see if Lineak supports your keyboard
---------------------------------------------

To test if Lineak supports your keyboard, simply run the program:

       xev

in a terminal. You should get a window that pops up along with some
terminal output. Now press one of your multimedia keys. It doesn't
really matter which one at this point. You should get an output like the
following:

       KeyPress event, serial 32, synthetic NO, window 0x2600001,
       root 0xea, subw 0x0, time 24644050, (143,-13), root: (548,770),
       state 0x0, keycode 223 (keysym 0x0, NoSymbol), same_screen YES,
       XLookupString gives 0 bytes:
       XmbLookupString gives 0 bytes:

       XFilterEvent returns: False
       KeyRelease event, serial 32, synthetic NO, window 0x2600001,
       root 0xea, subw 0x0, time 24644215, (143,-13), root: (548,770),
       state 0x0, keycode 223 (keysym 0x0, NoSymbol), same_screen YES,
       XLookupString gives 0 bytes:

If you get something around these lines, then your keyboard will be
supported. If you do not get anything, make sure the "Event Tester"
window is the active one when you press the key and then try again. If
you still do not get anything like the above then your keyboard is one
of the few that aren't supported and won't ever be supported through
Lineak. Even on Windows, these rare keyboards require special drivers.

Software Installation
---------------------

Lineak packages are in AUR.

You need at least the lineakd package.

If you want OSD (On Screen Display) then you should also install
lineak_xosdplugin and when ever you press a key you'll get a nice little
text displayed on your screen telling you what key you just pressed.

> GUI Tools

There are some GUI tools for lineak:

-   klineakconfig - QT / KDE3 GUI - not compatible with KDE4 - available
    in AUR
-   lineaksetup - Java GUI
-   lineakconfig - GTK+ GUI - doesn't seem to be maintained anymore

Note:All of these GUIs are quite old, if you're searching for a good GUI
you should probably head for keytouch.

Configuring Your Specific Keyboard
----------------------------------

Lineak does support many keyboards so you may want to check and see if
your keyboard is supported by Lineak.

For educational purposes, this section explains how to write your own
keyboard layout from scratch. So even if your keyboard isn't supported
this method will always work.

Once again run xev:

       xev

Make sure the "Event Tester" window is the active one and start pressing
your multimedia keys one by one and write down what the keycode is. For
example:

       KeyPress event, serial 32, synthetic NO, window 0x3a00001,
       root 0xea, subw 0x0, time 27586934, (-4,185), root: (0,253),
       state 0x0, keycode 234 (keysym 0x0, NoSymbol), same_screen YES,
       XLookupString gives 0 bytes:
       XmbLookupString gives 0 bytes:
       XFilterEvent returns: False

The keycode for that key is 234. So I would write down something like:
GoBack - 234. Repeat this step for all your multimedia keys you plan to
setup. Here's a sample list:

       GoBack	  = 234
       Play	     = 162
       Favorites	  = 230
       Mail             = 236
       SpeakerOff  = 160
       Home          = 178
       Next	    = 233
       Search        = 229
       Repeat        = 231
       Cancel         = 232
       ScreenShot	= 111

Now open up /etc/lineakkb.def in any editor you feel like and create a
section like this:

       [HP]
       brandname = "HP"
       modelname = "Custom"
           [KEYS]
                    GoBack	= 234
                    Play	= 162
                    Favorites	= 230
                    Mail        = 236
                    SpeakerOff  = 160
                    Home        = 178
                    Next	= 233
                    Search      = 229
                    Repeat      = 231
                    Cancel      = 232
                    ScreenShot	= 111
           [END KEYS]
       [END HP]

Now you have your basic configuration done. Now test and make sure that
you have it configured correctly. Type this into your terminal shell:

       lineakd -c HP

then type:

       lineakd -v

Press each and every one of your keys and make sure they are outputting
the correct settings. Then press Ctrl+C if everything is correct and
move onto the next step.

Type in the following in your terminal shell

       mkdir ~/.lineak

then type:

       nano ~/.lineak/lineakd.conf

just replace nano with your favorite editor. In that file put something
similar to the folllowing:

       Cancel = xmms --stop (or "remootstop" to make it work with most apps
       Favorites = firefox
       GoBack = xmms --rew 
       Next = xmms --fwd
       Home = nautilus --no-desktop /home/josh
       Mail = firefox http://www.gmail.com/
       Play = xmms --play-pause  
       Repeat = 
       Search = 
       Sleep = 
       SpeakerOff = 
       ScreenShot = sh $HOME/screen.sh

Save that file and now in your terminal type the following:

       lineakd &

and you will now have your multimedia keys setup correctly. Now just add
the command lineakd & to your session startup and voila. You now have
your very own multimedia keyboard working on linux.

Share it
--------

After you have made your new /etc/lineakkb.def, please send it to the
developers of lineak by emailing the file (or pasting it into the body
of your email, this is usually preferred with mailing lists) to

    lineak-devel lists.sourceforge.net

Again, the @ is missing for the benefit of spam bots. Sharing the file
allows other users of lineak who have the same keyboard as you to
benefit from your efforts in getting lineak to work.

See also
--------

Lineak official site

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lineak&oldid=205451"

Category:

-   Input devices
