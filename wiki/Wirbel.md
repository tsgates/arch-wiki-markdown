Wirbel
======

Note:Development is now discontinued. see Bye! Goodbye Note

Wirbel is a new programming language created by Mathias Kettner in 2008,
its syntax clearly resembles the Python programming language in many
ways.

However, the main difference is that Wirbel is a compiled language,
meaning that it runs very fast, and as it is compiled doesn't need a
runtime environment-meaning no need to have Wirbel on your computer to
run Wirbel compiled program.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Tips and Tricks                                                    |
|     -   2.1 Example                                                      |
|     -   2.2 Compilation                                                  |
|                                                                          |
| -   3 More Resources                                                     |
+--------------------------------------------------------------------------+

Installation
------------

The package is available in the AUR

Tips and Tricks
---------------

> Example

Wirbel "hello world" example

    #!/usr/bin/wirbel
    #Filename:helloworld.w

    print ("Hello World")

> Compilation

wic runs the Wirbel compiler

  
 type 'wic foo.w', with foo being the filename you wish to compile

    wic foo.w

Now you can run the program with

    ./foo.w

Alternatively, you can run the script

    wirbel foo.w

More Resources
--------------

-   Wirbel Homepage The Homepage of the Wirbel programming language

-   Wirbel tutorials Great tutorials, still a work in progress though

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wirbel&oldid=202753"

Category:

-   Programming language
