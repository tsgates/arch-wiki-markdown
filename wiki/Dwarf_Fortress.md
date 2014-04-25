Dwarf Fortress
==============

Dwarf Fortress is a single-player fantasy game. You can control a
dwarven outpost or an adventurer in a randomly generated, persistent
world. It is renowned for its highly customizable, complex indepth
gameplay.

The game is played with keyboard only, though there exist mods which
enable mouse support via plugins. Without any graphic mods (tilesets)
the game is displayed in the terminal with ASCII characters
(screenshots).

Installation
------------

Install package dwarffortress from the official repositories.

Alternatively there are some AUR packages coming with bitmap tilesets:

-   dwarffortress-ironhand
-   dwarffortress-mayday
-   dwarffortress-myne
-   dwarffortress-obsidian
-   dwarffortress-phoebus

Note:Enabling multilib repositories on x86_64 systems is required due to
32bit dependencies.

Tools
-----

> Dwarf Therapist

Dwarf Therapist (dwarftherapist-hg in AUR) is an almost essential mod to
tune dwarvish behaviour (makes life a lot easier). For it to work on
current kernels you will need to disable a kernel security feature,
since dwarf therapist directly accesses and modifies the memory of a
running dwarf fortress instance. This setting is called
kernel.yama.ptrace_scope and defaults to 1. You need to set it to 0 for
dwarf therapist to work:

    # sysctl -w kernel.yama.ptrace_scope=0

and then

    # sysctl -w kernel.yama.ptrace_scope=1

when you're done playing and have closed dwarf fortress and dwarf
therapist.

For more information see sysctl.

Warning:You should not set this to 0 in /etc/sysctl.d/ by default since
it is an important security feature in the kernel! It is best to set it
manually whenever you play dwarf fortress and reset it back to 1 when
you are done playing.

  
 Alternatively, you can just give that permission to dwarftherapist:

    # setcap cap_sys_ptrace=eip /usr/bin/dwarftherapist

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dwarf_Fortress&oldid=306106"

Category:

-   Gaming

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
