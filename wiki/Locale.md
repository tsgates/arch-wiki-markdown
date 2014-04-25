Locale
======

Locales are used in Linux to define which language the user uses. As the
locales define the character sets being used as well, setting up the
correct locale is especially important if the language contains
non-ASCII characters.

Locale names are defined using the following format:

    <lang>_<territory>.<codeset>[@<modifiers>]

Contents
--------

-   1 Enabling necessary locales
    -   1.1 US English example
-   2 Setting the locale system-wide
-   3 Setting fallback locales
-   4 Setting per user locale
-   5 Setting collation
-   6 Setting the first day of the week
-   7 Troubleshooting
    -   7.1 My terminal doesn't support UTF-8
        -   7.1.1 Xterm doesn't support UTF-8
        -   7.1.2 Gnome-terminal or rxvt-unicode doesn't support UTF-8
        -   7.1.3 Changed everything and my GNOME is still using wrong
            language?
-   8 See also

Enabling necessary locales
--------------------------

Before a locale can be used on the system, it has to be enabled first.
To list all available locales, use:

    $ locale -a

To enable a locale, uncomment the name of the locale in the file
/etc/locale.gen. This file contains all the available locales that can
be used on the system. Revert the process to disable a locale. After the
necessary locales are enabled, the system needs to be updated with the
new locales:

    # locale-gen

To display the locales currently in use, use:

    $ locale

Tip: Though it's most likely that just one language is used on your
computer, it can be helpful or even necessary to enable other locales as
well. If you're running a multi-user system with users that do not speak
English, their individual locale should at least be supported by your
system.

> US English example

First uncomment the following locales in /etc/locale.gen:

    /etc/locale.gen

    en_US.UTF-8 UTF-8

Then update the system as root:

    # locale-gen

Setting the locale system-wide
------------------------------

To define the system-wide locale used on the system, set LANG in
/etc/locale.conf.

locale.conf contains a new-line separated list of environment variable
assignments: besides LANG, it supports all the LC_* variables, with the
exception of LC_ALL.

Note:/etc/locale.conf does not exist by default and must be created
manually.

Tip: If the output of locale is to your liking during installation, you
can save a little time by doing:  # locale > /etc/locale.conf while
chrooted.

    /etc/locale.conf

    LANG="en_US.UTF-8"

An advanced example configuration would be:

    /etc/locale.conf

    # Enable UTF-8 with Australian settings.
    LANG="en_AU.UTF-8"

    # Keep the default sort order (e.g. files starting with a '.'
    # should appear at the start of a directory listing.)
    LC_COLLATE="C"

    # Set the short date to YYYY-MM-DD (test with "date +%c")
    LC_TIME="en_DK.UTF-8"

You can set the default locale in locale.conf also using localectl, for
example:

    # localectl set-locale LANG="de_DE.UTF-8"

See man 1 localectl and man 5 locale.conf for details.

They will take effect after rebooting the system and will be set for
individual sessions at login.

Setting fallback locales
------------------------

Programs which use gettext for translations respect the LANGUAGE option
in addition to the usual variables. This allows users to specify a list
of locales that will be used in that order. If a translation for the
preferred locale is unavailable, another from a similar locale will be
used instead of the default. For example, an Australian user might want
to fall back to British rather than US spelling:

    ~/.bashrc

    export LANGUAGE="en_AU:en_GB:en"

or system-wide:

    /etc/locale.conf

    LANG="en_AU"
    LANGUAGE="en_AU:en_GB:en"

Setting per user locale
-----------------------

As we mentioned earlier, some users might want to define a different
locale than the system-wide locale.

The script /etc/profile.d/locale.sh overrides the system-wide locale
with the one found in ~/.config/locale.conf. This file does not exist by
default.

    ~/.config/locale.conf

    LANG="de_DE.UTF-8"
    LANGUAGE="de_DE.UTF-8"

Setting collation
-----------------

Collation, or sorting, is a little different. Sorting is a goofy beast
and different locales do things differently. To get around potential
issues, Arch used to set LC_COLLATE="C" in /etc/profile. However, this
method is now deprecated. To enable this behavior, simply add the
following to /etc/locale.conf:

    /etc/locale.conf

    LC_COLLATE="C"

Now the ls command will sort dotfiles first, followed by uppercase and
lowercase filenames. Note that without a LC_COLLATE setting, locale
aware apps sort by LC_ALL or LANG, but LC_COLLATE settings will be
overridden if LC_ALL is set. If this is a problem, ensure that LC_ALL is
not set by adding the following to /etc/profile instead:

    /etc/profile

    export LC_ALL=

Note that LC_ALL is the only LC_* variable, which cannot be set in
/etc/locale.conf.

Setting the first day of the week
---------------------------------

In many countries the first day of the week is Monday. To adjust this,
change or add the following lines in
/usr/share/i18n/locales/<your_locale>:

    /usr/share/i18n/locales/<your_locale>

    LC_TIME
    ...
    week            7;19971130;5
    first_weekday   2
    first_workday   2

And then update the system:

    # locale-gen

Troubleshooting
---------------

> My terminal doesn't support UTF-8

Unfortunately some terminals do not support UTF-8. In this case, you
have to use a different terminal. Here are some terminals that have
support for UTF-8:

-   vte-based terminals
-   gnustep-terminal
-   konsole
-   mlterm
-   rxvt-unicode
-   xterm

Xterm doesn't support UTF-8

xterm only supports UTF-8, if ran as uxterm or xterm -u8.

Gnome-terminal or rxvt-unicode doesn't support UTF-8

You need to launch these applications from a UTF-8 locale or they will
drop UTF-8 support. Enable the en_US.UTF-8 locale (or your local UTF-8
alternative) per the instructions above and set it as the default
locale, then reboot.

Changed everything and my GNOME is still using wrong language?

Some GUI tools use ~/.pam_environment as a place where environment
variables are defined. GNOME reads this file.

See also
--------

-   Gentoo Linux Localization Guide
-   Gentoo Wiki Archives: Locales
-   ICU's interactive collation testing
-   Free Standards Group Open Internationalisation Initiative
-   The Single UNIX Specification definition of Locale by The Open Group
-   Locale environment variables

Retrieved from
"https://wiki.archlinux.org/index.php?title=Locale&oldid=305289"

Category:

-   Internationalization

-   This page was last modified on 17 March 2014, at 07:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
