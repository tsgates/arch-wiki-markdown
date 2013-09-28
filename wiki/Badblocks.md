badblocks
=========

badblocks is a program to test storage devices for bad blocks.

In case of a HDD the whole sector should get retired. A sector is a
subdivision of a track on a storage device and sectors that have become
bad cannot be used because they have become permanently damaged (a bad
sector can change a letter in a text file to causing a binary program to
have a segmentation fault).

S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology) is
Hardware-featured in almost every HDD still in use nowadays and in some
cases it can automatically retire defect HDD Sectors. Anyhow it only
passively waits for errors while badblocks writes simple patterns to
every block of a device and then reads and checks them searching for
damaged areas. (Just like memtest86* does with RAM.)

This can be done in a destructive write-mode that effectively wipes the
device (do Backup!) or in non-destructive read-write (Backup advisable
as well!) and read-only modes.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Usage                                                              |
| -   2 Storage Device Fidelity                                            |
| -   3 Comparisons with Other Programs                                    |
| -   4 Testing for Bad Sectors                                            |
|     -   4.1 read-write Test                                              |
|         -   4.1.1 define specific test pattern                           |
|             -   4.1.1.1 random pattern                                   |
|                                                                          |
|     -   4.2 read-write Test (non-destructive)                            |
|                                                                          |
| -   5 Have File System Incorporate Bad Sectors                           |
|     -   5.1 During Filesystem Check                                      |
|     -   5.2 Before Filesystem Creation                                   |
|         -   5.2.1 Block size                                             |
|                                                                          |
| -   6 References                                                         |
+--------------------------------------------------------------------------+

Usage
-----

badblocks is in e2fsprogs

Usage:

    badblocks  [  -svwnfBX  ]  [  -b  block-size  ] [ -c blocks_at_once ] [ -e max_bad_blocks ]
    [ -d read_delay_factor ] [ -i input_file ] [ -o output_file ] [ -p num_passes ] [ -t test_pattern ]
    device [ last-block ] [ first-block ]

Storage Device Fidelity
-----------------------

Although there is no firm rule has been set, it is common thinking that
a new drive should have zero bad sectors. Over time, bad sectors will
develop on a storage device and although they are able to be defined to
the file system so that they are avoided, continual use of the drive
will usually result in additional bad sectors forming and are usually
the harbinger of death of a hard drive. Replacement of the device is
recommended.

Comparisons with Other Programs
-------------------------------

Typical recommended practice for testing a storage device for bad
sectors is to use the manufacturer's testing program. Most manufacturers
have programs that do this. The main reasoning for this is that
manufacturers usually have their standards built into the test programs
that will tell you if the drive needs to be replaced or not. The caveat
here being is that some manufacturers testing programs do not print full
test results and allow a certain number of bad sectors saying only if
they pass or not. Manufacturer programs, however, are generally quicker
than badblocks sometimes a fair amount so.

Testing for Bad Sectors
-----------------------

To test for bad sectors in Linux the program badblocks is typically
used. badblocks had several different modes to be able to detect bad
sectors.

> read-write Test

This test is primarily for testing new drives and is a read-write test.
As the pattern is written to every accesible block the device
effectively gets wiped. Default is an extensive test with four passes
using four different patterns: 0xaa (10101010), 0x55 (01010101), 0xff
(11111111) and 0x00 (00000000). For some devices this will take a couple
of days to complete.

    # badblocks -wsv /dev/<device>

    Checking for bad blocks in read-write mode
    From block 0 to 488386583
    Testing with pattern 0xaa: done
    Reading and comparing: done
    Testing with pattern 0x55: done
    Reading and comparing: done
    Testing with pattern 0xff: 22.93% done, 4:09:55 elapsed. (0/0/0 errors)
    [...]
    Testing with pattern 0x00: done
    Reading and comparing: done
    Pass completed, 0 bad blocks found. (0/0/0 errors)

Options:

 -w
    do a destructive write test
 -s
    show progress-bar
 -v
    be "verbose" and output bad sectors detected to stdout

  
 Additional options you might consider:

 -p <number>
    run through the extensive four pass test <number> of sequent
    iterations
 -o </path/to/output-file>
    print bad sectors to <output-file> instead of stdout
 -t <test_pattern> 
    Specify a pattern. See below.

  

