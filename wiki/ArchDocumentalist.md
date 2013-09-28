ArchDocumentalist
=================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: It has been      
                           removed from the AUR     
                           https://mailman.archlinu 
                           x.org/pipermail/aur-gene 
                           ral/2012-August/019961.h 
                           tml                      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

ArchDocumentalist is a perl script to download a snapshot of this wiki
for a specific language. It is a more powerful alternative to the
arch-wiki-docs package.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Why should I download the wiki?                                    |
| -   2 Install                                                            |
| -   3 Usage                                                              |
| -   4 Cron                                                               |
| -   5 Advantages                                                         |
| -   6 Link                                                               |
+--------------------------------------------------------------------------+

Why should I download the wiki?
-------------------------------

Having a copy on the hard disk makes sure you will always have access to
the information you need, even without an internet connection.

Install
-------

archdocumentalist is availlable on AUR.

Usage
-----

Use the following command to run the script:

    $ archdocumentalist.pl EN /tmp

This will download all English (EN) pages to /tmp/arch-wiki-EN/ and
create index.html file listing all English wiki pages.

The language code is based on the ISO 3166-1 standard.

Note: /tmp was used as an example, it is not a suitable directory for
documentation.

Cron
----

Setting a monthly cronjob to rebuild the local wiki might be a good
idea.

Advantages
----------

There are some advantages compared to arch-wiki-docs package:

-   Less disk space usage: you only have the documentation in the
    language you speak.
-   Less bandwidth consumption
-   Update the documentation at the frequency you want

Link
----

-   Project git repository

Retrieved from
"https://wiki.archlinux.org/index.php?title=ArchDocumentalist&oldid=238762"

Category:

-   ArchWiki
