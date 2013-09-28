Gitolite
========

Gitolite allows you to host Git repositories easily and securely.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Add users                                                          |
| -   4 Gitosis-like usernames                                             |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

gitolite-git is available in the Arch User Repository.

It is also available on github, where you can find the last update.

Configuration
-------------

Add a user

    # useradd -m -U -r -s /bin/bash -d /srv/git git
    # su - git
    $ gitolite setup -pk id_rsa.pub

Add to your work-machine's ~/.ssh/config:

    Host server
    HostName 192.168.12.2
    User git
    ### IdentityFile specifies the private ssh-key
    IdentityFile ~/.ssh/id_rsa

  
 Do NOT add repos or users directly on the server! You MUST manage the
server by cloning the special 'gitolite-admin' repo on your workstation:

    $ git clone server:gitolite-admin

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

-   update authorized_keys file (for example, by pushing into
    gitolite-admin repo)

See also
--------

http://sitaramc.github.com/gitolite/index.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gitolite&oldid=222067"

Category:

-   Version Control System
