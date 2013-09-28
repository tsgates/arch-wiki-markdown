Modalias
========

This document is an intro to how the Linux kernel and modules see and
understand hardware, and how this translates into a sysfs 'modalias'

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is a 'modalias'                                               |
| -   2 What is a 'modalias' file?                                         |
| -   3 How is this information used?                                      |
| -   4 Where does this modules.alias file come from?                      |
| -   5 How does udev work?                                                |
+--------------------------------------------------------------------------+

What is a 'modalias'
--------------------

Modalias is a little sysfs trick that exports hardware information to a
file named 'modalias'. This file simply contains a formatted form of the
information normal hardware exposes. Let's look at a quick example
before we continue:

    $ cat /sys/devices/pci0000:00/0000:00:1f.1/modalias
         pci:v00008086d000024DBsv0000103Csd0000006Abc01sc01i8A

Don't worry, it will all become clear soon.

What is a 'modalias' file?
--------------------------

As described above, a modalias file simply exposes the information that
a given piece of hardware already tells the kernel. This file simply
specifies a structure for exposing this information. Let's return to the
example above:

    $ cat /sys/devices/pci0000:00/0000:00:1f.1/modalias
      pci:v00008086d000024DBsv0000103Csd0000006Abc01sc01i8A

Let's take it apart piece-by-piece. First, the file name.

    /sys/devices/pci0000:00/0000:00:1f.1/modalias

-   pci0000:00 is the id for the first PCI bus. For most machines this
    will be the only PCI bus you have, but it's possible this can extend
    to pci0000:01 or pci0000:02 - the exacts are unimportant, as it's a
    good guess that you only have one PCI bus (HINT: try ls
    /sys/devices/pci* to check)
-   0000:00:1f.1 is the index of the given device on the PCI bus.
    Specifically, this is on bus 0000:00 and has index 1f.1
-   All this is rather unimportant, unless you want to know where all
    these numbers come from. For completeness, if you check the output
    of lspci you will see the same information:

    $ lspci
      00:1f.1 IDE interface: Intel Corp.: Unknown device 24db (rev 02)

Now, let's take a peek at the contents of this modalias file for device
00:1f.1:

    pci:v00008086d000024DBsv0000103Csd0000006Abc01sc01i8A

Well, hey, I can see pci! I recognize that, but what's all this
gibberish at the end? This gibberish is actually structured data. You
will notice a repeating letter/number scheme. Let's split this apart to
make it easier to read:

    v  00008086
    d  000024DB
    sv 0000103C
    sd 0000006A
    bc 01
    sc 01
    i  8A

Each of these identifiers, and corresponding hex numbers represent some
of the info that a given device exposes. For starters, v is the vendor
id and d is the device id - these are very standard numbers, and are the
same exact numbers that tools like hwd uses to lookup a device. You can
even find websites to look up specific hardware identification based on
the vendor and device ids, for instance, http://www.pcidatabase.com/

We can also see these numbers here:

    $ lspci -n
      00:1f.1 Class 0101: 8086:24db (rev 02)

See how the 8086:24db matches to the v and d tokens listed above?

For the record, sv and sd are "subsystem" versions of both vendor and
device. A majority of the time these are ignored. They are mainly used
by the hardware developers to distinguish slight differences in the
inner workings which do not change the device as a whole.

bc (base class) and sc (sub class) are used to create the "Class" listed
by lspci, in order "bcsc". This is the device class, which is fairly
generic. In this case, the "class" is looked up in the normal lspci
output. We can see that "Class 0101" maps to "IDE Interface" (lspci also
looks up the vendor and device id's - 8086 maps to "Intel Corp." and
24DB maps to 'Unknown Device', hehe)

i is the "Programming interface", which is only meaningful for a few
devices classes.

How is this information used?
-----------------------------

Ok, now we all know what this information is. A bunch of obscure numbers
that each device exposes. Big deal. How does this matter when talking
about modules?

One thing which people tend to ignore, is all the work depmod does. When
you run depmod, it builds a series of "map" files in /lib/modules/`uname
-r` which tell modprobe how to handle certain things it needs to do. In
this case we can ignore most of them. The important one is
modules.alias. This file contains aliases, or secondary names for
modules. Just for a demonstration, let's look at aliases for, say,
snd_intel8x0m:

    $ grep snd_intel8x0m /lib/modules/`uname -r`/modules.alias
      alias pci:v00008086d00002416sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d00002426sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d00002446sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d00002486sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d000024C6sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d000024D6sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d0000266Dsv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d000027DDsv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00008086d00007196sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00001022d00007446sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v00001039d00007013sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v000010DEd000001C1sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v000010DEd00000069sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v000010DEd00000089sv*sd*bc*sc*i* snd_intel8x0m
      alias pci:v000010DEd000000D9sv*sd*bc*sc*i* snd_intel8x0m

