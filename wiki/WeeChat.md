WeeChat
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary

WeeChat is a highly extendable and feature rich IRC Client currently
under heavy development.

Alternative Clients

irssi

XChat

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Running WeeChat                                                    |
| -   3 Configuration                                                      |
|     -   3.1 Internal commands                                            |
|     -   3.2 Internal menu-based                                          |
|     -   3.3 Configuration Files                                          |
|                                                                          |
| -   4 Connecting to a server                                             |
| -   5 Creating a Server profile                                          |
| -   6 Configuring SSL                                                    |
| -   7 Tips and Tricks                                                    |
|     -   7.1 Upgrading                                                    |
|     -   7.2 Aliases                                                      |
|     -   7.3 Key Bindings                                                 |
|     -   7.4 SSH connection lost when idle                                |
|                                                                          |
| -   8 Getting Help                                                       |
| -   9 External Links                                                     |
| -   10 Guides                                                            |
+--------------------------------------------------------------------------+

Installing
----------

WeeChat is available in the [extra] repo. Install by running:

    # pacman -S weechat

There is also weechat-git in the AUR, install with your favorite AUR
Helper or makepkg.

Running WeeChat
---------------

WeeChat is going to have multiple interfaces at some point, run
weechat-[interface] to start WeeChat.

As WeeChat currently only has a Ncurses interface the command to start
WeeChat is:

    $ weechat-curses

Configuration
-------------

You can configure WeeChat in 3 ways: using WeeChat's internal commands;
using iset; or by editing the .conf files directly. WeeChat will
automatically save settings on exit, so if you are editing a .conf file
in an editor, be sure to run /reload from the console before exiting,
otherwise your changes will be lost.

> Internal commands

You can get a list of all configurable options by typing /set in the
weechat buffer window. Since there are nearly 600 default configurable
options, you can search through them with a wildcard syntax:
/set irc.server.* or /set *server* as an example. You can get help on
each option with the /help command:

    /help irc.server.freenode.autoconnect

> Internal menu-based

For a more convenient method, install the iset script. If you have
weechat 0.3.9, run:

    /script install iset.pl

In older versions, use /weeget install iset, or download iset.pl into
your ~/.weechat/perl/autoload directory manually.

Afterwards, run

    /iset

to get a buffer with all configuration options.

> Configuration Files

The .conf files for WeeChat are saved to ~/.weechat. These files are not
commented. Detailed information can be found within the program itself
(see Internally above), or WeeChat's user guide.

Connecting to a server
----------------------

You can connect to a IRC server by using /connect.

    /connect chat.freenode.net

Or if there is already a Server setup you can use:

    /connect freenode

Creating a Server profile
-------------------------

If you plan on connecting to a server more than once it may be
beneficial to create a Server.

    /server add example irc.example.net/6667

Would create the server example which would connect to irc.example.net
on port 6667

See the WeeChat documentation and /help server for more information.

Configuring SSL
---------------

Many IRC servers, including freenode where #archlinux is, support SSL.

If you're making a server with /server, add the SSL port (usually 6697)
and -ssl to the end of the line. For example:

    /server add freenode chat.freenode.net/6697 -ssl

You can do the same thing if using /connect.

    /connect chat.freenode.net/6697 -ssl

Warning:Some servers need the ssl_dhkey_size value changed to something
lower. For example, if you're using freenode you'll need to set /set
irc.server.freenode.ssl_dhkey_size 1024

Note: Different servers may have a different port than 6697 - this is
server specific.

Tips and Tricks
---------------

> Upgrading

WeeChat can be upgraded without disconnecting from the IRC servers
(non-SSL connections only):

    /upgrade

This will load the new WeeChat binary and reload the current
configuration.

> Aliases

Aliases can be created to simplify commonly executed commands. A nice
example is Wraithan's smart filter alias:

Smart Filter  
 First, we need to enable smart filters:

    /set irc.look.smart_filter "on"

Next, we will create the sfilter alias:

    /alias sfilter filter add irc_smart_$server_$channel irc.$server.$channel irc_smart_filter *

We can now type

    /sfilter

in any buffer, and the smart filter will only be enabled for that
buffer.

The following alias will remove a previously enabled smart filter in the
current buffer:  
 Add the alias:

    /alias rmsfilter filter del irc_smart_$server_$channel

and execute it by

    /rmsfilter

> Key Bindings

Some helpful bindings:

To use ctrl-left/right arrow keys to jump to next/previous words on the
input line:

    /key bind meta2-1;5D /input move_previous_word
    /key bind meta2-1;5C /input move_next_word

> SSH connection lost when idle

If you're connecting to your WeeChat through a remote shell using SSH,
for example running it in screen or tmux you might experience getting
disconnecting after a while when idle. There are multiple factors in
play why this might happen, but the easiest way to change this is to
force the connection to be kept alive by appending this to your
SSH-configuration on the remote shell. This has nothing to do with
WeeChat itself, but losing connection when idle won't happen with it's
alternative irssi by default, and thus is a common situation for those
converting to WeeChat.

    # /etc/ssh/sshd_config

    ClientAliveInterval 300

Or just have a look at Mosh

Getting Help
------------

To access WeeChat's built-in help, simply type

    /help

and the help will be displayed in the main buffer (usually buffer 1).

External Links
--------------

WeeChat Home Page   
 WeeChat Documentation   
 WeeChat Scripts   
 WeeChat Development Blog

Guides
------

FiXato's guide to WeeChat

Retrieved from
"https://wiki.archlinux.org/index.php?title=WeeChat&oldid=255609"

Category:

-   Internet Relay Chat
