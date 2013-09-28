PDF forms
=========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article is meant to guide (Arch)linux users to use PDF forms. Some
of the information here is from this thread.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Reading and filling PDF forms                                      |
|     -   1.1 Evince                                                       |
|     -   1.2 Inkscape                                                     |
|     -   1.3 Okular                                                       |
|     -   1.4 Adobe Acrobat Reader                                         |
|     -   1.5 Cabaret Stage                                                |
+--------------------------------------------------------------------------+

Reading and filling PDF forms
-----------------------------

> Evince

Evince (available in the extra repository) is a GNOME application that
can read, fill, and save PDF forms. However, it seems to be unable to
work with checkboxes accurately (As of 23/JL/2008).

For those of you who do not use GNOME, evince-gtk is available from AUR
without gnome-keyring and gconf as dependencies.

> Inkscape

Inkscape is an image editing program that can be used to fill PDF forms
by importing the PDF file and simply inserting text fields where you
want them to be. Its not really filling the form (the fields will
probably still be blank if the forms are to be read electronically), but
should work well enough if you intend to print them.

> Okular

Okular (available in the extra repository) is a universal document
viewer based on KPDF for KDE 4. The last stable release is Okular 0.10,
shipped in the kdegraphics module of KDE SC 4.4. Its development began
as part of Google's Summer of Code program. The description of the
project is located at KDE Developer's Corner.

Okular combines the excellent functionalities of KPDF with the
versatility of supporting different kind of documents, like PDF,
Postscript, DjVu, CHM, and others. The document format handlers page has
a chart describing in more detail the supported formats and the features
supported in each of them.

> Adobe Acrobat Reader

Naturally, Adobe's Reader (available through the AUR) will be able to
read and fill PDF files.

> Cabaret Stage

This freeware application claims to be able to read, fill, and save PDF
forms.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PDF_forms&oldid=252650"

Category:

-   Office
