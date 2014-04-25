Keytouch
========

KeyTouch is a program which allows you to easily configure the extra
function keys of your keyboard. This means that you can define, for
every individual function key, what to do if it is pressed.

This HOWTO will try to explain how keytouch is used in Arch Linux. For
further documentation, please have a look at the keytouch official
documentation.

Contents
--------

-   1 Installation
-   2 Keyboard File
    -   2.1 Creating a Keyboard File
    -   2.2 Share it
-   3 Configure keytouch
-   4 Starting the keytouch daemon
-   5 Troubleshooting

Installation
------------

Keytouch can be installed with the keytouch package, available in the
Arch User Repository.

Keyboard File
-------------

You need a keyboard file for your keyboard model. The package build
includes some of them. You can also check the official keyboards list.

If your model is not included in the keytouch package you will need to
create one for yourself.

> Creating a Keyboard File

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Install the keytouch-editor from the Arch User Repository. Make sure you
have evdev loaded (you should not need to do this if you using the stock
kernel)

    # modprobe evdev

We are going to need to make a keyboard file which is very simple. You
need to find out which input device is your keyboard first:

    # ls /dev/input/

Every event device (like a keyboard or a mouse) is related to one of
these ﬁles. To ﬁnd out which ﬁle belongs to your keyboard, run:

    # keytouch-editor /dev/input/eventX mykeyboardconfig

If the previous command fails due to a missing kdesu dependency, try the
following variation:

    # keytouch-editor-bin /dev/input/eventX mykeyboardconfig

Replace the X by a number. KeyTouch editor will ﬁrst show some
information about the device, including its name (”Input device name”)
that can tell you if you have chosen the correct event device. KeyTouch
editor asks you to press one of the extra function keys. If the program
continues after pressing the extra function key, you have chosen the
right event device. If not terminate the program by pressing Ctrl+C and
try another event device. Note that when your keyboard is connected via
USB there are two event devices: /dev/input/eventA (where A is replaced
by a number) for all ”normal” keys and /dev/input/eventB (where B = A+1)
for the extra function keys.

-   After you have found the correct device, follow the steps.
    keytouch-editor asks your name and the name of the manufacturer and
    model of your keyboard.

-   Now it is time to tell keytouch-editor about your extra function
    keys. You will see the following message:

    Press an extra function key or press enter to finish...

If your keyboard is connected via USB or you started keyTouch editor
with the ”–acpi” option, you will not see this message, but instead:

    Press return to a new key or enter F followed by return to finish...

-   First you will have to press the extra function key so that the
    program knows which key you mean. It is important that you do not
    press any other key than the extra function key. After pressing the
    key you will be asked to enter the keys name, keycode and default
    action.
-   Key name

Choose an appropriate name for the key. If there is for example a text
label on the key, use the label as the key’s name.

-   Keycode

Use one of the keycodes listed below. It actually doesn’t matter which
keycode you choose. However it is recommended that you choose a keycode
that matches the best the function of the key. A keycode may only be
used once in a keyboard ﬁle.

    AGAIN               EJECTCLOSECD        MAIL              REFRESH
    ALTERASE            EMAIL               MEDIA             REWIND
    BACK                EXIT                MENU              RIGHTMETA
    BASSBOOST           FASTFORWARD         MOVE              SCROLLDOWN
    BOOKMARKS           FILE                MSDOS             SCROLLUP
    BRIGHTNESSDOWN      FINANCE             MUTE              SEARCH
    BRIGHTNESSUP        FIND                NEXTSONG          SENDFILE
    CALC                FORWARD             OPEN              SETUP
    CAMERA              FRONT               PASTE             SHOP
    CANCEL              HANGUEL             PAUSE             SLEEP
    CHAT                HANJA               PAUSECD           SOUND
    CLOSE               HELP                PHONE             SPORT
    CLOSECD             HOMEPAGE            PLAY              STOP
    COFFEE              HP                  PLAYCD            STOPCD
    COMPOSE             ISO                 PLAYPAUSE         SUSPEND
    COMPUTER            KBDILLUMDOWN        POWER             SWITCHVIDEOMODE
    CONFIG              KBDILLUMTOGGLE      PREVIOUSSONG      UNDO
    CONNECT             KBDILLUMUP          PRINT             VOLUMEDOWN
    COPY                KPCOMMA             PROG1             VOLUMEUP
    CUT                 KPEQUAL             PROG2             WAKEUP
    CYCLEWINDOWS        KPLEFTPAREN         PROG3             WWW
    DELETEFILE          KPPLUSMINUS         PROG4             XFER
    DIRECTION           KPRIGHTPAREN        PROPS             YEN
    EDIT                LEFTMETA            QUESTION
    EJECTCD             MACRO               RECORD

