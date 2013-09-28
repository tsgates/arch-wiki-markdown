HCL/ESATA Cards
===============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page is about Cards to provide external Sata or eSATA for older
Systems.

DeLock
======

SiI 3531 Chipset
----------------

Tested card is a Express Card 34mm eSATA card from Delock. Output from
lspci:

    0d:00.0 Mass storage controller: Silicon Image, Inc. SiI 3531 [SATALink/SATARaid] Serial ATA Controller (rev 01)

For hotplugging the modules acpiphp and pciehp are needed, the card
itself works with the sata_sil24 module.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/ESATA_Cards&oldid=207100"

Category:

-   Other hardware