Hey, wait! I recognize that! That's the vendor/device id information
from before!

Yes, it is. It's a rather simple format of "alias <something> <actual
module>". In fact, you can alias just about anything you want. I can add
"alias boogabooga snd_intel8x0m" and then safely "modprobe boogabooga".

The "*" indicates it will match anything, much like filesystem globbing
(ls somedir/*). As stated before, most aliases ignore sv, sd, bc, sc,
and i by way of the "*" matching.

Where does this modules.alias file come from?
---------------------------------------------

Ok, now you may be thinking "Well, hwd used to look things up based on a
device table, what makes this any different?"

The difference is that this lookup table is not static. It is not
maintained by hand. In fact, it is built dynamically whenever you run
depmod. "Where does this information come from?", you ask? Why, from the
modules themselves. When you think about it, each specific module should
know what hardware it supports, as it's coded specifically for that
hardware. I mean, the nvidia module developers know that their modules
only works for Nvidia (vendor) Graphics Cards (class). In fact, the
module actually exports this information. It says "Hey, I can support
this:".

    $ modinfo nvidia
      filename:       /lib/modules/2.6.14-ARCH/kernel/drivers/video/nvidia.ko
      license:        NVIDIA
      alias:          char-major-195-*
      vermagic:       2.6.14-ARCH SMP preempt 686 gcc-4.1
      depends:        agpgart
      alias:          pci:v000010DEd*sv*sd*bc03sc00i00*

As you can see by the alias listed, it looks specifically for vendor
"10DE" (Nvidia) and bc/sc 0300 (which is most likely 'graphics cards').
In fact, if you look at the modinfo for snd_intel8x0m:

    $ modinfo snd_intel8x0m
      filename:       /lib/modules/2.6.14-ARCH/kernel/sound/pci/snd-intel8x0m.ko
      author:         Jaroslav Kysela <perex@suse.cz>
      description:    Intel 82801AA,82901AB,i810,i820,i830,i840,i845,MX440; SiS 7013; NVidia MCP/2/2S/3 modems
      license:        GPL
      vermagic:       2.6.14-ARCH SMP preempt 686 gcc-4.1
      depends:        snd-ac97-codec,snd-pcm,snd-page-alloc,snd
      alias:          pci:v00008086d00002416sv*sd*bc*sc*i*
      alias:          pci:v00008086d00002426sv*sd*bc*sc*i*
      alias:          pci:v00008086d00002446sv*sd*bc*sc*i*
      alias:          pci:v00008086d00002486sv*sd*bc*sc*i*
      alias:          pci:v00008086d000024C6sv*sd*bc*sc*i*
      alias:          pci:v00008086d000024D6sv*sd*bc*sc*i*
      alias:          pci:v00008086d0000266Dsv*sd*bc*sc*i*
      alias:          pci:v00008086d000027DDsv*sd*bc*sc*i*
      alias:          pci:v00008086d00007196sv*sd*bc*sc*i*
      alias:          pci:v00001022d00007446sv*sd*bc*sc*i*
      alias:          pci:v00001039d00007013sv*sd*bc*sc*i*
      alias:          pci:v000010DEd000001C1sv*sd*bc*sc*i*
      alias:          pci:v000010DEd00000069sv*sd*bc*sc*i*
      alias:          pci:v000010DEd00000089sv*sd*bc*sc*i*
      alias:          pci:v000010DEd000000D9sv*sd*bc*sc*i*

It matches the aliases found by 'grep'ing the alias file. These aliases
exported by each module, are gathered by depmod and merged into the
modules.alias file dynamically. There is no hand-changing of a lookup
table, as it is built on-the-fly. Each module knows exactly what it
supports, and therefore depmod can use that information to help load
modules.

How does udev work?
-------------------

udev is closely tied with sysfs (the filesystem which exposes the
modalias in the firstplace). In fact, to load modules based on the
modalias when a new device is added (or when udev is first started on
boot), it's insanely simple:

    DRIVER!="?*", ENV{MODALIAS}=="?*", RUN{builtin}="kmod load $env{MODALIAS}"

Yep, that's it. It's a one-liner. This simple line, which is part of the
default udev rules replace hotplug. Amazing, isn't it?

Retrieved from
"https://wiki.archlinux.org/index.php?title=Modalias&oldid=254522"

Category:

-   Kernel
