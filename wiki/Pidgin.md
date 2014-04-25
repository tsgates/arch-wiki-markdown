Pidgin
======

From the project home page:

Pidgin is an easy to use and free chat client used by millions. Connect
to AIM, MSN, Yahoo, and more chat networks all at once.

Contents
--------

-   1 Installation
-   2 Spellcheck
-   3 Sound fix
-   4 Browser error
-   5 QIP encoding bug
-   6 ICQ
-   7 IRC
-   8 Xfire
-   9 Web QQ
-   10 Facebook XMPP
-   11 Privacy
    -   11.1 Pidgin-OTR
    -   11.2 Pidgin-Encryption
    -   11.3 Pidgin-GPG
-   12 Sametime protocol
    -   12.1 Official repositories package
    -   12.2 AUR package
-   13 SIP/Simple protocol for Live Communications Server 2003/2005/2007
-   14 Other packages
-   15 Skype plugin
-   16 Auto logout on suspend
-   17 Troubleshooting
    -   17.1 Installing Pidgin after a Carrier installation
-   18 History import Kopete to Pidgin
-   19 Microphone
-   20 See also

Installation
------------

Install pidgin, available in the official repositories. Notable variants
are:

-   Pidgin Light — Light Pidgin version without GStreamer, Tcl/Tk,
    XScreenSaver, video/voice support.

http://pidgin.im/ || pidgin-light

You may also want to install additional plugins from the
purple-plugin-pack.

Spellcheck
----------

Aspell will be installed as a dependency, but to prevent all of your
text from showing up as incorrect you will need to install an aspell
dictionary like aspell-en. Use pacman -Ss aspell to list available
languages.

If spell checking doesn't work try running aspell separately to check
that it is setup correctly and doesn't spit out a helpful error message.

    $ echo center | aspell -a

Note:The switch spell plugin is included in the purple-plugin-pack. It
allows you to switch between multiple languages.

Sound fix
---------

To have event sounds working, install the gstreamer0.10-good package.
Alternatively, in the "Sounds" preferences tab, the method can be set to
'command' and one of the following sound commands used.

After configuring ALSA:

    $ aplay %s

If using OSS:

    $ ossplay %s

And for PulseAudio:

    $ paplay %s

Browser error
-------------

If clicking a link within Pidgin creates an error message about trying
to use 'sensible-browser' to open a link, try editing
~/.purple/prefs.xml. Find the line referencing 'sensible-browser' and
change it to this:

    <pref name='command' type='path' value='firefox'/>

This example assumes you use Firefox.

QIP encoding bug
----------------

There is another bug in character encoding when communicating between
Pidgin and QIP, which especially affects Czech language, but there are
also other languages affected. There are two possible solutions. The
better one is to upgrade from QIP to QIP 2012 or QIP Infium, second
solution is to install and enable plugin from pidgin-qip-decoder package
currently available from AUR.

ICQ
---

You can change encoding for ICQ account if encoding in Buddy Information
is not correct:

    Account > your ICQ account > Edit account > Advanced tab

Select Encoding: CP1251 (for Cyrillic).

IRC
---

This is a small tutorial for connecting to Freenode. It should work for
other IRC networks as long as you substitute the port numbers and other
specific settings.

Go to Accounts > Manage Accounts > Add. Fill/select the following
options:

    Protocol: IRC
    Username: your username

Now go to Buddies > New instant message (or hit Ctrl+m), fill
'freenode.net' in the textbox and username@irc.freenode.net, then click
'Ok'. Type:

    /join #archlinux

The channel is irrelevant.

In order to register your nick, type:

    /msg nickserv register password email-addres

Follow the instructions from the registration mail. For further help
type:

    /msg nickserv help
    /msg nickserv help command

