File Permissions and Attributes
===============================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Viewing permissions                                                |
|     -   1.1 What the columns mean                                        |
|     -   1.2 What the permissions mean                                    |
|         -   1.2.1 Folders                                                |
|         -   1.2.2 Files                                                  |
|                                                                          |
| -   2 Changing permissions using the chmod command                       |
|     -   2.1 Text method                                                  |
|         -   2.1.1 Text method shortcuts                                  |
|         -   2.1.2 Copying permissions                                    |
|                                                                          |
|     -   2.2 Numeric method                                               |
|     -   2.3 Selective chmod                                              |
|                                                                          |
| -   3 Changing ownership using the chown command                         |
| -   4 Reference table                                                    |
| -   5 Extended file attributes                                           |
|     -   5.1 chattr and lsattr                                            |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Viewing permissions
-------------------

In order to use chmod to change permissions of a file or directory, you
will first need to know what the current mode of access is. You can view
the contents of a directory in the terminal by "cd" to that directory
and then using:

    $ ls -l 

The -l switch is important because using ls without it will only display
the names of files or folders in the directory.

Below is an example of using ls -l on my home directory:

    [ben@ben ~]$ ls -l
    total 128
    -rw-r--r-- 1 ben users   832 Jul  6 17:22 #chmodwiki#
    drwxr-xr-x 2 ben users  4096 Jul  5 21:03 Desktop
    drwxr-xr-x 6 ben users  4096 Jul  5 17:37 Documents
    drwxr-xr-x 2 ben users  4096 Jul  5 13:45 Downloads
    drwxr-xr-x 2 ben users  4096 Jun 24 03:36 Movies
    drwxr-xr-x 2 ben users  4096 Jun 24 03:38 Music
    -rw-r--r-- 1 ben users 57047 Jun 24 13:57 Namoroka_wallpaper.png
    drwxr-xr-x 2 ben users  4096 Jun 26 00:09 Pictures
    drwxr-xr-x 3 ben users  4096 Jun 24 05:03 R
    -rw-r--r-- 1 ben users   354 Jul  6 17:15 chmodwiki
    -rw-r--r-- 1 ben users  5120 Jun 27 08:28 data
    -rw-r--r-- 1 ben users  3339 Jun 27 08:28 datadesign
    -rw-r--r-- 1 ben users  2048 Jul  6 12:56 dustprac
    -rw-r--r-- 1 ben users  1568 Jun 27 14:11 dustpracdesign
    -rw-r--r-- 1 ben users  1532 Jun 27 14:07 dustpracdesign~
    -rw-r--r-- 1 ben users   229 Jun 27 14:01 ireland.R
    -rw-r--r-- 1 ben users   570 Jun 27 17:02 noattach.R
    -rw-r--r-- 1 ben users   588 Jun  5 15:35 noattach.R~

> What the columns mean

The first column is the permissions of each file. if it begins with a -
it is a normal file, if it begins with a d, then it is a directory i.e.
a folder containing other files or folders. The letters after that are
the permissions, this first column is what we will be most interested
in. The second one is how many links there are in a file, we can safely
ignore it. The third coloumn has two values/names: The first one (in my
example 'ben') is the name of the user that owns the file. The second
value ('users' in the example) is the group that the owner belongs to
(Read more about groups).

The next column is the size of the file or directory in bytes and
information after that are the dates and times the file or directory was
last modified, and of course the name of the file or directory.

> What the permissions mean

The first three letters, after the first - or d, are the permissions the
owner has. The next three letters are permissions that apply to the
group. The final three letters are the permissions that apply to
everyone else. Each set of three letters is made up of r w and x. r is
always in the first position, w is always in the second position, and x
is always in the third position. r is the read permission, w is the
write permission, and x is the execute permission. If there is a hyphen
(-) in the place of one of these letters it means the permission is not
granted, and if the letter is present then it is granted.

Folders

In case of folders the mode bits can be interpreted as follows:

-   r (read) stands for the ability to read the table of contents of the
    given directory,
-   w (write) stands for the ability to write the table of contents of
    the given directory (create new files, folders; rename, delete
    existing files, folders) if and only if execute bit is set.
    Otherwise this permission is meaningless.
