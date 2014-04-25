IBus
====

Related articles

-   Fcitx
-   SCIM
-   UIM

IBus (Intelligent Input Bus) is an input method framework, a system for
entering foreign characters. IBus functions similarly to Fcitx, SCIM and
UIM.

Contents
--------

-   1 Installation
    -   1.1 Input method engines
    -   1.2 Initial setup
    -   1.3 GNOME
-   2 Configuration
    -   2.1 IBus
    -   2.2 Ibus-rime
        -   2.2.1 Usage
            -   2.2.1.1 Basic configuration access
            -   2.2.1.2 Chinese punctuation
            -   2.2.1.3 Advanced
-   3 Tips and tricks
    -   3.1 Pinyin usage
-   4 Troubleshooting
    -   4.1 Kimpanel
    -   4.2 rxvt-unicode
    -   4.3 GTK+ applications
    -   4.4 Chinese input
    -   4.5 LibreOffice

Installation
------------

Install the ibus package from the official repositories.

Additionally, to enable IBus for Qt applications, install the ibus-qt
library.

> Input method engines

You will need at least one input method, corresponding to the language
you wish to type. Available input methods include:

-   ibus-anthy - Japanese IME, based on anthy.
-   ibus-pinyin - Intelligent Chinese Phonetic IME for Hanyu pinyin and
    Zhuyin (Bopomofo) users. Designed by IBus main author and has many
    advance features such as English spell checking. Package currently
    not maintained and partly broken with latest ibus base. Use
    ibus-libpinyin instead.
-   ibus-rime - Powerful and smart Chinese input method for Chinese
    (pinyin, zhuyin, with or without tones, double pinyin, Jyutping,
    Wugniu, Cangjie5 and Wubi 86).
-   ibus-chewing - Intelligent Chinese Phonetic IME for Zhuyin
    (Bopomofo) users, based on libchewing.
-   ibus-hangul - Korean IME, based on libhangul.
-   ibus-unikey - IME for typing Vietnamese characters.
-   ibus-table - IME that accommodates table-based IMs.
-   ibus-m17n - M17n IME which allows input of many languages using the
    input methods from m17n-db.
-   ibus-mozc - Japanese IME, based on Mozc. Part of mozc package.
-   ibus-kkc - Japanese IME, based on libkkc.

To see all available input methods:

    $ pacman -Ss ^ibus-*

Others packages are also available in the AUR.

> Initial setup

Now, run  $ ibus-setup (as the user who will use IBus). It will start
the daemon and give you this message:

    IBus has been started! If you cannot use IBus, please add below lines in $HOME/.bashrc, and relogin your desktop.
    export GTK_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export QT_IM_MODULE=ibus

> Note:

-   Although IBus uses a daemon, it is not the sort of daemon managed by
    systemd: it runs as an ordinary user and will be started for you
    when you login.
-   If, however, IBus is not autostarted upon login, then move the
    “export …” lines above to $HOME/.xprofile instead, and append this
    line to the same file: ibus-daemon -drx, and relogin your desktop.
    You can also try adding ibus-daemon -drx after the export ... lines
    in $HOME/.bashrc.

You will then see a configuration screen; you can access this screen
whenever IBus is running by right-clicking the icon in the system tray
and choosing Preferences. See Configuration.

If IBus doesn't work in Qt/KDE applications, ensure that the ibus-qt
library is installed and define IBus as the default IME in the Qt
configuration editor:

    $ qtconfig-qt4

In Interface > Default Input Method, select ibus instead of xim.

> GNOME

GNOME includes IBus by default, so you should only need to install the
package specific to your language. To enable input in your language, add
it to the Input Sources section of the Region & Language settings. After
you add your input sources, GNOME will show the input switcher icon in
the tray. The default keyboard shortcut to switch to the next input
method in GNOME is Super+space; disregard the next input method shortcut
set in ibus-setup.

Configuration
-------------

> IBus

Note:You need to have east Asian fonts installed if you want to enter
Chinese, Japanese, Korean or Vietnamese characters.

