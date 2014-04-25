Adobe Reader
============

Securing Adobe Reader
---------------------

> TOMOYO

Follow the instructions here to install TOMOYO. Please note that this
section describes using TOMOYO 2.5.

Note that the instructions below describe securing acroread.

-   Open /etc/tomoyo/exception_policy.conf file and add these lines:

    path_group PDF_FILES /\{\*\}/\*.pdf
    path_group THEMES_FILES /usr/share/themes/\{\*\}/\*
    path_group THEMES_FILES /usr/share/themes/\*
    path_group FONTS_DIRS /usr/share/fonts/\{\*\}/
    path_group FONTS_FILES /usr/share/fonts/\{\*\}/\*
    path_group FONTS_FILES /usr/share/fonts/\*
    path_group ACROREAD_FILES /opt/Adobe/Reader9/\{\*\}/\*
    path_group ACROREAD_FILES /opt/Adobe/Reader9/\*
    path_group ACROREAD_FILES /home/\*/.adobe/Acrobat/\{\*\}/\*
    path_group ACROREAD_FILES /home/\*/.adobe/Acrobat/\*
    path_group ACROREAD_DIRS /home/\*/.adobe/Acrobat/\{\*\}/
    path_group ACROREAD_DIRS /home/\*/.adobe/\{\*\}/
    initialize_domain /usr/bin/acroread from any

