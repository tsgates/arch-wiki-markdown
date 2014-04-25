Git
===

Related articles

-   Super Quick Git Guide
-   Gitweb
-   Cgit
-   Subversion
-   Concurrent Versions System

Git is the version control system (VCS) coded by Linus Torvalds (the
creator of the Linux kernel) after being criticized for using the
proprietary BitKeeper with the Linux kernel. Git is now used to maintain
sources for the Linux kernel as well as thousands of other projects,
including a number of Arch Linux projects.

There is extensive documentation, including guides and tutorials,
available from the official web site.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Colors in Git prompt
-   3 Basic usage
    -   3.1 Cloning a repository
    -   3.2 Committing files
    -   3.3 Pushing your changes
    -   3.4 Pulling from the server
    -   3.5 Examining history
    -   3.6 Dealing with merges
-   4 Taking advantage of DVCS
    -   4.1 Creating a branch
    -   4.2 A word on commits
    -   4.3 Commits as checkpoints
    -   4.4 Editing the previous commit
    -   4.5 Squashing, rearranging, and changing history
-   5 Git prompt
-   6 Transfer protocols
    -   6.1 Smart HTTP
    -   6.2 Git SSH
        -   6.2.1 Specifying a non-standard port
    -   6.3 Git daemon
    -   6.4 Git repositories rights
-   7 Tunneling Git through HTTP proxies
-   8 See also

Installation
------------

git can be installed with pacman from the official repositories. If you
care about using Git with other VCS software, mail servers, or using
Git's GUI, pay close attention to the optional dependencies.

Bash completion (e.g. hitting Tab to complete commands you are typing)
should work if you add this line to your ~/.bashrc file:

    source /usr/share/git/completion/git-completion.bash

Alternatively, you can install the bash-completion package to load the
completions automatically for new shells.

If you want to use Git's built-in GUI (e.g. gitk or git gui) you should
install the tk package, or you will get a rather cryptic message:

    /usr/bin/gitk: line 3: exec: wish: not found.

In addition, if you're trying to run Git's built-in GUI (e.g. gitk or
git gui) on a headless server (i.e. a system on which you haven't done a
full-blown install of some desktop environment) you may want to make
sure you have the gsfonts package installed, or you might encounter this
problem when trying to run gitk:

    Segmentation fault (core dumped)

If you want to use the Git SVN bridge(git svn) and receive the following
error:

    Can't locate Term/ReadKey.pm in @INC (you may need to install the Term::ReadKey module)

you need to install perl-term-readkey.

Configuration
-------------

Git reads its configuration from a few INI type configuration files. In
each git repository .git/config is used for configuration options
specific to that repository. Per-user ("global") configuration in
$HOME/.gitconfig is used as a fall-back from the repository
configuration. You can edit the files directly but the preferred method
is to use the git-config utility. For example,

    $ git config --global core.editor "nano -w"

adds editor = nano -w to the [core] section of your ~/.gitconfig file.

The man page for the git-config utility has a fairly long list of
variables which can be set.

The two settings you should set before using Git are your name and
email. These are used to sign commits you make.

    $ git config --global user.name "Firstname Lastname"
    $ git config --global user.email "your_email@youremail.com"

> Colors in Git prompt

color.ui is also a very useful option to set because it enables colors
for all Git output.

    $ git config --global color.ui true

Basic usage
-----------

> Cloning a repository

    $ git clone repository_location dir

will clone a Git repository in a new directory inside your current
directory. Leaving out <dir> will cause it to name the folder after the
Git repository. For example,

    $ git clone git://github.com/torvalds/linux.git

clones GitHub's mirror of the Linux kernel into a directory named linux
in the terminal's current directory.

> Committing files

Git's commit process involves two steps:

1.  Add new files, add changes for existing files (both with
    git add <files>), and/or remove files (with git rm). These changes
    are put in a staging area called the index.
2.  Call git commit to commit the changes.

Git commit will open up a text editor to provide a commit message. You
can set this editor to whatever you want by changing the core.editor
option with git config.

Alternatively, you can use git commit -m <message> to supply the commit
message without opening the text editor.

Other useful commit tricks:

-   git commit -a lets you commit changes you have made to files already
    under Git control without having to take the step of adding the
    changes to the index. You still have to add new files with git add.

-   git commit -s adds the following line to the end of the commit
    message, which is useful when submitting patches to mailing lists or
    contributing to open-source software projects.

    Signed-off-by: <firstname> <lastname> <email>

