Super Quick Git Guide
=====================

  ------------------------ ------------------------ ------------------------
  [Tango-go-next.png]      This article or section  [Tango-go-next.png]
                           is a candidate for       
                           moving to Pacman Git.    
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Related articles

-   Git

This isn't meant to be an all-encompassing guide by any means - it is
meant to be a really quick walk-through on how to do some basic
operations on the pacman codebase in git, such as submitting a patch.

For more extensive tutorials, check out the following:

-   http://www.kernel.org/pub/software/scm/git/docs/gittutorial.html
-   http://www.kernel.org/pub/software/scm/git/docs/everyday.html
-   http://wiki.winehq.org/GitWine (talks a lot about maintaining
    patches)

In addition, all git commands have decent manpages to refer to. They can
be reached one of two ways - for the git-add command, type 'man git-add'
or 'git help add'.

Contents
--------

-   1 Getting started
-   2 Next steps
    -   2.1 Git branches
    -   2.2 Adding a remote repository
    -   2.3 Other time savers
-   3 Making a patch
-   4 Fixing your patch
-   5 Sending patches
-   6 Further reading
-   7 Advanced hints

Getting started
---------------

The first step with git is cloning a remote repository. This is known in
the CVS and SVN camps as checking out. GIT checkout has a different
purpose, but that will be covered later.

To grab the pacman source into a new directory named 'pacman', run the
following:

    git clone git://projects.archlinux.org/pacman.git pacman

This will check out a local copy of the repository for you. This means
you have the FULL history of the project on your computer, not just the
most recent revision. This allows you to get work done even when
offline, for example.

The first steps after cloning may be just to look around. If you have
read the tutorials mentioned above, even if you do not understand
everything in them, you will be much better off.

You will probably want to set up your name and email address for use in
commit logs:

    git config user.name "Your Name"
    git config user.email "me@example.com"

or use global settings that can be used by other applications:

    # chfn -f 'Your Name' user
    $ export EMAIL='me@example.com'

If you pass the '--global' flag to the above git commands, the name and
email will be stored in ~/.gitconfig, so will be used for all git
projects unless overridden by a setting in the individual project.

To update your local repository with any new branches, run 'git pull'.

Next steps
----------

> Git branches

'git branch' will show you a list of branches. Initially, master is the
only branch. However, if you pulled from a remote repo, you may have
grabbed other branches- these can be seen with 'git branch -r'. Read the
manpage for details.

When working with git, it is good practice to never do your work on the
master branch. This should stay clean to allow you to run 'git pull' and
ensure that conflicts do not happen on the update.

To create your own working branch, do the following (naming it whatever
your heart desires):

    git branch working
    git checkout working

Or compress the above into one command:

    git checkout -b working

To switch back to the master branch use:

    git checkout master

but you can only leave a branch if there are no pending changes to
commit. Find out what changes have not been committed using:

    $ git status
    # On branch working
    # Changed but not updated:
    #   (use "git add <file>..." to update what will be committed)
    #
    #	modified:   lib/libalpm/util.c
    #
    no changes added to commit (use "git add" and/or "git commit -a")
    $

Either commit the changes or revert them before switching branches.

I highly recommend you read the man page for these commands.

> Adding a remote repository

Each developer usually has his own repository, it might be interesting
to have them all available locally. For example:

    git remote add toofishes http://code.toofishes.net/gitprojects/pacman.git

You can see all available branches with 'git branch -r', and as above,
create your own based on one of these remote branches:

    git checkout -b toofishes-working toofishes/working

> Other time savers

If you use CVS or SVN and are used to 'co' being equivalent to
'checkout', try the following:

    git config --global alias.co "checkout"

You can set any other aliases you like. For example:

    git config --global alias.chp "cherry-pick"
    git config --global alias.b "branch"
    git config --global alias.rf "checkout HEAD"

'git status' is highly helpful, it is recommended to read up on that.

Making a patch
--------------

