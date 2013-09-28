CacheClean
==========

Cacheclean is python script to clean /var/cache/pacman/pkg allowing
users to specify how many package versions should be retained. In
function, it is similar to pacman -Sc except users select how many old
versions to keep. Another difference is unlike, pacman -Sc cacheclean
does not discriminate against packages that are not currently installed
as it inspects /var/cache/pacman/pkg.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Code                                                               |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

AUR package: cacheclean

Usage
-----

    cacheclean {-p} {-v} <# of copies to keep>
    	# of copies to keep - (required) how many generations of each package to keep
    	-p - (optional) preview what would be deleted; forces verbose (-v) mode.
    	-v - (optional) show deleted packages.

Code
----

For those wishing to contribute, the script's source code is hosted in
this github repository. To simplify updates, please fork and send a pull
request with updates/changes.

See also
--------

-   Author's original forum thread: A utility for cleaning
    /var/cache/pacman/pkg

Retrieved from
"https://wiki.archlinux.org/index.php?title=CacheClean&oldid=238328"

Categories:

-   Scripts
-   Package management
