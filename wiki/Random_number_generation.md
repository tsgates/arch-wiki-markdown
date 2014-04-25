Random number generation
========================

From wikipedia:Random number generation:

A random number generator (RNG) is a computational or physical device
designed to generate a sequence of numbers or symbols that lack any
pattern, i.e. appear random.

Generation of random data is crucial for several applications like
making cryptographic keys (e.g. for Disk Encryption), securely wiping
disks, running encrypted Software access points.

Contents
--------

-   1 Kernel built-in RNG
    -   1.1 /dev/random
    -   1.2 /dev/urandom
-   2 Faster alternatives
-   3 See also

Kernel built-in RNG
-------------------

The Linux kernel's built-in RNGs /dev/{u}random are highly commended for
producing reliable random data providing the same security level that is
used for the creation of cryptographic keys. The random number generator
gathers environmental noise from device drivers and other sources into
an entropy pool.

Note that the man random command will misdirect to the library function
manpage random(3) while for information about the /dev/random device
files you should run man 4 random to read random(4).

> /dev/random

/dev/random uses an entropy pool of 4096 bits (512 Bytes) to generate
random data and stops when the pool is exhausted until it gets (slowly)
refilled. /dev/random is designed for generating cryptographic keys
(e.g. SSL, SSH, dm-crypt's LUKS), but it is impractical to use for
wiping current HDD capacities: what makes disk wiping take so long is
waiting for the system to gather enough true entropy. In an
entropy-starved situation (e.g. a remote server) this might never end.
While doing search operations on large directories or moving the mouse
in X can slowly refill the entropy pool, it's designated pool size alone
will be indication enough of the inadequacy for wiping a disk.

You can always compare /proc/sys/kernel/random/entropy_avail against
/proc/sys/kernel/random/poolsize to keep an eye on the system's entropy
pool.

While Linux kernel 2.4 did have writable /proc entries for controlling
the entropy pool size, in newer kernels only read_wakeup_threshold and
write_wakeup_threshold are writable. The pool size is now hardcoded in
kernel line 275 of /drivers/char/random.c:

    /*
     * Configuration information
     */
    #define INPUT_POOL_WORDS 128
    #define OUTPUT_POOL_WORDS 32
    ...

The kernel's pool size is given by INPUT_POOL_WORDS * OUTPUT_POOL_WORDS
which makes, as already stated, 4096 bits.

Warning:Do not use even /dev/random to generate critical cryptographic
keys on a system you do not control. If in doubt, for example in shared
server environments, rather choose to create the keys on another system
and transfer them.

> /dev/urandom

In contrast to /dev/random, /dev/urandom reuses existing entropy pool
data while the pool is replenished: the output will contain less entropy
than the corresponding read from /dev/random, but its quality should be
sufficient for a paranoid disk wipe, preparing for block device
encryption, wiping LUKS keyslots, wiping single files and many other
purposes. Nevertheless it might still take a long time to bottle-feed
the neverending surge of large drives with data.

Warning:/dev/urandom is not recommended for the generation of long-term
cryptographic keys.

Faster alternatives
-------------------

A more practical compromise between performance and security is the use
of a pseudorandom number generator. In Arch Linux repositories for
example:

-   Haveged
-   Frandom

There are also cryptographically secure pseudorandom number generators
like Yarrow (FreeBSD/OS-X) or Fortuna (the intended successor of
Yarrow).

See also
--------

-   RFC4086 - Randomness Requirements for Security (Section 7.1.2 for
    /dev/random)
-   Linux Kernel ML - discussion on patching /dev/random for higher
    throughput (February 2013)
-   A challenge on /dev/random robustness (June 2013)
-   An analysis of low entropy state behaviour of /dev/random, Yarrow,
    Fortuna and new model approach (March 2014)
-   Randomness - A popular science article explaining different RNGs

Retrieved from
"https://wiki.archlinux.org/index.php?title=Random_number_generation&oldid=304226"

Category:

-   Security

-   This page was last modified on 12 March 2014, at 23:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
