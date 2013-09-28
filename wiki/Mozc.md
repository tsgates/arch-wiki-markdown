Mozc
====

Mozc is a Japanese Input Method Editor (IME) designed for multi-platform
such as Chromium OS, Windows, Mac and Linux. This open-source project
originates from Google Japanese Input. Detailed differences between Mozc
and Google Japanese Input are described in About Mozc (In short, Mozc
does not have equivalent conversion quality to Google Japanese Input).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Using Unofficial user repository                             |
|     -   1.2 Compiling Mozc using PKGBUILD                                |
|         -   1.2.1 Edit PKGBUILD                                          |
|         -   1.2.2 Build and install                                      |
|                                                                          |
|     -   1.3 Make available Mozc                                          |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Mozc for Emacs                                               |
|         -   2.1.1 Disabling XIM on Emacs                                 |
|                                                                          |
| -   3 Tips                                                               |
|     -   3.1 Confirming Mozc version which you are using now              |
|     -   3.2 Launching Mozc tools from command line                       |
|     -   3.3 Use CapsLock as Eisu_toggle key on ASCII layout keyboard     |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Building Mozc fails (process is killed)                      |
|     -   4.2 New version of Mozc does not appear though I upgraded Mozc   |
|         and restarted X or IBus (not rebooted)                           |
|                                                                          |
| -   5 Mozc variants on AUR                                               |
|     -   5.1 uim-mozc                                                     |
|     -   5.2 mozc-svn                                                     |
|     -   5.3 mozc-ut                                                      |
|     -   5.4 mozc-fcitx                                                   |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

You can install mozc using unofficial user repository or build yourself
from AUR.

Note:Mozc works with ibus. Please see also IBus for installation and
configuration.

Mozc is available on AUR. This package consists as follows:

Package

mozc

description

Group

mozc-im

Component

mozc

Server part of the Mozc

ibus-mozc

IBus engine module

emacs-mozc

Mozc for Emacs (optional)

Tip:Unofficial plugins for the other IM frameworks are available

> Using Unofficial user repository

There is an unofficial user repository of Mozc. Add the following into
your /etc/pacman.conf:

    [pnsft-pur]
    Server = http://downloads.sourceforge.net/project/pnsft-aur/pur/$arch

Note:This repo provides x86_64 packages only now.

And refresh package database:

    # pacman -Syy

You can choose install packages specifying group name as follows:

    # pacman -S mozc-im

Or, specify package names directly. For example:

    # pacman -S mozc ibus-mozc emacs-mozc

> Compiling Mozc using PKGBUILD

You can install from AUR as follows.

First, get mozc tarball from AUR and edit the PKGBUILD if necessary.

    $ wget https://aur.archlinux.org/packages/mo/mozc/mozc.tar.gz
    $ tar xvf mozc.tar.gz
    $ cd mozc

Edit PKGBUILD

If you will be using mozc.el on Emacs, uncomment _emacs_mozc line.

    ## If you will be using mozc.el on Emacs, uncomment below.
    _emacs_mozc="yes"

Build and install

Then, build and install:

    $ makepkg -s -i

Note:Some of AUR helper does not support split package so it may fail
installing mozc. Even in the case, package files (*.pkg.tar.xz) should
be generated unless makepkg is failed. You can install manually from AUR
helper's working directory or $PKGDEST using pacman -U.

> Make available Mozc

Restart X or IBus to enable use of Mozc.

Configuration
-------------

See also IBus for IBus configuration.

If you use Mozc by default, set it via ibus-setup:

    $ ibus-setup

Choose Input Method tab and move Mozc to top of the list.

You can switch input method by Alt + Shift_L (by IBus default).

> Mozc for Emacs

