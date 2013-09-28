Fcitx
=====

FCITX (Flexible Input Method Framework) is a input method framework
aiming at providing environment independent language support for Linux.
It supports a lot of different languages and also provides many useful
non-CJK features.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Using FCITX to Input                                               |
| -   3 Configuration                                                      |
| -   4 Desktop Environment Integration                                    |
|     -   4.1 Gnome-Shell                                                  |
|     -   4.2 KDE                                                          |
|                                                                          |
| -   5 Install other components of fcitx                                  |
|     -   5.1 Keyboard layout integration                                  |
|     -   5.2 Chinese Input                                                |
|     -   5.3 Japanese Input Method                                        |
|     -   5.4 Korean Input Method                                          |
|     -   5.5 Other language                                               |
|                                                                          |
| -   6 Clipboard Access                                                   |
| -   7 Troubleshooting                                                    |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

fcitx can be installed with Pacman from the [community] repository.

In order to have a better experience in gtk and qt programs (especially
gtk programs) (e.g. better cursor following) and get rid of many
unsolvable problems/bugs caused by xim, please install the corresponding
input method modules for gtk and qt: fcitx-gtk2 (for gtk2 programs),
fcitx-gtk3 (for gtk3 programs) and fcitx-qt (for qt programs). You can
install all four of them in a bundle by issuing this command:

     pacman -S fcitx-im

Using FCITX to Input
--------------------

Before you can make use of FCITX for input, you have to setup some
environment variables. It is quite simple.

-   Adding the following lines to your desktop startup script files
    (.xprofile or .profile when you are using KDM, GDM or LightDM, and
    .xinitrc when you are using startx or Slim). With these lines, fcitx
    will work along with gtk/qt input method modules and support xim
    programs (Please make sure the necessary input method modules are
    already installed):

     export GTK_IM_MODULE=fcitx
     export QT_IM_MODULE=fcitx
     export XMODIFIERS="@im=fcitx"

Optionally, you can also choose to use xim in your gtk and/or qt
programs, in which case you need to change the corresponding lines above
as following:

     export GTK_IM_MODULE=xim
     export QT_IM_MODULE=xim

Warning: Using xim can sometimes cause problems that are not solvable by
any input method including not being able to input, no cursor following,
application freeze on input method restart. For these xim related
problems, Fcitx cannot provide any fix or support. This is the same with
any other input method framework, so please use toolkit (gtk/qt) input
method modules instead of xim whenever possible

-   Re-login to make such environment effective.

If you are using any XDG compatible desktop environment such as KDE,
GNOME, XFCE, LXDE, after you relogin, the autostart should work out of
box. If not, open your favorite terminal, type:

    $ fcitx

To see if fcitx is working correctly, open an application such as
leafpad and press CTRL+Space (the default shortcut for switching input
method) to invoke FCITX and input some words.

