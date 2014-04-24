KMSCON
======

Related articles

-   KMS
-   systemd

From the project GitHub page:

Kmscon is a simple terminal emulator based on linux kernel mode setting
(KMS). It is an attempt to replace the in-kernel VT implementation with
a userspace console.

Contents
--------

-   1 Features
-   2 Install
-   3 Replacing Getty (agetty)
-   4 CJK support
-   5 Troubleshooting

Features
--------

Kmscon can function as a drop-in replacement for the in-kernel
linux-console. Features include:

-   Full vt220 to vt510 implementation.
-   Full internationalization support:
    -   Kmscon supports printing full Unicode glyphs, including the CJK
        ones.
    -   Kmscon provides internationalized keyboard handling through
        libxkbcommon, thus allowing it to use the full range of keyboard
        layouts supported in X keyboard.
-   Hardware accelerated rendering.
-   Multi-seat capability.

Note:In order to be able to log into a kmscon console as root, you have
to disable the pam_securetty module by removing or commenting out the
corresponding line in /etc/pam.d/login.

Install
-------

Despite its name, KMS is not a hard requirement for kmscon. Kmscon
supports the following video backends: fbdev (Linux fbdev video
backend), drm2d (Linux DRM software-rendering backend), drm3d (Linux DRM
hardware-rendering backend). Make sure one of them is available on your
system.

Install kmscon from one of the official repositories. Alternatively, you
can install kmscon-git from the AUR.

To enable it for the TTY1 run:

    # rm /etc/systemd/system/getty.target.wants/getty@tty1.service
    # systemctl enable kmsconvt@tty1.service

Replacing Getty (agetty)
------------------------

As root, issue:

    # ln -s /usr/lib/systemd/system/kmsconvt\@.service /etc/systemd/system/autovt\@.service

This will make systemd start KMSCON instead of agetty on each VT. Or
more precisely, this will make systemd-logind use kmsconvt@.service
instead of getty@.service for new VTs. In fact, all other
units/scripts/... that use getty@.service will not be affected by this
change.

If KMSCON cannot start for whatever reason, this unit will cause
getty@.service to be started instead. So you will always have a safe
fallback. Furthermore, if no VTs are available, this unit will not start
anything.

CJK support
-----------

Kmscon supports rendering CJK characters through the default font engine
pango. However, fontconfig has to be globally configured to map the
monospace font alias to proper CJK fonts. For Chinese users, the
following template is provided and proved to result in satisfactory
Chinese characters rendering:

    /etc/fonts/conf.d/99-kmscon.conf

    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
    <match>
            <test name="family"><string>monospace</string></test>
            <edit name="family" mode="prepend" binding="strong">
                    <string>DejaVu Sans Mono</string>
                    <string>WenQuanYi Micro Hei Mono</string>
            </edit>
    </match>
    </fontconfig>

You need to have ttf-dejavu and wqy-microhei, both available from the
official repositories, installed.

Troubleshooting
---------------

-   You may want to add --hwaccel --drm to ExecStart if you have
    problems with switching between Xorg and kmscon.

     ExecStart=/usr/bin/kmscon "--vt=%I" --seats=seat0 --no-switchvt --font-name Terminus --font-size 12 --hwaccel --drm

-   As version 7, if you cannot control the audio, add your user to
    audio group. Be aware of the shortcomings of this choice.

Retrieved from
"https://wiki.archlinux.org/index.php?title=KMSCON&oldid=303850"

Category:

-   Terminal emulators

-   This page was last modified on 9 March 2014, at 22:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
