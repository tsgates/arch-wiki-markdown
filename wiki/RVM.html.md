RVM
===

Related articles

-   Rbenv
-   Chruby
-   Ruby

RVM (Ruby Version Manager) is a command line tool which allows us to
easily install, manage and work with multiple Ruby environments from
interpreters to sets of gems.

There exists a similar application that you may also want to consider:
rbenv.

Contents
--------

-   1 Installing RVM
    -   1.1 Pre-requisites
    -   1.2 Single-user installation
    -   1.3 Multi-user installation
        -   1.3.1 A cautionary action
-   2 Post Installation
    -   2.1 Some extras
-   3 Using RVM
    -   3.1 Rubies
        -   3.1.1 Installing environments
        -   3.1.2 Switching environments
        -   3.1.3 System ruby
        -   3.1.4 Listing environments
    -   3.2 Gemsets
        -   3.2.1 Creating
        -   3.2.2 Using
            -   3.2.2.1 Notes
        -   3.2.3 Gems!
        -   3.2.4 Listing
        -   3.2.5 Deleting
        -   3.2.6 Emptying
    -   3.3 RVM
        -   3.3.1 Updating
        -   3.3.2 Uninstalling
    -   3.4 Further Reading
-   4 Troubleshooting
    -   4.1 "data definition has no type or storage class"
    -   4.2 Ruby 1.8.x won't compile with RVM
    -   4.3 Ruby 1.9.1 won't compile with RVM
-   5 See Also

Installing RVM
--------------

The install process is very easy, and is the very same for any distro,
including Archlinux. You have two choices, one system-wide, another as a
user. The first is for production servers, or if your are alone on your
machine. You'll need root privileges. The second is the recommended for
multiple users on the same machine (like a development test box). If you
do not know which to choose, start with a single user installation.

The upstream instructions for installing RVM should just work. The
install script is aware enough to tell you what packages you need to
install on Archlinux to make different rubies work. This usually
involves gcc and some other stuff needed to compile ruby.

As an observation, installing RVM with gem is not recommended anymore.
This article uses the recommended documentation with minor tweaks to
make it work on Archlinux.

> Pre-requisites

Before starting, you will need the following to get the installation
process going:

    $ pacman -S git curl

> Single-user installation

Note:This will install to your home directory only (~/.rvm), and won't
touch the standard Arch ruby package, which is in /usr.

For most purposes, the recommended installation method is single-user,
which is a self-contained RVM installation in a user's home directory.

Use the script that rvm docs recommends to install. Make sure to run
this script as the user for whom you want RVM installed (i.e. your
normal user that you use for development).

    $ curl -L get.rvm.io | bash -s stable

(to install a specific version replace stable with, for example, --
--version 1.13.0)

  
 If instead you want to check the script before running it, do:

    $ curl -L get.rvm.io > rvm-install

Inspect the file, then run it with:

    $ bash < ./rvm-install