If Fcitx failed to start with your desktop automatically or if you want
to change the parameters to start fcitx, please use tools provided by
your desktop environment to configure xdg auto start or edit the
fcitx-autostart.desktop file in your ~/.config/autostart/ directory
(copy it from /etc/xdg/autostart/ if it doesn't exist yet).

If your desktop environment does not support xdg auto start, please add
the following command to your startup script (after the environment
variables are set up properly).

    $ fcitx

When other input methods with xim support is also running, Fcitx may
fail to start due to xim error. Please make sure no other input method
is running before you start Fcitx.

Configuration
-------------

Fcitx provides GUI configure tool. You can install either
kcm-fcitx(based on kcm), fcitx-configtool(based on gtk3), or
fcitx-configtool-gtk2(based on gtk2, unsupported) from AUR.

Desktop Environment Integration
-------------------------------

> Gnome-Shell

You can install kimpanel from extensions.gnome.org or
gnome-shell-extension-kimpanel-git package in AUR, which provides a
similar user experience as ibus-gjs.

Since gnome is trying it best to break every input method in GNOME. In
order to use Fcitx, you need to remove all input source from
gnome-control-center , clear all the hotkey for inputmethord and use
this command to disable ibus integration:

    $gsettings set org.gnome.settings-daemon.plugins.keyboard active false

> KDE

You can install kcm-fcitx and kdeplasma-addons-applets-kimpanel.

kcm-fcitx is a kcontrol module for fcitx.

kdeplasma-addons-applets-kimpanel is a plasmoids providing native
feeling under kde. Simply add kimpanel to plasma and fcitx will
automatically switch to it without extra configuration.

Install other components of fcitx
---------------------------------

All components of fcitx will requires fcitx to restart after install.

> Keyboard layout integration

fcitx-keyboard is now built-in supported. Open a configuration tool
(kcm-fcitx or fcitx-configtool mentioned above), you might want to
uncheck the "Show only current language" and find your keyboard layout.

In order to enable spell checking, press ctrl + alt + h when fcitx is on
a input method provides by fcitx-keyboard. Then that's it, you can type
long word, to see whether it works.

> Chinese Input

fcitx built-in provides fcitx-pinyin and fcitx-table inside fcitx
package, which supports Pinyin and table-based input method, for
example, Wubi.

If you want better support for pinyin, you can install,
fcitx-cloudpinyin, fcitx-sunpinyin, fcitx-googlepinyin or
fcitx-libpinyin.

If you need Bopomofo support, you can install fcitx-chewing or
fcitx-libpinyin.

If you need Cangjie, Zhengma, Boshiamy support, you can install
fcitx-table-extra.

> Japanese Input Method

Install fcitx-anthy or fcitx-mozc.

> Korean Input Method

Install fcitx-hangul.

> Other language

m17n provides quite a long other language support, you can install m17n
support for fcitx with fcitx-m17n

Clipboard Access
----------------

You can use fcitx to input text in you clipboard (as well as a short
clipboard history and primary selection). The default trigger key is
Control-;. You can change the trigger key as well as other options in
the Clipboard addon configure page.

NOTE: This is NOT a clipboard manager, it doesn't hold the selection or
change it's content as what a clipboard manager is supposed to do. It
can only be used to input from the clipboard.

Warning: Some client doesn't support multi-line input so you may see the
multi-line clipboard content pasted as a single line using
fcitx-clipboard. That's either a bug or feature of the program been
input and it's not something fcitx is able to help with.

Troubleshooting
---------------

-   Emacs

If your LC_CTYPE is English, you may not be able to use input method in
emacs due to a old emacs' bug. You can set your LC_CTYPE to something
else such as "zh_CN.UTF-8" before emacs starts to get rid of this
problem.

The default fontset will use `-*-*-*-r-normal--14-*-*-*-*-*-*-*' as
basefont(in src/xfns.c), if you do not have one matched(like
terminus、or 75dpi things, you can look the output of `xlsfonts'), XIM
can not be activated.

  

-   Input method module

Warning: You may still be able to use input method in most programs
without the input method module, however, you may have unsolvable weird
problems if you do so.

Warning: for firefox above version 13, the popup menu may fail to work
due to xim, please make sure that fcitx-gtk2 along with a latest version
fcitx are installed.

-   Ctrl+Space fail to work in GTK programs

This problem sometimes happens especially when locale is set as English.
Please make sure your GTK_IM_MODULE is set correctly.

See also FAQ

If you have set the *_IM_MODULE environment variables to fcitx but
cannot activate fcitx, please check if you have installed the
corresponding input method modules.

Some programs can only use xim, if you are using these programs, please
make sure your XMODIFIERS is set properly and be aware of the problems
you may have. These programs includes: all programs that are not using
gtk or qt (e.g. programs that use tk, motif, or xlib directly), emacs,
opera, openoffice, libreoffice, skype

If you cannot enable fcitx in gnome-terminal under gnome and the above
way doesn't work, try selecting Fcitx in the right click Input method
menu.

See also
--------

-   Fcitx GitHub
-   Fcitx Google Code
-   Fcitx Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fcitx&oldid=255883"

Category:

-   Internationalization
