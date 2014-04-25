Mbrola
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

mbrola is a non-free phonemes-to-audio program.

Contents
--------

-   1 Step 1: Installation
-   2 Step 2: Add voices
-   3 Step 3: Testing
-   4 Step 4: Install a text-to-phonemes program
    -   4.1 lliaphon

Step 1: Installation
--------------------

A package is available in AUR

Step 2: Add voices
------------------

Packages named mbrola-voices-xxx are available in AUR

Note: these packages have been built by a script so if something is
wrong leave a comment and I'll try to fix.

Step 3: Testing
---------------

Once you have installed the wanted voice(s) go to the directory of the
installed language:

    $ cd /usr/share/mbrola/us1/

then list the test files:

    $ ls TEST/

If there are no test files for this language skip this test and go to
step 3 or try with an other language.

Else choose a test file (files with .pho extension) and try:

    $ mbrola ./us1 ./TEST/mbrola.pho ~/test.wav; aplay ~/test.wav; rm ~/test.wav

If you hear a voice it works, if not, check that you did everything good
and if it still do not work go ask for help on forums.

Note that we didn't give a text file to mbrola but a phoneme file so we
do not have a text-to-speech system yet, lets see the next step.

Step 4: Install a text-to-phonemes program
------------------------------------------

To obtain a full TTS system we need a text-to-phonemes program
compatible with mbrola: List of TTS programs compatible with mbrola.

> lliaphon

LLiaPhon is a TTS program which uses mbrola.

See the detailed article: lliaphon

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mbrola&oldid=232825"

Category:

-   Accessibility

-   This page was last modified on 31 October 2012, at 20:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