The default General settings should be fine, but go to Input Methods and
select your input method(s) in the drop down box, then press Add. You
can use multiple input methods if you wish. Once IBus is set up, you can
press Super+space to use it (multiple times to cycle through available
input methods). IBus will remember which input method you are using in
each window, so you will have to reactivate it for each new window. You
can override this behavior by right clicking the system tray icon,
selecting Preferences, and going to the Advanced tab.

> Ibus-rime

If you have decided to use the great ibus-rime IME, here are some help
to install it and to configure it.

In order to work, Rime is based on schemas that should be edited by the
user. However, it comes installed with a default pinyin input schema so
you can use it as it.

If you want it for another input method, here they are:

-   Luna Pinyin (Standard Mandarin)
-   Terra Pinyin (with tones)
-   Bopomofo (Mandarin Phonetic Symbol)
-   Double Pinyin (Ziranma, MSPY)
-   Jyutping (Cantonese)
-   Wugniu (Wuu)
-   Cangjie5
-   Wubi86

For example, if you want to be able to type pinyin with tones, you want
to use the Terra Pinyin input method. To do so, you have to first create
a directory:

    $ mkdir ~/.config/ibus/rime

In this directory, create a file entitled default.custom.yaml and add
the following lines to it:

    default.custom.yaml

    patch:
      schema_list:
        - schema: terra_pinyin

Note that the indentation level is important. Your file says to Rime to
replace the schema list with a list that only contains Terra Pinyin.

Eventually, if the changes aren't taken automatically, run:

    $ rm ~/.config/ibus/rime/default.yaml && ibus-daemon -drx

Note: Tones are optionals but you can type them to filter the list very
well. Here are how to type them:

    1st tone: -
    2nd tone: /
    3rd tone: <
    4th tone: \

Example: if one wants to type hǎo to display only Chinese characters
that are pronounced this way, one must type hao< and it will be
automatically converted to hǎo.

Usage

Rime provides some great features that allow you to write good Chinese
and all its punctuation.

Basic configuration access

At any time, while running Rime, you can access some basic options with
F4. The displayed options look like this:

    1.　Method name
    2. 中文　－›　西文
    3. 全角　－›　半角
    4. 漢字　－›　汉字
    etc.

The first one indicate the name of the method you can select (Ex:
地球拼音 for Terra Pinyin). If you want many methods, you'll have them
in this menu.

The second one lets you select which language you want to type in.

The third one lets you select if you want to type the punctuation in
full width (全角) or in half width (半角).

The last one allows you to type in traditional Chinese (漢字) or in
simplified Chinese (汉字).

Chinese punctuation

You can access to all the Chinese punctuation thanks to Rime. Here is a
little table showing you how to type some of them:

    [ -> 「　【　〔　［
    ] ->　」　】　〕　］
    { ->　『　〖　｛
    } ->　』　〗　｝
    < ->　《　〈　«　‹
    > ->　》　〉　»　›
    @ ->　＠　@　☯
    / ->　／　/　÷
    * ->　＊　*　・　×　※
    % ->　％　%　°　℃
    $ ->　￥　$　€　£　¥
    | ->　・　｜　|　§　¦
    _ -> ——
    \ ->　、　＼　\
    ^ ->　……
    ~ ->　〜　~　～　〰

Advanced

Rime allows you to change everything you can imagine and more examples
are provided on the website of the project (in Chinese):
https://code.google.com/p/rimeime/wiki/CustomizationGuide

Tips and tricks
---------------

> Pinyin usage

When using ibus-pinyin,

-   First type the pinyin (sans tones) for the characters you wish to
    enter.
-   Press Up and Down repeatedly to select a character (going on to the
    next page if necessary).
-   Press Space to use a character.
-   You can also use PageUp or PageDown to scroll pages, and use the
    number keys 1-5 to select the character you need.