-   Then open /etc/tomoyo/domain_policy.conf and add the following
    lines:

    <kernel> /usr/bin/acroread
    use_profile 3
    use_group 0

    file execute /bin/ls exec.realpath="/usr/bin/ls" exec.argv[0]="/bin/ls"
    file execute /bin/pwd exec.realpath="/usr/bin/pwd" exec.argv[0]="/bin/pwd"
    file execute /bin/sed exec.realpath="/bin/sed" exec.argv[0]="sed"
    file execute /opt/Adobe/Reader9/Reader/intellinux/bin/acroread exec.realpath="/opt/Adobe/Reader9/Reader/intellinux/bin/acroread" exec.argv[0]="/opt/Adobe/Reader9/Reader/intellinux/bin/acroread"
    file execute /usr/bin/basename exec.realpath="/usr/bin/basename" exec.argv[0]="basename"
    file execute /usr/bin/cat exec.realpath="/usr/bin/cat" exec.argv[0]="cat"
    file execute /usr/bin/cp exec.realpath="/usr/bin/cp" exec.argv[0]="cp"
    file execute /usr/bin/cut exec.realpath="/usr/bin/cut" exec.argv[0]="cut"
    file execute /usr/bin/dirname exec.realpath="/usr/bin/dirname" exec.argv[0]="dirname"
    file execute /usr/bin/expr exec.realpath="/usr/bin/expr" exec.argv[0]="expr"
    file execute /usr/bin/gconftool-2 exec.realpath="/usr/bin/gconftool-2" exec.argv[0]="gconftool-2"
    file execute /usr/bin/mkdir exec.realpath="/usr/bin/mkdir" exec.argv[0]="mkdir"
    file execute /usr/bin/rm exec.realpath="/usr/bin/rm" exec.argv[0]="rm"
    file execute /usr/bin/sed exec.realpath="/usr/bin/sed" exec.argv[0]="sed"
    file execute /usr/bin/test exec.realpath="/usr/bin/test" exec.argv[0]="/usr/bin/test"
    file execute /usr/bin/uname exec.realpath="/usr/bin/uname" exec.argv[0]="uname"
    file execute /usr/bin/which exec.realpath="/usr/bin/which" exec.argv[0]="which"
    file execute /usr/bin/xargs exec.realpath="/usr/bin/xargs" exec.argv[0]="xargs"
    file read /bin/bash
    file read /opt/Adobe/Reader9/bin/acroread
    file read /usr/bin/bash
    file read /usr/bin/sed
    file read /usr/lib/gconv/gconv-modules
    file read /usr/lib/locale/locale-archive
    file read @PDF_FILES
    file read/write /dev/tty
    file write /dev/null
    misc env \*


    <kernel> /usr/bin/acroread /usr/bin/cut
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /bin/pwd
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/dirname
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/expr
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/basename
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /bin/ls
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /bin/sed
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/sed
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/cat
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/uname
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/test
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/gconftool-2
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/xargs
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/xargs /usr/bin/dirname
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/which
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/rm
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/mkdir
    use_profile 0
    use_group 0


    <kernel> /usr/bin/acroread /usr/bin/cp
    use_profile 0
    use_group 0

    <kernel> /usr/bin/acroread /opt/Adobe/Reader9/Reader/intellinux/bin/acroread
    use_profile 3
    use_group 0

    file chmod /home/\*/.local/share/recently-used.\* 0600
    file chmod @ACROREAD_FILES 0644
    file create /dev/shm/sem.\* 0666
    file create /home/\*/.config/gtk-2.0/gtkfilechooser.ini\* 0666
    file create /home/\*/.local/share/recently-used.\* 0666
    file create /tmp/acroread\*/\* 0600
    file create @ACROREAD_FILES 0-07777
    file ioctl anon_inode:inotify 0x541B
    file link /dev/shm/sem.\* /dev/shm/sem.\*
    file mkdir /tmp/acroread_\*_\*/ 0700
    file mkdir @ACROREAD_DIRS 0-07777
    file read /dev/urandom
    file read /etc/fonts/conf.avail/\*.conf
    file read /etc/fonts/conf.d/\*.conf
    file read /etc/fonts/fonts.conf
    file read /etc/fstab
    file read /etc/gtk-2.0/gtk.immodules-32
    file read /etc/gtk-2.0/gtkrc
    file read /etc/nsswitch.conf
    file read /etc/pango/pango.modules-32
    file read /etc/passwd
    file read /home/\*/.XCompose
    file read /home/\*/.Xauthority
    file read /home/\*/.cache/fontconfig/\*
    file read /home/\*/.config/fontconfig/fonts.conf
    file read /home/\*/.fontconfig/\*
    file read /home/\*/.gtk-bookmarks
    file read /home/\*/.gtkrc-2.0
    file read /home/\*/.gtkrc.mine
    file read /home/\*/.kde4/share/config/gtkrc-2.0
    file read /home/\*/.local/share/mime/mime.cache
    file read /home/\*/.local/share/recently-used.xbel
    file read /usr/lib/locale/locale-archive
    file read /usr/lib32/gconv/ISO8859-1.so
    file read /usr/lib32/gconv/UTF-16.so
    file read /usr/lib32/gconv/UTF-32.so
    file read /usr/lib32/gconv/gconv-modules
    file read /usr/lib32/gdk-pixbuf-2.0/2.10.0/loaders.cache
    file read /usr/lib32/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-xpm.so
    file read /usr/lib32/gtk-\*/\*/engines/\*.so
    file read /usr/lib32/gtk-\*/\*/immodules/\*.so
    file read /usr/share/X11/locale/\*/XLC_LOCALE
    file read /usr/share/X11/locale/compose.dir
    file read /usr/share/X11/locale/iso8859-1/Compose
    file read /usr/share/X11/locale/iso8859-1/XLC_LOCALE
    file read /usr/share/X11/locale/locale.alias
    file read /usr/share/X11/locale/locale.dir
    file read /usr/share/mime/mime.cache
    file read @FONTS_FILES
    file read @ICONS_FILES
    file read @PDF_FILES
    file read @THEMES_FILES
    file read sysfs:/devices/system/cpu/online
    file read/write /dev/shm/sem.ADBE_REL_\*
    file read/write /dev/shm/sem.ADBE_ReadPrefs_\*
    file read/write /dev/shm/sem.ADBE_WritePrefs_\*
    file read/write/truncate/unlink @ACROREAD_FILES
    file read/write/unlink /dev/shm/sem.\*
    file read/write/unlink /home/\*/.config/gtk-2.0/gtkfilechooser.ini\*
    file read/write/unlink /home/\*/.local/share/recently-used.\*
    file read/write/unlink /tmp/acroread\*/\*
    file rename /home/\*/.config/gtk-2.0/gtkfilechooser.ini\* /home/\*/.config/gtk-2.0/gtkfilechooser.ini\*
    file rename /home/\*/.local/share/recently-used.\* /home/\*/.local/share/recently-used.\*
    file symlink /home/\*/.adobe/Acrobat/9.0/Cert/curl-ca-bundle.crt symlink.target="/opt/Adobe/Reader9/Reader/Cert/curl-ca-bundle.crt"
    misc env \*
    network unix stream connect /var/run/nscd/socket
    network unix stream connect \000/tmp/.X11-unix/X0

-   After finishing editing reload TOMOYO config files by executing
    these commands:

    # tomoyo-loadpolicy -df </etc/tomoyo/domain_policy.conf
    # tomoyo-loadpolicy -ef </etc/tomoyo/exception_policy.conf

Voilà — your Adobe Reader is sandboxed now.

Please note that this config is generated on 64-bit Arch system, and
some of your ioctls and library paths may differ from mentioned above.
So in order to fine-tune TOMOYO config for your Adobe Reader load
tomoyo-auditd daemon:

    # systemctl start tomoyo-auditd

Then go to /var/log/tomoyo folder and start watching reject_003.log:

    tail -f reject_003.log

The output of this command will show you rejected actions for Adobe
Reader, so you'll be able to add them to domain_policy.conf file if
needed.

Detailed guide about TOMOYO configuring can be found here.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Adobe_Reader&oldid=248310"

Category:

-   Office

-   This page was last modified on 24 February 2013, at 12:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
