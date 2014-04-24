Hp QuickPlay
============

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Copy-pasted from 
                           Gentoo wiki years ago    
                           (see note below and talk 
                           page); does not add      
                           anything new -           
                           everything relevant is   
                           already covered in Extra 
                           Keyboard Keys (and other 
                           pages from               
                           Category:Keyboards); I   
                           don't see anything       
                           specific to HP           
                           QuickPlay, which is why  
                           I think this page should 
                           be just deleted and not  
                           redirected. (Discuss)    
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: multiple         
                           instructions are         
                           specific to Gentoo (see  
                           the note below): emerge, 
                           scripts in /etc/conf.d/, 
                           ... (Discuss)            
  ------------------------ ------------------------ ------------------------

Note:This article is just an adaptation of
http://en.gentoo-wiki.com/wiki/Multimedia_Keys.

Most modern keyboards are equipped with a number of multimedia keys.
This article explains what needs to be done in order to use those keys.

Contents
--------

-   1 Determine the keycodes
    -   1.1 xev
    -   1.2 showkey
    -   1.3 Using KeyTouch
    -   1.4 lineakd
    -   1.5 Multiple application control
    -   1.6 Finding raw scan codes - PS/2 keyboards
        -   1.6.1 Mapping raw scan codes to key codes
        -   1.6.2 Finding raw scan codes - USB keyboards
-   2 Setting up xmodmap
    -   2.1 Disabling auto-repeat
-   3 Assigning keys to special functions
    -   3.1 Native hotkey support
        -   3.1.1 Audacious
    -   3.2 Window manager hotkey support
        -   3.2.1 Non window manager specific - xbindkeys
        -   3.2.2 Blackbox
        -   3.2.3 Fluxbox
        -   3.2.4 Openbox
        -   3.2.5 IceWM
        -   3.2.6 XFCE
        -   3.2.7 KDE
        -   3.2.8 GNOME
        -   3.2.9 Window Maker
        -   3.2.10 Enlightenment DR16
        -   3.2.11 Ion 3
        -   3.2.12 FVWM and FVWM-Crystal
    -   3.3 User and session independent hotkey support
-   4 Sample: eMachines m68xx
-   5 Getting bizarre keyboards working
-   6 Command Line Functions to Control Common Applications
    -   6.1 Audacious
    -   6.2 Rhythmbox
    -   6.3 amarok
    -   6.4 Quod Libet
    -   6.5 MPD/MPC
    -   6.6 ALSA
    -   6.7 Banshee player
    -   6.8 Goggles Music Manager
-   7 Getting illumination switching to work under X

Determine the keycodes
----------------------

Whenever a key is pressed on the keyboard, the kernel generates a raw
scancode, which can be mapped to a keycode. X does this slightly
differently and reads the kernel keycode table at startup, then maps the
keycode to its own keycode table. Each keycode can be mapped to a
keysym, which is a string that represents a key.

There are several applications that show the keycodes.

> xev

Install the xev program:

    pacman -S xev

And run it in an X terminal.

Pressing keys on the keyboard will cause their keycodes and other
information to printed in the xev window. The keycodes relating to
individual keys can be discovered in this way. The output of xev will
look similar to this:

    KeyRelease event, serial 31, synthetic NO, window 0x2800001,
    root 0x7d, subw 0x0, time 2792224, (-22,86), root:(565,101),
    state 0x10, keycode 160, same_screen YES,
    XLookupString gives 0 bytes:

The "keycode" value is what is relevant. In this example it is "160."
Make note of each keycode value in respect to each extended key.

The following script can help find the keycodes in the output of xev:

    xev | sed -n 's/^.*keycode *\([0-9]\+\).*$/keycode \1 = /p' | uniq

Run this instead of plain xev. Press all multimedia keys in order, then
close the xev window. The filtered output appears only after closing the
window.

Most likely, as in this example, the first line in the output does NOT
correspond to a multimedia key (it is the keycode value for the Enter
key).

A single key can be identified without ending xev by:

    xev | sed -n 's/^.*keycode *\([0-9]\+\).*$/keycode \1 = /p'

If pressing each key produces output from xev then jump ahead to Setting
up xmodmap. If pressing a key does not do anything at all (i.e., xev
produces no output), the raw scan code will need to be found.

> showkey

You can also switch to console and run

    $ showkey -s

to see the scan codes, or

    $ showkey -k

to see the key codes.

Note:One can switch to a console with the key-sequence Ctrl+Alt+F1.
Switching between consoles is done with Alt+F#, where # is the terminal
number. X usually runs on terminal seven or eight, so Alt+F7 or Alt+F8
return the user to X.

> Using KeyTouch

KeyTouch provides an all-in-one solution for multimedia keyboards.

    emerge -av keytouch

Start it under X and select the keyboard you have. After that, you can
use it to connect functions or programs to your special keys. You should
not need an xmodmap.

If your keyboard is not in the list, emerge keytouch-editor (which is
masked by keyword at the time of this writing).

    echo "x11-misc/keytouch-editor" >> /etc/portage/package.keywords
    emerge -av keytouch-editor

The official manual is available at http://keytouch.sourceforge.net/.
Basically you just hit each key and assign a name. Do not forget to send
the file to the keytouch project (you will be asked for that when saving
the file) to help others. The manual can help you solve problems such as
the following error from dmesg:

    keyboard.c: cannot emulate rawmode for keycode XXX

