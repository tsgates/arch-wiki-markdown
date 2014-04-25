Input Japanese using uim
========================

This page explains how to get the Japanese input to work using uim.

If you use SCIM, see Smart Common Input Method platform.

If you use IBus, see Ibus.

Contents
--------

-   1 Installation
    -   1.1 Japanese fonts
    -   1.2 uim
        -   1.2.1 Using pacman
        -   1.2.2 Compiling uim from source using PKGBUILD
    -   1.3 Input method
        -   1.3.1 Anthy
            -   1.3.1.1 Extra dictionary
        -   1.3.2 Modified Anthy (anthy-ut)
            -   1.3.2.1 Compiling modified Anthy using PKGBUILD
        -   1.3.3 Anthy Kaomoji
        -   1.3.4 Mozc
            -   1.3.4.1 Mozc (Vanilla)
            -   1.3.4.2 mozc-ut and mozc-svn
            -   1.3.4.3 Registering Mozc
        -   1.3.5 Google CGI API for Japanese input
-   2 Settings
    -   2.1 Environment variables
    -   2.2 Toolbar utilities
        -   2.2.1 uim-toolbar-gtk/qt
        -   2.2.2 uim-toolbar-gtk-systray
        -   2.2.3 Panel applet
    -   2.3 uim preferences
    -   2.4 Input Japanese on Emacs
        -   2.4.1 LEIM or minor-mode
            -   2.4.1.1 Settings for the minor-mode
            -   2.4.1.2 Settings for the LEIM
        -   2.4.2 Preferred character encoding
        -   2.4.3 Enable inline candidates displaying mode by default
        -   2.4.4 Set Hiragana input mode by default
        -   2.4.5 Ignoring C-SPC on uim.el
        -   2.4.6 Disabling XIM on Emacs
-   3 Troubleshooting
    -   3.1 Set the GTK_IM_MODULE variable, but uim still not works with
        GTK+ 2 applications
    -   3.2 Cannot input Japanese on Opera
    -   3.3 Cannot type a consonant in Zenkaku mode
    -   3.4 uim-toolbar-gtk-systray: tray icon is crushed
    -   3.5 I use darker theme, I cannot read the uim mode icons
-   4 See also

Installation
------------

You need the following packages to input Japanese.

-   Japanese fonts
-   Japanese input method (Kana to Kanji conversion engine)
-   Input method framework: uim

> Japanese fonts

see also Fonts and Font Configuration for configuration or more detail.

Recommended Japanese fonts are as follows.

-   IPA fonts || otf-ipafont

A high quality and formal style opensource font set including Gothic
(sans-serif) and Mincho (serif) glyphs. Default font of openSUSE-ja.

-   VL Gothic (AUR: ttf-vlgothic)

Default Gothic font of Debian-ja, Fedora-ja, Vine Linux, et al.

-   UmePlus Gothic (AUR: ttf-umeplus)

Default Gothic font of Mandriva Linux ja environment.

If you want to show 2channel Shift JIS art properly, use one of the
following fonts:

-   ipamona font (AUR: ttf-ipa-mona)
-   Monapo font (AUR: ttf-monapo)

> uim

Using pacman

Install uim from the official repositories.

Compiling uim from source using PKGBUILD

If you want to build uim with your configurationin, you can compile from
source, using ABS for istance. See official wiki for all configure
options.

In Arch official repositories, uim is built with the following custom
configuration (as of 1.8.6):

-   --with-anthy-utf8 - Enable Anthy(UTF-8) support
-   --with-qt4-immodule - Build Qt4 immodule
-   --with-qt4 - Build uim-tools for Qt4

If you want KDE4 plasma widget, install automoc4 for making dependency,
and add --enable-kde4-applet option to PKGBUILD file.

> Input method

Anthy

Anthy is one of the most popular Japanese input methods in the open
source world. However, it has not been maintained for a long time.
Debian succeeds it from May 2010.

Install anthy from the official repositories.

Extra dictionary

Anthy's default dictionary does not include several characters which are
not specified on EUC-JP (JIS X 0208) such as "①", "♥", etc. alt-cannadic
provides extra dictionaries including those characters.

