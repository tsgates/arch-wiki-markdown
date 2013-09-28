Umask
=====

The user file-creation mode mask (umask) is used to determine the file
permission for newly created files. It can be used to control the
default file permission for new files. It is a four-digit octal number.

Setting the UMASK
-----------------

You can setup the umask value in /etc/bashrc or /etc/profile for all
users. By default, most Linux distros set it to 0022 (022) or 0002
(002).

Open /etc/profile (global) or ~/.bashrc file

    # vi /etc/profile

or

    $ vi ~/.bashrc

Append/modify the following line to setup a new umask:

    umask 022

Save and close the file. Changes will take effect after next login.

But what is 0022 and 0002?

The default umask 0002 is used for regular users. With this mask,
default directory permissions are 775, and default file permissions are
664.

The default umask for the root user is 0022, and as a result, default
directory permissions are 755, and default file permissions are 644.

For directories, the base permissions are 0777 (rwxrwxrwx) and for files
they are 0666 (rw-rw-rw).

To calculate directory permissions for a umask value of 022 (root user):

    Default permission: 777
    Subtract umask value: 022 (-)
    Directory permission: 755

To calculate file permissions for a umask value of 022 (root user):

    Default permission: 666
    Subtract umask value: 022 (-)
    File permission: 644

The following example explains the steps needed to set a umask value
that will result in permission values 700 for directories and 600 for
user files. The idea very simply is that only the user will be allowed
to read or write the file, or to access the contents of the directory.

    Default permissions: 777 / 666
    Subtract umask value: 077 (-)
    Resulting permissions: 700 / 600

    $ umask 077
    $ touch file.txt
    $ mkdir directory
    $ ls -ld file.txt directory

Output:

    drwx------ 2 vivek vivek 4096 2007-02-01 02:21 directory
    -rw------- 1 vivek vivek    0 2007-02-01 02:21 file.txt

    Sample umask values and permissions
    umask value 	User 	Group 	Others
    0000 		all 	all 	all
    0007 		all 	all 	none
    0027 		all 	read 	none

For more information, see 'man bash' and 'help umask'.

See Also
--------

http://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html
(the source of this article)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Umask&oldid=241538"

Categories:

-   Security
-   File systems