> lineakd

Another simple way to bring your multimedia keys to life is to use
"lineakd". LinEAK is available via portage (see
http://lineak.sourceforge.net for details).

> Multiple application control

If you like to control more than one application you will need a command
wrapper like ReMoot. ReMoot can control audacious, Rhythmbox, Amarok,
Quod Libet, xine, kaffeine and some more. The command 'remoot play' will
control the active application multimedia application and therefore you
do not have to asign one key to one application. This is very useful
together with LinEAK or Keytouch

> Finding raw scan codes - PS/2 keyboards

If the above methods did not recognise your keys and your keyboard is
connected via the PS/2 connector (not USB), run the following command in
an X terminal:

    dmesg | tail

    atkbd.c: Unknown key released (translated set 2, code 0x96 on isa0060/serio0).
    atkbd.c: Use 'setkeycodes e016 <keycode>' to make it known.

This means that the kernel does not have keycodes mapped to your
keyboard's scancodes.

Mapping raw scan codes to key codes

You will have to add one line in /etc/conf.d/local.start for each
missing key as follows:

    $ /etc/conf.d/local.start

    ...
    setkeycodes e008 136
    setkeycodes e016 150
    ....

Where the first number (e008) is the raw scan code (what you see in
dmesg, or get from getkeycodes) and the second number (136) is an unused
keycode in your kernel. In general you can find a good keycode by taking
the last 2 digits of this first number, converting it from hex (base-16)
to decimal (base-10) and adding 128.

Here is a simple bash script that can do the conversion for you. Just
press all of your multimedia keys and run this script afterwards. It
will parse the output of dmesg for unknown keys and give you the lines
you should add to /etc/conf.d/local.start.

    grep setkeycodes

This will set up the proper scancode - keycode mapping every boot. To
set them up without rebooting, run the following as root:

    sh /etc/conf.d/local.start

After you have the proper mappings set up, restart X and try running xev
again to ensure that a keycode is displayed for each multimedia key you
want to use.

Finding raw scan codes - USB keyboards

atkbd.c is not used for USB keyboards, and if your kernel is configured
to use full HID support you will not see any kernel messages. Instead
you will need to run a user-mode program called getscancodes to read the
key codes from one of the /dev/input/eventX devices, as described here.

For example by this method it is possible to find out that the codes for
the zoom slider on a Microsoft Natural Ergonomic Keyboard 4000 are 0x1a2
and 0x1a3. Check the Microsoft Natural Ergonomic Keyboard 4000 article
for more details.

Setting up xmodmap
------------------

Once all the multimedia keys are being recognised by xev, they need to
be mapped to keysyms. Create a file called .Xmodmap in your $HOME
directory.

    ~/.Xmodmap Example

    ! This works with Trust Silverline Direct Access keyboard
    ! The second stanza works for Dell Inspiron e1405 and e1505 laptops, as well as other
    ! standard keyboards (including the Logitech G15, and the Dell sk-8135 keyboard.)
    ! Use ! for comments

    keycode 222 = XF86PowerOff
    keycode 223 = XF86Sleep
    keycode 236 = XF86Mail
    keycode 229 = XF86Search
    keycode 230 = XF86Favorites
    keycode 178 = XF86WWW

    keycode 162 = XF86AudioPlay
    keycode 164 = XF86AudioStop
    keycode 160 = XF86AudioMute
    keycode 144 = XF86AudioPrev
    keycode 153 = XF86AudioNext
    keycode 176 = XF86AudioRaiseVolume
    keycode 174 = XF86AudioLowerVolume

A list of possible keysyms can be found in /usr/share/X11/XKeysymDB
(!this file does not exist anymore). The following is a list of the more
commonly used keysyms as found in XKeysymDB.

    /usr/share/X11/XKeysymDB

    XF86ModeLock            :1008FF01
    XF86Standby             :1008FF10
    XF86AudioLowerVolume    :1008FF11
    XF86AudioMute           :1008FF12
    XF86AudioRaiseVolume    :1008FF13
    XF86AudioPlay           :1008FF14
    XF86AudioStop           :1008FF15
    XF86AudioPrev           :1008FF16
    XF86AudioNext           :1008FF17
    ... 
    XF86HomePage            :1008FF18
    XF86Mail                :1008FF19
    XF86Start               :1008FF1A
    XF86SplitScreen         :1008FF7D
    XF86Support             :1008FF7E
    XF86Away                :1008FF8D
    XF86Messenger           :1008FF8E
    XF86WebCam              :1008FF8F
    XF86MailForward         :1008FF90
    XF86Pictures            :1008FF91
    XF86Music               :1008FF92

All you have to do now is to call xmodmap whenever your X session
starts, if this does not already happen automatically (it should.)
Usually a good place to do this is your $HOME/.xsession file.

    $HOME/.xsession

    /usr/bin/xmodmap $HOME/.Xmodmap

Alternatively, you can set this up in ~/.xinitrc this way:

    $HOME/.xinitrc

    exec /usr/bin/xmodmap ${HOME}/.Xmodmap &

Remember to substitute $HOME for the full path of your home directory.

GDM setup If you are using GDM you can use the file /etc/X11/Xmodmap as
a system wide Xmodmap. You can also change the location to another
Xmodmap file if you wish. Simply change sysmodmap=/etc/X11/Xmodmap in
the file /etc/X11/gdm/Init/Default to whatever you would like.

KDM setup Under KDM and KDE, the proper place to load ~/.Xmodmap file is
~/.kde/share/config/kdm/Xsession.

    $HOME/.kde/share/config/kdm/Xsession

    #!/bin/sh
    if [ -f $HOME/.Xmodmap ]; then
        /usr/bin/xmodmap $HOME/.Xmodmap
    fi

Do not forget to run "chmod +x ~/.kde/share/config/kdm/Xsession"

xfce4 setup If you are using xfce4-sessions, then you just need to place
the .Xmodmap file to ${HOME}/.Xmodmap.

> Disabling auto-repeat

You may find that your keyboard has autorepeat enabled for the
multimedia keys, which has the undesirable effect of the "next track"
button sometimes skipping ahead by too many songs or the "play/pause"
button pausing and then resuming immediately, if you accidentally hold
the button down for a fraction too long.

Rather than altering your whole keyboard's auto-repeat timing to fix
this, you can disable auto-repeat completely for specific keys (or
enable it, if you have buttons to control the volume and you would like
to be able to hold these down instead of pressing them repeatedly to
adjust the volume.) This can be done by running the xset command at
startup (see above for the best place to put the commands, here
~/.xinitrc is being used.)

    ~/.xinitrc

    # Disable autorepeat for multimedia keys (except the volume controls)
    xset -r 162 -r 164 -r 160 -r 144 -r 153

    # The keycodes are the same ones supplied to xmodmap above

    # Use "r" instead of "-r" to enable autorepeat instead if
    # the keyboard does not natively repeat the key.

Assigning keys to special functions
-----------------------------------

Now that your multimedia keys have a keysym mapping, you can bind them
to whatever function you want or your window manager allows you to. Note
that some programs natively support hotkeys (especially media players)
so it is more efficient (and lower latency) to use this mechanism where
possible, as it does not rely on some other program executing a command
to perform the action (see below for a list of known programs with built
in hotkey support.)

> Native hotkey support

These programs support hotkeys without window manager help, so they are
much more responsive as a command does not have to be launched every
time a key is pressed.

Audacious

Since Audacious version 1.4 the hotkey plugin is available in the
package audacious-plugins. To use the plugin go to the Audacious
preferences, under Plugins, General, enable the Global Hotkey plugin and
configure it by selecting the different commands and pressing the
appropriate key.

> Window manager hotkey support

Non window manager specific - xbindkeys

If your window manager does not have a facility for keyboard shortcuts,
or indeed if you want to switch between multiple window managers/desktop
environments and keep the same keyboard shortcuts throughout, then
xbindkeys may be the solution for you.

To install, a simple:

    emerge xbindkeys

After installation you must edit the config file ~/.xbindkeysrc. If you
do not have the file (you will not), you will get it by running
xbindkeys and reading). The file is well commented with examples. To use
the key XF86WWW to open your webbrowser (Firefox in this case), place
the following code snippet into the config file:

    ~/.xbindkeysrc

    "firefox"
     XF86WWW
    #General format being:
    #"command to execute"
    # key combination

