Python
======

Related articles

-   Python Package Guidelines
-   mod_python
-   Python VirtualEnv

Python "is a remarkably powerful dynamic programming language that is
used in a wide variety of application domains. Python is often compared
to Tcl, Perl, Ruby, Scheme or Java."

Contents
--------

-   1 Installation
    -   1.1 Python 3
    -   1.2 Python 2
-   2 Dealing with version problem in build scripts
-   3 Integrated development environments
    -   3.1 Eclipse
    -   3.2 Eric
    -   3.3 IEP
    -   3.4 Ninja
    -   3.5 Spyder
    -   3.6 PyCharm
-   4 Getting easy_install
-   5 Getting completion in Python shell
-   6 Widget bindings
-   7 Old versions
-   8 Tips and tricks
-   9 See also
-   10 For Fun

Installation
------------

There are currently two versions of Python: Python 3 (which is the
default) and the older Python 2.

> Python 3

Python 3 is the latest version of the language, and is incompatible with
Python 2. The language is mostly the same, but many details, especially
how built-in objects like dictionaries and strings work, have changed
considerably, and a lot of deprecated features have finally been
removed. Also, the standard library has been reorganized in a few
prominent places. For an overview of the differences, visit
Python2orPython3 and their relevant chapter in Dive into Python 3.

To install the latest version of Python 3, install the python package
from the official repositories.

If you would like to build the latest RC/betas from source, visit Python
Downloads. The Arch User Repository also contains good PKGBUILDs. If you
do decide to build the RC, note that the binary (by default) installs to
/usr/local/bin/python3.x.

> Python 2

To install the latest version of Python 2, install the python2 package
from the official repositories.

Python 2 will happily run alongside Python 3. You need to specify
python2 in order to run this version.

Any program requiring Python 2 needs to point to /usr/bin/python2,
instead of /usr/bin/python, which points to Python 3.

To do so, open the program or script in a text editor and change the
first line.

The line will show one of the following:

    #!/usr/bin/env python

or

    #!/usr/bin/python

In both cases, just change python to python2 and the program will then
use Python 2 instead of Python 3.

Another way to force the use of python2 without altering the scripts is
to call it explicitely with python2, i.e.

    python2 myScript.py

Finally, you may not be able to control the script calls, but there is a
way to trick the environment. It only works if the scripts use
#!/usr/bin/env python, it won't work with #!/usr/bin/python. This trick
relies on env searching for the first corresponding entry in the PATH
variable. First create a dummy folder.

    $ mkdir ~/bin

Then add a symlink 'python' to python2 and the config scripts in it.

    $ ln -s /usr/bin/python2 ~/bin/python
    $ ln -s /usr/bin/python2-config ~/bin/python-config

Finally put the new folder at the beginning of your PATH variable.

    $ export PATH=~/bin:$PATH

Note that this change is not permanent and is only active in the current
terminal session. To check which python interpreter is being used by
env, use the following command:

    $ which python

A similar approach in tricking the environment, which also relies on
#!/usr/bin/env python to be called by the script in question, is to use
a Virtualenv. When a Virtualenv is activated, the Python executable
pointed to by $PATH will be the one the Virtualenv was installed with.
Therefore, if the Virtualenv is installed with Python 2, python will
refer to Python 2. To start, install python2-virtualenv.

Then create the Virtualenv.

    $ virtualenv2 venv # Creates a directory, venv/, containing the Virtualenv

Activate the Virtualenv, which will update $PATH to point at Python 2.
Note that this activation is only active for the current terminal
session.

    $ source venv/bin/activate

The desired script should then run using Python 2.

Dealing with version problem in build scripts
---------------------------------------------

