Android Notifier
================

Android Notifier is a linux application that receives notifications on
sms, mms, battery status and more from your phone to your Linux, Mac or
Windows PC. This article is about installing and running it in the
background on Arch Linux.  
 You will need the android app Remote Notifier installed on your phone
which is available for free at Market.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Installation                                                       |
| -   3 Adjust for Arch Linux (bugfix)                                     |
| -   4 Configuration                                                      |
| -   5 Starting android-notifier                                          |
+--------------------------------------------------------------------------+

Prerequisites
-------------

-   Android app installed on your phone: Remote Notifier by Rodrigo
    Damazio, from Market.
    -   Author's site
    -   More at Appbrain

-   Port 10600 tcp/udp open in your firewall (iptables rules coming
    soon...)

Installation
------------

Get it from AUR: android-notifier-desktop

Dependencies: java-runtime

Adjust for Arch Linux (bugfix)
------------------------------

Note:Since version 0.5.1-2 (introduced 25-07-2011) this bugfix is
already incorporated in the PKGBUILD and there is no need for manual
modifications.

By editing /usr/share/android-notifier-desktop/run.sh change

    java -DconfigDir=$configDir -Djava.util.prefs.userRoot=$configDir/android-notifier-desktop -Djava.net.preferIPv4Stack=true -client -Xms8m -Xmx32m -jar android-notifier-desktop.jar $1

to

    java -DconfigDir=$configDir -Djava.util.prefs.userRoot=$configDir/android-notifier-desktop -Djava.net.preferIPv4Stack=true -client -Xms8m -Xmx32m -jar /usr/share/android-notifier-desktop/android-notifier-desktop.jar $1

(use the full path to file
/usr/share/android-notifier-desktop/android-notifier-desktop.jar)

  
 If not applied, the error "The file android-notifier-desktop.jar
couldn't be found" is shown and it will not start.

More about bugfix

Configuration
-------------

To configure android-notifier, run
'/usr/share/android-notifier-desktop/run.sh -p'

To show help run '/usr/share/android-notifier-desktop/run.sh -h'

Starting android-notifier
-------------------------

Add this command to for example .xinitrc;
'/usr/share/android-notifier-desktop/run.sh &'   
Or just run it from terminal.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Android_Notifier&oldid=233672"

Category:

-   Status monitoring and notification
