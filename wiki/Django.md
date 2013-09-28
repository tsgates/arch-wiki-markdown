Django
======

"Django is a high-level Python Web framework that encourages rapid
development and clean, pragmatic design."

Note:Django 1.5 is the first Django release with support for Python 3
(specifically, Python 3.2 and newer). Python 3 support is still
considered experimental, but there is a porting guide if you would like
to try it out.

Installation
------------

Install python-django or python2-django, for Python 3 or Python 2
support respectively, from the Official Repositories.

Usage
-----

Django is not used like other python libraries for the most part, but it
can be. After installation, you should be able to simply import django
in any python script.

    >>> import django

In order to start a project, use django-admin3.py.

    $ django-admin3.py startproject myproject

This will create the directory myproject under the current directory. It
will also create the manage.py script, which has more useful functions
for managing and testing your project. For instance, django has a small
test server built into manage.py.

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
"https://wiki.archlinux.org/index.php?title=Django&oldid=252785"

Category:

-   Development
