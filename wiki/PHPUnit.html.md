PHPUnit
=======

Installing
----------

By far the easiest way to install is using the PHP Archive (PHAR)
package provided by the project. The PHAR package contains all
dependencies as well as some of the optional dependencies for PHPUnit.
The latest version can be retrieved from the project's site:

    wget https://phar.phpunit.de/phpunit.phar

Note:PHPUnit is also avalible from the AUR as phpunit.

  

You can then run PHPUnit using php phpunit.phar. You can also make the
PHP Archive executable (chmod +x phpunit.phar) and move it to
/usr/local/bin or ~/bin or somewhere else you have in your $PATH.

Note:You have to enable extension=phar.so in your php.ini for PHP to be
able to run PHP Archive/PHAR files.

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
"https://wiki.archlinux.org/index.php?title=PHPUnit&oldid=302274"

Category:

-   System administration

-   This page was last modified on 27 February 2014, at 03:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
