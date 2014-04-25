Adobe AIR
=========

Adobe Integrated Runtime (AIR) is a cross-platform runtime environment
developed by Adobe Systems for building rich Internet applications using
Adobe Flash, Adobe Flex, HTML, or Ajax, that can be deployed as desktop
applications.

Contents
--------

-   1 Installing Adobe AIR
-   2 Installing an AIR Application
    -   2.1 Making it executable
    -   2.2 Removing the application
    -   2.3 Running binaries that use AIR

Installing Adobe AIR
--------------------

Install adobe-air-sdk from the AUR.

Installing an AIR Application
-----------------------------

Download the application, and unzip it to /opt/airapps/<appname>. To run
it you can use the command

    $ /opt/adobe-air-sdk/bin/adl -nodebug /opt/airapps/<Application name>/META-INF/AIR/application.xml /opt/airapps/<Application name>/

> Making it executable

You can also make an executable by creating a file in /usr/local/bin:

     #!/usr/bin/sh
     /opt/adobe-air-sdk/bin/adl -nodebug /opt/airapps/<Application name>/META-INF/AIR/application.xml /opt/airapps/wimp/

The app might need parameters (voddler) so then the script can look
like:

     #!/usr/bin/sh
     /opt/adobe-air-sdk/bin/adl -nodebug /opt/airapps/<Application name>/META-INF/AIR/application.xml /opt/airapps/wimp/ -- ${@}

Then chmod the file so that it can execute:

    $ chmod +x filename

Now you have installed an application in AIR. Yes it is this silly :P

> Removing the application

Delete the application folder in /opt/airapps. Also delete the
executable if you created one.

> Running binaries that use AIR

Some applications using Adobe AIR can come with their own binaries
included. In this case, it's often better to run these binaries, rather
than bypassing them using adl, to not lose any extra functionality these
binaries might provide. These binaries will require some work however,
before they can be used with the Adobe AIR SDK.

First of all, binaries will look for Adobe AIR, rather than the Adobe
AIR SDK. There seems to be no way to change where to look, so you're
going to have to symlink the Adobe AIR runtime provided with the SDK to
the default location that binaries follow:

     # ln -s /opt/adobe-air-sdk/runtimes/air/linux/Adobe\ AIR/ /opt/Adobe\ AIR

With this, the binaries should be able to detect your Adobe AIR
installation. It will leave you with two Adobe AIR folders in  /opt,
which is dirty but there seems to be no way around this for now.

Another problem you'll run into is that whenever the AIR runtime starts
a process, it'll check whether you have accepted the EULA, something
that is not included with the SDK. Since it can't determine that you
did, it then tries to run the Adobe AIR Updater, which is ALSO not
included in the SDK runtime, causing the binary to fail and hang. To
avoid this you're going to have to manually accept the EULA.

Warning: By creating the following file you are most likely accepting
the Adobe AIR End User License Agreement. Make sure to read this
agreement, and do not perform this work-around if you do not agree with
it.

  
 To manually accept the EULA, use this command:

    echo -n 2 > ~/.appdata/Adobe/AIR/eulaAccepted

After this, you should clear the check and the binary should run
normally.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Adobe_AIR&oldid=302620"

Categories:

-   Development
-   Internet applications

-   This page was last modified on 1 March 2014, at 04:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