This final step will add your channel to 'Buddies': go to Buddies > Add
chat, fill the correct channel in the textbox named channel
(#archlinux).

Xfire
-----

Simply install pidgin-gfire and then add a new account, selecting xfire
as protocol.

Web QQ
------

Simply install pidgin-lwqq and then add a new account, selecting webQQ
as the protocol. QQ is a proprietary chat protocol/IM service mainly
used in Asia, particularly China.

Facebook XMPP
-------------

Since Facebook Chat supports XMPP, you can use Pidgin without extra
plugins. See this article for more information: Facebook Chat Now
Available Everywhere

Note:In order to utilise Facebook chat through XMPP and pidgin, you will
require a Facebook "username". This is located in Facebook > Account
settings > username (below real name)

1. Go to "Accounts" and select "Manage Accounts."

2. On the Basic tab, enter the following info:

Protocol: XMPP

Username: Your FacebookID (without e-mail domain, e.g. @yahoo.com, etc)

Domain: chat.facebook.com (make sure you haven't typed any extra space)

Resource: Pidgin (leave this empty if you get
"username@chat.facebook.com/Pidgin Not Authorized" error message)

Password: Your Password

Local alias: Your Name

3. Click the Advanced tab, then enter the following info:

Connect port: 5222

Connect server: chat.facebook.com (make sure you haven't typed any extra
space)

(Uncheck the box labeled "Require SSL/TLS")

> Note:

-   Newer versions of Pidgin do not have a "Require SSL/TLS" box.
    Instead, select "Use encryption if available" from the Connection
    Security dropdown in Advanced
-   Changing your Facebook privacy settings to "Turn off all apps"
    (under Apps and Websites), will disable your ability to send
    messages via jabber. (see Why can't Pidgin seem to send Facebook
    messages)
-   You may notice that all Facebook contacts are in a separate group
    every time you login with your XMPP account even though you moved
    them to other groups or created meta-contacts. If you want to be
    able to group contacts and create meta-contacts you can use the
    plugin available here: pidgin-xmpp-ignore-groups (after installing
    the plugin activate the option Ignore server-sent groups on the
    Advanced tab in your XMPP account settings). It essentially ignores
    the group data sent by the server roaster and preserves your local
    changes. It is easier to enable this plugin on your account before
    logging in the first time, so your contacts are put into the default
    group instead of a group called "Facebook Friends". Enabling it
    afterward won't move the contacts out of this group.

Privacy
-------

Pidgin has some privacy rules set by default. Namely, the whole world
cannot send you messages; only your contacts or people selected from a
list. Adjust this, and other settings through:

    Tools > Privacy

> Pidgin-OTR

This is a plugin that brings Off-The-Record (OTR) messaging to Pidgin.
OTR is a cryptographic protocol that will encrypt your instant messages.

First you need to install pidgin-otr from the official repositories.
Once this has been done, OTR has been added to Pidgin.

1.  To enable OTR, start Pidgin and go to Tools > Plugins or press
    Ctrl+u. Scroll down to the entry entitled "Off-The-Record
    Messaging". If the checkbox beside it is not checked, check it.
2.  Next, click on the plugin entry and select "Configure plugin" at the
    bottom. Select which account you wish to generate a key for, then
    click "Generate". You will have now generated a private key. If you
    are not sure what the other options do, leave them, the default
    options will work fine.
3.  The next step is to contact a buddy who also has OTR installed. In
    the chat window, a new icon should appear to the top right of your
    text input box. Click on it, and select "Start private
    conversation". This will start an 'Unverified' session. Unverified
    sessions are encrypted, but not verified - that is, you have started
    a private conversation with someone using your buddy's account who
    has OTR, but who might not be your buddy. The steps for verification
    of a buddy are beyond the scope of this section; however, they might
    be added in the future.

> Pidgin-Encryption

pidgin-encryption transparently encrypts your instant messages with RSA
encryption. Easy-to-use, but very secure.

You can enable it the same way as Pidgin-OTR.

Now you can open conversation window and new icon sould appear beside
menu. Press it to enable or disable encryption. Also if you want to make
encryption enabled by default right-click on a buddy's name (in your
buddy list), and select Turn Auto-Encrypt On. Now, whenever a new
conversation window for that buddy is opened, encryption will start out
as enabled.

> Pidgin-GPG

Pidgin-GPG transparently encrypt conversations using GPG, and taking
advantage of all the features of a pre-existing WoT.

The plugin is available on AUR as pidgin-gpg. It is enable in the same
way as the previously mentioned ones.

Sametime protocol
-----------------

Sametime support is not available in the default version of Arch Linux's
Pidgin package. This section will demonstrate how to enable this feature
via AUR and the 'Meanwhile' plugin. This section assumes that you are
familiar with using the AUR and that you are performing the following
commands in ~/builds directory.

First install meanwhile from the AUR.

Now you have to rebuild your installed version of Pidgin with Sametime
support: the procedure is different depending on whether you have Pidgin
from the official repositories or from a package in AUR.

> Official repositories package

Make sure you have installed the Arch Build System and downloaded the
ABS tree.

Now copy the pidgin directory of ABS to ~/builds:

    $ cp -r /var/abs/extra/pidgin ~/builds

Go to ~/builds/pidgin and edit the PKGBUILD file. Go to the build()
section and make sure you remove the --disable-meanwhile line from the
configure options.

Make the package:

    $ makepkg -s

Install first the libpurple package, then pidgin package.

Tip:If using pacman, the -U switch let you install local packages.

Pidgin now has the 'Sametime' protocol as an option when creating
accounts.

> AUR package

Download and extract your Pidgin package from AUR (this example will use
pidgin-gnome, change to preference):

    $ cd ~/builds && wget https://aur.archlinux.org/packages/pidgin-gnome/pidgin-gnome.tar.gz && tar xfvz pidgin-gnome.tar.gz

Change into the extracted directory:

    $ cd pidgin-gnome

In order to have 'Sametime' support you must remove the following from
PKGBUILD

    --disable-meanwhile

Build the package:

    $ makepkg -s

Install the package pidgin-gnome as root.

Pidgin now has the 'Sametime' protocol as an option when creating
accounts.

SIP/Simple protocol for Live Communications Server 2003/2005/2007
-----------------------------------------------------------------

The pidgin-sipe plugin is available from AUR.

Other packages
--------------

Arch has other Pidgin-related packages. Here are the most popular (for a
thorough list, search the AUR):

-   pidgin-libnotify - Libnotify support, for theme-consistent
    notifications
-   guifications - Toaster-style popup notifications
-   microblog-purple - Libpurple plug-in supporting microblog services
    like Twitter
-   pidgin-latex - A small latex plugin for pidgin. Put math between $$
    and have it rendered (recepient also needs to have this installed)

Skype plugin
------------

Install skype4pidgin from the AUR.

Auto logout on suspend
----------------------

If you suspend your computer pidgin seems to stay connected for about 15
minutes. To prevent message loss, it is needed to set your status
offline before suspending or hibernating. The status message won't be
changed.

Therefor create a new systemd unit pidgin-suspend in /etc/systemd/system
Take the following snippet and replace myuser with your user.

    [Unit]
    Description=Suspend Pidgin
    Before=sleep.target
    StopWhenUnneeded=yes

    [Service]
    Type=oneshot
    User=myuser
    RemainAfterExit=yes
    Environment=DISPLAY=:0
    ExecStart=-/usr/bin/purple-remote setstatus?status=offline
    ExecStop=-/usr/bin/purple-remote setstatus?status=available

    [Install]
    WantedBy=sleep.target

If you are using pm-utils, you could create a 00pidgin file in
/etc/pm/sleep.d/ instead.

    #!/bin/sh
    #
    # 00pidgin: set offline/online status

    case "$1" in
        hibernate|suspend)
            DISPLAY=:0 su -c 'purple-remote setstatus?status=offline' ''%myuser''
        ;;
        thaw|resume)
            DISPLAY=:0 su -c 'purple-remote setstatus?status=available' ''%myuser''
        ;;
        *) exit $NA
        ;;
    esac