To use multemedia keys to control sound vulome, place the following code
snippet into the config file:

    ~/.xbindkeysrc

    "amixer -q set Master 2- unmute"
    XF86AudioLowerVolume

    "amixer -q set Master 2+ unmute"
    XF86AudioRaiseVolume

    "amixer -q set Master toggle"
    XF86AudioMute

You can use various modifiers (alt, shift, ctrl) to add additional
shortcuts. For example, to launch a urxvt terminal with the key
combination Ctrl-n, place the following code snippet in your config
file:

    ~/.xbindkeysrc

    "urxvt"
     Control + n

When finished with your config file, simply run the command xbindkeys
(or 'xbindkeys -n' if you do not want xbindkeys to run as a daemon).

If you are running xbindkeys as a daemon and edit .xbindkeysrc, it will
automatically update bindings so you will not have to restart it.

Blackbox

You will need to emerge bbkeys. Once bbkeys is installed, make sure
bbkeys is ran whenever you start X. Example xinitrc:

    ~/.xinitrc

    bbkeys &
    exec blackbox

Now you will need to configure bbkeys. You can either use the global
configuration file (usually /usr/share/bbkeys/bbkeysrc) or copy it to
~/.bbkeysrc and edit that instead. Example:

    ~/.bbkeysrc

    [begin] (bbkeys configuration file)
     # * CUT DEFAULTS *
     [keybindings] (begin keybindings)
      # * CUT DEFAULTS *
      [Execute]   (XF86Mail)      {thunderbird}
      [Execute]   (XF86AudioPlay) {xmms --play-pause}
      [Execute]   (XF86AudioStop) {xmms --stop}
      [Execute]   (XF86AudioNext) {xmms --fwd}
      [Execute]   (XF86AudioPrev) {xmms --rew}
      [Execute]   (XF86AudioLowerVolume)  {amixer -q set PCM 2- unmute}
      [Execute]   (XF86AudioRaiseVolume)  {amixer -q set PCM 2+ unmute}
     [end] (end keybindings)
    [end] (end bbkeys configuration)