-   It is common for users to regularly contribute to a various mixture
    of private repositories, that users typically do not use
    "Signed-off-by" lines with, and open-source software projects that
    typically require patches to contain a "Signed-off-by" line. If you
    want to make sure you do not forget to add a "Signed-off-by" line
    when contributing to open-source software projects, set the
    following Git configuration setting to automatically append a
    "Signed-off-by" line when using git format-patch <commit>:

    $ git config --local format.signoff true

-   git add -p lets you commit specific parts of files you have changed.
    This is useful if you have made a large number of changes that you
    think would be best split into several commits.

> Pushing your changes

To push your changes up to a server (such as GitHub), use

    $ git push server_name branch

Adding -u will make this server the default one to push to for this
branch.

If you have cloned the repository as described above, the server will
default to the location you cloned the repository from (named "origin"),
and the branch will default to the "master" branch. In other words, if
you have followed this guide's instructions in cloning, git push will
suffice.

You can set up Git to push to multiple servers if you want, but that is
a more advanced topic.

Branches will be discussed later in this guide.

> Pulling from the server

If you are working on multiple machines and want to update your local
repository to what the server has, change directory into your local
repository and use

    $ git pull server_name branch

Similarly to push, the server name and branch should have sane defaults,
so git pull should suffice. Git pull is actually shorthand for doing two
things:

1.  Calling git fetch, which updates the local copy of what the server
    has. Such branches are called "remote" branches because they are
    mirroring remote servers.
2.  Calling git merge, which merges what the remote branch has with what
    you have. If your commit history is the same as the server's commit
    history, you will be automatically fast-forwarded to the latest
    commit on the server. If your history does not match (maybe someone
    else has pushed commits since you last synced), the two histories
    will be merged.

It is not a bad idea to get into the practice of using these two
commands instead of git pull. This way you can check to make sure that
the server contains what you would expect before merging.

> Examining history

The command git log shows the history of your current branch. Note that
each commit is identified by a SHA-1 hash. The author, commit date, and
commit message follow. A more useful command is

    $ git log --graph --oneline --decorate

which provides a display similar to TortoiseGit's log window. It shows
the following:

-   The first 7 digits of each commit's SHA-1 hash (enough to be unique)
-   The --graph option shows how any branches (if there are others) fork
    off from the current branch.
-   The --oneline option shows only the first line of each commit
    message
-   The --decorate option shows all commit labels (branches and tags)

It may be convenient to alias this command as git graph by doing the
following:

    $ git config --global alias.graph 'log --graph --oneline --decorate'

Now typing git graph will run git log --graph --oneline --decorate.

git graph and git log may be given the --all flag in order to view all
branches instead of just the current one. Adding --stat to one of these
commands is also useful because it shows which files each commit changed
and how many lines were changed in each file.

> Dealing with merges

Merges happen when you pull, as a result of a rebase operation, and when
you merge one branch into another. Like other version control tools,
when Git cannot automatically merge a commit, it turns to you. See this
section of the Git Book for an explanation on how to resolve merge
conflicts. If you screw up and would like to back out of the merge, you
can usually abort the merge using the --abort flag with whatever command
started the merge (e.g. git merge --abort, git pull --abort,
git rebase --abort).

Taking advantage of DVCS
------------------------

The above commands only provide the basics. The real power and
convenience in Git (and other distributed version control systems) come
from leveraging its local commits and fast branching. A typical Git
workflow looks like this:

1.  Create and check out a branch to add a feature.
2.  Make as many commits as you would like on that branch while
    developing that feature.
3.  Squash, rearrange, and edit your commits until you are satisfied
    with the commits enough to push them to the central server and make
    them public.
4.  Merge your branch back into the main branch.
5.  Delete your branch, if you desire.
6.  Push your changes to the central server.

> Creating a branch

    $ git branch branch_name

can be used to create a branch that will branch off the current commit.
After it has been created, you should switch to it using

    $ git checkout branch_name

A simpler method is to do both in one step with

    $ git checkout -b branch_name

To see a list of branches, and which branch is currently checked out,
use

    $ git branch

> A word on commits

Many of the following commands take commits as arguments. A commit can
be identified by any of the following:

-   Its 40-digit SHA-1 hash (the first 7 digits are usually sufficient
    to identify it uniquely)
-   Any commit label such as a branch or tag name
-   The label HEAD always refers to the currently checked-out commit
    (usually the head of the branch, unless you used git checkout to
    jump back in history to an old commit)
