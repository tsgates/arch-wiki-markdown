Desktop Entries
===============

Desktop entries is a freedesktop.org standard for specifying the
behaviour of programs running on X Window Systems. It is a configuration
file that describe how an application is launched and how it appears in
a menu with an icon. The most common desktop entries are the .desktop
and .directory files. This article explains briefly how to create useful
and standard compliant desktop entries. It is mainly intended for
package contributors and maintainers, but may also be useful for
software developers and others.

Note:A lot of applications do not have a desktop entry by default or
they have one that could be improved. To participate in creating and
maintaining desktop entries, please join the Arch Desktop Project.

There are roughly three types of desktop entries:

 Application 
    a shortcut to an application
 Link 
    a shortcut to a web link.
 Directory 
    a container of meta data of a menu entry

The following sections will roughly explain how these are created and
validated.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Application entry                                                  |
|     -   1.1 File example                                                 |
|     -   1.2 Key definition                                               |
|         -   1.2.1 Deprecation                                            |
|                                                                          |
| -   2 Icons                                                              |
|     -   2.1 Common image formats                                         |
|     -   2.2 Converting icons                                             |
|     -   2.3 Obtaining icons                                              |
|                                                                          |
| -   3 Tools                                                              |
|     -   3.1 gendesk                                                      |
|         -   3.1.1 How to use                                             |
|                                                                          |
| -   4 More resources                                                     |
+--------------------------------------------------------------------------+

Application entry
-----------------

Desktop entries for applications or .desktop files are generally a
combination of meta information resources and a shortcut of an
application. These files usually reside in /usr/share/applications.

> File example

Following is an example of its structure with additional comments. The
example is only meant to give a quick impression, and does not show how
to utilize all possible entry keys. The complete list of keys can be
found in the freedesktop.org specification.

    [Desktop Entry]
    Type=Application                          # Indicates the type as listed above
    Version=1.0                               # The version of the desktop entry specification to which this file complies
    Name=jMemorize                            # The name of the application
    Comment=Flash card based learning tool    # A comment which can/will be used as a tooltip
    Exec=jmemorize                            # The executable of the application.
    Icon=jmemorize                            # The name of the icon that will be used to display this entry
    Terminal=false                            # Describes whether this application needs to be run in a terminal or not
    Categories=Education;Languages;Java;      # Describes the categories in which this entry should be shown

> Key definition

-   Version key does not stand for the version of the application, but
    for the version of the desktop entry specification to which this
    file complies.

-   Name, GenericName and Comment often contain redundant values in the
    form of combinations of them, like:

    Name=Pidgin Internet Messenger
    GenericName=Internet Messenger

or

    Name=NoteCase notes manager
    Comment=Notes Manager 

This should be avoided, as it will only be confusing to users. The Name
key should only contain the name, or maybe an abbreviation/acronym if
available.

-   GenericName should state what you would generally call an
    application that does what this specific application offers (i.e.
    Firefox is a "Web Browser").
-   Comment is intended to contain any usefull additional information.

Deprecation

There are quite some keys that have become deprecated over time as the
standard has matured. The best/simplest way is to use the tool
desktop-file-validate which is part of the package desktop-file-utils.
To validate, run

    $ desktop-file-validate <your desktop file>

This will give you very verbose and useful warnings and error messages.

Icons
-----

> Common image formats

Here is a short overview of image formats commonly used for icons.

Support for image formats for icons as specified by the freedesktop.org
standard.

Extension

Full Name and/or Description

Graphics Type

Container Format

Supported

.png

Portable Network Graphics

Raster

no

yes

.svg(z)

Scalable Vector Graphics

Vector

no

yes (optional)

.xpm

X PixMap

Raster

no

yes (deprecated)

.gif

Graphics Interchange Format

Raster

no

no

.ico

MS Windows Icon Format

Raster

yes

no

.icns

Apple Icon Image

Raster

yes

no

> Converting icons