That is all there is to it.

Fluxbox

Open up your ~/.fluxbox/keys with your favourite editor. To control the
basic XMMS functionality you append this example to your file:

    ~/.fluxbox/keys

    None XF86AudioPlay :ExecCommand /usr/bin/xmms --play-pause
    None XF86AudioStop :ExecCommand /usr/bin/xmms --stop
    None XF86AudioPrev :ExecCommand /usr/bin/xmms --rew
    None XF86AudioNext :ExecCommand /usr/bin/xmms --fwd
    None XF86AudioLowerVolume :ExecCommand amixer -q set PCM 5%- unmute
    None XF86AudioMute :ExecCommand amixer -q set Master toggle
    None XF86AudioRaiseVolume :ExecCommand amixer -q set PCM 5%+ unmute

For certain cards it might work if you put PCM for mute instead of
Master. It might give the desired effect (Volume Up button when pressed
will unmute the card):

    ~/.fluxbox/keys

    None XF86AudioMute :ExecCommand amixer -q set PCM toggle

Openbox

Open your ~/.config/openbox/rc.xml file, search for section "keyboard"
and, following the examples, add in the end of session:

    ~/.config/openbox/rc.xml

    <source lang=xml>
    <keybind key="XF86AudioPlay">
      <action name="Execute"><execute>/usr/bin/xmms --play-pause</execute></action>
     </keybind>
     <keybind key="XF86AudioStop">
      <action name="Execute"><execute>/usr/bin/xmms --stop</execute></action>
     </keybind>
    </source>

For more information refer to the documentation for openbox about
actions and keybindings in
http://icculus.org/openbox/index.php/Help:Contents#Configuration.

IceWM

Just edit the file ~/.icewm/keys

    ~/.icewm/keys

    key “XF86AudioLowerVolume”      amixer sset PCM 5-
    key “XF86AudioRaiseVolume”      amixer sset PCM 5+
    key “XF86AudioMute”             amixer sset Master toggle
    key “XF86AudioPlay”             mpc toggle
    key “XF86AudioStop”             mpc stop
    key “XF86AudioPrev”             mpc prev
    key “XF86AudioNext”             mpc next
    key “XF86WWW”                   firefox
    key “XF86Mail”                  firefox “gmail.com”

And restart IceWM.

XFCE

Go to Settings > Keyboard Settings, and select the "Shortcuts" tab. To
define our own key bindings, we have to create a new theme. Click "Add"
to create it (note that all key bindings from the default theme are
copied into the new theme). In the "Command Shortcuts" section,
doubleclick on an empty slot, enter the command you would like to bind
and press the according key. The keysym from your .Xmodmap should appear
next to the command if everything works as expected. Done.

KDE

With KDE you can set almost all settings through the Control Center if
you have a supported keyboard. Go to Control Center -> Regional &
Accessibility -> Keyboard Layout and choose your Keyboard model. In
Mandriva 2009, go to Configure Desktop -> Regional & Language ->
Keyboard Layout and choose Keyboard model.

If Keyboard Layout is missing:

    emerge -av kde-base/kxkb

After you have set your model, use KHotKeys to map the keys to actions.
You can also use simple DCOP calls to talk to Amarok.

If your keyboard is not supported you can try the following:

If you use kdm as your login manager, kdm will source the file
~/.xprofile on each login.

Simply create the file ~/.Xmodmap as mentioned above, then have a line
in ~/.xprofile that has xmodmap use it.

    ~/.xprofile

    /usr/bin/xmodmap $HOME/.Xmodmap

If this does not work, simply create a file ~/.kde/Autostart/xmodmap
containing

    ~/.kde/Autostart/xmodmap

    #!/bin/sh
    /usr/bin/xmodmap $HOME/.Xmodmap

and make it executable.

Note:If everything is configured but nothing happens, try to emerge
kde-base/kmilo

GNOME

Gnome-2.10: Go to Desktop > Preferences > Keyboard Shortcuts, or run
gnome-keyboard-bindings, whichever suits your fancy. Make sure the Sound
category in the Actions column is expanded, then click on the desired
action. The entry in the Shortcut column will change to "New
accelerator...." Press the desired key for the binding, and the shortcut
is made. A proper entry should look similar to

  ------------- ---------------
  Action        Shortcut
  Volume mute   XF86AudioMute
  ------------- ---------------

If you feel more comfortable with (or are just that more adventurous),
open up Gnome's Configuration Editor, either through the menus, or
through the command gconf-editor, then navigate to Apps >
gnome_settings_daemon > keybindings. For the even-more-adventurous, use
your favorite editor, and open
~/.gconf/apps/gnome_settings_daemon/keybindings/%gconf.xml

