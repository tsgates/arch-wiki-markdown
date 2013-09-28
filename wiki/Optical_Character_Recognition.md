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

> OCR (Optical Character Recognition) Engines

-   CuneiForm — A command line OCR system originally developed and open
    sourced by Cognitive technologies. Supported languages: eng, ger,
    fra, rus, swe, spa, ita, ruseng, ukr, srp, hrv, pol, dan, por, dut,
    cze, rum, hun, bul, slo, lav, lit, est, tur.

https://launchpad.net/cuneiform-linux || cuneiform

-   GOCR/JOCR — An OCR engine which also supports barcode recognition.

http://jocr.sourceforge.net/ || gocr

-   Ocrad — An OCR program based on a feature extraction method.

http://www.gnu.org/software/ocrad/ || ocrad

-   Tesseract — "Probably one of the most accurate open source OCR
    engines available". Package splitted, you need install some
    datafiles for each language (tesseract-data-eng for examle).

http://code.google.com/p/tesseract-ocr/ || tesseract

> Layout analysers and user interfaces

-   OCRFeeder — Python GUI for Gnome which performs document analysis
    and rendition, and can use either CuneiForm, GOCR, Ocrad or
    Tesseract as OCR engines. It can import from PDF or image files, and
    export to HTML or OpenDocument.

http://live.gnome.org/OCRFeeder || ocrfeeder

-   YAGF — graphical interface for the CuneiForm text recognition
    program on the Linux platform. Available from community repository

http://symmetrica.net/cuneiform-linux/yagf-en.html || yagf

-   gImageReader — A graphical GTK frontend to Tesseract

http://gimagereader.sourceforge.net/ || gimagereader

-   gscan2pdf — scans, runs Tesseract and creates a PDF all in one go

http://gscan2pdf.sourceforge.net/ || gscan2pdf

-   OCRopus — OCR platform, modules exist for document layout analysis,
    OCR engines (it can use Tesseract or its own engine), natural
    language modelling, etc. Available from AUR

http://code.google.com/p/ocropus/ || ocropus

Retrieved from
"https://wiki.archlinux.org/index.php?title=Optical_Character_Recognition&oldid=239622"

Category:

-   Applications
