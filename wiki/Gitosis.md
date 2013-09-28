Gitosis
=======

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Gitosis is a tool which provides access control and remote management
for hosted Git repositories. It allows for fine-grained management of
read and write access over SSH, without requiring that the users have
local system accounts on the server. To do this, it sets up a single
system account "git" which is then used for all Git access.

Gitosis provides installation instructions in its README file. This
guide is based on those instructions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation and setup                                             |
| -   2 Configuration                                                      |
|     -   2.1 Repositories and permissions                                 |
|     -   2.2 Adding users                                                 |
|     -   2.3 Public access                                                |
|     -   2.4 More tricks                                                  |
|     -   2.5 Non-standard SSH port                                        |
|     -   2.6 keydir                                                       |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation and setup
----------------------

Install the gitosis-git package from the AUR. This will create three
things:

-   the git user
-   the git group to which this user belongs
-   the /srv/gitosis directory, which will hold data and repositories
    for Gitosis

To configure Gitosis, you do not edit files directly on the server.
Instead, Gitosis provides a Git repository which contains the
configuration. To update this configuration, you clone, commit, and push
to gitosis-admin just as you would any other repository.

Since Gitosis uses SSH keys to authenticate users, you will need to
generate a keypair to use for the administrative repository. If you do
not have one, you can generate it using ssh-keygen, for example:

    $ ssh-keygen -t rsa

You can now initialize the administrative repository.

    $ sudo -H -u git gitosis-init < /path/to/public_key.pub
    Initialized empty Git repository in /srv/gitosis/repositories/gitosis-admin.git/
    Reinitialized existing Git repository in /srv/gitosis/repositories/gitosis-admin.git/

Note:In some cases, this might result in an error of this kind:

    OSError: [Errno 13] Permission denied: '//gitosis'

The cause of this might be that the git home directory was not set
properly. Fix it by setting it manally:

    # usermod -d /srv/gitosis git

In addition, this command creates the directory
/srv/gitosis/repositories in which the actual hosted repositories will
be stored.

After the initialisation of the admin repository is complete, it might
be sensible to disable the password based ssh login of the user git.

To achieve this, add

    Match User git
    PasswordAuthentication no

at the end of /etc/ssh/sshd_config

Configuration
-------------

As mentioned above, Gitosis is configured by pushing commits to the
gitosis-admin repository. To clone this repository (using Gitosis!),
run:

    $ git clone git@your.git.server:gitosis-admin.git

Inside the gitosis-admin repository, you will see two things:

-   gitosis.conf – configuration file for Gitosis and repository
    permissions
-   keydir – directory containing public keys for each user

To modify repositories or users, or to configure Gitosis, just commit
changes in your clone and push them back to the server.

> Repositories and permissions

You'll be able to find some example configuration files in
/usr/share/doc/gitosis.

    [gitosis]
    gitweb = yes

    [repo foobar]
    description = Git repository for foobar
    owner = user

    [group devs]
    members = user1 user2

    [group admins]
    members = user1

    [group gitosis-admin]
    writable = gitosis-admin
    members = @admins

    [group foobar]
    writable = foobar
    members = @devs

    [group myteam]
    writable = free_monkey
    members = jdoe

    [group deployer]
    writable = free_monkey
    readonly = monkey_deployer

This defines a new group called "free_monkey", which is an arbitrary
string. "jdoe" is a member of myteam and will have write access to the
"gitosis" repository. The "monkey_deployer" key will have only read-only
access to "free_monkey".

Save this addition to gitosis.conf, commit and push it:

    $ git commit -a -m "Allow jdoe write access to free_monkey"
    $ git push

Now the user "jdoe" has access to write to the repository named
"free_monkey", but we still have not created a repository yet. What we
will do is create a new repository locally, initialize it on the Git
server, and then push it:

    $ mkdir free_monkey
    $ cd free_monkey
    $ git init
    $ git remote add origin git@YOUR_SERVER_HOSTNAME:free_monkey.git

Do some work, git add and commit files

    $ git push origin master:refs/heads/master

When using SSH, the last command will fail with the error message "does
not appear to be a Git repository" This can be fixed by initializing the
repository manually on the server

    $ git init --bare /srv/gitosis/repositories/free_monkey.git

and retry the last command

With the final push, you are off to the races. The repository
"free_monkey" has been created on the server (in
/srv/gitosis/repositories) and you are ready to start using it like any
ol' Git repository.

Gitosis repositories can also be used with gitweb; just point the
directory that contains the repository inside the gitweb configuration.

> Adding users

The next natural thing to do is to grant a lucky few commit access to
the FreeMonkey project. This is a simple two step process.