-   You can enter multiple characters that form a word or phrase at a
    time (such as "zhongwen" to enter "中文"). ibus-pinyin will remember
    which characters you type most frequently and over time make
    suggestions that are more tuned to your typing profile.

Troubleshooting
---------------

> Kimpanel

IBus main interface is currently only available in GTK+, but Kimpanel
provides a native Qt/KDE input interface. The package
kdeplasma-addons-applets-kimpanel is compiled to support IBus, but IBus
needs to be launched as following to be able to communicate with the
panel:

    $ ibus-daemon --xim --panel=/usr/lib/kde4/libexec/kimpanel-ibus-panel

To get a menu entry for launching ibus this way, save the following file
to ~/.local/share/applications/ibus-kimpanel.desktop:

    [Desktop Entry]
    Encoding=UTF-8
    Name=IBus (KIMPanel)
    GenericName=Input Method Framework
    Comment=Start IBus Input Method Framework
    Exec=ibus-daemon --xim --panel=/usr/lib/kde4/libexec/kimpanel-ibus-panel
    Icon=ibus
    Terminal=false
    Type=Application
    Categories=System;Utility;
    X-GNOME-Autostart-Phase=Applications
    X-GNOME-AutoRestart=false
    X-GNOME-Autostart-Notify=true
    X-KDE-autostart-after=panel

Then you can either let KDE autostart ibus, or set it as the input
method application in Kimpanel, and manually click on the kimpanel icon
to start it. In either case, choose Utility/Ibus (Kimpanel) in the
Choose Application dialog.

> rxvt-unicode

If anyone has any issues with IBus and rxvt-unicode, the following steps
should solve it.

Add the following to your ~/.Xdefaults (possibly not required, first try
without):

    URxvt.inputMethod: ibus
    URxvt.preeditType: OverTheSpot

And start IBus with:

    $ ibus-daemon --xim

If you start ibus-daemon automatically (e.g. in ~/.xinitrc or
~/.xsession) but used to use ibus-daemon & without the --xim option,
make sure to kill the existing process before testing the new command.

> GTK+ applications

Some users have had problems using Input Methods with GTK applications,
because it seems that the gtk.immodules file can't be found. Adding:

    export GTK_IM_MODULE_FILE=/etc/gtk-2.0/gtk.immodules

for GTK+ 2, or:

    export GTK_IM_MODULE_FILE=/usr/lib/gtk-3.0/3.0.0/immodules.cache

for GTK+ 3, in addition to the three lines above in your $HOME/.bashrc
seems to fix the problem.

Note:If you set it to GTK+ 2, then you can't use GTK+ 3 applications
like gedit, if you set it to GTK+ 3, then you can't use GTK+ 2
applications like Xfce.

> Chinese input

If you encounter problems when using Chinese input, check your locale
setting. For example in Hong Kong, export LANG=zh_HK.utf8.

Note:There are large revisions after IBus 1.4, you might not be able to
input Chinese words with ibus-pinyin or ibus-sunpinyin, which are
written in C. So the solution is to install ibus-libpinyin.

To start ibus with GNOME, add this in ~/.profile and restart the GNOME.

    export GTK_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export QT_IM_MODULE=ibus
    ibus-daemon -d -x

Chinese users can refer to this page for detailed solution concerning
this bug.

> LibreOffice

If IBus does load but doesn't see LibreOffice as an input window, add
this line to ~/.bashrc:

    export XMODIFIERS=@im=ibus

And then, you need to start ibus with --xim -d, for example, add this
line to ~/.xinitrc:

    ibus-daemon --xim -d

But the horrible thing is that you need to start LibreOffice in
terminal.

If you're using KDE and the above doesn't work, install
libreoffice-gnome and add this line to ~/.xprofile if you don't mind
running LibreOffice in GTK+ 2 mode:

    export OOO_FORCE_DESKTOP="gnome"

That will make IBus work with LibreOffice, and you can start LibreOffice
from anywhere, not just the terminal.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBus&oldid=304578"

Category:

-   Internationalization

-   This page was last modified on 15 March 2014, at 07:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
