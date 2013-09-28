lrzip
=====

Long Range ZIP or Lzma RZIP is a compression program optimised for large
files. The larger the file and the more memory you have, the better the
compression advantage this will provide, especially once the files are
larger than 100MB. The advantage can be chosen to be either size (much
smaller than bzip2) or speed (much faster than bzip2).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing Lrzip                                                   |
| -   2 Usage                                                              |
|     -   2.1 Compression                                                  |
|     -   2.2 Decompression                                                |
|                                                                          |
| -   3 Details                                                            |
| -   4 Benchmarks                                                         |
| -   5 FAQ                                                                |
+--------------------------------------------------------------------------+

Installing Lrzip
----------------

Install lrzip, available in the Official Repositories.

Usage
-----

> Compression

Compression of directories (recursive) requires lrztar which first tars
the directory, then compresses the single file just like tar does when
users compress with gzip or xz (tar zcf ... and tar Jcz ...
respectfully).

This will produce an LZMA compressed archive "foo.tar.lrz" from a
directory named "foo".

    $ lrztar foo

This will produce an lzma compressed archive "bar.lrz" from a file named
"bar"

    $ lrzip bar

For extreme compression, add the -z switch which enables ZPAQ but takes
notably longer than lzma.

    $ lrztar -z foo

For extremely fast compression and decompression, use the -l switch for
LZO.

    $ lrzip -l bar

> Decompression

To completely extract an archived directory.

    $ lrzuntar foo.tar.lrz

To decompress "bar.lrz to "bar".

    $ lrunzip bar.lrz

Details
-------

Lrzip uses an extended version of rzip which does a first pass long
distance redundancy reduction. The lrzip modifications make it scale
according to memory size. The data is then either:

1.  Compressed by lzma (default) which gives excellent compression at
    approximately twice the speed of bzip2 compression
2.  Compressed by a number of other compressors chosen for different
    reasons, in order of likelihood of usefulness:
    1.  ZPAQ: Extreme compression up to 20% smaller than lzma but ultra
        slow at compression AND decompression.
    2.  LZO: Extremely fast compression and decompression which on most
        machines compresses faster than disk writing making it as fast
        (or even faster) than simply copying a large file.
    3.  GZIP: Almost as fast as LZO but with better compression.
    4.  BZIP2: A defacto linux standard of sorts but is the middle
        ground between lzma and gzip and neither here nor there.

3.  Leaving it uncompressed and rzip prepared. This form improves
    substantially any compression performed on the resulting file in
    both size and speed (due to the nature of rzip preparation merging
    similar compressible blocks of data and creating a smaller file). By
    "improving" I mean it will either speed up the very slow compressors
    with minor detriment to compression, or greatly increase the
    compression of simple compression algorithms.

The major disadvantages are:

1.  The main lrzip application only works on single files so it requires
    the lrztar wrapper to fake a complete archiver.
2.  It requires a lot of memory to get the best performance out of, and
    is not really usable (for compression) with less than 256MB.
    Decompression requires less ram and works on smaller ram machines.
    Sometimes swap may need to be enabled on these lower ram machines
    for the operating system to be happy.
3.  STDIN/STDOUT works fine on both compression and decompression, but
    larger files compressed in this manner will end up being less
    efficiently compressed.

The unique feature of lrzip is that it tries to make the most of the
available ram in your system at all times for maximum benefit. It does
this by default, choosing the largest sized window possible without
running out of memory. It also has a unique "sliding mmap" feature which
makes it possible to even use a compression window larger than your
ramsize, if the file is that large. It does this (with the -U option) by
implementing one large mmap buffer as per normal, and a smaller moving
buffer to track which part of the file is currently being examined,
emulating a much larger single mmapped buffer. Unfortunately this mode
can be many times slower.

Benchmarks
----------

See the README.benchmarks included in the source/docs.

FAQ
---

See the README included with the source package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lrzip&oldid=207064"

Category:

-   Data compression and archiving