-   x (execute) stands for the ability to enter the given directory with
    command cd and access files, folders in that directory.

Let's see some examples to clarify, taking one directory from above:

    # Ben has full access to the Documents directory.
    # He can list, create files and rename, delete any file in Documents,
    # regardless of file permissions.
    # His ability to access a file depends on the file's permission. 
    drwx------ 6 ben users  4096 Jul  5 17:37 Documents

    # Ben has full access except he can not create, rename, delete
    # any file.
    # He can list the files and (if file's permission empowers) 
    # may access an existing file in Documents.
    dr-x------ 6 ben users  4096 Jul  5 17:37 Documents

    # Ben can not do 'ls' in Documents but if he knows
    # the name of an existing file then he may list, rename, delete or
    # (if file's permission empowers him) access it.
    # Also, he is able to create new files.
    d-wx------ 6 ben users  4096 Jul  5 17:37 Documents

    # Ben is only capable of (if file's permission empowers him) 
    # access those files in Documents which he knows of.
    # He can not list already existing files or create, rename,
    # delete any of them.
    d--x------ 6 ben users  4096 Jul  5 17:37 Documents

You should keep in mind that we elaborate on directory permissions and
it has nothing to do with the individual file permissions. When you
create new file it is the directory what changes, that is why you need
write permission to the directory.

Note:to keep out graphical file managers, you ought to remove r, not x.

Files

Let's look at another example, this time of a file, not a directory:

    -rw-r--r-- 1 ben users  5120 Jun 27 08:28 data

    - rw- r-- r-- 1 ben users 5120 Jun 27 08:28 data (Split the permissions coloumn again for easier interpretation)

Here we can see the first letter is not d but -. So we know it is a
file, not a directory. Next the owners permissions are rw- so the owner
has the ability to read and write but not execute. This may seem odd
that the owner does not have all three permissions, but the x permission
is not needed as it is a text/data file, to be read by a text editor
such as Gedit, EMACS, or software like R, and not an executable in it's
own right (if it contained something like python programming code then
it very well could be). The group's permssions are set to r--, so the
group has the ability to read the file but not write/edit it in any way
- it is essentially like setting something to Read-Only. We can see that
the same permissions apply to everyone else as well.

Changing permissions using the chmod command
--------------------------------------------

chmod is a command in Linux and other Unix-like operating systems. It
allows you to change the permissions (or access mode) of a file or
directory.

> Text method

To change the permissions-or access mode-of a file, we use the chmod
command in a terminal. Below is the command's general structure:

    chmod who=permissions filename

Where Who is any from a range of letters, and each signifies who you are
going to give the permission to. They are as follows:

    u - The user that own the file.
    g - The group the file belongs to.
    o - The other users i.e. everyone else.
    a - all of the above - use this instead of having to type ugo.

The permissions are the same as already discussed (r, w, and x).

Lets have a look at some exaples now using this command. Suppose I
became very protective of my Documents directory and wanted to deny
everybody but myself permissions to read, write, and execute (or in this
case search/look) in it:

    Before: drwxr-xr-x 6 ben users  4096 Jul  5 17:37 Documents

    Command 1: chmod g= Documents
    Command 2: chmod o= Documents

    After: drwx------ 6 ben users  4096 Jul  6 17:32 Documents

Here, because I want to deny permissions, I do not put any letter after
the = where permissions would be entered. Now you can see that only the
owners permissions are rwx and all other permissions are -'s.

This can be reverted back again:

    Before: drwx------ 6 ben users  4096 Jul  6 17:32 Documents

    Command 1: chmod g=rx Documents
    Command 2: chmod o=rx Documents

    After: drwxr-xr-x 6 ben users  4096 Jul  6 17:32 Documents

This time I wanted to grant read and execute permissions to the group,
and other users, so I put the letters for the permissions (r and x)
after the =, with no spaces.

You can simplify this to put more than one who letter in the same
command e.g:

    chmod go=rx Documents

Note: It does not matter which order you put the who letters or the
permission letters in a chmod command: you could have chmod go=rx File
or chmod og=xr File. It's all the same.

