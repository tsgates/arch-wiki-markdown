Docbook
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

We will assume that our docbook document is in File.xml

Contents
--------

-   1 Setting up Docbook in Arch
-   2 Validating XML file
-   3 Converting into XHTML
    -   3.1 Single file
    -   3.2 Segmented
-   4 Automating

Setting up Docbook in Arch
--------------------------

To set up docbook running on arch:

    $ pacman -S docbook-xml docbook-xsl libxslt libxml2

Validating XML file
-------------------

To validate the XML file use:

    $ xmllint --valid --noout File.xml

This will generate no output if the file is proper XML.

Converting into XHTML
---------------------

> Single file

To convert into a XHTML file (single file) use:

    xsltproc /usr/share/xml/docbook/`pacman -Q docbook-xsl | cut -d ' ' -f 2 | cut -d '-' -f 1`/xhtml/docbook.xsl File.xml > Output.html

> Segmented

To convert into a a segmented XHTML file (each section in its own file)
use:

    xsltproc /usr/share/xml/docbook/`pacman -Q docbook-xsl | cut -d ' ' -f 2 | cut -d '-' -f 1`/xhtml/chunk.xsl File.xml

Automating
----------

You can add these to ~/.bashrc(or similar shell startup file):

    alias doc2html1="xsltproc /usr/share/xml/docbook/xhtml/docbook.xsl"
    alias doc2multihtml="xsltproc /usr/share/xml/docbook/xhtml/chunk.xsl"
    alias docvalidate="xmllint --valid --noout"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Docbook&oldid=198561"

Category:

-   Office

-   This page was last modified on 23 April 2012, at 18:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
