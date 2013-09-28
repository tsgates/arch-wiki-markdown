Stata
=====

STATA is a general-purpose statistical software package for *nix,
Windows and Mac. In the following you'll be presented with how to
install STATA and the needed libraries.

Needed libraries
----------------

You need to install a series of libraries to run Stata. Stata uses the
GTK+ framework.

If you use GNOME, you'll need the following additional packages.

> GNOME

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: symlink like     
                           this is always frowned   
                           upon. If so name is      
                           changed, it usually      
                           means not backward       
                           compatiable. So fix the  
                           package or rebuild it.   
                           Do not use this walk     
                           around. (Discuss)        
  ------------------------ ------------------------ ------------------------

You need the package libgtksourceviewmm2 which is found in the
'[community]' repository.

After you have installed the package, you need to create a symlink from
libgtksourceview-2.0.so.0 to libgtksourceview-1.0.so.0. To do this run
this command as root:

    ln -s /usr/lib/libgtksourceview-2.0.so.0 /usr/lib/libgtksourceview-1.0.so.0

You also need the package libgnomeprint which is available in the AUR.

Installing Stata
----------------

After you have installed these packages, you need to insert your STATA
DVD and mount it.

If you have been provided an ISO rather than a physical DVD you can
mount it with the following command

    mount -o loop /path/to/file.iso /mnt

If you have been provided a DVD and it is not automatically mounted, you
can use the following command to mount it to /mnt

    mount -t iso9660 -o ro /dev/cdrom /mnt

  
 You then need to create a directory for Stata. Stata recommends putting
it under /usr/local/

    Create a directory

     mkdir /usr/local/stata12

Once you've created the directory, change into the directory:

    cd /usr/local/stata12

And run the installer from the directory you mounted the CD into(/mnt in
this guide):

    /mnt/installer

Follow the instructions and you'll end up with Stata installed.

After you have installed Stata, change the permissions on
/usr/local/stata12 so you can execute it as a normal user:

    chmod -R 755 /usr/local/stata12

Retrieved from
"https://wiki.archlinux.org/index.php?title=Stata&oldid=247075"

Category:

-   Status monitoring and notification
