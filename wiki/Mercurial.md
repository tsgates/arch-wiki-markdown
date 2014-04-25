Mercurial
=========

Mercurial (commonly referred to as hg) is a distributed version control
system written in Python and is similar in many ways to Git, Bazaar and
darcs.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
    -   3.1 Dotfiles Repo
-   4 See also

Installation
------------

Install mercurial, available in the Official repositories.

Configuration
-------------

At the minimum you should configure your username or mercurial will most
likely give you an error when trying to commit. Do this by editing
~/.hgrc and adding the following:

    ~/.hgrc

    [ui]username = John Smith

To use the graphical browser hgk aka. hg view, add the following to
~/.hgrc (see forum thread):

    ~/.hgrc

    [extensions]hgk=

You will need to install tk before running hg view to avoid the rather
cryptic error message:

    /usr/bin/env: wish: No such file or directory

To remove Mercurial warnings of unverified certificate fingerprints, add
the following to ~/.hgrc (see Mercurial wiki):

    ~/.hgrc

    [web]cacerts = /etc/ssl/certs/ca-certificates.crt

If you are going to be working with large repositories (e.g.
ttf-google-fonts-hg), you may want to enable the progress extension by
adding it to your ~/.hgrc file:

    ~/.hgrc

    [extensions]progress =

This will show progress bars on longer operations after 3 seconds. If
you would like the progress bar to show sooner, you can append the
following to your configuration file:

    ~/.hgrc

    [progress]delay = 1.5

Usage
-----

All mercurial commands are initiated with the hg prefix. To see a list
of some of the common commands, run

    $ hg help

You can either work with a pre-existing repository (collection of code
or files), or create your own to share.

To work with a pre-existing repository, you must clone it to a directory
of your choice:

    $ mkdir mercurial$ cd mercurial$ hg clone http://hg.serpentine.com/tutorial/

To create you own, change to the directory you wish to share and
initiate a mercurial project

    $ cd myfiles$ hg init myfiles

> Dotfiles Repo

If you intend on creating a repo of all your ~/. files, you simply
initiate the project in your home folder:

    $ hg init

It is then just a case of adding the specific files you wish to track:

    $ hg add 

You can then create a ~/.hgignore to ensure that only the files you wish
to include in the repository are tracked by mercurial.

Tip:If you include: syntax: glob at the top of the .hgignore file, you
can easily exclude groups of files from your repository.

See also
--------

-   Mercurial: The Definitive Guide
-   hginit.com - a tutorial by Joel Spolsky
-   Mercurial Kick-Start one more tutorial by Aragost.
-   Bitbucket - free and commercial hosting of mercurial repositories
-   Intuxication - free mercurial hosting

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mercurial&oldid=301560"

Category:

-   Version Control System

-   This page was last modified on 24 February 2014, at 11:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
