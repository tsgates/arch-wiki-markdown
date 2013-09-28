FiSH
====

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 About FiSH                                                         |
| -   2 Adding FiSH to mIRC                                                |
| -   3 Adding FiSH to xChat                                               |
| -   4 Adding FiSH to Irssi                                               |
+--------------------------------------------------------------------------+

About FiSH
----------

FiSH is a plugin/module that facilitates encrypted chatting over IRC.
It's available for mIRC, xChat and Irssi.

Adding FiSH to mIRC
-------------------

TBC

Adding FiSH to xChat
--------------------

TBC

Adding FiSH to Irssi
--------------------

This requires light editing of a Makefile and compiling from source,
nothing too difficult if you RTFM.

Proceedure Outline Download, unpack and build the MIRACL library for
handling large numbers. Download and unpack the FiSH source. Copy the
MIRACL.so library (built in step 1) to the FiSH source directory. Edit
the makefile to point to paths for glib and irssi Compile FiSH Move the
compiled plugin to irssi's folder.

Needed Packages: MIRACL FiSH opt: Irssi (If you did not compile Irssi
from source, you will need to get the irssi headers from the irssi
source for compiling FiSH)

Retrieved from
"https://wiki.archlinux.org/index.php?title=FiSH&oldid=203102"

Categories:

-   Internet Relay Chat
-   Security
