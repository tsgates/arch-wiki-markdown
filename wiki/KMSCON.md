KMSCON
======

Summary

A guide to installing and configuring kmscon, the userspace
linux-console replacement.

Related

KMS

systemd

From the project github page:

Kmscon is a simple terminal emulator based on linux kernel mode setting
(KMS). It is an attempt to replace the in-kernel VT implementation with
a userspace console.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Features                                                           |
| -   3 Installation                                                       |
| -   4 Replacing linux-console                                            |
| -   5 CJK Support                                                        |
+--------------------------------------------------------------------------+

Requirements
------------

Despite its name, KMS is not a hard requirement for kmscon. Kmscon
supports the following video backends: fbdev (Linux fbdev video
backend), drm2d (Linux DRM software-rendering backend), drm3d (Linux DRM
hardware-rendering backend). Make sure one of them is available on your
system.

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

Installation
------------

Install kmscon from one of the official repositories. Alternatively, you
can install kmscon-git from the Arch User Repository.

Replacing linux-console
-----------------------

Note:Make sure you are using kmscon>=7, which contains an improved
version of kmsconvt@.service. Alternatively, you can use the git
version.

As root, issue:

    # ln -s /usr/lib/systemd/system/kmsconvt\@.service /etc/systemd/system/autovt\@.service
    # systemctl enable kmsconvt\@.service

This will make systemd start kmscon instead of agetty on each VT. If for
whatever reason kmscon failed to start, then agetty would be started
instead.

CJK Support
-----------

Note:Make sure you are using kmscon>=7 as kmscon<=6 does not render
multi-cell glyphs correctly. Alternatively, you can use the git version.

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=KMSCON&oldid=249123"

Category:

-   Terminal emulators
