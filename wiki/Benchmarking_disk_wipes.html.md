Benchmarking disk wipes
=======================

Summary help replacing me

Benchmark different methods of disk wiping.

> Related

Securely wipe disk

Frandom

Benchmarking

Contents
--------

-   1 Frequently asked Questions
    -   1.1 Q: How do I wipe a disk?
    -   1.2 Q: Are there other way's to benchmark a disk?
    -   1.3 Q: How do I get the HDD model with hdparm?
    -   1.4 Q: How do I check progress of dd while running?
    -   1.5 Benchmarking with dcfldd
-   2 Data
    -   2.1 /dev/frandom
    -   2.2 /dev/zero

Frequently asked Questions
--------------------------

Q: How do I wipe a disk?

A: Securely wipe disk.

Q: Are there other way's to benchmark a disk?

A: Of course. Take a look at Hdparm.

Q: How do I get the HDD model with hdparm?

A: # hdparm -i /dev/sdX | grep Model.

Q: How do I check progress of dd while running?

A: Checking progress of dd while running.

> Benchmarking with dcfldd

Dcfldd doesn't print the average speed in MB/s like good old dd does but
with time you can work around that.

Time the run clearing the disk:

    # time dcfldd if=/dev/zero of=/dev/sdX bs=4M
    18944 blocks (75776Mb) written.dcfldd:: No space left of device
    real     16m17.033s
    user     0m0.377s
    sys      0m51.160s

Calculate MB/s by dividing the output of the dcfldd command by the time
in seconds. For this example: 75776Mb / (16.4 min * 60) = 77.0 MB/s.

Data
----

Note:The community is encouraged to populate the tables in this section.

> /dev/frandom

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Frandom.    
                           Notes: The "Benchmarks"  
                           on the frandom page      
                           should get incorporated  
                           here. The frandom page   
                           should stay intact of    
                           course. (Discuss)        
  ------------------------ ------------------------ ------------------------

> /dev/zero

Note:As there has been no evident clarification in the article this
table was moved from it can only be assumed all wipes were done with
/dev/zero.

  Manufacture       Model             HDD Speed (RPM)   Interface   Capacity (GB)   Time (Hrs)   Throughput (MB/s)
  ----------------- ----------------- ----------------- ----------- --------------- ------------ -------------------
  Hitachi           HTS725016A9A364   7200              SATA2       160             0.72         63
  Intel             SSDSA2M080G2GC    SSD               SATA2       80              0.27         77
  Samsung           HD322HJ           7200              SATA2       320             1.15         74
  Seagate           ST31000333AS      7200              SATA2       1000            2.92         90
  Seagate           ST31500341AS      7200              SATA2       1500            4.13         96
  Western Digital   WD20EARS          5900              SATA2       2000            5.91         94

Retrieved from
"https://wiki.archlinux.org/index.php?title=Benchmarking_disk_wipes&oldid=304827"

Categories:

-   Security
-   Hardware

-   This page was last modified on 16 March 2014, at 07:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
