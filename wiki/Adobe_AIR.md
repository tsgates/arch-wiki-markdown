Adobe AIR
=========

Adobe Integrated Runtime (AIR) is a cross-platform runtime environment
developed by Adobe Systems for building rich Internet applications using
Adobe Flash, Adobe Flex, HTML, or Ajax, that can be deployed as desktop
applications.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Adobe AIR                                               |
| -   2 Installing an AIR Application                                      |
|     -   2.1 Making it executable                                         |
|     -   2.2 Removing the application                                     |
+--------------------------------------------------------------------------+

Installing Adobe AIR
--------------------

Install adobe-air-sdk from the AUR.

Installing an AIR Application
-----------------------------

Download the application, and unzip it to /opt/airapps/<appname>. To run
it you can use the command

    $ /opt/adobe-air-sdk/bin/adl -nodebug /opt/airapps/<Application name>/META-INF/AIR/application.xml /opt/airapps/<Application name>/

> Making it executable

You can also make an executable by creating a file in /usr/bin:

     #! /bin/sh
     /opt/adobe-air-sdk/bin/adl -nodebug /opt/airapps/<Application name>/META-INF/AIR/application.xml /opt/airapps/wimp/

The app might need parameters (voddler) so then the script can look
like:

     #! /bin/sh
     /opt/adobe-air-sdk/bin/adl -nodebug /opt/airapps/<Application name>/META-INF/AIR/application.xml /opt/airapps/wimp/ -- $1 $2 $3 $4

Then chmod the file so that it can execute:

    $ chmod +x filename

Now you have installed an application in AIR. Yes it is this silly :P

> Removing the application

Delete the application folder in /opt/airapps. Also delete the
executable if you created one.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Adobe_AIR&oldid=239968"

Categories:

-   Development
-   Internet Applications
