Speech Recognition
==================

Speech recognition is any means by which you can interface with your
computer via spoken word. This page is designed to identify applications
that can facilitate speech recognition and to serve as a guide in
installing and using this software in Arch.

A note to newcomers: Speech recognition is something that traditionally
has not been well supported in Linux. If you become interested and
choose to dig below the immediate surface, you can expect difficulty in
finding documentation or help from the community.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Types of Speech Recognition                                        |
| -   2 Development Status                                                 |
| -   3 Text-To-Speech                                                     |
|     -   3.1 Festival                                                     |
|     -   3.2 eSpeak                                                       |
|         -   3.2.1 Installing eSpeak                                      |
|         -   3.2.2 Testing eSpeak                                         |
|         -   3.2.3 eSpeak Usage/Configuration                             |
|                                                                          |
| -   4 Voiced Commands                                                    |
|     -   4.1 Gnome-Voice-Control                                          |
|     -   4.2 VEDICS                                                       |
|     -   4.3 Perlbox-Voice                                                |
|                                                                          |
| -   5 Speech Recognition                                                 |
|     -   5.1 Free Speech Recognition Engines                              |
|         -   5.1.1 CMU Sphinx                                             |
|         -   5.1.2 Simon                                                  |
|         -   5.1.3 Julius                                                 |
|         -   5.1.4 XVoice                                                 |
|         -   5.1.5 ViaVoice                                               |
|         -   5.1.6 sphinxkeys                                             |
|         -   5.1.7 VoxForge                                               |
|                                                                          |
|     -   5.2 Proprietary Speech Recognition Engines                       |
|         -   5.2.1 Dragon Naturally Speaking in Wine                      |
|         -   5.2.2 Wizzscribe SI                                          |
|         -   5.2.3 Verbio ASR                                             |
|         -   5.2.4 DynaSpeak from SRI International                       |
|         -   5.2.5 LumenVox Speech Engine                                 |
+--------------------------------------------------------------------------+

Types of Speech Recognition
---------------------------

Speech recognition can mean several things:

-   Text-To-Speech:
    As it sounds, Text-To-Speech (or TTS) will manipulate a string of
    text into an audio clip. There are several programs available that
    perform TTS, some of which are command-line based (ideal for
    scripting) and others which provide a handy GUI.
-   Simple Voice Control/Commands:
    This is the most basic form of Speech-To-Text application. These are
    designed to recognize a small number of specific, typically one-word
    commands and then perform an action. This is often used as an
    alternative to an application launcher, allowing the user for
    instance to say the word “firefox” and have his OS open a new
    browser window.
-   Full dictation/recognition:
    Full dictation/recognition software allows the user to read full
    sentences or paragraphs and translates that data into text on the
    fly. This could be used, for instance, to dictate an entire letter
    into the window of an email client. In some cases, these types of
    applications need to be trained to your voice and can improve in
    accuracy the more they are used.

Development Status
------------------

Several years ago there was a push to implement speech recognition in
Linux. Since then, many of those projects have stagnated.

Text-To-Speech
--------------

The two major players in text-to-speech applications are Festival and
eSpeak. Comparison available here

> Festival

Festival offers a general framework for building speech synthesis
systems as well as including examples of various modules. As a whole it
offers full text to speech through a number APIs: from shell level,
though a Scheme command interpreter, as a C++ library, from Java, and an
Emacs interface. Festival is multi-lingual (currently English (British
and American), and Spanish) though English is the most advanced.

-   Free
-   Can install several different voices/accents.
-   Available in Extra

Site Link

> eSpeak

eSpeak is "a compact open source software speech synthesizer for English
and other languages, for Linux and Windows".

-   Open source
-   Lightweight
-   Available in the community repository
-   Excellent language support

Installing eSpeak

To install eSpeak:

     pacman -S espeak

Testing eSpeak

     echo "Hello.  This is a test." | espeak

eSpeak Usage/Configuration

The Documents page on the eSpeak website here provides an excellent
guide for using different voices, adjusting pronunciation, etc. There
are many different accents included in this install that are worth
trying out.

  

Voiced Commands
---------------

> Gnome-Voice-Control

Gnome-Voice-Control is a dialogue system to control the GNOME Desktop.
It is developed on Google Summer of Code 2007.

Available in AUR

> VEDICS

VEDICS (Voice Enabled Desktop Interaction and Control System) is an
assistive software which lets the user to interact with the OS using
voice commands.

Note: Not yet tested

Site Link

Features:

1.  Perform common window operations like close, minimize, maximize etc.
2.  Invoke default applications like browsers, mail clients etc.
3.  Access any element on the desktop just by saying its name.
4.  Supports GNOME3, GNOME2

> Perlbox-Voice

Perlbox Voice is an voice enabled application to bring your desktop
under your command.

Note:

-   Last updated in 2005
-   Package is in AUR, but missing festival-don dependency.

Site Link

Features:

1.  Text to speech (Thanks to the Festival speech synthesizer)
2.  Voice control to open user specified applications. For example, if
    you say "Web", the Perlbox-Voice Control will open the browser of
    your choice.
3.  Desktop plugins to control your Linux desktop using only your voice.
    You can switch virtual screens, cycle through desktops, invoke the
    run dialog, quick lock the screen.
4.  Custom commands are fully supported, and you can add commands on the
    fly.
5.  Pseudo Commands' allow you to enter commands that the speaker should
    say. For example, if you say "Good morning", the computer voice
    could say "And good morning to you".

  

Speech Recognition
------------------

> Free Speech Recognition Engines

CMU Sphinx

See http://cmusphinx.sourceforge.net/ and Wikipedia.

Simon

Julius

XVoice

ViaVoice

sphinxkeys

VoxForge

> Proprietary Speech Recognition Engines

Dragon Naturally Speaking in Wine

Dragon Naturally Speaking software by Nuance is a well-functioning and
popular implementation of speech dictation. It is developed for Windows,
but has been run sucsessfully in a a linux enviornment using wine. It
can be used independantly for dictation into other wine programs such as
notepad or it can be paired with Platypus to interface with any native
linux program. Platypus also provides a feature to control of your OS
using voice commands, similar to the programs described in the Voiced
Commands section.

Nuance's software is non-free, so you will have to purchase a copy. Note
that Dragon provides you with the ability to install it on a set number
of machines. Installing/Reinstalling in wine may use up some of these
licenses.

Platypus Project

Wizzscribe SI

Verbio ASR

DynaSpeak from SRI International

LumenVox Speech Engine

Retrieved from
"https://wiki.archlinux.org/index.php?title=Speech_Recognition&oldid=219394"

Categories:

-   Accessibility
-   Audio/Video