Now let's consider a second example, say I wanted to change my data file
so as I have read and write permissions and fellow users in my group
users who may be colleagues working with me on data can also read an
write to it, but other users can only read it:

    Before: -rw-r--r-- 1 ben users  5120 Jun 27 08:28 data

    Command1: chmod g=rw data

    After: -rw-rw-r-- 1 ben users  5120 Jun 27 08:28 data

This is exactly like the first example, but with a data file, not a
directory, and I granted a write permission (Just so as to give an
example of granting every permission).

Text method shortcuts

The chmod command lets us add and subtract permissions from an existing
set using + or minus instead of =. This is different to the above
commands, which essentially re-write the permissions (i.e. to change a
permission from r-- to rw-, you still need to include r as well as w
after the = in the chmod command. If you missed out r, it would take
away the r permission as they are being re-written with the =. Using +
and - avoid this by adding or taking away from the current set of
permissions).

Lets try this + and - method with the previous example of adding write
permissions to the group:

    Before: -rw-r--r-- 1 ben users 5120 Jun 27 08:28 data

    Command: chmod g+w data

    After: -rw-rw-r-- 1 ben users  5120 Jun 27 08:28 data

Heres another example, denying write permissions to all (a):

    Before: -rw-rw-r-- 1 ben users  5120 Jun 27 08:28 data

    Command: chmod a-w data

    After: -r--r--r-- 1 ben users  5120 Jun 27 08:28 data

Copying permissions

It is possible to tell chmod to copy the permissions from one class, say
the owner, and give those same permissions to group or even all. To do
this, instead of putting r, w, or x after the =, we put another who
letter. e.g:

    Before: -rw-r--r-- 1 ben users 5120 Jun 27 08:28 data

    Command: chmod g=u data

    After: -rw-rw-r-- 1 ben users 5120 Jun 27 08:28 data

This command essentially translates to "change the permissions of group
(g=), to have the same as owning user (=u). Note that you can't copy a
set of permissions as well as grant new ones e.g.:

    chmod g=wu data

Because chmod will have a small fit and throw you an error.

> Numeric method

chmod can also set permissions using numbers.

Using numbers is another method which allows you to edit the permissions
for all three owner, group, and others at the same time. This basic
structure of the code is this:

    chmod xxx file/directory

Where xxx is a 3 digit number where each digit can be anything from 1 to
7. The first digit applies to permissions for owner, the second digit
applies to permissions for group, and the third digit applies to
permissions for all others.

In this number notation, the values r, w, and x have their own number
value:

    r=4
    w=2
    x=1

To come up with a three digit number you need to consider what
permissions you want owner, group, and user to have, and then total
their values up. For example, say I wanted to grant the owner of a
directory read write and execution permissions, and I wanted group and
everyone else to have just read and execute permissions. I would come up
with the numerical values like so:

    Owner: rwx = 4+2+1=7
    Group: r-x = 4+0+1=5 (or just 4+1=5)
    Other: r-x = 4+0+1=5 (or just 4+1=5)

    Final number = 755

    Command: chmod 755 filename

This is the equivalent of using the following:

    chmod u=rwx filename
    chmod go=rx filename

Most folders/directories are set to 755 to allow reading and writing and
execution to the owner, but deny writing to everyone else, and files are
normally 644 to allow reading and writing for the owner but just reading
for everyone else, refer to the last note on the lack of x permissions
with non executable files - its the same deal here.

To see this in action with examples consider the previous example I've
been using but with this numerical method applied instead:

    Before: -rw-r--r-- 1 ben users  5120 Jun 27 08:28 data

    Command: chmod 664 data

    After: -rw-rw-r-- 1 ben users  5120 Jun 27 08:28 data

If this were an executable the number would be 774 if I wanted to grant
executable permission to the owner and group. Alternatively if I wanted
everyone to only have read permission the number would be 444. Treating
r as 4, w as 2, and x as 1 is probably the easiest way to work out the
numerical values for using chmod xxx filename, but there is also a
binary method, where each permission has a binary number, and then that
is in turn converted to a number. It is a bit more convoluted, but I
include it for completeness.

Consider this permission set:

- rwx r-x r--

If you put a 1 under each permission granted, and a 0 for every one not
granted, the result would be something like this:

    - rwx rwx r-x
     111 111 101  

You can then convert these binary numbers:

    000=0	    100=4
    001=1	    101=5
    010=2	    110=6
    011=3	    111=7

