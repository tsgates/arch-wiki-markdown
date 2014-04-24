Optical Character Recognition
=============================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There are several steps to the whole OCR process, the actual OCR engine
is only part of this:

1.  scanning
2.  document layout analysis
3.  optical character recognition
4.  post-processing (formatting, PDF creation)

OCR software
------------

> OCR (Optical Character Recognition) engines

-   CuneiForm — Command line OCR system originally developed and open
    sourced by Cognitive technologies. Supported languages: eng, ger,
    fra, rus, swe, spa, ita, ruseng, ukr, srp, hrv, pol, dan, por, dut,
    cze, rum, hun, bul, slo, lav, lit, est, tur.

https://launchpad.net/cuneiform-linux || cuneiform

-   GOCR/JOCR — OCR engine which also supports barcode recognition.

http://jocr.sourceforge.net/ || gocr

-   Ocrad — OCR program based on a feature extraction method.

http://www.gnu.org/software/ocrad/ || ocrad

-   Tesseract — Accurate open source OCR engine. Package splitted, you
    need install some datafiles for each language (tesseract-data-eng
    for example).

http://code.google.com/p/tesseract-ocr/ || tesseract

> Layout analyzers and user interfaces

-   gImageReader — Graphical GTK frontend to Tesseract.

http://gimagereader.sourceforge.net/ || gimagereader

-   gscan2pdf — Scans, runs Tesseract and creates a PDF all in one go.

http://gscan2pdf.sourceforge.net/ || gscan2pdf

-   OCRFeeder — Python GUI for Gnome which performs document analysis
    and rendition, and can use either CuneiForm, GOCR, Ocrad or
    Tesseract as OCR engines. It can import from PDF or image files, and
    export to HTML or OpenDocument.

http://wiki.gnome.org/OCRFeeder || ocrfeeder

-   OCRopus — OCR platform, modules exist for document layout analysis,
    OCR engines (it can use Tesseract or its own engine), natural
    language modeling, etc.

http://code.google.com/p/ocropus/ || ocropus

-   YAGF — Graphical interface for the CuneiForm text recognition
    program on the Linux platform.

http://symmetrica.net/cuneiform-linux/yagf-en.html || yagf

Retrieved from
"https://wiki.archlinux.org/index.php?title=Optical_Character_Recognition&oldid=273112"

Category:

-   Applications

-   This page was last modified on 29 August 2013, at 17:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
