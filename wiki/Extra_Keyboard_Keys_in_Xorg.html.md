Extra Keyboard Keys in Xorg
===========================

Related articles

-   Extra Keyboard Keys
-   Extra Keyboard Keys in Console
-   Map scancodes to keycodes
-   Xorg
-   Xmodmap

Contents
--------

-   1 Mapping keysyms to actions
    -   1.1 Desktop environments
        -   1.1.1 Gnome
        -   1.1.2 KDE
        -   1.1.3 Xfce4
    -   1.2 Window managers
        -   1.2.1 Openbox
        -   1.2.2 PekWM
        -   1.2.3 Xmonad
        -   1.2.4 i3
    -   1.3 Third-party tools
        -   1.3.1 sxhkd
        -   1.3.2 keytouch
        -   1.3.3 actkbd
        -   1.3.4 xbindkeys

Mapping keysyms to actions
--------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Keyboard    
                           Shortcuts#X11_2.         
                           Notes: same topic        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

When we are in a graphical environment we may want to execute a command
when certain key combination is pressed. There are multiple ways to do
that:

-   The most portable way using low level tools, such as acpid. Not all
    keys are supported, but configuration in uniform way is possible for
    keyboard keys, power adapter connection and even headphone jack
    (un)plugging events.
-   The universal way using Xorg utilities (e.g. xbindkeys) and
    eventually your desktop environment or window manager tools.
-   The quicker way using a third-party program to do everything in GUI,
    such as the Gnome Control Center or Keytouch.

> Desktop environments

Gnome

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: I am quite       
                           certain that GNOME does  
                           not override Xorg that   
                           much... (Discuss)        
  ------------------------ ------------------------ ------------------------

Gnome Control Center is quite complete for the extra keyboard keys
management. In fact it can directly detect scancodes which means that it
can map any key seen by the kernel.

KDE

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with KDE.        
                           Notes: KDE currently     
                           does not provide any     
                           information about        
                           mapping actions; provide 
                           only link after the      
                           merge. (Discuss)         
  ------------------------ ------------------------ ------------------------

Keyboard shortcuts can be configured in System Settings -> Shortcuts and
Gestures.

Xfce4

See Xfce#Manage Keyboard Shortcuts

> Window managers

Openbox

See Openbox#Keybinds

PekWM

See PekWM#Hotkeys

Xmonad

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Xmonad.     
                           Notes: Provide only link 
                           after the merge.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you use Xmonad as a stand alone window manager, you can edit the
xmonad.hs to add unbound keyboard keys. You just need to find the Xf86
name of the key (such as XF86PowerDown) and look it up in
/usr/include/X11/XF86keysym.h. It will give you a keycode (like
0x1008FF2A) which you can use to add a line like the following in the
keybindings section of your xmonad.hs:

    ((0,               0x1008FF2A), spawn "sudo pm-suspend")

i3

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with i3.         
                           Notes: Provide only link 
                           after the merge.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Open your ~/.i3/config and just bind the keysym to a command:

    bindsym XF86AudioLowerVolume exec amixer -q set Master 5-
    bindsym XF86AudioRaiseVolume exec amixer -q set Master 5+
    bindsym XF86AudioMute exec $(amixer get Master | grep off > /dev/null && amixer -q set Master unmute) || amixer -q set Master mute
    bindsym XF86MonBrightnessDown  exec  xbacklight -dec 10
    bindsym Print                  exec  scrot

> Third-party tools

sxhkd

A simple X hotkey daemon with a powerful and compact configuration
syntax.

Available as sxhkd-git and sxhkd in AUR.

keytouch

KeyTouch is a program which allows you to easily configure the extra
function keys of your keyboard. This means that you can define, for
every individual function key, what to do if it is pressed.

See the main article: keytouch.

actkbd

From actkbd home page:

actkbd (available in AUR) is a simple daemon that binds actions to
keyboard events. It recognises key combinations and can handle press,
repeat and release events. Currently it only supports the linux-2.6
evdev interface. It uses a plain-text configuration file which contains
all the bindings.

A sample configuration and guide is available here.

xbindkeys

xbindkeys allows advanced mapping of keysyms to actions independently of
the Desktop Environment.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Extra_Keyboard_Keys_in_Xorg&oldid=305964"

Categories:

-   Keyboards
-   X Server

-   This page was last modified on 20 March 2014, at 17:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
