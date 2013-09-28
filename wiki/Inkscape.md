Inkscape
========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Inkscape is a vector graphics editor application. It is distributed
under a free software license, the GNU GPL. Its stated goal is to become
a powerful graphics tool while being fully compliant with the XML, SVG,
and CSS standards.[1]

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Without GNOME dependencies                                   |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 Build error with libpng 1.2.x                                |
|                                                                          |
| -   3 Related pages                                                      |
+--------------------------------------------------------------------------+

Installation
------------

inkscape can be installed from the official repositories.

> Without GNOME dependencies

Inkscape has quite a few GNOME dependencies, which can be annoying to
users of other environments. If you do not want these, you can compile
inkscape-nognome from the AUR.

Troubleshooting
---------------

> Build error with libpng 1.2.x

If inkscape fails to build with the following error:

    In file included from /usr/include/libpng12/png.h:474,
    from sp-image.cpp:44:
    /usr/include/libpng12/pngconf.h:328: error: expected constructor, destructor, or type conversion before '.' token
    /usr/include/libpng12/pngconf.h:329: error: '__dont__' does not name a type

You should be able to solve that by simply commenting the two mentioned
Lines in /usr/include/libpng12/pngconf.h out:

    //__pngconf.h__ already includes setjmp.h;
    //__dont__ include it again.;

(I have got no idea what else those changes influence, so you might want
to undo them after inkscape is built. This could be related to Debian
Bug#522477 and might get fixed in libpng 1.4)

Related pages
-------------

Multimedia in Arch Linux

Inkscape Homepage

Inkscape at Wikipedia

Retrieved from
"https://wiki.archlinux.org/index.php?title=Inkscape&oldid=210240"

Category:

-   Graphics and desktop publishing