-   Any of the above plus ~ to refer to previous commits. For example,
    HEAD~ refers to one commit before HEAD and HEAD~5 refers to five
    commits before HEAD.

> Commits as checkpoints

In Subversion and other older, centralized version control systems,
commits are permanent - once you make them, they are there on the server
for everyone to see. In Git, your commits are local and you can combine,
rearrange, and edit them before pushing them to the server. This gives
you more flexibility and lets you use commits as checkpoints. Commit
early and commit often.

> Editing the previous commit

    $ git commit --amend

allows you to modify the previous commit. The contents of the index will
be applied to it, allowing you to add more files or changes you forgot
to put in. You can also use it to edit the commit message, if you would
like.

> Squashing, rearranging, and changing history

    $ git rebase -i commit

will bring up a list of all commits between <commit> and the present,
including HEAD but excluding <commit>. This command allows you rewrite
history. To the left of each commit, a command is specified. Your
options are as follows:

-   The "pick" command (the default) uses that commit in the rewritten
    history.
-   The "reword" command lets you change a commit message without
    changing the commit's contents.
-   The "edit" command will cause Git to pause during the history
    rewrite at this commit. You can then modify it with
    git commit --amend or insert new commits.
-   The "squash" command will cause a commit to be folded into the
    previous one. You will be prompted to enter a message for the
    combined commit.
-   The "fixup" command works like squash, but discards the message of
    the commit being squashed instead of prompting for a new message.
-   Commits can be erased from history by deleting them from the list of
    commits
-   Commits can be re-ordered by re-ordering them in the list. When you
    are done modifying the list, Git will prompt you to resolve any
    resulting merge problems (after doing so, continue rebasing with
    git rebase --continue)

When you are done modifying the list, Git will perform the desired
actions. If Git stops at a commit (due to merge conflicts caused by
re-ordering the commits or due to the "edit" command), use
git rebase --continue to resume. You can always back out of the rebase
operation with git rebase --abort.

Warning:Only use git rebase -i on local commits that have not yet been
pushed to anybody else. Modifying commits that are on the central server
will cause merge problems for obvious reasons.

Git prompt
----------

The Git package comes with a prompt script. To enable the prompt
addition, you will need to source the git-prompt.sh script and add
$(__git_ps1 " (%s)") to your PS1 variable.

-   Add the following line to your ~/.bashrc/~/.zshrc:

    source /usr/share/git/completion/git-prompt.sh

-   For Bash:

    PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

Note:For information about coloring your Bash prompt, see
Color_Bash_Prompt

Note:For information about coloring your Git prompt, see #Colors in Git
Prompt

-   For zsh:

    PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '

The %s is replaced by the current branch name. Git information is
displayed only if you are navigating in a Git repository. You can enable
extra information by setting and exporting certain variables to a
non-empty value as shown in the following table:

  Variable                     Information
  ---------------------------- -----------------------------------------
  GIT_PS1_SHOWDIRTYSTATE       * for unstaged and + for staged changes
  GIT_PS1_SHOWSTASHSTATE       $ if something is stashed
  GIT_PS1_SHOWUNTRACKEDFILES   % if there are untracked files

  : 

In addition you can set the GIT_PS1_SHOWUPSTREAM variable to "auto" in
order to see < if you are behind upstream, > if you are ahead and <> if
you have diverged.

Note:If you experience that $(__git_ps1) returns ((unknown)), then
there's a .git folder in your current directory which does not contain
any repository, and therefore Git does not recognize it. This can, for
example, happen if you mistake Git's configuration file to be
~/.git/config instead of ~/.gitconfig.

Transfer protocols
------------------

> Smart HTTP

Git is able to use the HTTP(S) protocol as efficiently as the SSH or Git
protocols, by utilizing the git-http-backend. Furthermore it is not only
possible to clone or pull from repositories, but also to push into
repositories over HTTP(S).

The setup for this is rather simple as all you need to have installed is
the Apache web server (apache, with mod_cgi, mod_alias, and mod_env
enabled) and of course, git.

Once you have your basic setup running, add the following to your Apache
configuration file, which is usually located at
/etc/httpd/conf/httpd.conf:

    <Directory "/usr/lib/git-core*">
        Require all granted
    </Directory>

    SetEnv GIT_PROJECT_ROOT /srv/git
    SetEnv GIT_HTTP_EXPORT_ALL
    ScriptAlias /git/ /usr/lib/git-core/git-http-backend/

