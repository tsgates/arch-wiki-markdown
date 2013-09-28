Powerbook G3
============

I use a Powerbook G3 Series aka Wallstreet II or PDQ running Arch Linux
PPC. This Model was manufactured in 1998 and originally sported a 266MHz
G3 740/750 CPU (was upgraded to a 400MHz one a couple years ago).

    [floh@cranberry: ~]$ cat /proc/cpuinfo
    processor       : 0
    cpu             : 740/750
    temperature     : 52 C (uncalibrated)
    clock           : 400.000000MHz
    revision        : 2.2 (pvr 0008 0202)
    bogomips        : 33.15
    timebase        : 16671233
    platform        : PowerMac
    machine         : PowerBook
    motherboard     : AAPL,PowerBook1998 MacRISC
    detected as     : 50 (PowerBook Wallstreet)
    pmac flags      : 00000009
    L2 cache        : 1024K unified pipelined-syncro-burst
    pmac-generation : OldWorld

Configuration: 320 MB Ram, 10 GB HD, GPU ATI RageLT PCI and Ethernet.

    [floh@cranberry: ~]$ lspci
    00:00.0 Host bridge: Motorola MPC106 [Grackle] (rev 40)
    00:0d.0 Class ff00: Apple Computer Inc. Paddington Mac I/O
    00:10.0 Class ff00: Apple Computer Inc. Paddington Mac I/O
    00:11.0 Display controller: ATI Technologies Inc 3D Rage LT Pro (rev dc)
    00:13.0 CardBus bridge: Texas Instruments PCI1131 (rev 01)
    00:13.1 CardBus bridge: Texas Instruments PCI1131 (rev 01)

While playing with this baby, I encountered a problem with the PCMCIA
subsystem: When I plugged in my Lucent Orinoco WiFi card, I received a
kernel oops instantly leaving the wireless card unusable. By now, it
seems like the Cardbus bridge and the "Heathrow" and "Gatwick" chips
(IDE chipset) disagree over free adress space, both claiming the range
0xfd000000-0xfdffffff as theirs which causes havoc as soon as both are
supposed to be used.

There's probably no use in arguing whether the PCMCIA stuff crew is in
fault there or the guys who wrote the driver for the Heathrow and
Gatwick chips. This problem described here reportedly not only affects
the Wallstreet II type of Powerbook but the Lombard as well. In addition
to those two models, it could maybe affect also the "surrounding" models
of G3 Powerbooks.

And here's the hackaround (only confirmed for BootX): append an
additional boot parameter to the kernel line saying
"reserve=0xfd000000,0xffffff". This worked for me, feedback will be
gladly received.

What works:

-   Display: ok, no 3D Acceleration though, probably due to lack of
    resources in the graphics chip used (ATI Rage LT, 4MB VRAM)
-   Audio: output works with snd-powermac
-   Ethernet: bmac module
-   Audio buttons: works with pbbuttonsd along with minor
    reconfiguration to match keycodes

What doesn't work (yet):

-   Backlight buttons: should work with pbbuttonsd, but didn't manage to
    find the right setting yet. Keycodes are sent by the keyboard, maybe
    an issue with backlight control hardware?
-   Suspend2RAM/Disk: am not 100% sure if this works or not, with
    pbbuttonsd the backlight gets switched off when the lid is closed,
    but haven't yet managed to get it on again when the lid is opened
    again. Maybe interconnected with the yet unresolved backlight
    buttons issue.
-   CPU Frequency Scaling: no idea whether or not the Wallstreet is
    capable of this
-   Modem: probably completely unsupported as in the iBook G3 12"
-   Microphone: completely untested yet, matter of priority ;-)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Powerbook_G3&oldid=196810"

Categories:

-   Apple
-   PowerPC