You can use mozc.el (mozc-mode) to input Japanese via LEIM (Library of
Emacs Input Method). To use mozc-mode, write the following into your
.emacs.d/init.el or some other file for Emacs customizing:

    (require 'mozc)  ; or (load-file "/path/to/mozc.el")
    (setq default-input-method "japanese-mozc")

mozc.el provides "overlay" mode in the styles of showing candidates
(from mozc r77) which shows a candidate window in box style close to the
point. If you want to use it by default, add the following:

    (setq mozc-candidate-style 'overlay)

C-\ (`toggle-input-method') enables/disables use of mozc-mode.

Disabling XIM on Emacs

When you are using input method on your desktop and assigning
activation/deactivation of input method to C-SPC, you will be not able
to use C-SPC/C-@ as set-mark-command on Emacs. To avoid this problem,
add the following into your ~/.Xresources or ~/.Xdefaults. xim will be
disabled on Emacs.

    Emacs*UseXIM: false

Tips
----

> Confirming Mozc version which you are using now

Type "ばーじょん" ("version") and convert it while activating Mozc. The
version number of Mozc will be shown in the candidate list like follows:

    ばーじょん

    バージョン
    ヴァージョン
    ばーじょん
    Mozc-1.6.1187.102  ⇐ Current version of Mozc
    ...

> Launching Mozc tools from command line

The followings are commands to launch mozc tools.

-   Mozc property:

        $ /usr/lib/mozc/mozc_tool --mode=config_dialog

-   Mozc Dictionary Tool:

        $ /usr/lib/mozc/mozc_tool --mode=dictionary_tool

-   Mozc Word Register:

        $ /usr/lib/mozc/mozc_tool --mode=word_register_dialog

-   Mozc Hand Writing:

        $ /usr/lib/mozc/mozc_tool --mode=hand_writing

-   Mozc Character Palette:

        $ /usr/lib/mozc/mozc_tool --mode=character_palette

> Use CapsLock as Eisu_toggle key on ASCII layout keyboard

All of the preset keymap styles of Mozc, command
'ToggleAlphanumericMode' on 'Composition' mode is assigned to Eisu
(Eisu_toggle), Hiragana/Katakana or Muhenkan key, but the ASCII keyboard
has none of them.

One of the solution for it is to use CapsLock key as Eisu_toggle (Mozc
does not recognize CapsLock key as of r124). The following is way to
assign the Eisu_toggle to CapsLock (without any modifier keys) and the
Caps_Lock to Shift + CapsLock, like OADG keyboard layout.

Warning:This way affects to desktop wide.

Edit the ~/.Xmodmap as follows:

    keycode 66 = Eisu_toggle Caps_Lock
    clear Lock

Then, restart X or run xmodmap to apply immediately:

    $ xmodmap ~/.Xmodmap

Troubleshooting
---------------

> Building Mozc fails (process is killed)

If build process is failed with like the following messages:

    ...
    /bin/sh: line 1:  xxxx killed
    ...
    make: *** [xxx/xxx...] error 137
    ...

Make sure whether you have run out of memory.

> New version of Mozc does not appear though I upgraded Mozc and restarted X or IBus (not rebooted)

Old version of Mozc may be still on your memory. Try to kill existing
mozc process:

    $ killall mozc_server

Mozc variants on AUR
--------------------

> uim-mozc

Though Mozc adapts to only ibus input method framework, macuim provides
uim-mozc plugin. uim-mozc(AUR) is for Mozc (vanilla), mozc-svn and
mozc-ut can build uim-mozc for themselves (see Input Japanese using
uim). You can install uim-mozc from Unofficial User Repository as well
as Mozc (vanilla).

> mozc-svn

mozc-svn builds using the published svn repository instead of source
tarball and can build uim-mozc and fcitx-mozc plugin. You should use
mozc (vanilla) or mozc-ut unless you have any reason. This is exactly
similar to mozc (published svn repository is not actually trunk) and
run-time of makepkg of mozc-svn will be longer than mozc.

> mozc-ut

mozc-ut comes with Mozc UT dictionary and can build uim-mozc. The
dictionary adds over 350,000 words into original.

Note:Building mozc-ut requires long time to generate dictionary seed.

> mozc-fcitx

mozc-fcitx is all in one Mozc package dedicated to Fcitx.

Each packages consist as follows:

Package

mozc

mozc-svn

mozc-ut

mozc-fcitx

description

Group

mozc-im

mozc-im-svn

mozc-im-ut

mozc-im

Component

mozc

mozc-svn

mozc-ut

--

Server part of the Mozc

ibus-mozc

ibus-mozc-svn

ibus-mozc-ut

--

IBus engine module (optional)

(uim-mozc)

uim-mozc-svn

uim-mozc-ut

--

uim plugin module (optional)

N/A

fcitx-mozc-svn

N/A

--

Fcitx module (optional)

emacs-mozc

emacs-mozc-svn

emacs-mozc-ut

--

Mozc for Emacs (optional)

--

--

--

mozc-fcitx

mozc-fcitx package (all in one)

See also
--------

-   Mozc official site
-   Input Japanese using uim

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mozc&oldid=250246"

Category:

-   Internationalization