Woo! You found a bug in pacman (what a surprise) and know how to fix it.
Ensure you have your working branch checked out ('git checkout
working'). Then edit the file(s) you need in order to make your changes.
Compiling is a good idea to ensure your patch didn't break anything, and
if it is a big change, running 'make check' is highly recommended.

So what do you do now? First, run 'git status'. You should see a list or
even a few lists of files. The descriptions by each are a bit confusing,
but you should be able to figure it out. GIT takes a different approach
than CVS or SVN to committing changes- it doesn't commit a thing by
default. You have to tell it what to commit, usually by running 'git add
<filename>'. At this point, the file in its current state will be sent
to a staging area for the commit. If you go back and change something in
the file, you will have to git-add it again if you want the changes to
be reflected in the commit.

To commit your patch to your branch:

    git add <all edited files>
    git commit -s

or just:

    git commit -sa

You will then be prompted for a commit message. When writing the
message, keep the following in mind. The first line is used as a patch
summary- keep it short and concise. Next, skip a line and type out a
full description of what your patch does. By full, I do not mean long-
if you described everything in the summary line, then do not even bother
with a message. Finally, skip one more line and you will have your
Signed-off-by. This should have been automatically added by passing the
'-s' parameter to 'git commit'.

There is one more important step before submission. Because git is
distributed, you do not have the most current version of the repository
unless you go out and get it. In the easiest case, this is just running
'git pull' on the master branch.

    git checkout master
    git pull

You also want to make sure your patches are based off the most recent
revision, known as the 'head'. To do this, checkout your branch with
your patches, and use the following command:

    git checkout my-branch
    git rebase master

To visualize what the above command did, qgit can be very helpful.

To format a patch for email submission and review:

    git format-patch master

This command will format all patches that make up the difference between
your working branch and the master branch. They will be saved in the
local directory; to store them elsewhere read up on the '-o' option.

Fixing your patch
-----------------

So you sent off your patch to the ML and you got a few suggestions back.
How does one fix it? Hopefully you did it on a branch and not the master
branch, otherwise you are going to have a much tougher time. :)

If it was the last patch on a branch:

    (edit the required files)
    git add <edited files>
    git commit --amend

If it was deeper in your patch tree, use git rebase -i. Use git log to
find the sha1 of the commit just before the one you wish to edit (or the
unique prefix), and then:

    git rebase -i <sha1 from above>
    (edit the text file that appears so 'edit' appears next to the commit you wish to modify)
    (edit the required files)
    git add -u
    git commit --amend
    git rebase --continue

http://wiki.winehq.org/GitWine has good information on the above, that
is where most of this came from. After fixing your patch, you will
probably want to rebase it as described above, and then use format-patch
to submit it again.

Sending patches
---------------

A nice way to send patches is to use git send-email, but it requires
some initial setup, especially for the smtp client. If you follow the
instructions carefully, it should go fine : Msmtp

Then you just need to tell git to use msmtp:

    git config --global sendemail.smtpserver "/usr/bin/msmtp"

For each git repo, you can specify the email address where the patches
should be sent:

    git config sendemail.to "pacman-dev@archlinux.org"

Then simply send your patches generated by git format-patch:

    git send-email 0001-amazing-new-feature

Further reading
---------------

Commands you will definitely want to be knowledgeable on:

    clone (only once!), branch, checkout, status, pull, fetch, diff, add,
    commit, rebase, format-patch

Advanced hints
--------------

qgit in extra is a great GUI viewer for git repositories. In addition,
read up on 'git-instaweb'.

Used to CVS or SVN-like behavior on commits, where all changes in the
local tree are committed? Try using 'git-commit -a'.

Not running a black and white console? Then you probably want color in a
lot of GIT's console output.

    git config --global color.branch auto
    git config --global color.diff auto
    git config --global color.status auto

Retrieved from
"https://wiki.archlinux.org/index.php?title=Super_Quick_Git_Guide&oldid=290716"

Category:

-   Package development

-   This page was last modified on 29 December 2013, at 03:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
