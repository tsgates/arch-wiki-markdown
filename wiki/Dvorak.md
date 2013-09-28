Dvorak
======

This is a quick blurb for setting or converting your keymaps to dvorak
instead of qwerty.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setting Dvorak On The Console                                      |
| -   2 Setting Dvorak In X                                                |
| -   3 Setting Dvorak International In X                                  |
| -   4 For International Users                                            |
|     -   4.1 Swedish                                                      |
|     -   4.2 Spanish                                                      |
|                                                                          |
| -   5 Typing Tutors                                                      |
+--------------------------------------------------------------------------+

Setting Dvorak On The Console
-----------------------------

To convert to dvorak on the console, type

    loadkeys dvorak

If you are using the left-handed dvorak layout,please type

    loadkeys dvorak-l

or type

    loadkeys dvorak-r

if you are using the right-handed dvorak layout.

To make this change permanently, set

    KEYMAP="dvorak"

in /etc/vconsole.conf.

Setting Dvorak In X
-------------------

To change to the dvorak layout in X, see Xorg#Keyboard_settings

Setting Dvorak International In X
---------------------------------

Setting your system to the dvorak international layout (with dead keys)
is a simple matter of changing the XkbVariant option to dvorak-intl. It
should look as follows:

    Option "XkbVariant" "dvorak-intl"

Your XkbLayout should already be set to us.

In a small aside, you can test your configuration in a new X by entering
the following into a shell:

    $ xinit -- :1

This will work if you have xinit installed. If you are not using a
custom .xinitrc, this will open a terminal in the new X session. From
that terminal you can test your setup and exit that session by typing
exit in the terminal. If you are using your own .xinitrc, you will have
to exit in whatever way is provided by your setup.

For International Users
-----------------------

> Swedish

Swedish people interested in trying dvorak can find the swedish
"version", called svorak, at aoeu.info! To convert to svorak in X you do
not need to download any additional files from www.aoeu.info.

> Spanish

You can install the AUR dvorak-es-loadkeys package, and then use
dvorak-es instead of dvorak, both in loadkeys and /etc/vconsole.conf to
use the spanish dvorak variant.

On X, you don't need to install anything, just edit
/etc/X11/xorg.conf.d/01-keyboard-layout.conf and put:

    Section "InputClass"
      Identifier "Keyboard-layout"
      Driver "evdev"
      MatchIsKeyboard "yes"
      Option "XkbLayout" "es(dvorak)"
    EndSection

Typing Tutors
-------------

Console: DvorakNG

GUI: kdeedu-ktouch (includes Dvorak lessons in English, French, German &
Spanish)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dvorak&oldid=234361"

Category:

-   Keyboards