A decent set to work with is:

    ~/.gconf/apps/gnome_settings_daemon/keybindings/%gconf.xml

    <?xml version="1.0"?>
    <gconf>
            <entry name="www" mtime="1115511556" type="string">
                    <stringvalue>XF86HomePage</stringvalue>
            </entry>

            <entry name="email" mtime="1115511554" type="string">
                    <stringvalue>XF86Mail</stringvalue>
            </entry>
            <entry name="next" mtime="1115511504" type="string">
                    <stringvalue>XF86AudioNext</stringvalue>

            </entry>
            <entry name="previous" mtime="1115511503" type="string">
                    <stringvalue>XF86AudioPrev</stringvalue>
            </entry>
            <entry name="stop" mtime="1115511498" type="string">

                    <stringvalue>XF86AudioStop</stringvalue>
            </entry>
            <entry name="play" mtime="1115511489" type="string">
                    <stringvalue>XF86AudioPlay</stringvalue>
            </entry>

            <entry name="volume_up" mtime="1116696662" type="string">
                    <stringvalue>XF86AudioRaiseVolume</stringvalue>
            </entry>
            <entry name="volume_down" mtime="1115511485" type="string">
                    <stringvalue>XF86AudioLowerVolume</stringvalue>

            </entry>
            <entry name="volume_mute" mtime="1116697540" type="string">
                    <stringvalue>XF86AudioMute</stringvalue>
            </entry>
    </gconf>

Window Maker

Adding shortcuts to Window Maker is simple using the Window Maker
Preferences Utility: WPrefs. By default WPrefs is the third icon down in
the dock. If WPrefs is no longer in the dock, you can access it on most
distros by running the following command in an X terminal:

    /usr/lib/GNUstep/Applications/WPrefs.app/WPrefs

You can go to the keyboard section of WPrefs to bind the extended keys
to some predefined internal Window Maker commands.

Simply scroll right until the keyboard icon is visible and click on it.

You will see a list of internal commands that you can higlight. Select
the command you want to bind and then click the "capture" button. Now
simply hit the key and any modifiers (ctrl, alt, shift etc.) you want to
bind to this function.

While binding internal Window Maker commands is useful, you can also
bind external commands to keystrokes. The only way to do this is to add
them to the main Window Maker menu, the same menu you can access from
right clicking on the root window or hitting F12 by default.

In WPrefs you can click on the menu icon: the one next to the keyboard
icon to access the menu.  
 An editable version of the menu will pop up outside of the main WPref
window. You can drag any of the sample elements from the main WPrefs
window to the editable menu to create a new element of that type.  
 Double-click on an element in the editable menu to change its name. Be
sure to press Enter after completing the name change or else it will
revert.

Adding a shortcut to a program entry will result in the shortcut keysym
showing up in the menu; It will not show up in the editable version of
the menu. Because the keysyms are a bit ugly you can tidy up the menu by
sticking the programs in a submenu.

You can add a shortcut to a "Run Program" element by selecting it in the
dummy menu and clicking the "Capture" button then pressing the
key/keystroke you want to bind to that program.

Enlightenment DR16

Emerge the e16keyedit package. Then run 'e16keyedit' inside of
enlightenment. Create a new keybinding, and press the 'Change' button to
record a keystroke. Just press your new multimedia key and bind it to
whatever action you would like (use the 'Run' action to bind it to a
command like aumix). Remember to press the 'Save' button when you are
done.

Ion 3

Copy /etc/X11/ion3/cfg_bindings.lua to ~/.ion3/cfg_bindings.lua (if you
did not do this already) and edit it. By using kpress(KEY, ACTION) you
can bind actions to multimedia keys:

    ~/.ion3/cfg_bindings.lua

    bdoc("Mute/Unmute Sound."),
    kpress("AnyModifier+XF86AudioMute", "ioncore.exec_on(_, 'amixer sset Master toggle')"),
    bdoc("Increase Volume."),
    kpress("AnyModifier+XF86AudioRaiseVolume", "ioncore.exec_on(_, 'amixer sset Master 3%+')"),
    bdoc("Decrease Volume."),
    kpress("AnyModifier+XF86AudioLowerVolume", "ioncore.exec_on(_, 'amixer sset Master 3%-')"),
    ....

Note that in some later versions of ion3, key bindings have moved from
cfg_bindings.lua to cfg_ioncore.lua. Same syntax, just a different file.
If you do not have an /etc/X11/ion3/cfg_bindings.lua to copy, this is
probably why.

FVWM and FVWM-Crystal

Add a binding in your configuration. FVWM-Crystal users can find a
description of the modifiers used by Crystal in
/usr/share/fvwm-crystal/fvwm/components/functions/Keyboard-Modifiers

For a system wide configuration using the Aumix mixer, modify the file
/usr/share/fvwm-crystal/fvwm/components/functions/Mixer-aumix, otherwise
copy it in ~/.fvwm-crystal/components/functions and add:

    ~/.fvwm-crystal/components/functions/Mixer-aumix

    ...
    Key XF86AudioLowerVolume A $[Mod0] Mixer-Volume-Down
    Key XF86AudioRaiseVolume A $[Mod0] Mixer-Volume-Up
    ....

Another example with FVWM functions, parameters, external command and
key modifiers:

    ~/.fvwm-crystal/components/functions/Music-myplayer

    ...
    # Same key with modifiers and call to an external program
    Key XF86AudioMute A $[Mod0] Exec exec alsaplayer --volume 0
    key XF86AudioMute A C Exec exec alsaplayer --volume 1
    ...
    # Another key with modifiers
    # + FVWM function
    key XF86AudioPlay A $[Mod0] Music-PlayPause
    key XF86AudioPlay A C Music-Pause
    # + FVWM function with parameter
    key XF86AudioPlay A $[Mod1] Music-Speed normal
    ....