The value of the above would therefore be 775.

Consider we wanted to remove the writable permission from group:

    - rwz r-x r-x
     111 101 101

The value would therefore be 755 and you would use chmod 755 filename to
remove the writable permission. You will notice you get the same three
digit number no matter which method you use. Whether you use text or
numbers will depend on personal preference and typing speed. When you
want to restore a directory or file to default permissions i.e. read and
write (and execute) permission to the owner but deny write permission to
everyone else, it may be faster to use chmod 755/644 directory/filename.
But if you are changing the permissions to something out of the norm, it
may be simpler and quicker to use the text method as opposed to trying
to convert it to numbers, which may lead to a mistake. It could be
argued that there isn't any real significant difference in the speed of
either method for a user that only needs to use chmod on occasion.

> Selective chmod

Since folders should be chmod to 755 and files to 644 in PHP-.Nuke, you
need a means of applying the above command only to files, or only to
folders. No problem with pipes, just do Code:

    find directory/ -type d -print0 | xargs -0 chmod 755

    find directory/ -type f -print0 | xargs -0 chmod 644

The "/" after the directory name is important here. The "-type" option
selects the appropriate file type (directory of file), the "-print0"
option terminates the names wih a zero, so that filenames with blanks
are recognized properly (since filename terminator is now a zero and not
a blank). xargs applies the following command (chmod) to any arguments
passed to it by the pipe, -0 indicates again that the argument separator
is a zero and not a blank.

If you use some Windows program, search for some settings. I know that
WS_FTP has a graphical interface to chmod, see for example How to chmod
using WS_FTP. Just select all the files you want the change to apply to
and follow the instructions in that link.

Changing ownership using the chown command
------------------------------------------

Whilst this is an article dedicated to chmod, chown deserves mention as
well. Where chmod changes the access mode of a file or directory, chown
changes the owner of a file or directory, which is quicker and easier
than altering the permissions in some cases, but do be careful when you
do so.

Consider the following example, making a new partition with GParted for
backup data. Gparted for may does this all as root so everything belongs
to root. This is all well and good but when it came to writing data to
the mounted partition, permission was denied.

    brw-rw----  1 root disk      8,   9 Jul  6 16:02 sda9
    drwxr-xr-x 5 root  root 4096 Jul  6 16:01 Backup

As you can see the device in /dev is owned by root, as is where it is
mounted (/media/Backup). To change the owner of where it is mounted one
can do the following:

    Before: drwxr-xr-x 5 root  root 4096 Jul  6 16:01 Backup

    Command: chown ben Backup  (cd'd to /media first)

    After drwxr-xr-x 5 ben  root 4096 Jul  6 16:01 Backup

Now the partition can have backup data written to it as instead of
altering the permissions, as the owner already has rwx permissions, the
owner has been altered to the user ben. Alternatives would be to alter
the permissions for everyone else (undesirable as it's a backup
permission) or adding the user to the group root.

Reference table
---------------

  Who               Permission           Numbers
  ----------------- -------------------- -------------
  u - owning user   r - read             4 - read
  g - group         w - write            2 - write
  o - others        x - execute/search   1 - execute
  a - all                                

Extended file attributes
------------------------

Apart from the file mode bits that control user and group read, write
and execute permissions, several file systems support extended file
attributes that enable further customization of allowable file
operations. This section describes some of these attributes and how to
work with them.

> chattr and lsattr

For ext2 and ext3 file systems, the e2fsprogs package contains the
programs lsattr and chattr that list and change a file's attributes,
respectively. Though some are not honored by all file systems, the
available attributes are:

-   a : append only
-   c : compressed
-   d : no dump
-   e : extent format
-   i : immutable
-   j : data journalling
-   s : secure deletion
-   t : no tail-merging
-   u : undeletable
-   A : no atime updates
-   C : no copy on write
-   D : synchronous directory updates
-   S : synchronous updates
-   T : top of directory hierarchy

See also
--------

-   Linux file permissions @ tuxfiles.org
-   wikipedia:Chattr
-   Umask

Retrieved from
"https://wiki.archlinux.org/index.php?title=File_Permissions_and_Attributes&oldid=253894"

Category:

-   File systems
