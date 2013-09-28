PHPUnit
=======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Running                                                            |
| -   3 Additional                                                         |
| -   4 Example                                                            |
| -   5 References                                                         |
+--------------------------------------------------------------------------+

Installing
----------

First of all, you need PEAR to install PHPUnit.

    pacman -S php-pear

Now you can do just like the official documentation. As root (sudo will
NOT be enough, You'll have to do this as "real" root), just type

    pear config-set auto_discover 1
    pear install pear.phpunit.de/PHPUnit

Notice that you might have to run following command before start to
install phpunit

    #pear clear-cache

Done.   

Running
-------

For running PHPUnit properly you must have the /usr/bin/ directory
listed in the open_basedir option at the /etc/php/php.ini

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/bin/

Or just unset it

    open_basedir =

Additional
----------

In some php framework, you will meet the error of missing Selenium. Just
install the selenium package with pear ( make sure you have root right )

     pear install phpunit/PHPUnit_Selenium

Example
-------

This section gives beginners a very brief introduction to how to use
PHPUnit to run test cases. It won't explain how to write them but if you
want to get more information about this have a look at the references.

As the application to be tested we use in this example a JSON schema
validator. In the directory tests you'll see the directory mock and
three files.

-   mock
-   JsonValidatorTest.php
-   bootstrap.php
-   phpunit.xml

mock contains JSON schemas which have nothing to do with PHPUnit itself,
it's application-specific here, you won't find it in other applications.

phpunit.xml is a configuration file where you

-   configure PHPUnit's core functionality,
-   compose a test suite out of test suites and test cases,
-   select groups of tests from a suite of tests that should (not) be
    run,
-   configure the blacklist and whitelist for the code coverage
    reporting,
-   configure the logging of the test execution,
-   attach additional test listeners to the test execution,
-   configure PHP settings, constants, and global variables or
-   configure a list of Selenium RC servers.

In bootstrap.php you put code to be run before tests are executed. Here
you could register your autoloading functions or include other php
scripts. Though there's one limitation, only one bootstrap can be
defined per PHPUnit configuration file.

JsonValidatorTest.php is the PHP file with the test cases. It's beyond
the scope to explain the content of this file in depth. As a beginner
you are most likely interested in how to run the test cases so what you
need to execute is simply

    phpunit JsonValidatorTest JsonValidatorTest.php

You pass it the class with the test cases and the file where they're
defined. That's it.

References
----------

-   Official PHPUnit Manual
-   Introduction to Unit Testing with PHPUnit

Retrieved from
"https://wiki.archlinux.org/index.php?title=PHPUnit&oldid=247698"

Category:

-   System administration
