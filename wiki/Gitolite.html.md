Gitolite
========

Gitolite allows you to host Git repositories easily and securely.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Add users
-   4 Gitosis-like usernames
-   5 See also

Installation
------------

gitolite is available in the Arch User Repository, but installation is
easier when done manually via the Git repository on GitHub.

Configuration
-------------

-   Add a git user and setup gitolite. Installing Git from pacman should
    automatically add a "git" user to the system. If not, create a new
    user named "git":

    # useradd -m -U -r -s /bin/bash git

-   Make sure /home/git exists, and copy over *your* SSH public key to
    /home/git/<your_username>.pub

    # sudo cp ~/.ssh/id_rsa.pub /home/git/<your_username>.pub

-   Run Gitolite setup script

    # sudo -i -u git
    $ rm -f ~/.ssh/authorized_keys
    $ mkdir ~/bin
    $ gitolite/install -to $HOME/bin
    $ gitolite setup -pk <your_username>.pub

Do NOT add repositories or users directly on the server! You MUST manage
the server by cloning the special gitolite-admin repository on your
workstation:

    $ git clone <your_server_hostname>:gitolite-admin

See Gitolite

Add users
---------

Ask each user who will get access to send you a public key. On their
workstation generate the pair of ssh keys:

    $ ssh-keygen

Rename each public key according to the user's name, with a .pub
extension, like sitaram.pub or john-smith.pub. You can also use periods
and underscores. Have the users send you the keys.

Copy all these *.pub files to keydir in your gitolite-admin repo clone.
You can also organise them into various subdirectories of keydir if you
wish, since the entire tree is searched.

Edit the config file (conf/gitolite.conf in your admin repo clone). See
the gitolite.conf documentation
(http://sitaramc.github.com/gitolite/admin.html#conf) for details on
what goes in that file, syntax, etc. Just add new repos as needed, and
add new users and give them permissions as required. The users names
should be exactly the same as their keyfile names, but without the .pub
extension

    $ nano conf/gitolite.conf

Commit and push the changes them:

    git commit -a
    git push

Gitosis-like usernames
----------------------

If you want to distinguish users with the same login (like
username@server1, username@server2) you may want to do the following
(for gitolite-3.04-1):

-   edit /usr/lib/gitolite/triggers/post-compile/ssh-authkeys and
    replace

    $user =~ s/(\@[^.]+)?\.pub$//;    # baz.pub, baz@home.pub -> baz

by

    $user =~ s/\.pub$//;              # baz@home.pub -> baz@home

-   update authorized_keys file (for example, by pushing into the
    gitolite-admin repository)

See also
--------

http://sitaramc.github.com/gitolite/index.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gitolite&oldid=285957"

Category:

-   Version Control System

-   This page was last modified on 3 December 2013, at 07:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
