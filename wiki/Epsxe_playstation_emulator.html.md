Epsxe playstation emulator
==========================

This is a guide to install the freeware Playstation emulator ePSXe.

Warning:The installation and use of this emulator requires a Sony
PlayStation BIOS file. You may not use such a file to play games in a
PSX emulator if you do not own a Sony PlayStation, Sony PSOne or Sony
PlayStation 2 console. Owning the BIOS image without owning the actual
console is a violation of copyright law. You have been warned.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Problems and Workarounds
-   4 Links

Installation
------------

Install epsxe from the AUR.

Many plugins can also be found on AUR.

Start epsxe with the lauchner (located in /usr/bin/), it creates .epsxe
in your home and links to epsxe.

Configuration
-------------

-   In the menu, open "Config -> BIOS", and set it to
    /usr/share/epsxe/bios/SCPH1001.BIN

-   Open "Config -> Video", and select either "Pete's XGL2 Driver 2.7"
    or "P.E.Op.S. Softx Driver 1.17". Click configure, then OK to write
    a config file. Verify that it is working by clicking the Test
    button.

-   In "Config -> Sound" select "P.E.Op.S. OSS Audio Driver", Configure,
    OK. Verify with the Test button.

-   In Config -> CDROM, set the path to your CD/DVD-ROM. In most cases
    it should be /dev/cdrom but in some /dev/hdc. You can check your
    path by typing "mount |grep cd" in a console.

-   In Config -> Game Pad -> Pad 1 menu, you can set up the controls.

Now you should be all set.

If you want to use an original PSX CD-ROM, insert it and select "File ->
Run CDROM" It might take a while for the game to load, so be patient.

You can load backup ISO:s from your hard disk with "File -> Run ISO.

When you are running your game you can press Esc any time to exit,
save/load game states, or change discs. To get back, select Run ->
Continue.

Problems and Workarounds
------------------------

Plugins are not listed

Sometimes epsxe will not recognize your plugins even though they may be
correctly installed. They should be installed to /opt/epsxe/cfg and
/opt/epsxe/plugins a solution to this is to run epsxe once (if you have
not already) and the file "epsxerc" will be generated in ~/.epsxe open
it and it will list plugins. They may say "DISABLED" or list a plugin
that dose not exist (such as libgpu.so or libspu.so) simply change the
string to the plugin you have in your /opt/epsxe/plugins folder. Run
epsxe and it should be working.

NOTE: If your are running epsxe from a 32bit chroot you will need
install nvidia-utils (pacman -S nvidia-utils) to the chroot enviorment
to use the xgl2 plugin.

File not found

Sometimes the symlinks in ~./epsxe will not let you run the epsxe
executable even if the permission are correct and the link is working.
You may simply copy the epsxe executable from /opt/epsxe to ~/.epsxe
this can also be done for any other files or folders whose symlinks are
not working correctly.

Settings will not be saved

It's a similar problem like not listed plugins. I recommend to install
the epsxe-launcher-python package, it creates the directories for epsxe
in your home too.

Sound device not found

If you using alsa and the sound plugin doesn't have sound, run :

    # modprobe snd-pcm-oss

Links
-----

-   ePSXe - http://www.epsxe.com/
-   Pete's PSX plugins - http://www.pbernert.com/index.htm

Retrieved from
"https://wiki.archlinux.org/index.php?title=Epsxe_playstation_emulator&oldid=277255"

Categories:

-   Gaming
-   Emulators

-   This page was last modified on 1 October 2013, at 19:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