Many projects' build scripts assume python to be Python 2, and that
would eventually result in an error - typically complaining that
print 'foo' is invalid syntax. Luckily, many of them call python in the
$PATH instead of hardcoding #!/usr/bin/python in the shebang line, and
the Python scripts are all contained within the project tree. So,
instead of modifying the build scripts manually, there is an easy
workaround. Just create /usr/local/bin/python with content like this:

    /usr/local/bin/python

    /path/to/project2/*

Where /path/to/project2/* is a list of patterns separated by | matching
all project trees.

Don't forget to make it executable:

    # chmod +x /usr/local/bin/python

Afterwards scripts within the specified project trees will be run with
Python 2.

Integrated development environments
-----------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Can just point   
                           to                       
                           List_of_Applications#Int 
                           egrated_Development_Envi 
                           ronments                 
                           that we could integrate  
                           with the items not yet   
                           there. (Discuss)         
  ------------------------ ------------------------ ------------------------

There are some Python specific IDEs available in the official
repositories.

> Eclipse

Eclipse supports both Python 2.x and 3.x series by using the PyDev
extension.

> Eric

For the latest Python 3 compatible version, install the eric package.

Version 4 of Eric is Python 2 compatible and can be installed with the
eric4 package.

These IDEs can also handle Ruby.

> IEP

IEP is an interactive (e.g. MATLAB) python IDE with basic debugging
capabilities and is especially suitable for scientific computing. It is
provided by the package iep.

> Ninja

The Ninja IDE is provided by the package ninja-ide.

> Spyder

Spyder (previously known as Pydee) is a powerful interactive development
environment for the Python language with advanced editing, interactive
testing, debugging and introspection features. It focuses on scientific
computations, providing a matlab-like environment. It can be installed
with the package spyder

> PyCharm

PyCharm 3. The intelligent Python IDE with unique code assistance and
analysis, for productive Python development on all levels. The community
edition is available for free. pycharm-community

Getting easy_install
--------------------

The easy_install tool is available in the package python-setuptools.

Getting completion in Python shell
----------------------------------

Copy this into Python's interactive shell

    /usr/bin/python

    import rlcompleter
    import readline
    readline.parse_and_bind("tab: complete")

Source

Widget bindings
---------------

The following widget toolkit bindings are available:

-   TkInter — Tk bindings

http://wiki.python.org/moin/TkInter || standard module

-   pyQt — Qt bindings

http://www.riverbankcomputing.co.uk/software/pyqt/intro || python2-pyqt4
python2-pyqt5 python-pyqt4 python-pyqt5

-   pySide — Qt bindings

http://www.pyside.org/ || python2-pyside python-pyside

-   pyGTK — GTK+ 2 bindings

http://www.pygtk.org/ || pygtk

-   PyGObject — GTK+ 2/3 bindings via GObject Introspection

https://wiki.gnome.org/PyGObject/ || python2-gobject2 python2-gobject
python-gobject2 python-gobject

-   wxPython — wxWidgets bindings

http://wxpython.org/ || wxpython

To use these with Python, you may need to install the associated widget
kits.

Old versions
------------

Old versions of Python are available via the AUR and may be useful for
historical curiosity, old applications that don't run on current
versions, or for testing Python programs intended to run on a
distribution that comes with an older version (eg, RHEL 5.x has Python
2.4, or Ubuntu 12.04 has Python 3.1):

-   python15: Python 1.5.2
-   python16: Python 1.6.1
-   python24: Python 2.4.6
-   python25: Python 2.5.6
-   python26: Python 2.6.8
-   python30: Python 3.0.1
-   python31: Python 3.1.5
-   python32: Python 3.2.3

As of February 2014, Python upstream only supports Python 2.7, 3.1, 3.2,
and 3.3 for security fixes. Using older versions for Internet-facing
applications or untrusted code may be dangerous and is not recommended.

Extra modules/libraries for old versions of Python may be found on the
AUR by searching for python(version without decimal), eg searching for
"python26" for 2.6 modules.

Tips and tricks
---------------

IPython is a enhanced Python command line available in the official
repositories as ipython and ipython2.

See also
--------

-   Learning Python is one of the most comprehensive, up to date, and
    well-written books on Python available today.
-   Dive Into Python is an excellent (free) resource, but perhaps for
    more advanced readers and has been updated for Python 3.
-   A Byte of Python is a book suitable for users new to Python (and
    scripting in general).
-   Learn Python The Hard Way the best intro to programming.
-   facts.learnpython.org nice site to learn python.
-   Crash into Python Also known as Python for Programmers with 3 Hours,
    this guide gives experienced developers from other languages a crash
    course on Python.
-   Beginning Game Development with Python and Pygame: From Novice to
    Professional for games

For Fun
-------

Try the following snippets from Python's interactive shell:

    >>> import this

    >>> from __future__ import braces

    >>> import antigravity

Retrieved from
"https://wiki.archlinux.org/index.php?title=Python&oldid=305743"

Category:

-   Programming language

-   This page was last modified on 20 March 2014, at 01:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