If you stumble across an icon which is in a format that is not supported
by the freedesktop.org standard (like gif or ico), you can convert
(which is part of the imagemagick package) it to a supported/recommended
format, e.g.:

    $ convert <icon name>.gif <icon name>.png             /* Converts from gif to png */

If you convert from a container format like ico, you will get all images
that were encapsulated in the ico file in the form <icon
name>-<number>.png. If you want to know the size of the image, or the
number of images in a container file like ico you can use identify (also
part of the imagemagick package)

    $ identify /usr/share/vlc/vlc48x48.ico
    /usr/share/vlc/vlc48x48.ico[0] ICO 32x32 32x32+0+0 8-bit DirectClass 84.3kb
    /usr/share/vlc/vlc48x48.ico[1] ICO 16x16 16x16+0+0 8-bit DirectClass 84.3kb
    /usr/share/vlc/vlc48x48.ico[2] ICO 128x128 128x128+0+0 8-bit DirectClass 84.3kb
    /usr/share/vlc/vlc48x48.ico[3] ICO 48x48 48x48+0+0 8-bit DirectClass 84.3kb
    /usr/share/vlc/vlc48x48.ico[4] ICO 32x32 32x32+0+0 8-bit DirectClass 84.3kb
    /usr/share/vlc/vlc48x48.ico[5] ICO 16x16 16x16+0+0 8-bit DirectClass 84.3kb

As you can see, the example ico file, although its name might suggest a
single image of size 48x48, contains no less than 6 different sizes, of
which one is even greater than 48x48, namely 128x128. And to give a bit
of motivation on this subject, at the point of writing this section
(2008-10-27), the 128x128 size was missing in the vlc package (0.9.4-2).
So the next step would be to look at the vlc PKGBUILD and check whether
this icon format was not in the source package to begin with (in that
case we would inform the vlc developers), or whether this icon was
somehow omitted from the Arch-specific package (in that case we can file
a bug report at the Arch Linux bug tracker). (Update: this bug has now
been fixed, so as you can see, your work will not be in vain.)

> Obtaining icons

Although packages that already ship with a .desktop-file most certainly
contain an icon or a set of icons, there is sometimes the case when a
developer has not created a .desktop-file, but may ship icons,
nonetheless. So a good start is to look for icons in the source package.
You can i.e. first filter for the extension with find and then use grep
to filter further for certain buzzwords like the package name, "icon",
"logo", etc, if there are quite a lot of images in the source package.

    $ find /path/to/source/package -regex ".*\.\(svg\|png\|xpm\|gif\|ico\)$"      /* this filters for common extensions */

If the developers of an application do not include icons in their source
packages, the next step would be to search on their web sites. Some
projects, like i.e. tvbrowser have an artwork/logo page where additional
icons may be found. If a project is multi-platform, there may be the
case that even if the linux/unix package does not come with an icon, the
Windows package might provide one. If the project uses a Version control
system like CVS/SVN/etc. and you have some experience with it, you also
might consider browsing it for icons. If everything fails, the project
might simple have no icon/logo yet.

Tools
-----

> gendesk

gendesk is a Arch Linux-specific tool for generating .desktop files from
PKGBUILD files. Most of the information is fetched directly from the
PKGBUILD.

Icons are downloaded from fedora, if available. The source for icons can
easily be changed in the future.

How to use

-   Add gendesk to makedepends

-   Start the build() function with:

    cd "$srcdir"
    gendesk
    # And then the rest

-   Add _name=('Program Name') to the PKGBUILD to choose a name for the
    menu entry. There are other options available too, like
    _exec=('someapp --with-ponies').

-   Use gendesk -n if you wish to generate a .desktop file, but not
    download any icon

-   See the gendesk source for more information. (Patches and pull
    requests are welcome).

More resources
--------------

-   desktop wikipedia article
-   freedesktop.org desktop entry specification
-   freedesktop.org icon theme specification
-   freedesktop.org menu specification
-   freedesktop.org basedir specification
-   information for developers

Retrieved from
"https://wiki.archlinux.org/index.php?title=Desktop_Entries&oldid=221417"

Category:

-   Package development
