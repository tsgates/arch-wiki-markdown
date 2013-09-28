Freeswitch
==========

The FreeSWITCH telephony engine is a powerful system enabling voice,
video, presence, chat, and other media types via a variety of protocols.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Configuring                                                        |
| -   3 Running                                                            |
| -   4 Testing                                                            |
| -   5 Hints                                                              |
+--------------------------------------------------------------------------+

Installing
----------

The 'release' version freeswitch and the git version freeswitch-git are
available in the AUR. The following instructions assume you are using
the freeswitch-git package.

Also, you may wish to configure FreeSWITCH build options. Edit the
PKGBUILD and change any BUILD CONFIGURATION options to suit your desired
usage.

Note:Editing the PKGBUILD will configure both modules.conf and
autoload_configs/modules.conf.xml according to the modules listed in
ENABLED_MODULES and DISABLED_MODULES.

Configuring
-----------

The FreeSWITCH configuration files with the custom modules.conf and
modules.conf.xml reside in /etc/freeswitch. For following FreeSWITCH
documentation, the base directory is /var/lib/freeswitch (generallly
seen as /usr/local/freeswitch in FreeSWITCH documentation).

FreeSWITCH comes out of the box with a default password for
registrations to users 1000-1019 as '1234'. You are advised to change
this before running it. This variable is set in
/etc/freeswitch/vars.xml. The overall default configuration given is a
kitchen sink featured PBX, likely many more things than are typically
used. Customizing the PBX (or non-PBX) features of FreeSWITCH is beyond
the scope of this document; see the FreeSWITCH Wiki for in-depth
documentation.

Upstream documentation as well as the original conf/ directory are
provided in /usr/share/doc/freeswitch.

Running
-------

Startup options are configured in /etc/conf.d/freeswitch.conf. You may
wish to add -nonat if you are not behind nat, see freeswitch --help for
a full list of command line options.

FreeSWITCH can be started with

    rc.d start freeswitch

To start FreeSWITCH upon each boot, add "freeswitch" to DAEMONS in
/etc/rc.conf if using the default archlinux default init system. If
using Systemd or Runit, add to your running service via their provided
methods. You'll need to use the -nc and -nf options to the freeswitch
command line to keep it running in the foreground as supervisors expect.

Testing
-------

-   Fire up a SIP Client
-   Register to your FreeSWITCH box as user 1000, password what you set
    as default_password in vars.xml
-   Dial 9196 (You should connect to an Echo Test)

Hints
-----

To see interesting things you can do with a dialplan, open up
/etc/freeswitch/dialplan/default.xml and scroll through those examples.
Dialing the numbers that match the 'expression' of a condition from your
SIP client will demonstrate their use.

You can dial into the FreeSWITCH public voice conference, for instance,
by dialing 9888 (8k codec), 91616 (16k codec), or 93232 (32k codec)

FreeSWITCH support is available in #freeswitch on Freenode

Retrieved from
"https://wiki.archlinux.org/index.php?title=Freeswitch&oldid=207224"

Categories:

-   Audio/Video
-   Telephony and Voice