An example with amixer:

    fvwm multimedia key definition

    key XF86AudioLowerVolume 	A A Exec exec amixer set Front 10%-
    key XF86AudioRaiseVolume 	A A Exec exec amixer set Front 10%+
    key XF86AudioMute 		A A Exec exec amixer set Front toggle

FVWM-Crystal is using $[Mod0] which is not defined in plain FVWM. To
determine the modifiers into FVWM, you can use the output of

    xmodmap -pm

As [Mod0] is defined as N (none) in Crystal and [Mod1] as M for Meta
(Alt), all that is needed is to replace all the occurrences of
[Mod0] by N and [Mod1] by M:

    Key XF86AudioLowerVolume A N Mixer-Volume-Down
    Key XF86AudioRaiseVolume A N Mixer-Volume-Up
    key XF86AudioPlay A N Music-Play
    key XF86AudioPlay A C Music-Pause
    key XF86AudioPlay A M Music-PlayPause

> User and session independent hotkey support

The program Magmakeys can be used tie arbitrary commands to specific
hotkeys independently from the user logged in or the window manager
used. This is especially useful for keys directly related to the
hardware (e.g. volume control, enabling wireless network devices etc.).
The Magmakeys daemon hooks into the input subsystem of the kernel and
intercepts key presses on a system-wide basis; commands are then
globally defined in /etc/magmakeys.conf:

     # volume control
     KEY_VOLUMEUP    1       /usr/bin/amixer set Master 2%+ 
     KEY_VOLUMEDOWN  1       /usr/bin/amixer set Master 2%-
     # keep changing the volume when holding the key
     KEY_VOLUMEUP    2       /usr/bin/amixer set Master 2%+ 
     KEY_VOLUMEDOWN  2       /usr/bin/amixer set Master 2%-
     KEY_MUTE        1       /usr/bin/amixer set Master toggle

Sample: eMachines m68xx
-----------------------

If you own an eMachines m68xx notebook and want to jump right to using
the keys, you can use the following to setup the keys.   
NB: These were created on an m6809, but I assume they are the same for
the other m68xx models, if you have access to one of the other models
and can confirm/deny this, please update this page.

First, we update the the keysyms. On an x86_64 system the file we want
is /usr/lib64/X11/xkb/symbols/inet. Insert the following code:

    /usr/lib64/X11/xkb/symbols/inet

    // eMachines

    partial alphanumeric_keys
    xkb_symbols "emachines" {
        name[Group1]= "Laptop/notebook eMachines m68xx";

        key <I2E> {       [ XF86AudioLowerVolume  ]       };
        key <I6D> {       [ XF86AudioMedia        ]       };
        key <I30> {       [ XF86AudioRaiseVolume  ]       };
        key <I20> {       [ XF86AudioMute ]       };
        key <I6C> {       [ XF86Mail      ]       };
        key <I32> {       [ XF86iTouch    ]       };
        key <I65> {       [ XF86Search    ]       };
        key <I5F> {       [ XF86Sleep     ]       };
        key <I22> {       [ XF86AudioPlay, XF86AudioPause ]       };
        key <I24> {       [ XF86AudioStop ]       };
        key <I10> {       [ XF86AudioPrev ]       };
        key <I19> {       [ XF86AudioNext ]       };
        key <KP0> {       [ KP_0  ]       };
        key <KP1> {       [ KP_1  ]       };
        key <KP2> {       [ KP_2  ]       };
        key <KP3> {       [ KP_3  ]       };
        key <KP4> {       [ KP_4  ]       };
        key <KP5> {       [ KP_5  ]       };
        key <KP6> {       [ KP_6  ]       };
        key <KP7> {       [ KP_7  ]       };
        key <KP8> {       [ KP_8  ]       };
        key <KP9> {       [ KP_9  ]       };
        key <KPDL>        {       [ KP_Decimal    ]       };
        key <KPAD>        {       [ KP_Add        ]       };
        key <KPSU>        {       [ KP_Subtract   ]       };
        key <KPMU>        {       [ KP_Multiply   ]       };
        key <KPDV>        {       [ KP_Divide     ]       };
    };

