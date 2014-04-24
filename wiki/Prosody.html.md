Prosody
=======

Prosody (pronunciation: 1, 2) is an XMPP server written in the Lua
programming language. Prosody is designed to be lightweight and highly
extensible. It is licensed under a permissive MIT license. Prosody is
available for Arch Linux in the Community repository with some optional
dependencies available from the Arch User Repository.

Previous experience with building and installing packages from the AUR
and basic knowledge of XMPP will be very helpful when following the
guide. As per usual, when command line commands are provided, lines
preceded by $ indicate that the command may be run as a regular user,
while lines preceded by # indicate that the command must be run as root.

Contents
--------

-   1 Installation
    -   1.1 Optional Dependencies
-   2 Configuration
    -   2.1 Logging
-   3 Operation
    -   3.1 Security
        -   3.1.1 User Registration
        -   3.1.2 Stream Encryption
    -   3.2 Listing Users
-   4 Removal
-   5 Tips & Tricks
    -   5.1 Components
        -   5.1.1 Multi-User Chat
    -   5.2 Prosody Modules
    -   5.3 Console
-   6 Troubleshooting
-   7 Development
-   8 Communication
-   9 See also

Installation
------------

Prosody is available in the Community repository, and is straightforward
to install via pacman:

# pacman -S prosody

> Optional Dependencies

Prosody has optional depedencies that although not strictly required for
its operation, provide useful features. These dependencies may also have
to be built and installed from the AUR. If you are unfamiliar with how
to build and install packages from the AUR please see this tutorial.

 TLS/SSL Support (Recommended) 
    Allow Prosody to encrypt streams to prevent eavesdropping.  
    Requires: lua51-sec (Community)

 Better Connection Scaling (Recommended) 
    Allow Prosody to use libevent to handle a greater number of
    simultaneous connections.  
    Requires: lua51-event (AUR)

 Stream Compression 
    Allow Prosody to compress client-to-server streams for compatible
    clients to save bandwidth.  
    Requires: lua51-zlib (Community)

 Cyrus SASL Support 
    Allow Prosody to use the Cyrus SASL library to provide
    authentication.  
    Requires: lua-cyrussasl (AUR)

Configuration
-------------

Note:The posix module and pidfile setting contained in the default
configuration file are required for Prosody's proper operation on Arch
Linux. Please do not disable or alter them.

The main configuration file is located at /etc/prosody/prosody.cfg.lua,
information on how to configure Prosody can be found in Prosody's
documentation. The syntax of the configuration file can be checked after
any changes are made by running:

$ luac -p /etc/prosody/prosody.cfg.lua

No output means the syntax is correct.

> Logging

The Arch Linux Prosody package is pre-configured to log to syslog. Thus,
by default, Prosody log messages are available in the systemd journal.

Operation
---------

You can start Prosody through the included Systemd script:

# systemctl start prosody

To automatically start Prosody at boot execute:

# systemctl enable prosody

Prosody uses the default XMPP ports, 5222 and 5269, for client-to-server
and server-to-server communications respectively. Configure your
firewall as necessary.

You can manipulate Prosody users by using the prosodyctl program. To add
a user:

# prosodyctl adduser <JID>

Tip:You will likely want to make at least one user an administrator by
adding their Jabber ID to the admins list in the configuration file.

Issue man prosodyctl to see the man page for prosodyctl.

> Security

User Registration

Prosody supports XMPP's in-band registration standard, which allows
users to register with an XMPP client from within their client and
change their passwords. While this is convenient for users it does not
allow administrators to moderate the registration of new users. As such,
the register module is enabled in the default configuration but
allow_registration is set to false. This allows existing users to change
their passwords from within their client but does not allow new users to
register themselves.

Tip:If you do decide to support new in-band registrations, you will
likely find the watchregistrations and welcome modules useful.

Stream Encryption

Prosody can utilize TLS certificates to encrypt client-to-server
communications (if the proper dependencies are installed). See the
relevant sections of prosody.cfg.lua to configure Prosody to utilize
these certificates.

To require encryption for client-to-server communications add the
following to your configuration file:

    /etc/prosody/prosody.cfg.lua

    Host "*"

        c2s_require_encryption = true

  
 Similarly, for server-to-server communications you may do:

    /etc/prosody/prosody.cfg.lua

    Host "*"

        s2s_require_encryption = true

While requiring client-to-server encryption is generally a good idea,
please keep in mind that some popular XMPP services such as Google
Talk/Gmail do not support server-to-server encryption.

> Listing Users

A simple way to see a list of the registered users is

    # ls -l /var/lib/prosody/*/accounts/*

alternatively, you can download the module mod_listusers.lua, and use it
as

    # prosodyctl mod_listusers

Removal
-------

Prosody and all its (required) dependencies can be removed using pacman:

# pacman -Rs prosody

Check above for optional dependencies that may also be removed.

Prosody may leave the following directories on your filesystem that you
may want to remove if you do not plan on reinstalling Prosody:
/etc/prosody and /var/lib/prosody.

Tips & Tricks
-------------

> Components

