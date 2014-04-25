Umask
=====

Related articles

-   File permissions and attributes

The user file-creation mode mask (umask) is used to determine the file
permission for newly created files. It can be used to control the
default file permission for new files. It is a four-digit octal number.

Contents
--------

-   1 Setting the umask
-   2 Meaning of the umask value
-   3 Example
-   4 See also

Setting the umask
-----------------

You can set the umask value through the umask command. Most Linux
distributions set a default value of 0022 (022, including Arch [1]) or
0002 (002) in /etc/profile or in the default shell configuration files,
e.g. /etc/bashrc.

If you need to set a different value, you can either directly edit such
file, thus affecting all users, or call umask from your shell's user
configuration file, e.g. ~/.bashrc. Any changes will only take effect
after the next login.

Meaning of the umask value
--------------------------

The base permissions for directories are 0777 (rwxrwxrwx) and for files
they are 0666 (rw-rw-rw-).

Setting a umask value of 022 means that the write bit for the group (2
in the second place) and all other users (2 in the third place) are
cleared. This mask results in default permissions of 755 for directories
and 644 for files.

To calculate directory permissions for a umask value of 022:

Base permissions: 777

Subtract umask value: 022

Directory permissions: 755

To calculate file permissions for a umask value of 022:

Base permissions: 666

Subtract umask value: 022

File permissions: 644

Sample umask values and permissions:

  umask value   User   Group   Others
  ------------- ------ ------- --------
  0000          all    all     all
  0007          all    all     none
  0027          all    read    none

For more information, see man bash and man umask.

Example
-------

The following example explains the steps needed to set a umask value
that will result in permission values 700 for directories and 600 for
user files. The idea very simply is that only the user will be allowed
to read or write the file, or to access the contents of the directory.

Base permissions: 777 / 666

Subtract umask value: 077 / 077

Resulting permissions: 700 / 600

    $ umask 077
    $ touch file.txt
    $ mkdir directory

    $ ls -ld file.txt directory

    drwx------ 2 vivek vivek 4096 2007-02-01 02:21 directory
    -rw------- 1 vivek vivek    0 2007-02-01 02:21 file.txt

See also
--------

-   http://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html
    (the source of this article)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Umask&oldid=302879"

Categories:

-   Security
-   File systems

-   This page was last modified on 2 March 2014, at 10:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
