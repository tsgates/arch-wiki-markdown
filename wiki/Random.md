Random
======

The man random command will misdirect to the library function manpage
random(3) while for information about the /dev/random device files you
should run man 4 random to read random(4).

Entropy
-------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Securely    
                           wipe disk#Kernel         
                           built-in RNG.            
                           Notes: What is specific  
                           to disk wiping should    
                           get merged there and     
                           deleted here. (Discuss)  
  ------------------------ ------------------------ ------------------------

The Kernel built-in RNG /dev/random provides you the same quality random
data you would use for keygeneration, but can be nearly impractical to
use at least for wiping current HDD capacitys. What makes disk wiping
take so long with is to wait for it to gather enough true entropy. In an
entropy starved situation (e.g. remote server) this might never end
while doing search operations on large directories or moving the mouse
in X can slowly refill the entropy pool.

You can always compare /proc/sys/kernel/random/entropy_avail against
/proc/sys/kernel/random/poolsize to keep an eye on your entropy pool.

The Kernels poolsize is 4096 bit. (512 Byte)

While Linux kernel 2.4 did have writable /proc-entries for controlling
the entropy-poolsize in newer kernels only read_wakeup_threshold and
write_wakeup_threshold are writable.

The pool size is now hardcoded in kernel line 275 of
/drivers/char/random.c

    /*
     * Configuration information
     */
    #define INPUT_POOL_WORDS 128
    #define OUTPUT_POOL_WORDS 32
    #define SEC_XFER_SIZE 512
    #[...]

where poolsize is 4096 = INPUT * OUTPUT

/dev/urandom
------------

/dev/random uses the kernel entropy pool and will halt overwriting until
more input entropy once this pool has been exhausted. This can make it
impractical for overwriting large hard disks.

/dev/urandom in contrast will reuse entropy when low on it so you won't
get stuck. Nevertheless it might still take a long time to bottle-feed
the neverending surge of large drives with data.

The output may contain less entropy than the corresponding read from
/dev/random. However it is still intended as a pseudorandom number
generator suitable for most cryptographic purposes,

Warning:/dev/urandom is not recommended for the generation of long-term
cryptographic keys.

Pseudorandom number generator
-----------------------------

A Good Compromise between Performance and Security might be the use of a
pseudorandom number generator (like Frandom).

There are also cryptographically secure pseudorandom number generators
like Yarrow (FreeBSD/OS-X) or Fortuna (the intended successor of
Yarrow).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Random&oldid=226455"

Category:

-   Security