Troubleshooting
---------------

-   If Facebook XMPP verification does not work for you, there a package
    in the aur pidgin-facebookchat which does not require a unique user
    name (you may login with an email address)

-   The facebookchat plugin will prompt for varification (enter these
    two words...), if that fails, hit cancel and log onto Facebook with
    pidgin open, this will configre the plugin's security setting)

> Installing Pidgin after a Carrier installation

If you previously installed carrier (aka FunPidgin), follow these steps
before installing Pidgin:

-   Quit Carrier
-   Delete your ~/.purple directory.

Warning:This will remove all your user settings for any programs that
use libpurple, i.e. Pidgin, Carrier, etc.

    rm -r ~/.purple

-   Uninstall carrier and libpurple.
-   Install pidgin and libpurple.

History import Kopete to Pidgin
-------------------------------

-   Install xalan-c and create ~/bin/history_import_kopete2pidgin.sh
    with this code:

    #!/bin/sh

    KOPETE_DIR=~/.kde4/share/apps/kopete/logs
    PIDGIN_DIR=~/.purple/logs
    CURRENT_DIR=~/bin

    cd

    if [ ! -d $KOPETE_DIR ];then
        echo "Kopete log directory not found"
        exit 1;
    fi

    if [ ! -d $PIDGIN_DIR ];then
        echo "Pidgin log directory not found"
        exit 2;
    fi

    for KOPETE_PROTODIR in $(ls $KOPETE_DIR); do
        PIDGIN_PROTODIR=$(echo $KOPETE_PROTODIR | sed 's/Protocol//' | tr [:upper:] [:lower:])
        for accnum in $(ls $KOPETE_DIR/$KOPETE_PROTODIR); do
            echo "Account number: $accnum"
            for num in $(ls $KOPETE_DIR/$KOPETE_PROTODIR/$accnum); do
                FILENAME=$(Xalan $KOPETE_DIR/$KOPETE_PROTODIR/$accnum/$num $CURRENT_DIR/history_import_kopete2pidgin_filename.xslt)
                if [ $? = 0 ]; then
                    echo "$KOPETE_DIR/$KOPETE_PROTODIR/$accnum/$num"
                    echo " -> $PIDGIN_DIR/$PIDGIN_PROTODIR/$FILENAME"
                    mkdir -p $(dirname $PIDGIN_DIR/$PIDGIN_PROTODIR/$FILENAME)
                    Xalan -o $PIDGIN_DIR/$PIDGIN_PROTODIR/$FILENAME $KOPETE_DIR/$KOPETE_PROTODIR/$accnum/$num $CURRENT_DIR/history_import_kopete2pidgin.xslt
                fi
            done
        done
    done