The above example configuration assumes that your Git repositories are
located at /srv/git and that you want to access them via something like
http(s)://your_address.tld/git/your_repo.git. Feel free to customize
this to your needs.

Note:Of course, you have to make sure that Apache can read and write (if
you want to enable push access) to your Git repositories.

For more detailed documentation, visit the following links:

-   http://progit.org/2010/03/04/smart-http.html
-   https://www.kernel.org/pub/software/scm/git/docs/v1.7.10.1/git-http-backend.html

> Git SSH

You first need to have a public SSH key. For that follow the guide at
SSH keys. To set up SSH itself, you need to follow the SSH guide. This
assumes you have a public SSH key now and that your SSH is working. Open
your SSH key in your favorite editor (default public key name is
~/.ssh/id_rsa.pub), and copy its content. Now go to your user where you
have made your Git repository, since we now need to allow that SSH key
to log in on that user to access the Git repository. Open
~/.ssh/authorized_keys in your favorite editor, and paste the contents
of ~/.ssh/id_rsa.pub in it. Be sure it is all on one line! That is
important! It should look somewhat like this:

Warning:Do not copy the line below! It is an example! It will not work
if you use that line!

 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCboOH6AotCh4OcwJgsB4AtXzDo9Gzhl+BAHuEvnDRHNSYIURqGN4CrP+b5Bx/iLrRFOBv58TcZz1jyJ2PaGwT74kvVOe9JCCdgw4nSMBV44cy+6cTJiv6f1tw8pHRS2H6nHC9SCSAWkMX4rpiSQ0wkhjug+GtBWOXDaotIzrFwLw== username@hostname
Now you can checkout your Git repository this way (change where needed.
Here it is using the username git and the host localhost):

    git clone git@localhost:my_repository.git

You should now get an SSH yes/no question, if you have the SSH client
setting StrictHostKeyChecking set to ask (the default). Type yes
followed by Enter. Then you should have your repository checked out.
Because this is with SSH, you also have commit rights now. To modify an
existing repository to use SSH, the URL for the origin branch can simply
be changed.

    git remote set-url origin git@localhost:my_repository.git

For more information, read the Super Quick Git Guide.

Specifying a non-standard port

Connecting on a port other than 22 can be configured on a per-host basis
in /etc/ssh/ssh_config or ~/.ssh/config. To set up ports for a
repository, specify the path in .git/config using the port number N and
the absolute path /PATH/TO/REPO:

    ssh://user@example.org:N/PATH/TO/REPO

Typically the repository resides in the home directory of the user which
allows you to use tilde-expansion. Thus to connect on port N=443,

    url = git@example.org:repo.git

becomes:

    url = ssh://git@example.org:443/~git/repo.git

> Git daemon

Note:The Git daemon only allows read access. For write access, refer to
#Git SSH.

This will allow URLs like git clone git://localhost/my_repository.git.

Start git-daemon.socket with root privileges.

    # systemctl start git-daemon.socket

To run the git-daemon every time at boot, enable the systemd unit
git-daemon.socket.

The daemon is started with the following parameters which are placed in
the systemd service file.

    ExecStart=-/usr/lib/git-core/git-daemon --inetd --export-all --base-path=/srv/git

You have to place your repositories in /srv/git/ to be able to clone
them with the Git daemon.

Clients can now simply use the following:

    $ git clone git://localhost/my_repository.git

> Git repositories rights

To restrict read and/or write access, you can simply use Unix
permissions. Refer to
http://sitaramc.github.com/gitolite/doc/overkill.html[dead link
2013-11-06] for more information.

For fine-grained access management, refer to gitolite and gitosis.

Tunneling Git through HTTP proxies
----------------------------------

Restrictive corporate firewalls typically block the port that git uses.
However, git can be made to tunnel through HTTP proxies using utilities
such as corkscrew. When git sees the environment variable
GIT_PROXY_COMMAND set, it will run the command in $GIT_PROXY_COMMAND and
use that program's stdin and stdout, instead of a network socket.

Create a script file corkscrewtunnel.sh

    #! /bin/bash

    corkscrew proxyhost proxyport $*

Set GIT_PROXY_COMMAND

    export GIT_PROXY_COMMAND=path-to-corkscrewtunnel.sh

Now, git should be able to tunnel successfully through the HTTP proxy.

See also
--------

-   Pro Git book
-   Git Reference
-   https://www.kernel.org/pub/software/scm/git/docs/
-   https://help.github.com/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Git&oldid=305695"

Category:

-   Version Control System

-   This page was last modified on 20 March 2014, at 01:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