Prosody supports XMPP components, which provide extra services to
clients. Components are either provided internally by special Prosody
modules or externally using the protocol specified in XEP-0114.

Note:Components must use a different hostname from the VirtualHosts
defined in prosody.cfg.lua. Attempting to host a component on the same
hostname as a defined VirtualHost will result in errors.

By default, Prosody will listen for external components. If you do not
plan to use any external components with Prosody you can disable this
behavior by adding the following your configuration:

    /etc/prosody/prosody.cfg.lua

    component_ports = {}

Multi-User Chat

A common component used with XMPP servers is Multi-User Chat (MUC),
which allows conferences between multiple users. MUC is provided as an
internal component with Prosody. To enable MUC add the following to your
configuration file:

    /etc/prosody/prosody.cfg.lua

    Component "conference.example.com" "muc"

This will enable the MUC component on host conference.example.com.

> Prosody Modules

Prosody Modules is a collection of extra modules not distributed with
Prosody. These modules are in various states of development from highly
experimental to relatively stable. You should consult a given module's
wiki page for more information. An example of an extra module is
pastebin, which when loaded will intercept long messages (for example,
log file output) and replace them with a link to a pastebin hosted using
Prosody's internal HTTP server (provided by the core module,
httpserver).

To use an extra module download its raw file(s) from the source browser
(when viewing a file, search for the link "View raw file").
Alternatively and likely easier, use Mercurial to clone the entire
repository:

$ hg clone https://prosody-modules.googlecode.com/hg/ prosody-modules

Now you can copy the module (and any additional files it needs) to
Prosody's module directory at /usr/lib/prosody/modules. To enable the
module add it to your modules_enabled list in your prosody.cfg.lua for
the host or component you wish to use it for. For example, to use the
pastebin module on a MUC component:

    /etc/prosody/prosody.cfg.lua

    Component "conference.example.com" "muc"
        modules_enabled = { "pastebin" }

Note:An enforced Prosody convention is that modules are named
mod_foo.lua but simply enabled by adding foo to the modules_enabled
list.

> Console

Warning:The console does not require any authentication so any user on a
multi-user system can connect and issue commands on the console.
Therefore it is not recommended to enable the console module on a
multi-user system.

The console module provides a telnet console from which administrative
operations and queries can be performed. You can connect to the console
by issuing:

$ telnet localhost 5582

You of course need the telnet program provided by the inetutils package.
Use the help command in the console to get usage help.

The console even allows you to execute Lua commands directly on the
server by preceding a command with >. For example to see if a client
connection is compressed:

> full_sessions["romeo@montague.lit/Resource"].compressed

Will return true if the connection is compressed or nil if it is not.

Troubleshooting
---------------

One of Prosody's primary design principles is to be simple to use and
configure. However, issues can still arise (and likely will as is the
case with any complex software). If you encounter a problem there are a
variety of steps you can take to narrow down the cause:

-   Check for known issues  
    Look at the release notes for your Prosody version to see if your
    issue is listed as a known issue. Also check the issue tracker to
    see if your issue has already been reported.
-   Check configuration syntax  
    Run luac -p /etc/prosody/prosody.cfg.lua to check for any syntax
    errors in your configuration file. If there is no output your syntax
    is fine.
-   Check the log  
    Errors are only logged if there is a critical problem so always
    address those issues. If you think you have a very low level issue
    (like protocol compatibility between clients and servers with
    Prosody) then you can enable the very verbose debug level logging.
-   Check permissions  
    The Prosody package should add a new prosody user and group to your
    system and set appropriate permissions, but it is always good to
    double check. Ensure that /etc/prosody and /var/lib/prosody are
    owned by the prosody user and that the user has appropriate
    permissions to read and write to those paths and all contained
    files.
-   Check listening ports  
    When troubleshooting connection issues make sure that Prosody is
    actually listening for connections. You may do so by running ss -tul
    and making sure that xmpp-client (port 5222) and xmpp-server (port
    5269) are listed.
-   Restart  
    Like most things, it doesn't hurt to restart Prosody
    (systemctl restart prosody) to see if it resolves an issue.

If you're unable to resolve your issue yourself there are a variety of
resources you can use to seek help. In order of immediacy with which
you'll likely receive help:

1.  XMPP Conference: prosody@conference.prosody.im
2.  Mailing List: Web Interface, Email
3.  Arch Forums (for package issues)

Development
-----------

Two development packages are maintained for Prosody in the AUR,
prosody-devel and prosody-hg]. prosody-devel tracks the latest source
release of a development version (alpha, beta, release candidate) and
will actually be behind the stable version if a final version of the
development version is released. prosody-hg tracks the Mercurial
repository tip for Prosody and will always contain the latest code as it
is checked in. Both packages are built similarly to the stable package.

Communication
-------------

-   Mailing Lists: prosody-dev, prosody-users
-   Conference: prosody@conference.prosody.im
-   Blog: Prosodical Thoughts

See also
--------

-   Official documentation
-   Prosodical Thoughts (Blog)
-   Issue Tracker
-   Prosody Modules (Extra Modules)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Prosody&oldid=302651"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
