Python VirtualEnv
=================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

virtualenv is a Python tool written by Ian Bicking and used to create
isolated environments for Python in which you can install packages
without interfering with the other virtualenvs nor with the system
Python's packages. The present article covers the installation of the
virtualenv package and its companion command line utility
virtualenvwrapper designed by Doug Hellmann to (greatly) improve your
work flow. A quick how-to to help you to begin working inside virtual
environment is then provided.

Contents
--------

-   1 Virtual Environments at a glance
-   2 Virtualenv
    -   2.1 Installation
    -   2.2 Basic Usage
-   3 Virtualenvwrapper
    -   3.1 Installation
    -   3.2 Basic Usage
-   4 See Also

Virtual Environments at a glance
--------------------------------

virtualenv is a tool designated to address the problem of dealing with
packages' dependencies while maintaining different versions that suit
projects' needs. For example, if you work on two Django web sites, say
one that needs Django 1.2 while the other needs the good old 0.96. You
have no way to keep both versions if you install them into
/usr/lib/python2/site-packages . Thanks to virtualenv it's possible, by
creating two isolated environments, to have the two development
environment to play along nicely.

vitualenvwrapper takes virtualenv a step further by providing convenient
commands you can invoke from your favorite console.

Virtualenv
----------

virtualenv supports Python 2.6+ and Python 3.x.

> Installation

Simply install from the community repository:

    # pacman -S python2-virtualenv

or

    # pacman -S python-virtualenv

> Basic Usage

An extended tutorial on how use virtualenv for sandboxing can be found
here.

The typical use case is:

-   Create a folder for the new virtualenv:

    $ mkdir -p ~/.virtualenvs/my_env

-   Create the virtualenv:

    $ virtualenv2 ~/.virtualenvs/my_env

-   Activate the virtualenv:

    $ source ~/.virtualenvs/my_env/bin/activate

-   Install some package inside the virtualenv (say, Django):

    (my_env)$ pip install django

-   Do your things
-   Leave the virtualenv:

    (my_env)$ deactivate

Virtualenvwrapper
-----------------

virtualenvwrapper allows more natural command line interaction with your
virtualenvs by exposing several useful commands to create, activate and
remove virtualenvs. This package is a wrapper for both python-virtualenv
and python2-virtualenv.

> Installation

Install the python-virtualenvwrapper package from the official
repositories.

Now add the following lines to your ~/.bashrc:

    export WORKON_HOME=~/.virtualenvs
    source /usr/bin/virtualenvwrapper.sh

If you are not using python3 by default (check the output of
$ python --version) you also need to add the following line to your
~/.bashrc prior sourcing the virtualenvwrapper.sh script. The current
version of the virtualenvwrapper-python package only works with python3.
It can create python2 virtualenvs fine though.

    VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

Re-open your console and create the WORKON_HOME folder:

    $ mkdir $WORKON_HOME

> Basic Usage

The main information source on virtualenvwrapper usage (and extension
capability) is Doug Hellmann's page.

-   Create the virtualenv:

    $ mkvirtualenv -p /usr/bin/python2.7 my_env

-   Activate the virtualenv:

    $ workon my_env

-   Install some package inside the virtualenv (say, Django):

    $ (my_env)$ pip install django

-   Do your things
-   Leave the virtualenv:

    (my_env)$ deactivate

See Also
--------

-   virtualenv Pypi page
-   Tutorial for virtualenv
-   virtualenvwrapper page at Doug Hellmann's

Retrieved from
"https://wiki.archlinux.org/index.php?title=Python_VirtualEnv&oldid=305751"

Category:

-   Development

-   This page was last modified on 20 March 2014, at 01:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
