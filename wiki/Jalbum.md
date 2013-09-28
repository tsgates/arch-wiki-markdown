Jalbum
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Extra Skins                                                        |
|     -   3.1 Installation of Skins                                        |
|         -   3.1.1 BananAlbum                                             |
|                                                                          |
| -   4 Free Hosting Service                                               |
| -   5 Sample Jalbums                                                     |
| -   6 Tips                                                               |
+--------------------------------------------------------------------------+

Introduction
------------

[Jalbum] consists of freeware cross-platform software for managing and
creating digital photo albums or galleries, and a free / paid-for photo
sharing service on which to publish them. Uses need not use the free
sharing service though. Jalbum outputs a stand-alone directory
structure/html indexes that users can upload to their own web spaces
either with the built-in FTP software or via their own means. Jalbum
software has been used to create over 23 million photo galleries, with
over 40,000 users hosting theirs on jalbum.net.

Jalbum can be thought of as similar to Google's Picasa, or Apple's
iPhoto, and is credited as being extremely easy to use, flexible and
versatile. It runs on Java so can be run on most operating systems, and
is available in 32 languages.

The software allows users to manage their photo collection, sorting
photos into albums, performing basic digital editing and commenting
(although not tagging) individual photos. The main focus is on producing
HTML and Flash based galleries, for publishing online or distributing
via other means. Users can customize the look and functionality of their
photo galleries by using a small set of templates or skins that come
with the program, or by choosing from over 100 skins available for free
download. The community that has formed around Jalbum produces a variety
of creative skins, offering galleries based on standard HTML designs,
AJAX slideshows and popular Flash based image viewers.

Jalbum was created by Swedish programmer David Ekholm in 2002.

Installation
------------

BlackEagle has written a PKGBUILD for Jalbum which is available in the
AUR [at this URL]. For those unfamiliar with the AUR, installation is
trivial. First get the tarball, then unpack it, install the dependency
if you haven't already, make the package, and install it. The example
below is given using Arch x86_64 and version 8.3.1 of Jalbum (current at
the time this article was written). Obviously you will substitute the
current version number and architecture appropriate for your system:

    $ wget https://aur.archlinux.org/packages/jalbum/jalbum.tar.gz
    $ tar zxvf jalbum.tar.gz
    $ cd jalbum
    # pacman -S java-environment
    $ makepkg -s
    # pacman -U jalbum-8.3.1-1-x86_64.pkg.tar.gz

Jalbum should now be available from your Applications>Graphics menu
(Gnome).

Extra Skins
-----------

As mentioned above, there are many additional skins one can
download/install to enhance Jalbum's options of photo albums/galleries.
A complete listing of skins is available from [this URL].

> Installation of Skins

Skins can be 'installed' simply by unpacking their archive to the
/usr/share/java/Jalbum/skins/SKINNAME

Alternatively and preferable, users should consider making a PKGBUILD
file for the skin and install it via pacman for maximal flexibility.

BananAlbum

Currently, the popular [BananAlbum] skin is packaged for pacman
available from [this URL]. BananAlbum is a flash-based album with a sexy
interface, and is highly customizable. It is installed following a
similar process to that described above:

    $ wget https://aur.archlinux.org/packages/bananalbum/bananalbum.tar.gz
    $ tar zxvf bananalbum.tar.gz
    $ cd bananalbum
    $ makepkg -s
    # pacman -U bananalbum-6.1.4-1-x86_64.pkg.tar.gz

Free Hosting Service
--------------------

The website jalbum.net is used as a social photo sharing website, as
well as to promote and distribute the software. 30MB of space for photos
is offered free to all users who register, with upgrades to 1GB or 10GB
available for a yearly subscription fee. Free galleries remain hosted
indefinitely, with no risk of deletion due to inactivity.

Sample Jalbums
--------------

Sample Jalbums are available from the official [Jalbum site].

Tips
----

-   EXIF data from photographs can be displayed with most skins.
-   One can further customize the bananalbum skin to display EXIF data
    to the right of the photo by following the advice in [this thread].

Retrieved from
"https://wiki.archlinux.org/index.php?title=Jalbum&oldid=198161"

Category:

-   Graphics and desktop publishing
