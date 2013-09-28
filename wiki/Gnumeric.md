Gnumeric
========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Gnumeric is the most powerful spreadsheet application which can import
and export in various formats including csv, HTML, LaTeX, Lotus 1-2-3,
OpenDocument Spreadsheet and Microsoft Excel.

Installing
----------

Install gnumeric from the Official Repositories.

Optional dependencies are psiconv (for Psion 5 file support),
python2-gobject2 (for python plugin support) and yelp (for viewing the
help manual).

> decimal separator

Gnumeric is depending on your locale and use it for exporting as csv
file too. For example, octave use dot decimal seperator.

Display 1/2:

With german locale "de", Gnumeric shows 0,5 (comma)

With englisch locale "en", Gnumeric shows 0.5 (dot)

To start Gnumeric with a different locale, just run

     LC_NUMERIC="en" gnumeric

External Resources
------------------

-   Gnumeric Official Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gnumeric&oldid=207063"

Category:

-   Office
