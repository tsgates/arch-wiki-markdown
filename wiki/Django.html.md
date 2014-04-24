Django
======

"Django is a high-level Python Web framework that encourages rapid
development and clean, pragmatic design."

Note:Django 1.5 is the first Django release with support for Python 3
(specifically, Python 3.2 and newer). Starting with Django 1.6, Python 3
support is no longer considered experimental. The porting guide provides
details for developers wishing to support both Python 2 and 3 with their
projects.

Installation
------------

Install python-django or python2-django, for Python 3 or Python 2
support respectively, from the Official repositories.

Usage
-----

Django is not used like other python libraries for the most part, but it
can be. After installation, you should be able to simply `import django`
in any python script.

    >>> import django

In order to start a project under Python 2, use django-admin.py.

    $ django-admin.py startproject myproject

If you wish to start a project under Python 3, use django-admin3.py.

    $ django-admin3.py startproject myproject

This will create the directory myproject under the current directory. It
will also create the manage.py script, which has more useful functions
for managing and testing your project. For instance, Django has a small
test server built into manage.py.

Note:The following commands assume you are running Django under Python
2. If you would like to try Python 3 support, substitute `python2` for
`python`.

    $ python2 manage.py runserver
    Validating models...
    0 errors found

    Django version 1.1, using settings 'modsite.settings'
    Development server is running at http://127.0.0.1:8000/
    Quit the server with CONTROL-C.

It can be changed to run at, say, port 8080 like so.

    $ python2 manage.py runserver 8080
    Validating models...
    0 errors found

    Django version 1.1, using settings 'modsite.settings'
    Development server is running at http://127.0.0.1:8080/
    Quit the server with CONTROL-C.

For more help, please see the Django Book or Official Django
Documentation

eric-IDE Tips & Tricks
----------------------

Eric is a good IDE for Django. It has Highlighting, Autocompletion, CVS
& Subversion, Debugger, and Breakpoints.

eric (Python 3) and eric4 (Python 2) can be installed from the official
repositories.

To start a new Django Project.

First click on the "Project/new." Then under "Project Type" select
Django. After your new django project has been created, Right-click on
the "Project Viewer", to the Left, and select "Configure", and in the
configuration window set "Project type" to Django.

After that, in eric4's "Settings/Preferences" select Django, from the
left, and add this change to the "Console Command."

If KDE,

    konsole --workdir `pwd` -e
    konsole --workdir `pwd` --noclose -e

This will solve the problem...

    /usr/bin/python2: can't open file 'manage.py': [Errno 2] No such file or directory

Note the "Django" menu next to "Project" and "Extras". There you will
find Django tools to runserver and sync database.

Now, just play around with it a little. All your Python code will be
Added to the first tab of the "Project-Viewer" and your html templates
will be opened in the second tab.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Django&oldid=303557"

Category:

-   Development

-   This page was last modified on 8 March 2014, at 02:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
