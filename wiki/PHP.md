PHP
===

PHP is a widely-used general-purpose scripting language that is
especially suited for Web development and can be embedded into HTML.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Setup                                                              |
| -   3 Configuration                                                      |
|     -   3.1 Extensions                                                   |
|                                                                          |
| -   4 Zend Core + Apache                                                 |
| -   5 Development tools                                                  |
|     -   5.1 Komodo                                                       |
|     -   5.2 Netbeans                                                     |
|     -   5.3 Eclipse PDT                                                  |
|     -   5.4 Zend Studio                                                  |
|     -   5.5 Aptana Studio                                                |
|     -   5.6 Zend Code Analyzer                                           |
|         -   5.6.1 Installation                                           |
|         -   5.6.2 Vim Integration                                        |
|         -   5.6.3 Eclipse Integration                                    |
|         -   5.6.4 Komodo Integration                                     |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 PHP Fatal error: Class 'ZipArchive' not found                |
+--------------------------------------------------------------------------+

Installation
------------

Install the php package from the official repositories.

A number of commonly used PHP extensions can also be found in the
official repository:

    # pacman -Ss php-

Setup
-----

While PHP can be run standalone, it is typically used with http servers
such as apache, nginx and lighttpd.

-   nginx: see Nginx page.
-   apache: to setup PHP, Apache and MySQL, commonly known as the LAMP,
    see LAMP article.
-   lighttpd: see Lighttpd article.

Configuration
-------------

The main PHP confiuration file is well-documented and located at
/etc/php/php.ini.

> Extensions

For php-gd uncomment the line

    extension=gd.so

Zend Core + Apache
------------------

Zend Core is the official PHP distribution provided by zend.com. It
includes an installer/updater, zend optimizer, oracle support, and
necessary libraries. However, it lacks support for postgresql, firebird,
and odbc.

-   Install mod_fcgid (pacman -S mod_fcgid), a FastCGI module for apache
    (the official one sucks).
-   Install Zend Core (official php distribution)
    -   Uninstall arch linux's php package.
    -   Download and install zend core from [1] ; don't install the
        bundle apache or tell it to setup your web server. It always
        installs to /usr/local/Zend/Core due to hard-coded path.
    -   Create a script /usr/local/bin/zendcore and create symlinks to
        php, php-cgi, pear, phpize under /usr/local/bin  
        #!/bin/bash                                                                                                                                       export LD_LIBRARY_PATH="/usr/local/Zend/Core/lib"exec /usr/local/Zend/Core/bin/`basename $0` "$@"

-   Setup Apache:
    -   In /etc/httpd/conf/httpd.conf, add  
        LoadModule fcgid_module lib/apache/mod_fcgid.so<Directory /srv/http>AddHandler fcgid-script .phpFCGIWrapper /usr/local/bin/php-cgi .phpOptions ExecCGIAllow from all</Directory>SocketPath /tmp/fcgidsockSharememPath /tmp/fcgidshm
    -   Remember to change the Directory path

-   Disable Zend Optimizer (so you can use cache):
    -   Edit /etc/php.ini, uncomment the following line near the end of
        file:  
        zend_extension_manager.optimizer="/usr/local/Zend/Core/lib/zend/optimizer"

-   Install APC (Alternative PHP Cache):
    -   Run pear install pecl.php.net/apc as superuser.
    -   Edit /etc/php.ini, add the line after "; Zend Core
        extensions..." (line 1205):  
        extension=apc.so

-   Update Zend Core and/or install other components
    -   Just run /usr/local/Zend/Core/setup

Development tools
-----------------

> Komodo

Good integration for PHP+HTML+JavaScript. Lacks code formatting and
unicode support in doc comments.

Komodo IDE | Komodo Edit (free)

Add custom encodings:

-   Edit
    KOMODO_INSTALL_DIR/lib/mozilla/components/koEncodingServices.py,
    line 84, add:

     ('cp950', 'Chinese(CP-950/Big5)', 'CP950', '', 1,'cp950'),
     ('cp936', 'Chinese(CP-936/GB2312)', 'CP936', '', 1,'cp936'),
     ('GB2312', 'Chinese(GB-2312)', 'GB2312', '', 1,'GB2312'),
     ....

The format is (encoding name in python, description, short description,
BOM, is ASCII-superset?, font encoding)

> Netbeans

A complete IDE for many languages including PHP. Includes features like
debugging, refactoring, code tempalting, autocomplete, XML features, and
web design and development functionalities (very good CSS autocomplete
functionality and PHP/JavaScript code notifications/tips).

> Eclipse PDT

Eclipse PDT is not very complete at the current stage (v0.7); for
instance, it cannot pop-up class list automatically when you type,
though you can add custom auto-activation trigger keys.

You would need other plugins for javascript support and DB query.

> Zend Studio

Zend Studio is the official PHP IDE, based on eclipse. The IDE has
autocomplete, advanced code formatting, WYSIWYG html editor,
refactoring, and all the eclipse features such as db access and version
control integration and whatever you can get from other eclipse plugins.

> Aptana Studio

A good IDE for programming in PHP and web development. The current
version (3.2.2) does not have a PHP debugger.

> Zend Code Analyzer

A PHP code analyzer from Zend Studio. The program is indispensable for
any serious PHP coding.

Installation

-   Download and install Zend Studio Neon
-   In the installation dir, run find . -name "ZendCodeAnalyzer to get
    the path.
-   Copy ZendCodeAnalyzer to /usr/local/bin/zca
-   Now you can remove zend studio; you won't need a key or anything.

Vim Integration

Add the following lines into your .vimrc:

    autocmd FileType php setlocal makeprg=zca\ %<.php
    autocmd FileType php setlocal errorformat=%f(line\ %l):\ %m

Eclipse Integration

Error Link plugin:

-   Symlink zca to build.zca (so Error Link can recognize it)
-   Install Sunshade plugin suite;
-   Preference -> Sunshade -> Error Link -> Add:
    ^(.*\.php)\(line (\d+)\): ()(.*)
-   Run -> External Tools -> Open External Tools Dialog -> Select
    "Program" -> Clicn on "New":  
    Name: Zend Code Analyzer  
    Location: /usr/local/bin/build.zca  
    Working Directory: ${container_loc}  
    Arguments: --recursive ${resource_name}

Komodo Integration

Toolbox -> Add -> New Command:

-   Command: zca --recursive %F
-   Run in: Command Output Tab
-   Parse output with:
    ^(?P<file>.+?)\(line (?P<line>\d+)\): (?P<content>.*)$
-   Select Show parsed output as a list

Troubleshooting
---------------

> PHP Fatal error: Class 'ZipArchive' not found

Ensure the zip extension is enabled.

    $ grep zip /etc/php/php.ini
    extension=zip.so

Retrieved from
"https://wiki.archlinux.org/index.php?title=PHP&oldid=242978"

Category:

-   Programming language