define specific test pattern

From the manpage:"The <test_pattern> may either be a numeric value
between 0 and ULONG_MAX-1 inclusive [...]."

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

random pattern

Badblocks can be made to repeatedly write a single "random pattern" with
the -t random option.

    # badblocks -wsv -t random /dev/<device>

    Checking for bad blocks in read-write mode
    From block 0 to 488386583
    Testing with random pattern: done                                                 
    Reading and comparing: done                                                 
    Pass completed, 0 bad blocks found. (0/0/0 errors)

Warning:This is not secure for cryptographic purposes. A "random
pattern" is a contradiction in itself. As badblocks does not (like
urandom) apply sophisticated procedures to reuse entropy but simply
repeats one "random pattern" it should not be used where random data
would be needed, e.g. for block device encryption.

> read-write Test (non-destructive)

This test is designed for devices with data already on them. A
non-destructive read-write test does transparently backup original
content before testing sectors with a single random pattern and then
restoring the content from the backup. This is a single pass test and is
useful as a general maintenance test.

    # badblocks -nsv /dev/<device>

    Checking for bad blocks in non-destructive read-write mode
    From block 0 to 488386583
    Checking for bad blocks (non-destructive read-write test)
    Testing with random pattern: done                                                 
    Pass completed, 0 bad blocks found. (0/0/0 errors)

The -n option signifies a non-destructive read-write test.

Have File System Incorporate Bad Sectors
----------------------------------------

To not use bad sectors they have to be known by the filesystem.

> During Filesystem Check

Incorporating bad sectors can be done using the filesystem check utility
(fsck). fsck can be told to use badblocks during a check. To do a
read-write (non-destructive) test and have the bad sectors made known to
the filesystem run:

    # fsck -vcck /dev/<device-PARTITION>

The -cc option tells run fsck in non-destructive test mode, the -v tells
fsck to show its output, and the -k option preserves old bad sectors
that were detected.

To do a read-only test (not recommended):

    # fsck -vck /dev/<device-PARTITION>

> Before Filesystem Creation

Alternately, this can be done before filesystem creation.

If badblocks is run without the -o option bad sectors will only be
printed to stdout.

Example output for read errors in the beginning of the disk:

    # badblocks -wsv /dev/<drive>

    [...]
    Testing with pattern 0xff: done                                                 
    Reading and comparing:
    [...]
    37584
    37585 0.84% done, 7:31:08 elapsed. (0/0/527405 errors)
    37586
    [...]
    done
    Testing with pattern 0x00:
    Reading and comparing:
    [...]
    37584
    37585
    [...]
    done
    Pass completed, 527405 bad blocks found. (0/0/527405 errors)

For comfortably passing badblocks error output to the filesystem it has
to be written to a file.

    # badblocks -wsv -o /root/<badblocks.txt> /dev/<device>

    Checking for bad blocks in read-write mode
    From block 0 to 488386583
    Testing with pattern 0xaa: done
    Reading and comparing:   6.36% done, 0:51 elapsed. (0/0/14713 errors)
    [...]
    Testing with pattern 0x00: done
    Reading and comparing: done
    Pass completed, 527405 bad blocks found. (0/0/527405 errors)

Then (re-)create the file system with the information:

    # mkfs.<filesystem-type> -l /root/<badblocks.txt> /dev/<device>

Note:The means of 0/0/527405 errors is <number of read errors>/<number
of write errors>/<number of corruption errors>.

Block size

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Securely    
                           wipe disk#Block size.    
                           Notes: Block size        
                           alignment is not         
                           specific to this tiny    
                           section. Other Arch Wiki 
                           Articles already do      
                           cover this up. Search    
                           for it and cover         
                           everything up on a Block 
                           size page. (Discuss)     
  ------------------------ ------------------------ ------------------------

first find the file systems block size. For example for ext#
filesystems:

    # dumpe2fs /dev/<device-PARTITION> | grep 'Block size'

feed this to badblocks:

    # badblocks -b <block size>

References
----------

-   My hard disk has bad sectors or is developing bad sectors over time

Retrieved from
"https://wiki.archlinux.org/index.php?title=Badblocks&oldid=243779"

Category:

-   Hardware detection and troubleshooting
