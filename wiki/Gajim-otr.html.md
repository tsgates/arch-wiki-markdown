Gajim-otr
=========

  
 OTR (off-the-record) encryption is strong end-to-end encryption
protocol for instant messaging (read more). OTR hasn't any XMPP XEP,
because OTR is of cross-protocol nature.

And Gajim is a powerful XMPP-client without OTR support out-of-the-box.

Contents
--------

-   1 Gajim >= 0.15 (or gajim-hg)
-   2 Installation
-   3 Configuration
-   4 Troubleshooting

Gajim >= 0.15 (or gajim-hg)
---------------------------

Since version 0.15, Gajim has powerful plugin system. The gotr plugin is
used to provide OTR encryption, and it depends on python-potr, the
modern OTR protocol implementation written on python by Kjell Bradden.

Installation
------------

To install the plugin follow these simple steps:

1.  Install aur:pure-python-otr-git;
2.  Install/update the gajim plugins from hg.
    1.  To go through next steps, you need mercurial (a popular DVCS)
        installed:

            $ sudo pacman -S mercurial

    2.  Go to gajim plugins directory:

            $ mkdir -p ~/.local/share/gajim/plugins/; cd ~/.local/share/gajim/plugins/

    3.  (at first time) Download all plugins:

            $ hg clone http://hg.gajim.org/gajim-plugins/ .

    4.  (at next times) Update plugins to newer versions:

            $ hg pull; hg up; rm -f */*.pyo

3.  [Re]Start gajim;

Configuration
-------------

At first time, you also need to activate OTR plugin:

1.  Go to menu Edit => Modules;
2.  Activate the "Off-the-record encryption" plugin;
3.  Click on plugin settings button;
4.  Generate your OTR key using "Generate key";
5.  Take a look on other settings;
6.  Close dialogs to save the changes.

Troubleshooting
---------------

Q: "Off-the-record encryption" is not shown in Modules.

A: Be sure, that ~/.local/share/gajim/plugins/gotr/ is not empty and
python-potr installed on latest version.

Q: There are no Modules item in gajim menu.

A: Go to Help => About. The gajim version should be 0.15 or something
like 0.14.0.1-b9cb32f5badd, where "b9cb32f5badd" is any commit id, if
gajim-hg is used. If not, update gajim as said earlier.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gajim-otr&oldid=302636"

Categories:

-   Internet applications
-   Security

-   This page was last modified on 1 March 2014, at 04:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