Now, we add the required references to this keyboard layout to
X11/kxb/rules/(xorg

In the X.Org file we add it to the list of $inetkbds like so:

    /usr/lib64/X11/xkb/rules/xorg

    ! $inetkbds = airkey acpi scorpius azonaRF2300 \
                  brother \
                  btc5113rf btc5126t btc9000 btc9000a btc9001ah btc5090\
                  cherryblue cherrybluea cherryblueb \
                  chicony chicony9885 \
                  compaqeak8 compaqik7 compaqik13 compaqik18 armada presario ipaq \
                  dell inspiron dtk2000 \
                  dexxa diamond genius geniuscomfy2 \
                  emachines ennyah_dkb1008 \
                  hpi6 hp2501 hp2505 hp5181 hpxe3gc hpxe3gf hpxe4xxx hpzt11xx \
                  hp500fa hp5xx hp5185 \
                  honeywell_euroboard \
                  rapidaccess rapidaccess2 rapidaccess2a \
                  ltcd logiaccess logicdp logicdpa logicink logiciink \
                  logiinkse logiinkseusb logiik itouch \
                  mx1998 mx2500 mx2750 \
                  microsoftinet microsoftpro microsoftprooem microsoftprose \
                  microsoftoffice microsoftmult \
                  oretec \
                  propeller \
                  qtronix \
                  samsung4500 samsung4510 \
                  sk1300 sk2500 sk6200 sk7100 \
                  sven symplon toshiba_s3000 trust trustda yahoo

In xorg.lst we add one line among the large list of models.

    /usr/lib64/X11/xkb/rules/xorg.lst

    ...
    emachines     Laptop/notebook eMachines m68xx
    ....

And finally in xorg.xml we give it a description, which can be
localized.

    /usr/lib64/X11/xkb/rules/xorg.xml

    <source lang=xml>
         ...
         <model>
           <configItem>
             <name>emachines</name>
             <description>Laptop/notebook eMachines m68xx</description>
     
           </configItem>
         </model>
         ...
    </source>

Now, after all that, restart your X server and there is a fresh new
m68xx keyboard waiting to be selected. In KDE this can be selected
easily by opening the Keyboard Layout Control Module and choosing the
newly added "Laptop/notebook eMachines m68xx" from the Keyboard Model
list. Any of the specials keys can then be bound as shortcuts the way
you configure any other shortcut.

Since this is at the X server level, and system wide, it should be
accessible to all users in any window manager.

Getting bizarre keyboards working
---------------------------------

Some keyboards have volume wheels or unusual buttons that do not
generate X keyboard events. A perl script exists to take care of those
keys, however it is a bit of a pain to use. It will however get ANY keys
or buttons that the keyboard sends to work by going to the low level
evdev interface.

In the kernel, enable the "Event interface" driver (evdev module) to get
kernel support.

Then, grab the photkeys script (Description:
http://thequux.com/modules/zmagazine/article.php?articleid=2 Download:
http://thequux.com/modules/wmpdownloads/), and follow the instructions
there to set it up.

    Sample Script

    gus alexg # photkeys /dev/input/event1
    Unrecognized event: '4:4:28'. Define it in /usr/bin/photkeys
    ...
    Unrecognized event: '4:4:139'. Define it in /usr/bin/photkeys

Something should appear in /dev/input/event1 when you press a button,
however your system device file may be different.

Alternatively:

-   Input Event Manager
    http://powerman.asdfgroup.com/Projects/input_event/ Possibly much
    more flexible, stable and less of a pain to use.
-   EvRouter (http://www.bedroomlan.org/~alexios/coding_evrouter.html)

Command Line Functions to Control Common Applications
-----------------------------------------------------

Many applications have methods to control them from command line. These
are perfect for creating shortcuts to use with multimedia keys.

If you like to control all the apps below (and 20+ more apps) you will
need a command wrapper like ReMoot. ReMoot can control xmms, Mplayer,
Rhythmbox, Amarok, Quod Libet, xine, kaffeine and 20 more apps. The
command 'remoote play' will control the active multimedia application
and therefor you do not have to asign one key to one application. ReMoot
works best with
[/HOWTO_Use_Multimedia_Keys#Alternative:_lineakd_or_keyTouch Lineak],
Keytouch or xbindkeys and has a web-frontend that works remote control
with a PDA or any web enabled gadget.

> Audacious

Audacious has some straightforward command line switches. You can see
more by executing this command in a terminal:

    man audacious

    Audacious command line switches from the audacious manpage

    audacious --rew        # Skip backwards in playlist.
    audacious --stop       # Stop current song.
    audacious --play-pause # Pause if playing, play otherwise.
    audacious --fwd        # Skip forward in playlist.

> Rhythmbox

Rhythmbox can be controlled using the command line:

    rhythmbox-client command line switches

    rhythmbox-client --previous   # Skip backwards in playlist
    rhythmbox-client --next       # Skip forward in playlist
    rhythmbox-client --play-pause # Pause if playing, play otherwise
    rhythmbox-client --pause      # Pause

> amarok

    amarok command line switches from "dcop amarok player" (v. 1.4.4)

    QCStringList interfaces()
    QCStringList functions()
    QString version()
    bool dynamicModeStatus()
    bool equalizerEnabled()
    bool osdEnabled()
    bool isPlaying()
    bool randomModeStatus()
    bool repeatPlaylistStatus()
    bool repeatTrackStatus()
    int getVolume()
    int sampleRate()
    int score()
    int rating()
    int status()
    int trackCurrentTime()
    int trackCurrentTimeMs()
    int trackPlayCounter()
    int trackTotalTime()
    QString album()
    QString artist()
    QString bitrate()
    QString comment()
    QString coverImage()
    QString currentTime()
    QString encodedURL()
    QString engine()
    QString genre()
    QString lyrics()
    QString lyricsByPath(QString path)
    QString lastfmStation()
    QString nowPlaying()
    QString path()
    QString setContextStyle(QString)
    QString title()
    QString totalTime()
    QString track()
    QString type()
    QString year()
    void configEqualizer()
    void enableOSD(bool enable)
    void enableRandomMode(bool enable)
    void enableRepeatPlaylist(bool enable)
    void enableRepeatTrack(bool enable)
    void mediaDeviceMount()
    void mediaDeviceUmount()
    void mute()
    void next()
    void pause()
    void play()
    void playPause()
    void prev()
    void queueForTransfer(KURL url)
    void seek(int s)
    void seekRelative(int s)
    void setEqualizer(int,int,int,int,int,int,int,int,int,int,int)
    void setEqualizerEnabled(bool active)
    void setEqualizerPreset(QString name)
    void setLyricsByPath(QString url,QString lyrics)
    void setBpm(float bpm)
    void setBpmByPath(QString url,float bpm)
    void setScore(int score)
    void setScoreByPath(QString url,int score)
    void setRating(int rating)
    void setRatingByPath(QString url,int rating)
    void setVolume(int volume)
    void setVolumeRelative(int ticks)
    void showBrowser(QString browser)
    void showOSD()
    void stop()
    void transferDeviceFiles()
    void volumeDown()
    void volumeUp()
    void transferCliArgs(QStringList args)

> Quod Libet

    Quod Libet command line switches from "quodlibet --help"

    quodlibet --previous   # Skip backwards in playlist
    quodlibet --play       # Start playing current playlist
    quodlibet --play-pause # Play if stopped, pause if playing
    quodlibet --pause      # Pause playback
    quodlibet --next       # Skip forwards in playlis

> MPD/MPC

If you use MPD your client may already support some keysyms. For
instance gmpc correctly recognises XF86AudioNext, XF86AudioPrev,
XF86AudioStop, and XF86AudioPlay. Furthermore, gmpc works with profiles,
and whichever you have selected will be played, paused, stopped, next'd,
or previous'd automagically.

If you do not use gmpc, or do not want to leave gmpc running then you
may want to bind these keys to short cuts to the command line MPD
client, mpc. first you must install mpc by executing:

    emerge mpc

The mpc command line switches are:

    mpc switches from "mpc --help"

    mpc next     # Play the next song in the current playlist
    mpc prev     # Play the previous song in the current playlist
    mpc toggle   # Toggles Play/Pause, plays if stopped
    mpc stop     # Stop the currently playing playlists

> ALSA

ALSA can be controlled using amixer. The following commands will adjust
the PCM levels of your ALSA soundcard.

    Controling PCM levels with amixer

    amixer sset PCM 2+       # This will increase the PCM hardware volume value by 2
    amixer sset PCM 2-       # This will decrease the PCM hardware volume value by 2
    amixer sset PCM toggle   # This will toggle the PCM between muted and unmuted states

Not all sound cards support mute toggling. The following script can be
used on such cards. It saves the current volume to $HOME/.lastVolume and
sets it to 0. To "unmute", execute the script again and the previous
value will be restored.

    /usr/local/bin/muteVolume

    #!/bin/bash
    # simple script to mute by changing volume
    filename="$HOME/.lastVolume"
    numid="30"   #find apropriate number with: amixer controls
    volume=$(amixer cget numid=$numid | grep : | sed -e 's/  : values=//')
    if [ $volume = '0' ] # Or if that does not work try: if [ $volume = '0,0' ]
    then
    	echo "Volume is 0, restoring"
    	volume=$(cat $filename)
    	amixer -q cset numid=$numid $volume &> /dev/null
    else
     	echo "Volume is $volume, muting"
     	echo $volume > $filename
    	amixer -q cset numid=$numid 0 &> /dev/null
    fi

(Verified with amixer 1.0.13)

> Banshee player

    Banshee command line switches from "banshee --help"

    Usage: banshee [ options ... ]
    where options include:
     ...
       --show              Show window
       --hide              Hide window
       --next              Play next song
       --previous          Play previous song
       --toggle-playing    Toggle playing of current song
       --play              Play current song
       --pause             Pause current song
       --shutdown          Shutdown Banshee
     ...

> Goggles Music Manager

As of v0.7.4, Goggles Music Manager supports the following command line
options:

    Goggles Music Manager command line options from "gmm --help"

    gmm --play        Start playback
    gmm --play-pause  Play if stopped, pause if playing
    gmm --pause       Pause playback
    gmm --previous    Play previous track
    gmm --next        Play next track
    gmm --stop        Stop playback

Getting illumination switching to work under X
----------------------------------------------

To get switching on/off the illumination of multimedia keyboard to work
under X using key Scroll_Lock:

Change mapping of Scroll_lock by extending ~.Xmodmap with something like
this:

    keycode  78 = XF86LightBulb

Of course you could use any other key you like.

Make a little script somewere like this:

    kbd-illum

    #!/bin/bash
    #
    # /usr/local/bin/kbd-illum - control illumination of keyboard
    #
    case "$1" in
      ( on  ) xset  led 3 ;;
      ( off ) xset -led 3 ;;
      ( -t | --toggle )
        xsetleds -show | grep -q 'ScrollLock \+on' &&
        xset -led 3 || xset led 3 ;;
      ( -s | --status )
        xsetleds -show | grep -q 'ScrollLock \+on' &&
        echo on || echo off ;;
      ( * ) echo "usage: $( basename "$0" ) -t|--toggle | -s|--status | on | off"
    esac

and make it executable.

Of course you need xsetleds installed:

    emerge -n x11-misc/xsetleds

Then bind key XF86LightBulb to this command:

    /usr/local/bin/kbd-illum --toggle

like explained above and you are done.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hp_QuickPlay&oldid=299803"

Category:

-   Input devices

-   This page was last modified on 22 February 2014, at 15:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
