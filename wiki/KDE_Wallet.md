KDE Wallet
==========

KDE Wallet Manager is a tool to manage the passwords on your KDE system.
By using the KDE wallet subsystem it not only allows you to keep your
own secrets but also to access and manage the passwords of every
application that integrates with the KDE wallet.

Using the KDE Wallet to store ssh keys
--------------------------------------

Install Ksshaskpass from comunity repo:

    pacman -S ksshaskpass

Create the file

    ~/.kde4/Autostart/ssh-add.sh

Add this content

    #!/bin/sh
    ssh-add </dev/null

  
 Make it executable and run

    chmod +x ~/.kde4/Autostart/ssh-add.sh
    ~/.kde4/Autostart/ssh-add.sh

You may also have to source the script that sets the SSH_ASKPASS
environment variable:

    . /etc/profile.d/ksshaskpass.sh

It will ask for your password and unlock the your ssh keys.

You may need to go to system settings -> advanced -> Autostart -> add
script in newer version of KDE.

KDE Wallet for firefox
----------------------

There is an addon to make firefox store passwords with KDE wallet.

http://kde-apps.org/content/show.php/Firefox+addon+for+kwallet?content=116886

KDE Wallet for chromium
-----------------------

Chromium has built in wallet integration.

To enable it you should run your Chromium browser by adding
--password-store=kwallet or --password-store=detect.

While second option SHOULD be default it happened to not working for
author, so it's if it's happening to You, invoke Your browser with:

    chromium --password-store=kwallet

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDE_Wallet&oldid=250990"

Category:

-   Desktop environments