Get alt-cannadic dictionary and put them under your
~/.anthy/imported_words_default.d.

    $ tar jxvf alt-cannadic-091230.tar.bz2
    $ mkdir ~/.anthy/imported_words_default.d (if not exist)
    $ cp alt-cannadic-091230/extra/*.t ~/.anthy/imported_words_default.d/

Please see official wiki for more detail (Japanese).

Warning:If you will be using this extra dictionary, choose Anthy (UTF-8)
for default input method on uim.

Modified Anthy (anthy-ut)

Modified Anthy is a set of patches and huge extended dictionaries which
aims to improve the Kana to Kanji conversion quality of original Anthy.

Modified Anthy consists two different upstreams:

-   Patched source of Anthy by G-HAL
-   Huge extended dictionalies by UTSUMI

> Warning:

-   Modified Anthy applies to only Anthy (UTF-8). So you have to choose
    Anthy (UTF-8) for default input method on uim.
-   Modified Anthy does not have compatibility of the dictionaries and
    learning data with original Anthy.

Compiling modified Anthy using PKGBUILD

Modified Anthy is available on AUR named anthy-ut.

Get anthy-ut tarball and makepkg to make and install package:

    $ wget https://aur.archlinux.org/packages/anthy-ut/anthy-ut.tar.gz
    $ tar xvf anthy-ut.tar.gz
    $ cd anthy-ut
    $ makepkg -s -i

If you already use original Anthy, you have to convert the existing
learning data format.

    $ rm ~/.anthy/last-record1_*.bin
    $ anthy-agent --update-base-record
    $ rm ~/.anthy/last-record1_*.bin
    $ anthy-agent --update-base-record

(Though this step repeats the same commands twice, it is not mistypes.)

Anthy Kaomoji

Anthy Kaomoji is a modified version of Anthy that converts Hiragana text
to Kana Kanji mixed text and has emoticon (顔文字) and 2ch dictionaries.
It can be found in the AUR (anthy-kaomoji).

Mozc

See Mozc.

Mozc is a Japanese Input Method Editor (IME) designed for multi-platform
such as Chromium OS, Windows, Mac and Linux which originates from Google
Japanese Input.

Though Mozc adapts to only ibus input method framework, macuim provides
uim-mozc plugin.

Mozc (Vanilla)

uim-mozc is available on AUR.

Note:This does not support kill_line feature of uim-mozc.

You can install this from unofficial user repository. Add the following
into your /etc/pacman.conf:

    [pnsft-pur]
    SigLevel = Optional TrustAll
    Server = http://downloads.sourceforge.net/project/pnsft-aur/pur/$arch

Note:This repo provides x86_64 packages only now.

And refresh package database:

    # pacman -Syy

You can choose install packages specifying group name as follows:

    # pacman -S mozc-im

Or, specify package names directly. For example:

    # pacman -S uim-mozc

mozc-ut and mozc-svn

mozc-ut and mozc-svn can be built uim-mozc.

Note:mozc-ut can work with uim-mozc.

To build uim-mozc, edit PKGBUILD like follow, i,e. uncomment _uim_mozc=
line:

    ## If you will not be using ibus, comment out below.
    _ibus_mozc="yes"
    ## If you will be using uim, uncomment below.
    _uim_mozc="yes"
    ## If applying patch for uim-mozc fails, try to uncomment below.
    #_kill_kill_line="yes"
    ## This will disable the 'kill-line' function of uim-mozc.

Tip:If you will never be using ibus-mozc, comment out the _ibus_mozc=
line.

Registering Mozc

Warning:You must run the following command whenever you upgrade or
(re-)install uim.  
 # uim-module-manager --register mozc

Google CGI API for Japanese input

Google CGI API for Japanese Input (Google-CGIAPI-Jp) is CGI service to
provide Japanese conversion on the Internet by Google. It can be used on
web browser. Its conversion engine seems to be equivalent to Google
Japanese Input, so conversion quality is probably better than Mozc.

Note:This service sends/receives preedits and candidates as plain text
(as of 2012-09).

You can use it via uim. Choose "Google-CGIAPI-Jp" on
uim-im-switcher-gtk/gtk3/qt4 or uim-pref-gtk/gtk3/qt4.

Settings
--------

Add the followings to ~/.xprofile, ~/.xinitrc or ~/.xsession:

> Environment variables

    export GTK_IM_MODULE='uim'
    export QT_IM_MODULE='uim'
    uim-xim &
    export XMODIFIERS='@im=uim'

Note:The variables should be exported before starting your desktop
environment, i.e. before "exec startxfce4" or similar.

> Toolbar utilities

If you want to use UimToolbar utilities which shows and controls uim
mode, add one of the followings, too.

uim-toolbar-gtk/qt

Using toolbar appears as a window.

For GTK+ 2:

    uim-toolbar-gtk &

For GTK+ 3:

    uim-toolbar-gtk3 &

For Qt4:

    uim-toolbar-qt4 &

uim-toolbar-gtk-systray

Using toolbar for system tray.

For GTK+ 2:

    uim-toolbar-gtk-systray &

For GTK+ 3:

    uim-toolbar-gtk3-systray &

Panel applet

Or, if you use GNOME, KDE or Xfce, you can use uim-toolbar panel applet
(Xfce requires xfce4-xfapplet-plugin to use uim-applet-gnome).

> uim preferences

Configure uim preferences by running :

    $ uim-pref-gtk (Or, uim-pref-gtk3/uim-pref-qt4)

which brings forth a GUI.

Choose your preferring input method as 'Default input method'.

Note:Mozc will be not listed in 'Default input method' at first time so
you will need to add it into 'Enabled input methods' to use.

You can run uim-xim or restart X to test your settings.

Provided everything went well you should be able to input Japanese in X.

> Input Japanese on Emacs

uim provides uim.el the bridge software between Emacs and uim. Here is a
sample to use uim on Emacs with utf-8 encoding.

Please see Official wiki for more detail.

LEIM or minor-mode

You can call uim.el from Emacs in two ways; directly or with the LEIM
(Library of Emacs Input Method) framework. Though settings of them are
different, basic functions are same. If you want to switch between
uim.el and other Emacs IMs frequently, you should use LEIM framework.

Settings for the minor-mode

If you will be using on minor-mode, write the following settings into
your .emacs.d/init.el or some other file for Emacs customizing.

    ;; read uim.el
    (require 'uim)
    ;; uncomment next and comment out previous to load uim.el on-demand
    ;; (autoload 'uim-mode "uim" nil t)

    ;; key-binding for activate uim (ex. C-\)
    (global-set-key "\C-\\" 'uim-mode)

Settings for the LEIM

If you will be using via LEIM, write the following settings into your
.emacs.d/init.el or some other file for Emacs customizing and choose
default input method.

    ;; read uim.el with LEIM initializing
    (require 'uim-leim)

    ;; set default IM. Uncomment the one of the followings.
    ;(setq default-input-method "japanese-anthy-utf8-uim")        ; Anthy (UTF-8)
    ;(setq default-input-method "japanese-google-cgiapi-jp-uim")  ; Google-CGIAPI-Jp
    ;(setq default-input-method "japanese-mozc-uim")              ; Mozc

Preferred character encoding

uim.el uses euc-jp character encoding by default. To set UTF-8 as
preferred encodings, add the followings into your .emacs.d/init.el or
some other file for Emacs customizing.

    ;; Set UTF-8 as preferred character encoding (default is euc-jp).
    (setq uim-lang-code-alist
          (cons '("Japanese" "Japanese" utf-8 "UTF-8")
               (delete (assoc "Japanese" uim-lang-code-alist) 
                       uim-lang-code-alist)))

Enable inline candidates displaying mode by default

The inline candidates displaying mode displays conversion candidates
just below (or above) preedit text vertically instead of echo area. If
you want to enable inline candidates displaying mode by default, write
as follows.

    ;; set inline candidates displaying mode as default
    (setq uim-candidate-display-inline t)

Set Hiragana input mode by default

To set Hiragana input mode at activting uim, add the settings like
follows:

    ;; Set Hiragana input mode at activating uim.
    (setq uim-default-im-prop '("action_anthy_utf8_hiragana"
                                "action_google-cgiapi-jp_hiragana"
                                "action_mozc_hiragana"))

Ignoring C-SPC on uim.el

When you are assigning activation/deactivation of input method to C-SPC,
C-SPC is stolen to switch input mode by uim.el while it is activated. To
prevent the stealing and use for set-mark-command, add the followings
into your .emacs.d/init.el or some other file for Emacs customizing.

    (add-hook 'uim-load-hook
              '(lambda ()
                 (define-key uim-mode-map [67108896] nil)
                 (define-key uim-mode-map [0] nil)))

Disabling XIM on Emacs

When you are using input method on your desktop and assigning
activation/deactivation of input method to C-SPC, you will be not able
to use C-SPC/C-@ as set-mark-command on Emacs. To avoid this problem,
add the following into your ~/.Xresources or ~/.Xdefaults. xim will be
disabled on Emacs.

    Emacs*UseXIM: false

Troubleshooting
---------------

> Set the GTK_IM_MODULE variable, but uim still not works with GTK+ 2 applications

In case you already set the GTK_IM_MODULE environmental variable, but
uim still not works with GTK+ 2 applications, you need to specify the
location of gtk.immodules, which is created by and can be generated with
gtk-query-immodules-2.0.

The default location is /etc/gtk-2.0/gtk.immodules for GTK+ 2.

You can do this with either the GTK_IM_MODULE_FILE variable (not
recommended, it causes GTK+ 3 applications to see incompatible modules)
or the im_module_file setting (recommended).

Add the following to /etc/gtk-2.0/gtkrc or ~/.gtkrc-2.0:

     im_module_file "/etc/gtk-2.0/gtk.immodules"

> Cannot input Japanese on Opera

If you use Opera and cannot input Japanese with uim, try to edit
environment variable as follows: Make sure to add follows in the
beginning of /usr/bin/opera.

    export XMODIFIERS='@im=uim'
    export QT_IM_MODULE='xim'

> Cannot type a consonant in Zenkaku mode

If you cannot type a consonant in Zenkaku mode, add follows to your
config file.

       e.g.  vi ~/.uim.d/customs/custom-google-cgiapi-jp.scm
        
       (define ja-rk-rule-hoge
       (map
       (lambda (c)
       (list (cons (list c) ()) (list c c c)))
       '("b" "c" "d" "f" "g" "h" "j" "k" "l" "m"
       "p" "q" "r" "s" "t" "v" "w" "x" "y" "z"
       "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M"
       "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z")))
       (if (symbol-bound? 'ja-rk-rule-hoge)
       (set! ja-rk-rule (append ja-rk-rule-hoge ja-rk-rule)))

> uim-toolbar-gtk-systray: tray icon is crushed

Though some of DE, WM or panel application may provide only one icon
space per application on system-tray/notification-area,
uim-toolbar-gtk-systray displays some icons on it by default so those
icons are crushed. Choose just one of them to solve it. The steps to
display only 'Input mode' icon for example as follows:

1.  Run uim-pref-gtk.
2.  Click 'Toolbar' on 'Group' list.
3.  Take the all checkmarks off.
4.  Click 'Anthy', 'Anthy (UTF-8)' or 'Mozc' which you are using on
    'Group' list.
5.  Click Edit button in 'Toolbar' box > 'Enable toolbar buttons' line.
6.  Enable only 'Input mode' and click 'Close' button.
7.  Click 'OK' button to close uim-pref-gtk.

The tray icon will be displayed "あ" (Hiragana mode) or "ー" (Direct
mode).

> I use darker theme, I cannot read the uim mode icons

You can choose icons for darker background (uim 1.6.0 or later).

1.  Run uim-perf-gtk
2.  Click 'Toolbar' on 'Group' list.
3.  Check 'Use icon for dark background'.

See also
--------

uim 
    uim official document
    uim on wikibooks

Fonts 
    Japanese fonts showcase
    modified Japanese fonts

Retrieved from
"https://wiki.archlinux.org/index.php?title=Input_Japanese_using_uim&oldid=282514"

Category:

-   Internationalization

-   This page was last modified on 12 November 2013, at 20:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
