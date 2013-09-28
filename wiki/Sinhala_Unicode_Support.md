Sinhala Unicode Support
=======================

This page explains how to get the Sinhala unicode support and sinhala
unicode input to work using ibus (sayura-ibus) or scim (sayura-scim).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Sinhala Unicode Font                                               |
| -   2 Guide to install Sinhala Unicode Font                              |
| -   3 Enabling Sinhala Locale                                            |
| -   4 Sinhala Unicode Input Support                                      |
|     -   4.1 sayura-ibus                                                  |
|     -   4.2 sayura-scim                                                  |
|     -   4.3 scim configuration                                           |
|                                                                          |
| -   5 Further Reading and More Information                               |
+--------------------------------------------------------------------------+

Sinhala Unicode Font
--------------------

Install ttf-lklug from the AUR.

Guide to install Sinhala Unicode Font
-------------------------------------

Download and Install lklug.ttf Sinhala Unicode font file

    sudo pacman -S wget
    sudo wget -P /usr/share/fonts http://sinhala.sourceforge.net/files/lklug.ttf

Then Run the following command

    fc-cache -fv

And proceed to the below steps..

Enabling Sinhala Locale
-----------------------

Edit /etc/locale.gen. Uncomment following line

    si_LK UTF-8

Run following program

    locale-gen

Immediately you'll be able to read Sinhala Unicode in your programs (If
not You may need to restart the relavent programs. eg: Firefox)

Sinhala Unicode Input Support
-----------------------------

> sayura-ibus

Install ibus-sayura from the AUR. For more information about see Ibus
Article

> sayura-scim

Install scim-sayura from the AUR.

> scim configuration

More about scim can be found here. To enable scim add following lines to
/etc/profile

    export XMODIFIERS=@im=SCIM
    export GTK_IM_MODULE="scim"
    export QT_IM_MODULE="scim"

Further Reading and More Information
------------------------------------

-   sinhala linux - Official Homepage
-   sayura-scim - Official Homepage
-   LKLUG - Lanka Linux User Group (Sinhala Linux Mailing List)
-   Sinhala Unicode Group (සිංහල යුනිකෝඩ් සමූහය)
-   Enabling Unicode Sinhala in GNU/Linux HOWTO

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sinhala_Unicode_Support&oldid=252648"

Category:

-   Internationalization