You can find the correct keycodes from the official keycodes list.

-   Default action

It is important to realize that the default action for a key, is not the
action you want to use for this key, but one that corresponds to the
function of the key. The default action can be a program or a plugin. If
it is a program, just ﬁll in the name of the program. If it is a plugin
type ”plugin” (without the quotes) instead. Then ﬁll in the name of the
plugin. To get a list of all available plugins, run keyTouch and go to
the ”Preferences” part. Select the plugin and click the ”Information...”
button to get a list of the functions of the selected plugin. After
entering the plugins name in keytouch-editor, ﬁll in the function name.
Note that the name and function you ﬁll in are case sensitive.

-   When you entered the information, the program asks again to press an
    extra function key. If there are no more extra function keys, just
    press enter to write the output ﬁle and terminate the program.

> Share it

After you made the file and tested it, it would be a good idea to send
it to the author of keytouch so he can include it in the next release.
This helps future users of keytouch who have the same keyboard as you
do.

    marvinr users.sourceforge.net

(You know there's a missing @ because of spam bots ;))

Configure keytouch
------------------

-   We now need to run keytouch

    $ keytouch

-   What to do...

1.  When you see the list of keyboards select import and find where you
    put the keyboard config file you just made.
2.  Now you should see your keyboard module and manufacturer. Select it
    and click ok.
3.  Now you get to the keytouch configuration theme. I think this is
    pretty self explanatory.

Starting the keytouch daemon
----------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: sysvinit has     
                           been replaced by systemd 
                           and the file rc.conf is  
                           no longer available.see  
                           the news (Discuss)       
  ------------------------ ------------------------ ------------------------

-   You should start the keytouch daemon at boot time (add keytouch to
    the daemons array in /etc/rc.conf)
-   You have to load keytouchd on your session startup. There is a
    script /etc/X11/Xsession which runs all daemons located in
    /etc/X11/Xsession.d/ including the keytouchd.
    -   You can add /etc/X11/Xsession into your ~/.xinitrc if you log in
        from console
    -   If you, however, use KDM as your login manager .xinitrc will not
        be parsed. You can add /etc/X11/Xsession to your session list of
        your Desktop Environment (Gnome, Kde, Xfce-svn, among others).

Troubleshooting
---------------

-   When I change the volume with the special keys, the OSD looks ugly.
    What's wrong?:

Maybe you have started the /etc/X11/Xsession script as root. This is
what happens when you place "/etc/X11/Xsession" on a script like
/opt/kde/share/config/kdm/Xstartup. The only thing that
/etc/X11/Xsession script does, is to look on /etc/X11/Xsession.d/ and
execute every script that is there. Once you have installed keytouch,
two scripts are created there:

    $ pwd
    /etc/X11/Xsession.d
    $ ls
    91keytouch-acpid_launch  92keytouchd_launch

If them aren't executed, there is no keytouchd for you. But if you
execute them as root (e.g. in a KDM startup script) they will look ugly
and that isn't good for most people. Just run them as yourself (e.g.
creating a symbolic link of /etc/X11/Xsession in ~/.kde/Autostart).

-   My multimedia keys (Play/Pause/Previos/Next...) do not work at all:

The problem is probably the same as above. If you run keytouchd as root,
the programs you run with the multimedia keys are expected to run as
root, they just won't work.

-   I've just created a brand new keyboard file for my own model (using
    keytouch-editor) but when I select it in keytouch, it says that my
    keyboard file doesn't exist. I know that is there!:

Actually, the error isn't that the file doesn't exist: It only has a bad
filename. When you make your own keyboard file, you have to make sure
that your filename has exactly this format:

    Model.Manufacturer

For example:

    Satellite-L25-SP141.Toshiba

That should do the trick.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keytouch&oldid=305963"

Category:

-   Keyboards

-   This page was last modified on 20 March 2014, at 17:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