First, gather their public SSH keys, which I'll call "alice.pub" and
"bob.pub", and drop them into keydir/ of your local gitosis-admin
repository. Second, edit gitosis.conf and add them to the "members"
list.

    $ cd gitosis-admin
    $ cp ~/alice.pub keydir/
    $ cp ~/bob.pub keydir/
    $ git add keydir/alice.pub keydir/bob.pub

Note that the key filename must have a ".pub" extension.

gitosis.conf changes:

    [group myteam]
    members = jdoe alice bob
    writable = free_monkey

Commit and push:

    $ git commit -a -m "Granted Alice and Bob commit rights to FreeMonkey"
    $ git push

That's it. Alice and Bob can now clone the free_monkey repository like
so:

    $ git clone git@YOUR_SERVER_HOSTNAME:free_monkey.git

Alice and Bob will also have commit rights.

> Public access

If you are running a public project, you will have your users with
commit rights, and then you'll have everyone else. How do we give
everyone else read-only access without fiddling with SSH keys?

We just use git-daemon. This is independent of Gitosis and it comes with
Git itself.

    $ sudo -u git git-daemon --base-path=/srv/gitosis/repositories/ --export-all

This will make all the repositories you manage with Gitosis read-only
for the public. Someone can then clone FreeMonkey like so:

    $ git clone git://YOUR_SERVER_HOSTNAME/free_monkey.git

To export only some repositories and not others, you need to touch
git-daemon-export-ok inside the root directory (e.g.
/srv/gitosis/repositories/free_monkey.git) of each repository that you
want public. Then remove "--export-all" from the git-daemon command
above.

> More tricks

gitosis.conf can be set to do some other neat tricks. Open example.conf
in the Gitosis source directory (where you originally cloned Gitosis way
at the top) to see a summary of all options. You can specify some
repositories to be read-only (opposite of writable), but yet not public.
A group members list can include another group. And a few other tricks
that I'll leave it to the reader to discover.

Caveats

If /srv/gitosis/.gitosis.conf on your server never seems to get updated
to match your local copy (they should match), even though you are making
changes and pushing, it could be that your post-update hook is not
executable. Older versions of setuptools can cause this. Be sure to fix
that:

    $ sudo chmod 755 /srv/gitosis/repositories/gitosis-admin.git/hooks/post-update

If your Python goodies are in a non-standard location, you must
additionally edit post-update and put an "export PYTHONPATH=..." line at
the top. Failure to do so will give you a Python stack trace the first
time you try to push changes within gitosis-admin.

If you want to install Gitosis in a non-standard location, I do not
recommend it. It's an edge case that the author has not run up against
until I bugged him to help me get it working.

For the brave, you need to edit whatever file on your system controls
the default PATH for a non-login, non-interactive shell. On Ubuntu this
is /etc/environment. Add the path to gitosis-serve to the PATH line.
Also insert a line for PYTHONPATH and set it to your non-standard Python
site-packages directory. As an example, this is my /etc/environment:

    $ PATH="/home/$(whoami)/sys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games"
    $ PYTHONPATH=/home/$(whoami)/sys/lib/python2.4/site-packages

Be sure to logout and log back in after you make these changes.

Do not use the gitosis-init line I have above for the standard install,
instead use this slightly modified one:

    $ sudo -H -u git env PATH=$PATH gitosis-init < /tmp/id_rsa.pub

Be sure to also set PYTHONPATH in your post-update hook as described
above.

That *should* do it. I am purposefully terse with this non-standard
setup as I think not many people will use it. Hit me up in #git on
FreeNode if you need more information (my nick is up_the_irons).

> Non-standard SSH port

If you run SSH on a non-standard port on your server, there are two ways
of specifying on which port Git will try to connect. One is to
explicitly state that you are using the SSH protocol, as this lets you
put in a port number in the URL too:

    git clone ssh://git@myserver.com:1234/repo.git

Or you can put this in your ~/.ssh/config file:

    $ Host myserver.com
    $ Port 1234

-   [repo] blocks are used to define some necessary areas being used
    with gitweb.
-   [group] blocks are used for both:
    -   defining user groups
    -   defining repository permissions

-   @ is used to define user groups.

You should commit and push any changes you do in this file.

> keydir

keydir is simply a directory that contains public keys of the users.
Some of the keys can be in the form of user@machine and those keys must
be defined with that form inside gitosis.conf. It's better to create
user groups and use them as members of the repositories. Once you add
new keys to enable some new users, you should add the files to the Git
repository and commit and push them. The new users will use the above
form of Git commands like you have used to clone the gitosis-admin
repository.

See also
--------

-   Gitosis source
-   Gitolite – an alternative to Gitosis which provides many similar
    features
-   Girocco – Git hosting code used on repo.or.cz
-   Gitorious – open-source Git hosting
-   Gitlab – a free git repository management application based on Ruby
    on Rails and Gitolite.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gitosis&oldid=237315"

Category:

-   Version Control System
