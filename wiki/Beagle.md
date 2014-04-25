Beagle
======

Beagle is a desktop search daemon, similar to Spotlight on Mac OS X.

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: This article     
                           provides informations    
                           about an ancient piece   
                           of software not packaged 
                           in any way. The bigger   
                           part of the article      
                           (#Prerequisites)         
                           contains ancillar        
                           information instead of   
                           directly related ones.   
                           The latter part says     
                           nothing but "launch the  
                           daemon, a settings tool  
                           exists. Use it.".        
                           Official site is for     
                           sale. Probably Beagle    
                           does not work in a       
                           recent Mono VM. Much     
                           safer alternatives       
                           exist. (Discuss)         
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Prerequisites
    -   1.1 Enabling extended file attributes
    -   1.2 Increasing inotify value
-   2 Installation
-   3 Configuration
-   4 Autostart
-   5 Searching

Prerequisites
-------------

> Enabling extended file attributes

By default the Arch kernel has extended file attributes build in, if you
have built your own make sure you have it enabled in your kernel:

     File Systems -->
      <*> Second extended fs support
       [*]   Ext2 extended attributes
     
      <*> Ext3 journalling file system support
       [*]   Ext3 extended attributes
     
      <*> Reiserfs support
       [*]   ReiserFS extended attributes

You then need to mount the file system you wish to index with the
user_xattr option, to do this add it after 'defaults' in your
/etc/fstab, so you end up with something like this:

     /dev/sda2 / ext4 defaults,user_xattr 0 1

To use Beagle without restarting you can remount the filesystem with
this option:

     # mount -o remount,user_xattr /

> Increasing inotify value

Beagle uses the inotify subsystem of Linux in order to watch files for
changes. This enables Beagle to be notified of changes to files and
directories instead of having to rescan the filesystem.

By default the maximum number of watches is set to 8192, which is rather
low. Increasing this value will have no noticeable side effects, so you
can safely increase it. You can do this by adding the following to
/etc/sysctl.d/99-inotify.conf:

     fs.inotify.max_user_watches = 65536

This will take effect from the next reboot, however you can change it
right away by issuing the following command:

     # echo 65536 > /proc/sys/fs/inotify/max_user_watches

Installation
------------

Beagle is not available in Arch Linux. It depends on Mono, so if you do
not already have this installed there may be a lot of packages to
download.

     # pacman -S beagle

By default it comes with a GNOME GUI, which has a lot of GNOME
dependencies. If you do not want these you can compile a version which
does not include this. If you are using KDE there are various GUIs
available, including KBeagleBar and Kerry.

Configuration
-------------

Beagle will by default index your home directory, you can test that by
running the following command:

     $ beagled --debug --fg

After a few moments you should start to see your files being indexed.
After this press Ctrl+C to quit. Run the command again without
arguments, and it will start as a daemon.

     $ beagled

If you wish to exclude directories or change advanced settings, launch
the Beagle settings tool:

     $ beagle-settings

Autostart
---------

To autostart the daemon just setup your desktop environment to run the
last command on startup.

GNOME users can do this by clicking on the Desktop menu, going to
Preferences, then Sessions. In the Sessions dialog, choose the Startup
Programs tab, and add an entry which executes beagled.

Searching
---------

Under GNOME you can press the F12 key (unless you changed it) to launch
the search GUI. Under other desktop environments you need to run the
following command (or setup a hotkey):

     $ beagle-search

Retrieved from
"https://wiki.archlinux.org/index.php?title=Beagle&oldid=301731"

Category:

-   Search

-   This page was last modified on 24 February 2014, at 13:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
