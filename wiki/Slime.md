Slime
=====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Resources                                                          |
+--------------------------------------------------------------------------+

Introduction
------------

SLIME (Superior Lisp Interaction Mode for Emacs) provides a development
environment for SBCL (detailed in this article), CMUCL, CLISP and other
Lisp implementations.

The components required are:

-   emacs
-   sbcl
-   slime

Installation
------------

Install emacs and sbcl from the official repositories and slime-cvs from
the AUR.

Configuration
-------------

From the .INSTALL file.

To make use of slime, add the following lines to your init file:

    (setq inferior-lisp-program "/path/to/lisp-executable")
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
    (require 'slime)
    (slime-setup)

Then run M-x slime from within emacs.

Alternatively, for a fancier slime setup, you can change the above lines
to:

    (setq inferior-lisp-program "/path/to/lisp-executable")
    (add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
    (require 'slime)
    (slime-setup '(slime-fancy))

Resources
---------

-   The Common Lisp wiki
-   Practical Common Lisp
-   Structure and Interpretation of Computer Programs
-   Paul Graham's Lisp resources.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Slime&oldid=238806"

Category:

-   Development