After the script has finished, then add the following line to the end of
your ~/.bash_login or ~/.bashrc (or ~/.zprofile or whatever):

    $ [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

Now, close out your current shell or terminal session and open a new
one. (You may attempt reloading your ~/.bash_login with the following
command:

    $ source ~/.bash_login

However, closing out your current shell or terminal and opening a new
one is the preferred way for initial installations.)

> Multi-user installation

Note:This will install to /usr/local/rvm, and won't touch the standard
Arch ruby package, which is in /usr.

System-wide installation is a similar procedure to the single user
install. However, instead run the install script with sudo. Do not run
the installer directly as root!

    $ curl -L get.rvm.io | sudo bash -s stable

(to install a specific version replace stable with, for example, --
--version 1.13.0)

After the script has finished, add yourself and your users to the 'rvm'
group. (The installer does not auto-add any users to the rvm group.
Admins must do this.) For each one, repeat:

    $ sudo usermod -a -G rvm <user>

Group memberships are only evaluated at login time. Log the users out,
then back in. You too: close out your current shell or terminal session
and open a new one. (You may attempt reloading your ~/.bash_login with
the following command:

    $ source ~/.bash_login

However, closing out your current shell or terminal and opening a new
one is the preferred way for initial installations. Alternatively, you
can use the "newgrp rvm" command and check with "id" to see whether the
shell has picked up the new group membership of your user)

  

Note:Remember to change the line [ [ -s
HOME/.rvm/scripts/rvm ] ] && source HOME/.rvm/scripts/rvm to the
system-wide location changing $HOME to /usr/local/

  
 RVM will be automatically configured for every user on the system (in
opposite to the single-user installation); this is accomplished by
loading /etc/profile.d/rvm.sh on login. Archlinux defaults to parsing
/etc/profile which contains the logic to load all files residing in the
/etc/profile.d/ directory.

Before installing gems with multi-user rvm, make sure that /etc/gemrc
does not have the line "gem: --user-install". If it does you need to
comment it out otherwise the gems will install to the wrong place.

You only use the sudo command during the install process. In multi-user
configurations, any operations which require sudo access must use the
rvmsudo command which preserves the RVM environment and passes this on
to sudo. There are very few cases where rvmsudo is required once the
core install is completed, except for when updating RVM itself. There is
never a reason to use sudo post-install. rvmsudo should only be needed
for updating with

    $ rvmsudo rvm get head

A cautionary action

In order to prevent the installation breakage by this cause, you may add
this configuration to your /etc/sudoers file:

    ## Cmnd alias specification
    Cmnd_Alias RVM = /usr/local/rvm/rubies/<ruby_interpreter>/bin/gem, \
                     /usr/local/rvm/rubies/<another_ruby_interpreter>/bin/gem, \
                     /usr/local/rvm/bin/rvm

    ## User privilege specification
    root ALL=(ALL) ALL

    ## Uncomment to allow members of group wheel to execute any command
    %wheel ALL=(ALL) ALL, !RVM

Where <ruby_interpreter> would be —for example— ruby-1.9.2-p290.

Post Installation
-----------------

After the installation, check everything worked with this command:

    $ type rvm | head -n1

The response should be:

    $ rvm is a function

If you receive rvm: not found, you may need to source your ~/.bash_login
(or wherever you put the line above):

    $ . ~/.bash_login

Check if the rvm function is working:

    $ rvm notes

Finally, see if there are any dependency requirements for your
installation by running:

    $ rvm requirements

(Follow the returned instructions if any.)

Very important: whenever you upgrade RVM in the future, you should
always run rvm notes and rvm requirements as this is usually where you
will find details on any major changes and/or additional requirements to
ensure your installation stays working.

> Some extras

You may put in your ~/.bashrc the following lines to get some useful
features:

    # Display the current RVM ruby selection
    PS1="\$(/usr/local/rvm/bin/rvm-prompt) $PS1"

    # RVM bash completion
    [[ -r /usr/local/rvm/scripts/completion ]] && . /usr/local/rvm/scripts/completion

Or if you're running as a single user:

    # RVM bash completion
    [[ -r "$HOME/.rvm/scripts/completion" ]] && source "$HOME/.rvm/scripts/completion"

Using RVM
---------

The RVM documentation is quite comprehensive and explanatory. However,
here are some RVM usage examples to get you started.

> Rubies

Installing environments

To see what Ruby environments are available to install, run:

    $ rvm list known

To install one, run:

    $ rvm install <ruby_version>

For example, to install Ruby 1.9.2 one would run the following command:

    $ rvm install 1.9.2

This should download, configure and install Ruby 1.9.2 in the place you
installed RVM. For example, if you did a single user install, it will be
in ~/.rvm/rubies/1.9.2.

You can define a default ruby interpreter by doing:

    $ rvm use <ruby_version> --default

If not, the default environment will be the system ruby in /usr —if you
have installed one using pacman— or none.

Switching environments

To switch from one environment to another simply run:

    $ rvm use <ruby_version>

For example to switch to Ruby 1.8.7 one would run the following command:

    $ rvm 1.8.7

(As you see, the flag use is not really necessary.)

You should get a message telling you the switch worked. It can be
confirmed by running:

    $ ruby --version

Note that this environment will only be used in the current shell. You
can open another shell and select a different environment for that one
in parallel.

In case you have set a default interpreter as explained above, you can
do the switch with:

    $ rvm default

System ruby

If you wish the ruby interpreter that is outside RVM (i.e. the one
installed in /usr by the standard Archlinux package), you can switch to
it using:

    $ rvm system

Listing environments

To see all installed Ruby environments, run the following command:

    $ rvm list

If you've installed a few rubies, this might generate a list like so:

    rvm Rubies
       jruby-1.5.0 [ [i386-java] ]
    => ruby-1.8.7-p249 [ i386 ]
       ruby-1.9.2-head [ i386 ]
    System Ruby
       system [ i386 ]

The ASCII arrow indicates which environment is currently enabled. In
this case, it is Ruby 1.8.7. This could be confirmed by running:

    $ ruby --version
    ruby 1.8.7 (2010-01-10 patchlevel 249) [i686-linux]

> Gemsets

RVM has a valued feature called gemsets which enables you to store
different sets of gems in compartmentalized independent ruby setups.
This means that ruby, gems and irb are all separate and self-contained
from the system and each other.

Creating

Gemsets must be created before being used. To create a new gemset for
the current ruby, do this:

    $ rvm use <ruby_version>
    $ rvm gemset create <gemset_name>

Alternatively, if you prefer the shorthand syntax offered by rvm use,
employ the --create option like so:

    $ rvm use <ruby_version>@<gemset_name> --create

You can also specify a default gemset for a given ruby interpreter, by
doing:

    $ rvm use <ruby_version>@<gemset_name> --default

Using

Tip: remove gems that reside in system priore RVM installation with:

    $ gem  list --local | awk '{print "gem uninstall " $1}' | bash

and check what's left:

    $ gem list --local

To use a gemset:

    $ rvm gemset use <gemset_name>

You can switch to a gemset as you start to use a ruby, by appending
@<gemset_name> to the end of the ruby selector string:

    $ rvm use <ruby_version>@<gemset_name>

Notes

When you install a ruby environment, it comes with two gemsets out of
the box, their names are default and global. You will usually find in
the latter some pre-installed common gems, while the former always
starts empty.

A little bit about where the default and global gemsets differ: When you
do not use a gemset at all, you get the gems in the default set. If you
use a specific gemset (say @testing), it will inherit gems from that
ruby's @global. The global gemset is to allow you to share gems to all
your gemsets.

Gems!

Within a gemset, you can utilize usual RubyGems commands

    $ gem install <gem>

to add,

    $ gem uninstall <gem>

to remove gems, and

    $ gem list

to view installed ones.

If you are deploying to a server, or you do not want to wait around for
rdoc and ri to install for each gem, you can disable them for gem
installs and updates. Just add these two lines to your ~/.gemrc or
/etc/gemrc:

    install: --no-document
    update: --no-document

Listing

To see the name of the current gemset:

    $ rvm gemset name

To list all named gemsets for the current ruby interpreter:

    $ rvm gemset list

To list all named gemsets for all interpreters:

    $ rvm gemset list_all

Deleting

This action removes the current gemset:

    $ rvm gemset use <gemset_name>
    $ rvm gemset delete <gemset_name>

By default, rvm deletes gemsets from the currently selected Ruby
interpreter. To delete a gemset from a different interpreter, say 1.9.2,
run your command this way:

    $ rvm 1.9.2 do gemset delete <gemset_name>

Emptying

This action removes all gems installed in the gemset:

    $ rvm gemset use <gemset_name>
    $ rvm gemset empty <gemset_name>

> RVM

Updating

To upgrade to the most recent release version:

    $ rvm get latest

Upgrading to the latest repository source version (the most bugfixes):

    $ rvm get head

Remember to use rvmsudo for multi-user setups. Update often!

Uninstalling

Executing

    $ rvm implode

is going to wipe out the RVM installation —cleanly—.

> Further Reading

This is just a simple introduction to switching ruby versions with RVM
and managing different set of gems in different environments. There is
lots more that you can do with it! For more information, consult the
very comprehensive RVM documentation. This page is a good place to
start.

Troubleshooting
---------------

You will need to take care with rvm installations, since ArchLinux is
very well updated, and some earlier ruby's patchlevels do not like it.
RVM many times do not choose the latest patchlevel version to install,
and you'll need to check manually on the ruby website, and force RVM to
install it.

"data definition has no type or storage class"

This appears to be specific to 1.8.7, but if you get this error while
compiling the following steps will fix your problem:

    $ cd src/ruby-1.8.7-p334/ext/dl
    $ rm callback.func
    $ touch callback.func
    $ ruby mkcallback.rb >> callback.func
    $ rm cbtable.func
    $ touch cbtable.func
    $ ruby mkcbtable.rb >> cbtable.func

Naturally, substitute the actual build path to your source, which will
be something like ~/.rvm/src/.

Ruby 1.8.x won't compile with RVM

This is a known issue on Arch Linux, and is caused by a problem with
openssl. Arch uses openssl 1.0, lower patchlevels of 1.8.7 assumes 0.9.

Certain patch levels may not build (p352 for example), p299 should work
fine and can be installed using the following command:

    $ rvm remove 1.8.7
    $ rvm install 1.8.7-p299

Another approach is to install local openssl via RVM:

    $ rvm pkg install openssl
    $ rvm remove 1.8.7
    $ rvm install 1.8.7 -C --with-openssl-dir=$HOME/.rvm/usr

It may be necessary to patch 1.8.7:

    $ wget http://redmine.ruby-lang.org/attachments/download/1931/stdout-rouge-fix.patch
    $ rvm remove 1.8.7
    $ rvm install --patch Downloads/stdout-rouge-fix.patch ruby-1.8.7-p352

Ruby 1.9.1 won't compile with RVM

Like with 1.8.x, earlier patchlevels do not like the OpenSSL 1.0. Then
you can use the very same solution above, by installing openssl locally
on RVM.

    $ rvm pkg install openssl
    $ rvm remove 1.9.1
    $ rvm install 1.9.1 -C --with-openssl-dir=$HOME/./rvm/usr

The patchlevels >p378 have a problem with gem paths, when $GEM_HOME is
set. The problem is known and fixed in 1.9.2.
(http://redmine.ruby-lang.org/issues/3584). If you really need 1.9.1
please use p378.

    $ rvm install 1.9.1-p378 -C --with-openssl-dir=$HOME/.rvm/usr

See Also
--------

-   RVM project website.
-   The Perfect Rails Setup.

Retrieved from
"https://wiki.archlinux.org/index.php?title=RVM&oldid=301990"

Category:

-   Development

-   This page was last modified on 25 February 2014, at 08:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
