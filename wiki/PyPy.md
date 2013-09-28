PyPy
====

PyPy is an alternate implementation of the Python 2.7.2 interpreter.
PyPy's benefits are in the area of speed, memory usage, sandboxing and
stacklessness. It is compatible with Cpython with
[http://pypy.org/compat.html some exceptions. PyPy also can be used to
compile Rpython programs to C code.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 Interactive Interpreter                                      |
|     -   2.2 Run Program From File                                        |
|                                                                          |
| -   3 EasyInstall                                                        |
|     -   3.1 EasyInstall Installation                                     |
|     -   3.2 Installing EasyInstall Packages                              |
|     -   3.3 EasyInstall Package Example                                  |
|                                                                          |
| -   4 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the pypy package from the official repositories.

PyPy is installed in /opt/pypy/ and the main pypy executable is
/opt/pypy/pypy-c

Usage
-----

Basic PyPy usage is done through the pypy command and functions
similarly to Cpython usage. Enter

    pypy -h

to view the listing of pypy options.

> Interactive Interpreter

To load the pypy interactive interpreter run

    pypy

> Run Program From File

To run a python program from a file in pypy run

    pypy example.py

where example.py is the file name of the program.

EasyInstall
-----------

Python libraries and programs can be installed in PyPy through
EasyInstall. PyPy libraries are stored in a different folder then
Cpython libraries.

> EasyInstall Installation

EasyInstall does not come with the PyPy package and must be installed
manually. Create the /opt/pypy/site-packages/ folder which will be
needed for the EasyInstall installation.

    sudo mkdir /opt/pypy/site-packages/

Download distribute_setup.py to the folder /opt/pypy/ and run it.
distribute_setup.py will install EasyInstall.

    cd /opt/pypy/
    sudo wget python-distribute.org/distribute_setup.py
    sudo pypy distribute_setup.py

EasyInstall is located at /opt/pypy/bin/easy_install

> Installing EasyInstall Packages

To install EasyInstall package package_name into PyPy enter

    sudo /opt/pypy/bin/easy_install package_name

Packages Will be Located at /opt/pypy/site-packages Installed libraries
and applications will be at /opt/pypy/bin Programs installed through
EasyInstall on PyPy can usually be ran with /opt/pypy/bin/program_name
where program_name is the name of the PyPy program.

> EasyInstall Package Example

The following will install the Lamson email framework.

    sudo /opt/pypy/bin/easy_install lamson

The following will run the framework's gen-project option

    /opt/pypy/bin/lamson gen -project testproject

See Also
--------

PyPy website

Python

Retrieved from
"https://wiki.archlinux.org/index.php?title=PyPy&oldid=241229"

Category:

-   Development