-   Make ~/bin/history_import_kopete2pidgin.sh executable:

    chmod +x ~/bin/history_import_kopete2pidgin.sh

-   Create ~/bin/history_import_kopete2pidgin.xslt with this code:

    <?xml version="1.0"?>
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output method="text" indent="no" />

        <xsl:template match="kopete-history">
            <xsl:apply-templates select="msg"/>
        </xsl:template>

        <xsl:template match="msg">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="translate(substring-after(@time,' '),':',',')"/>
            <xsl:text>) </xsl:text>
            <xsl:value-of select="@nick"/>
            <xsl:if test="not(@nick) or @nick = ">
                <xsl:value-of select="@from"/>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="."/>
    		<xsl:text>
    </xsl:text>
        </xsl:template>
    </xsl:stylesheet>
    </nowiki>

-   Create ~/bin/history_import_kopete2pidgin_filename.xslt with this
    code:

    <?xml version="1.0"?>
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output method="text" indent="no" />

        <xsl:template match="kopete-history">
            <xsl:value-of select="head/contact[@type = 'myself']/@contactId"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="head/contact[not(@type)]/@contactId"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="head/date/@year"/>
            <xsl:text>-</xsl:text>
            <xsl:if test="head/date/@month &lt; 10">0</xsl:if>
            <xsl:value-of select="head/date/@month"/>
            <xsl:text>-</xsl:text>
            <xsl:if test="string-length(substring-before(msg[1]/@time,' ')) &lt; 2">0</xsl:if>
            <xsl:value-of select="translate(msg[1]/@time,' :','.')"/>
            <xsl:text>+0200EET.txt</xsl:text>
        </xsl:template>
    </xsl:stylesheet>

-   Execute the command in the shell:

    ~/bin/history_import_kopete2pidgin.sh

Microphone
----------

For the microphone to work out of GNOME, you must install gnome-media
then run and configure gstreamer-properties.

See also
--------

-   Pidgin homepage
-   History import Kopete to Pidgin

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pidgin&oldid=302650"

Categories:

-   Internet applications
-   Internet Relay Chat

-   This page was last modified on 1 March 2014, at 04:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
