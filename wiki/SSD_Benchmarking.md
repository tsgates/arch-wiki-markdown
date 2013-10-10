SSD Benchmarking
================

> Summary

This article covers several Linux-native apps that benchmark I/O devices
such as HDDs, SSDs, USB thumb drives, etc. There is also a "database"
section specific to SSDs meant to capture user-entered benchmark
results.

Related Articles

Solid State Drives

Benchmarking

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Using hdparm                                                 |
|     -   1.2 Using gnome-disks                                            |
|     -   1.3 Using systemd-analyze                                        |
|     -   1.4 Using dd                                                     |
|     -   1.5 Model Specific Data                                          |
|     -   1.6 Template                                                     |
|                                                                          |
| -   2 Results                                                            |
|     -   2.1 Table                                                        |
|     -   2.2 Corsair                                                      |
|         -   2.2.1 Corsair Force 3                                        |
|                                                                          |
|     -   2.3 Crucial                                                      |
|         -   2.3.1 Crucial C300                                           |
|         -   2.3.2 Crucial M4                                             |
|                                                                          |
|     -   2.4 Intel                                                        |
|         -   2.4.1 Intel 310 Soda Creek                                   |
|         -   2.4.2 Intel 330                                              |
|         -   2.4.3 Intel X18-M (G2)                                       |
|         -   2.4.4 Intel X25-M (G2)                                       |
|         -   2.4.5 Intel X25-M (G2)                                       |
|         -   2.4.6 Intel X25-M (G2)                                       |
|         -   2.4.7 Intel X25-M (G2)                                       |
|                                                                          |
|     -   2.5 OCZ                                                          |
|         -   2.5.1 OCZ-VERTEX 4 128 GB                                    |
|         -   2.5.2 OCZ-VERTEX 4 128 GB                                    |
|             -   2.5.2.1 In SATA 6.0 Gb/s Controller                      |
|             -   2.5.2.2 In SATA 3.0 Gb/s Controller                      |
|                                                                          |
|         -   2.5.3 OCZ-VERTEX 60gb                                        |
|         -   2.5.4 OCZ-VERTEX3 120                                        |
|         -   2.5.5 OCZ-VERTEX3 120GO                                      |
|         -   2.5.6 OCZ-VERTEX-TURBO 30gb                                  |
|         -   2.5.7 OCZ-VERTEX2 240GB                                      |
|         -   2.5.8 OCZ-VERTEX3 120GB                                      |
|         -   2.5.9 OCZ-AGILITY3 120GB                                     |
|                                                                          |
|     -   2.6 Samsung                                                      |
|         -   2.6.1 SAMSUNG 128GB / SATAII                                 |
|         -   2.6.2 SAMSUNG 470 64GB                                       |
|         -   2.6.3 SAMSUNG 830 128GB                                      |
|         -   2.6.4 SAMSUNG 830 256GB                                      |
|         -   2.6.5 SAMSUNG 840 250GB                                      |
|                                                                          |
|     -   2.7 Sandisk                                                      |
|         -   2.7.1 Sandisk Extreme 240 GB                                 |
|         -   2.7.2 Sandisk Extreme 120 GB                                 |
|                                                                          |
|     -   2.8 Kingston                                                     |
|         -   2.8.1 Kingston HyperX 120 GB                                 |
|         -   2.8.2 Kingston HyperX 3K 120GB                               |
|         -   2.8.3 Kingston HyperX 3K 120GB                               |
|         -   2.8.4 Kingston SSDNow V+100 128 GB                           |
|         -   2.8.5 Kingston SNV425-S2BD 128GB                             |
|                                                                          |
|     -   2.9 Mushkin                                                      |
|         -   2.9.1 Mushkin mSATA Atlas 128GB                              |
|                                                                          |
|     -   2.10 Liteon                                                      |
|         -   2.10.1 Liteon M3S                                            |
|                                                                          |
| -   3 Encrypted Partitions                                               |
|     -   3.1 dm-crypt with AES                                            |
|         -   3.1.1 Crucial                                                |
|             -   3.1.1.1 Crucial M4 256 Gb                                |
|                                                                          |
|         -   3.1.2 OCZ                                                    |
|             -   3.1.2.1 OCZ-VERTEX2 180GB                                |
|                                                                          |
|         -   3.1.3 Samsung                                                |
|             -   3.1.3.1 SAMSUNG 470 128GB                                |
|             -   3.1.3.2 SAMSUNG 830 256GB                                |
|             -   3.1.3.3 SAMSUNG 830 256GB                                |
|                                                                          |
|     -   3.2 Truecrypt                                                    |
|                                                                          |
| -   4 Comparison - high end SCSI RAID 0 hard drive benchmark             |
|     -   4.1 LSI 320-2X Megaraid SCSI                                     |
+--------------------------------------------------------------------------+

Introduction
------------

Several I/O benchmark options exist under Linux.

-   Using hddparm with the -Tt switch, one can time sequential reads.
    This method is independent of partition alignment!
-   There is a graphical benchmark called gnome-disks contained in the
    gnome-disk-utility package that will give min/max/ave reads along
    with ave access time and a nice graphical display. This method is
    independent of partition alignment!
-   The dd utility can be used to measure both reads and writes. This
    method is dependent on partition alignment! In other words, if you
    failed to properly align your partitions, this fact will be seen
    here since you're writing and reading to a mounted filesystem.
-   Bonnie++

> Using hdparm

    # hdparm -Tt /dev/sdX
    /dev/sdX:
    Timing cached reads:   x MB in  y seconds = z MB/sec
    Timing buffered disk reads:  x MB in  y seconds = z MB/sec

Note:One should run the above command 4-5 times and manually average the
results for an accurate evaluation of read speed per the hddparm man
page.

> Using gnome-disks

    # gnome-disks

Users will need to navigate through the GUI to the benchmark button
("More actions..." => "Benchmark Volume..."). Example

> Using systemd-analyze

    systemd-analyze plot > boot.svg

Will plot a detailed graphic with the boot sequence: kernel time,
userspace time, time taken by each service. Example

> Using dd

Note:This method requires the command to be executed from a mounted
partition on the device of interest!

First, enter a directory on the SSD with at least 1.1 GB of free space
(and one that obviously gives your user wrx permissions) and write a
test file to measure write speeds and to give the device something to
read:

    $ cd /path/to/SSD
    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    w bytes (x GB) copied, y s, z MB/s

Next, clear the buffer-cache to accurately measure read speeds directly
from the device:

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    w bytes (x GB) copied, y s, z MB/s

Now that the last file is in the buffer, repeat the command to see the
speed of the buffer-cache:

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    w bytes (x GB) copied, y s, z GB/s

Note:One should run the above command 4-5 times and manually average the
results for an accurate evaluation of the buffer read speed.

Finally, delete the temp file

    $ rm tempfile

> Model Specific Data

Please contribute to this section using the template below to post
results obtained.

See here for a nice database of benchmarks.

> Template

-   SSD:
-   Model Number:
-   Firmware Version:
-   Capacity: x GB
-   Controller:
-   User:
-   Kernel:

[*Filesystem: write something about your FS, optional] [*Notes:
additional Notes, optional]

    # hdparm -Tt /dev/sdx

    Minimum Read Rate: x MB/s
    Maximum Read Rate: x MB/s
    Average Read Rate: x MS/s
    Average Access Time x ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    $ dd if=tempfile of=/dev/null bs=1M count=1024

Results
-------

> Table

All values are taken from the dd benchmark. This is just an overview and
has no scientific use.

  User              Vendor     Model              Capacity [GB]   Write [MB/sec]   Read [MB/sec]   Re-Read [MB/sec]
  ----------------- ---------- ------------------ --------------- ---------------- --------------- ------------------
  jac               Crucial    C300               128             138              372             6500
  lynix             Crucial    M4                 128             193              268             6800
  wzyboy            Crucial    M4                 64              113              276             3400
  dundee            Intel      310 Soda Creek     40              44.2             197             4200
  bugflux           Intel      330                120             44.2             242             4500
  Cirk              Intel      X18-M (G2)         160             103              263             2700
  Graysky           Intel      X25-M (G2)         80              80.6             268             6300
  fackamato         Intel      X25-M (G2)         160             98               262             3000
  Cirk              Intel      X25-M (G2)         80              70               208             4200
  timo.hardebusch   Intel      X25-M (G2)         120             106              265             2900
  Musikolo          OCZ        Vertex 4 SATA 3    128             233              392             3600
  Graysky           OCZ        Vertex 4 SATA 3    128             228              394             -
  Graysky           OCZ        Vertex 4 SATA 2    128             251              284             -
  Surfed            OCZ        Vertex             60              142              236             5200
  Sputnick          OCZ        Vertex 3           120             245              225             4600
  ScottKidder       OCZ        Vertex Turbo       30              49               115             2600
  longint           OCZ        Vertex 2           240             852?             241             3400
  muflone           OCZ        Vertex 3           120             377              291             10300
  bardo             OCZ        Agility 3          120             445              455             8200
  Cirk              Samsung    MMCQE28GFMUP-MVA   128             45               99              2300
  skylinux          Samsung    470                64              188              204             1000
  kevincodux        Samsung    830                128             313              525             9000
  Earlz             Samsung    840                250             242              282             9800
  Dani              Sandisk    Extreme            240             481              414             6000
  kozaki            Sandisk    Extreme            120             458              403             8200
  Artsibash         Kingston   HyperX             120             451              431             8600
  WonderWoofy       Kingston   HyperX 3k          120             518              316             7200
  Tuxe              Kingston   SSDNow V+100       128             110              232             3300
  thof              Kingston   SNV425-S2BD        128             164              260             3000
  WonderWoofy       Mushkin    Atlas (mSATA II)   128             262              242             7300
  AleksMK           Liteon     M3S                256             336              432             4200

> Corsair

Corsair Force 3

-   SSD: Corsair Force 3 120gb (SATA 3)
-   Model Number: Corsair Force 3 SSD
-   Firmware Version: 1.3.3
-   Capacity: 120 GB
-   User: bserem
-   Kernel: 3.4.9
-   Filesystem: BTRFS
-   Notes: , Systemd, UEFI (with a small FAT uefi partition at the
    beggining of the disk)

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   28232 MB in  2.00 seconds = 14137.02 MB/sec
    Timing buffered disk reads: 1164 MB in  3.01 seconds = 387.33 MB/sec

    Minimum Read Rate: 388.04 MB/s
    Maximum Read Rate: 387.13 MB/s
    Average Read Rate: 387.252 MS/s

  

> Crucial

Crucial C300

-   SSD: Crucial C300 (SATA 3: 6Gb/s)
-   Model Number: CTFDDAC128MAG-1G1
-   Capacity: 128 GB
-   User: jac

    # hdparm -Tt /dev/sdb
    /dev/sda:
    Timing cached reads:   24112 MB in  2.00 seconds = 12072.84 MB/sec
    Timing buffered disk reads: 1056 MB in  3.00 seconds = 351.58 MB/sec

    Minimum Read Rate: 350.88 MB/s
    Maximum Read Rate: 351.58 MB/s
    Average Read Rate: 351.264 MB/s

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 7.77883 s, 138 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.88752 s, 372 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.164471 s, 6.5 GB/s

Crucial M4

-   SSD: Crucial M4 (SATA 3: 6Gb/s)
-   Model Number: M4-CT128M4SSD2 (Firmware: 0009)
-   Capacity: 128 GB
-   User: lynix
-   Filesystem: ext4 on LVM
-   Notes: connected to SATAII 3Gb/s port while benchmarking. firmware
    matters!

    # hdparm -Tt /dev/sde
    /dev/sde:
    Timing cached reads:   19094 MB in  2.00 seconds = 9559.40 MB/sec
    Timing buffered disk reads: 786 MB in  3.00 seconds = 261.63 MB/sec

    Minimum Read Rate: 271.7 MB/s
    Maximum Read Rate: 381.7 MB/s
    Average Read Rate: 279.0 MB/s

    Minimum Write Rate: 58.6 MB/s
    Maximum Write Rate: 258.9 MB/s
    Average Write Rate: 194.8 MB/s

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 5.57478 s, 193 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.00688 s, 268 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.157567 s, 6.8 GB/s

> Intel

Intel 310 Soda Creek

-   SSD: Intel 310 Soda Creek
-   Model Number: SSDMAEMC040G2
-   Firmware Version: 2CV1023M
-   Capacity: 40 GB
-   User: dundee
-   Filesystem: ext4

    # hdparm -Tt /dev/sdb

/dev/sdb:

    Timing cached reads:   6278 MB in  2.00 seconds = 3141.39 MB/sec
    Timing buffered disk reads:  784 MB in  3.00 seconds = 260.96 MB/sec

    Minimum Read Rate: 189.7 MB/s
    Maximum Read Rate: 281.1 MB/s
    Average Read Rate: 277.1 MS/s
    Minimum Write Rate: 30.3 MB/s
    Maximum Write Rate: 44.6 MB/s
    Average Write Rate: 43.8 MS/s

    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 24.3013 s, 44.2 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 5.45325 s, 197 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.255569 s, 4.2 GB/s

Intel 330

-   SSD: Intel 330
-   Model Number: SSDSC2CT120A3
-   Firmware Version: 300i
-   Capacity: 120 GB
-   User: bugflux
-   Filesystem: ext4
-   Note: Sata II computer

    # hdparm -tT /dev/sda
    /dev/sda:
    Timing cached reads:   9222 MB in  2.00 seconds = 4612.61 MB/sec
    Timing buffered disk reads: 672 MB in  3.01 seconds = 223.40 MB/sec

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 24.3013 s, 44.2 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.43827 s, 242 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.240778 s, 4.5 GB/s

Intel X18-M (G2)

-   SSD: Intel X18-M Generation 2
-   Model Number: SSDSA1M1602GN
-   Capacity: 160 GB
-   User: Cirk

    # hdparm -Tt /dev/sda
    Timing cached reads:   2826 MB in  2.00 seconds = 1414.39 MB/sec
    Timing buffered disk reads: 694 MB in  3.00 seconds = 231.14 MB/sec

    Minimum Read Rate: 216.1 MB/s
    Maximum Read Rate: 283.5 MB/s
    Average Read Rate: 271.2 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 10.4608 s, 103 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.0866 s, 263 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.403244 s, 2.7 GB/s

Intel X25-M (G2)

-   SSD: Intel X25-M Generation 2
-   Model Number: SSDSA2MH080G2R5
-   Capacity: 80 GB
-   User: Graysky

    # hdparm -Tt /dev/sdb
    /dev/sdb:
    Timing cached reads:   15644 MB in  1.99 seconds = 7845.48 MB/sec
    Timing buffered disk reads:  788 MB in  3.00 seconds = 262.52 MB/sec

    Minimum Read Rate: 253.6 MB/s
    Maximum Read Rate: 286.1 MB/s
    Average Read Rate: 282.6 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 13.3236 s, 80.6 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.00297 s, 268 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.169713 s, 6.3 GB/s

Intel X25-M (G2)

-   SSD: Intel X25-M Generation 2
-   Model Number: SSDSA2M160G2GC
-   Capacity: 160 GB
-   User: fackamato

    # hdparm -Tt /dev/sda
    Timing cached reads:   2890 MB in  2.00 seconds = 1445.86 MB/sec
    Timing buffered disk reads: 738 MB in  3.00 seconds = 245.69 MB/sec

    Minimum Read Rate: 244.3 MB/s
    Maximum Read Rate: 278.6 MB/s
    Average Read Rate: 273.3 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 10.8582 s, 98.9 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.09679 s, 262 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.363709 s, 3.0 GB/s

Intel X25-M (G2)

-   SSD: Intel X25-M Generation 2
-   Model Number: SSDSA2M080G2C
-   Capacity: 80 GB
-   User: Cirk

    # hdparm -Tt /dev/sda
    Timing cached reads:   9384 MB in  2.00 seconds = 4694.29 MB/sec
    Timing buffered disk reads: 808 MB in  3.01 seconds = 268.64 MB/sec

    Minimum Read Rate: 229.9 MB/s
    Maximum Read Rate: 281.6 MB/s
    Average Read Rate: 272.4 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 15.1671 s, 70.8 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 5.15237 s, 208 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.256211 s, 4.2 GB/s

Intel X25-M (G2)

-   SSD: Intel X25-M Generation 2
-   Model Number: SSDSA2MH120G2K5
-   Capacity: 120 GB
-   User: timo.hardebusch

    # hdparm -Tt /dev/sdb
    /dev/sdb:
    Timing cached reads:   4358 MB in  2.00 seconds = 2178.89 MB/sec
    Timing buffered disk reads:  752 MB in  3.01 seconds = 250.07 MB/sec

    Minimum Read Rate: 259.1 MB/s
    Maximum Read Rate: 283.3 MB/s
    Average Read Rate: 280.6 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 10.1452 s, 106 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.05181 s, 265 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.369308 s, 2.9 GB/s

> OCZ

OCZ-VERTEX 4 128 GB

-   SSD:OCZ Vertex 4
-   Model Number: VTX4-25SAT3
-   Firmware Version: 1.5
-   Capacity: 128 GB
-   Controller: Marvell Technology Group Ltd. 88SE9128 PCIe SATA 6 Gb/s
    RAID controller (rev 11)
-   Kernel: 3.6.11-1
-   User: Musikolo
-   Notes:
    -   Filesystem: ext4 with options defaults,relatime,discard.
    -   Partition: aligned (fist sector 2048 / 1MiB free space at the
        beginning). Additional info here.
    -   Scheduler: deadline. Additional info here.

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   7752 MB in  2.00 seconds = 3877.19 MB/sec
    Timing buffered disk reads: 1122 MB in  3.00 seconds = 373.78 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.60766 s, 233 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.74071 s, 392 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.302118 s, 3.6 GB/s

OCZ-VERTEX 4 128 GB

-   SSD:OCZ Vertex 4
-   Model Number: VTX4-25SAT3 - firmware 1.5
-   Capacity: 128 GB
-   User: User:Graysky

In SATA 6.0 Gb/s Controller

    #  hdparm -Tt /dev/sda

    /dev/sda:
    Timing cached reads:   33756 MB in  2.00 seconds = 16902.49 MB/sec

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.9279 s, 367 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.49942 s, 430 MB/s

In SATA 3.0 Gb/s Controller

    # hdparm -Tt /dev/sda

    /dev/sda:
     Timing cached reads:   15842 MB in  2.00 seconds = 7930.79 MB/sec
     Timing buffered disk reads: 814 MB in  3.00 seconds = 271.02 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.28493 s, 251 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.78546 s, 284 MB/s

OCZ-VERTEX 60gb

-   SSD:OCZ-VERTEX
-   Model Number:Firmware 1.5
-   Capacity: 60 GB
-   User:Surfed

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   16306 MB in  2.00 seconds = 8162.55 MB/sec
    Timing buffered disk reads: 646 MB in  3.00 seconds = 215.09 MB/sec

  

    Minimum Read Rate: 226.7 MB/s
    Maximum Read Rate: 275.2 MB/s
    Average Read Rate: 256.9 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 7.5581 s, 142 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.55881 s, 236 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.205299 s, 5.2 GB/s

OCZ-VERTEX3 120

-   SSD:OCZ-VERTEX3
-   Firmware Version:
-   Capacity: 6Gb/s SATA III
-   User:User:pingpong

    # hdpram -Tt /dev/sda

    /dev/sda:
    Timing cached reads:   11180 MB in  2.00 seconds = 5594.15 MB/sec
    Timing buffered disk reads: 736 MB in  3.00 seconds = 245.27 MB/sec

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc

    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.20024 s, 256 MB/s

    #echo 3 > /proc/sys/vm/drop_caches

    $ dd if=tempfile of=/dev/null bs=1M count=1024
     1024+0 records in
     1024+0 records out
     1073741824 bytes (1.1 GB) copied, 4.12454 s, 260 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024

    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.172948 s, 6.2 GB/s

OCZ-VERTEX3 120GO

-   SSD:OCZ-VERTEX3
-   Firmware Version:2.06
-   Capacity: 6Gb/s SATA III
-   User:User:Sputnick
-   Notes: tested on SATA II 3Gb/s Dell Optiplex 780 motherboard 0C27VV

    # hdparm -Tt /dev/sdc

    /dev/sdc:
    Timing cached reads:   13702 MB in  2.00 seconds = 6859.89 MB/sec
    Timing buffered disk reads: 644 MB in  3.00 seconds = 214.40 MB/sec

  

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 enregistrements lus
    1024+0 enregistrements écrits
    1073741824 octets (1,1 GB) copiés, 4,37831 s, 245 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 enregistrements lus
    1024+0 enregistrements écrits
    1073741824 octets (1,1 GB) copiés, 4,76932 s, 225 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 enregistrements lus
    1024+0 enregistrements écrits
    1073741824 octets (1,1 GB) copiés, 0,234682 s, 4,6 GB/s

OCZ-VERTEX-TURBO 30gb

-   SSD:OCZ-VERTEX-TURBO
-   Model Number:Firmware 1.5
-   Capacity: 30 GB
-   User:ScottKidder

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   6286 MB in  2.00 seconds = 3149.62 MB/sec
    Timing buffered disk reads: 630 MB in  3.01 seconds = 209.10 MB/sec

    Minimum Read Rate: 211.8 MB/s
    Maximum Read Rate: 254.1 MB/s
    Average Read Rate: 249.2 MB/s
    Average Access Time 0.1 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 21.5437 s, 49.8 MB/s

    # echo 3 > /proc/sys/vm/drop_caches

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 9.34704 s, 115 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.40667 s, 2.6 GB/s

OCZ-VERTEX2 240GB

-   SSD: OCZ
-   Model Number: Vertex2
-   Capacity: 240GB
-   User: longint
-   Filesystem: btrfs compression=lzo,space_cache

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   10972 MB in  2.00 seconds = 5489.70 MB/sec
    Timing buffered disk reads: 648 MB in  3.00 seconds = 215.96 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 1.26013 s, 852 MB/s

    # echo 3 > /proc/sys/vm/drop_caches

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.45112 s, 241 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.320492 s, 3.4 GB/s

OCZ-VERTEX3 120GB

-   SSD:OCZ-VERTEX3 SATA III
-   Firmware Version:2.13
-   Capacity: 120 GB
-   Filesystem: ext4 with discard and commit=60
-   User:muflone

    # hdparm -Tt /dev/sdc
    /dev/sdc:
    Timing cached reads:   23870 MB in  2.00 seconds = 11950.12 MB/sec
    Timing buffered disk reads: 866 MB in  3.00 seconds = 288.36 MB/sec

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.85159 s, 377 MB/s

    # echo 3 > /proc/sys/vm/drop_caches

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.6931 s, 291 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.10383 s, 10.3 GB/s

OCZ-AGILITY3 120GB

-   SSD:OCZ-AGILITY3 SATA III
-   Firmware Version:2.15
-   Capacity: 120 GB
-   Filesystem: ext4 with discard
-   User:bardo

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   27738 MB in  2.00 seconds = 13889.38 MB/sec
    Timing buffered disk reads: 1158 MB in  3.01 seconds = 385.08 MB/sec

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.41537 s, 445 MB/s

    # echo 3 > /proc/sys/vm/drop_caches

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.35961 s, 455 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.130664 s, 8.2 GB/s

> Samsung

SAMSUNG 128GB / SATAII

-   SSD: SAMSUNG 128GB / SATAII
-   Model Number: MMCQE28GFMUP-MVA
-   Capacity: 128 GB
-   User: Cirk

    # hdparm -Tt /dev/sda
    Timing cached reads:   2612 MB in  2.00 seconds = 1307.40 MB/sec
    Timing buffered disk reads: 294 MB in  3.01 seconds =  97.67 MB/sec

    Minimum Read Rate: 108.7 MB/s
    Maximum Read Rate: 114.5 MB/s
    Average Read Rate: 113.7 MB/s
    Average Access Time 0.2 ms

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 23.7352 s, 45.2 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 10.7563 s, 99.8 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.464824 s, 2.3 GB/s

SAMSUNG 470 64GB

-   SSD: SAMSUNG 470 64GB
-   Model Number: MZ-5PA064/US
-   Firmware: AXM070Q1
-   Capacity: 64 GB
-   User: skylinux

    # hdparm -Tt /dev/sda
    Timing cached reads:   1736 MB in  2.00 seconds = 868.62 MB/sec
    Timing buffered disk reads: 516 MB in  3.00 seconds = 171.87 MB/sec

    Minimum Read Rate: 276.5 MB/s
    Maximum Read Rate: 278.8 MB/s
    Average Read Rate: 278.2 MB/s
    Average Access Time 0.2 ms

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 5.69714 s, 188 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 5.25116 s, 204 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 1.05824 s, 1.0 GB/s

SAMSUNG 830 128GB

-   SSD: SAMSUNG 830 128GB
-   Model Number: MZ-7PC128D
-   Firmware: CXM03B1Q
-   Capacity: 128 GB
-   User: kevincodux
-   Filesystem: ext4,discard,noatime
-   Notes: SATAIII, partitions aligned and no swap

    # hdparm -Tt /dev/sda
    Timing cached reads:   22130 MB in  2.00 seconds = 11080.54 MB/sec
    Timing buffered disk reads: 1500 MB in  3.00 seconds = 499.38 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.42567 s, 313 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.04691 s, 525 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.119695 s, 9.0 GB/s

SAMSUNG 830 256GB

-   SSD: SAMSUNG 830 256GB
-   Model Number: MZ-7PC256
-   Firmware Version: CXM03B1Q
-   Capacity: 256 GB
-   User: Revelation
-   Kernel: 3.5.4
-   Filesystem: ext4

    # hdparm -Tt /dev/sda
    Timing cached reads:   15888 MB in  2.00 seconds = 7952.13 MB/sec
    Timing buffered disk reads: 1464 MB in  3.00 seconds = 488.00 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3,15782 s, 340 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2,08421 s, 515 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.119695 s, 6.2 GB/s

  

SAMSUNG 840 250GB

-   SSD: SAMSUNG 840 250GB
-   Firmware: DXT07B0Q
-   Capacity: 250 GB
-   Filesystem: XFS(defaults,relatime,discard)
-   Kernel: 3.7.7-1-ARCH
-   Other details: SATA3 motherboard and hookups. Configured with hdparm
    to reserve 20% of the drive for over-provisioning
-   User: Earlz

    # hdparm -Tt /dev/sdc
    /dev/sdc:
    Timing cached reads:   21380 MB in  2.00 seconds = 10703.38 MB/sec
    Timing buffered disk reads: 810 MB in  3.00 seconds = 269.74 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.44147 s, 242 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.80874 s, 282 MB/s

Notes: Firmware updating was a pain because they don't make it obvious
you can update without using their Windows-only magician software. Go
here for ISO images of the updates pre-made and ready to download.

> Sandisk

Sandisk Extreme 240 GB

-   SSD: Sandisk Extreme (SATA 3: 6Gb/s)
-   Model Number: SDSSDX240GG25
-   Capacity: 240 GB
-   User: Dani

    # sudo hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   11596 MB in  2.00 seconds = 5802.26 MB/sec
    Timing buffered disk reads: 1190 MB in  3.00 seconds = 396.16 MB/sec

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.23003 s, 481 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.5909 s, 414 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.177952 s, 6.0 GB/s

Sandisk Extreme 120 GB

-   SSD: Sandik Extreme 120 GB (SATA 3: 6 GB/s)
-   Model Number: SDSSDX-120G-G25
-   Firmware Version: R201
-   Capacity: 120 GB
-   User: hsngrms
-   Kernel: 3.6.3-1-ARCH x86_64
-   Filesystem: EXT4

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   6824 MB in  2.00 seconds = 3413.53 MB/sec
    Timing buffered disk reads: 1332 MB in  3.00 seconds = 443.99 MB/sec 

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 2,44496 s, 439 MB/s 

    # echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 2,64944 s, 405 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 0,163495 s, 6,6 GB/s

-   SSD: Sandik Extreme 120 GB
-   Model Number: SDSSDX-120G-G25
-   Firmware Version: R211
-   Capacity: 120 GB
-   Controller: SATA controller: Intel Corporation 7 Series/C210 Series
    Chipset Family 6-port [AHCI mode] (rev 04)
-   User: kozaki
-   Kernel: 3.7.4-1-ARCH x86_64
-   Filesystem: EXT4 (Arch 201301 Default: fstab: default)
-   Notes: SataIII, GPT partitions aligned on sectors, LVM2
    (--dataalignment 1m), cfq I/O scheduler, Asrock B75Pro mobo

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:  16913 MB in  2.00 seconds = 8464.76 MB/sec
    Timing buffered disk reads: 1414 MB in  3.00 seconds = 470.85 MB/sec 

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 2.3301 s, 461.33 MB/s

    # echo 3 > /proc/sys/vm/drop_caches

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 2.65322 s, 403.67 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 0.137885 s, 7.87 GB/s

-   Note: Same model and config, but with the Filesystem mount options
    and the deadline I/O scheduler
-   Filesystem: EXT4 (fstab: noatime,discard)

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:  17162 MB in  2.00 seconds = 8588.88 MB/sec
    Timing buffered disk reads: 1416 MB in  3.00 seconds = 471.76 MB/sec 

    $ dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 2.3486 s, 458 MB/s

    # echo 3 > /proc/sys/vm/drop_caches

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 2.6593 s, 403.33 MB/s

    $ dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1,1 GB) copied, 0.1312 s, 8.2 GB/sec

> Kingston

Kingston HyperX 120 GB

-   SSD: Kingston HyperX 120 GB
-   Model Number: SH100S3120G
-   Firmware: 320ABBF0
-   Capacity: 120 GB
-   User: Artsibash

    # hdparm -Tt /dev/sda
    Timing cached reads:   26564 MB in  2.00 seconds = 13296.53 MB/sec
    Timing buffered disk reads: 1130 MB in  3.00 seconds = 376.16 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.37858 s, 451 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.48961 s, 431 MB/s

    # dd if=/tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.125463 s, 8.6 GB/s

Kingston HyperX 3K 120GB

-   SSD: Kingston HyperX 3K 120GB (MLC/Intel synchronous ONFi NAND/LSI
    SandForce SF-2281 25nm controller/SATA3/2.5")
-   Model Number: SH103S3120G
-   Firmware: 501ABBF0
-   Capacity: 120 GB
-   Misc: Intel DQ77MK mobo SATA3 port, linux 3.5.4-1, ext4 (has_journal
    + discard,noatime)
-   User: MajorTom

    # hdparm -Tt /dev/sda
    Timing cached reads:   15382 MB in  2.00 seconds = 7702.01 MB/sec
    Timing buffered disk reads: 1442 MB in  3.00 seconds = 480.39 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.06937 s, 519 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.58996 s, 415 MB/s

    # dd if=/tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.207434 s, 5.2 GB/s

Kingston HyperX 3K 120GB

-   SSD: Kingston HyperX 3K 120GB
-   Model Number: SH103S3120G
-   Firmware: 503ABBF0
-   Capacity: 120 GB
-   Misc: SATA3 port, linux 3.6.4-1-ck, ext4
-   User: WonderWoofy

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   16562 MB in  2.00 seconds = 8289.47 MB/sec
    Timing buffered disk reads: 1078 MB in  3.01 seconds = 358.53 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.07445 s, 518 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.40264 s, 316 MB/s

    # dd if=/tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.149056 s, 7.2 GB/s

Kingston SSDNow V+100 128 GB

-   SSD: Kingston SSDNow v+100 128 GB
-   Model Number: SVP100S2128G
-   Firmware: CJRA0202
-   Capacity: 128 GB
-   User: Tuxe

    # hdparm -Tt /dev/sda
    Timing cached reads:   11598 MB in  1.99 seconds = 5822.73 MB/sec
    Timing buffered disk reads: 598 MB in  3.01 seconds = 198.90 MB/sec

    Minimum Read Rate: 145.8 MB/s
    Maximum Read Rate: 259.2 MB/s
    Average Read Rate: 243.5 MB/s
    Average Access Time 0.1 ms

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 9.74199 s, 110 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.62165 s, 232 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.330142 s, 3.3 GB/s

Kingston SNV425-S2BD 128GB

-   SSD: Kingston SNV425-S2BD/128GB
-   Model Number: SNV425S2128GB
-   Firmware: C09112a6
-   Capacity: 128 GB
-   User: thof
-   Filesystem: ext4
-   Kernel: 3.3.4

    # hdparm -Tt /dev/sda
    Timing cached reads:   3614 MB in  2.00 seconds = 1808.83 MB/sec
    Timing buffered disk reads: 736 MB in  3.01 seconds = 244.91 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 6.5301 s, 164 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.1377 s, 260 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.363142 s, 3.0 GB/s

> Mushkin

Mushkin mSATA Atlas 128GB

-   SSD: Mushkin Atlas 128GB SATA III
-   Model Number: MKNSSDAT120GB-DX
-   Firmware: 504ABBF0
-   Capacity: 120 GB
-   Misc: SATA II Port (mSATA), linux 3.6.4-1-ck, ext4, Sandforce,
-   User: WonderWoofy

    # hdparm -Tt /dev/sda
    /dev/sdb:
    Timing cached reads:   16116 MB in  2.00 seconds = 8065.82 MB/sec
    Timing buffered disk reads: 458 MB in  3.00 seconds = 152.53 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied,  4.09965 s, 262 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.4438 s, 242 MB/s

    # dd if=/tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.143544 s, 7.5 GB/s

> Liteon

Liteon M3S

-   SSD: Liteon M3S 256GB SATA III
-   Model Number: LCT-256M3S
-   Firmware: VRDC
-   Capacity: 256 GB
-   User: AleksMK

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   8406 MB in  2.00 seconds = 4206.12 MB/sec
    Timing buffered disk reads: 1212 MB in  3.00 seconds = 403.81 MB/sec

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.2338 s, 332 MB/s

    # echo 3 > /proc/sys/vm/drop_caches 
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.48531 s, 432 MB/s

    # dd if=/tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.24457 s, 4.4 GB/s

Encrypted Partitions
====================

This section should show some data for encrypted partitions.

dm-crypt with AES
-----------------

Please list your CPU and if you are using AES-NI. Without AES-NI support
in the CPU, the processor will be the bottleneck long before you touch
the >500MB/s SSD speeds.

i7-620M Benchmark

-   ~570 MB/s :With AES-NI
-   ~100 MB/s :Without AES-NI

i5-3210M

-   ~500 MB/s :With AES-NI
-   ~200 MB/s :Without AES-NI

> Crucial

The crucial drive does not use any compression to reach its speeds, so
it is expected to be fast.

Crucial M4 256 Gb

-   User: crobe
-   Filesystem: ext4 on dm-crypt
-   Running Sata 6 Gbit/s on an older 3 Gbit/s controller
-   Comment: The drive is faster on writing ( on fresh space ), which
    has been observed on the internet. Maybe this is the maximum of my
    machine.

    # cryptsetup status
    type:    LUKS1
    cipher:  aes-xts-plain
    keysize: 256 bits

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   3012 MB in  2.00 seconds = 1507.62 MB/sec
    Timing buffered disk reads: 558 MB in  3.00 seconds = 185.93 MB/sec
    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 Datensätze ein
    1024+0 Datensätze aus
    1073741824 Bytes (1,1 GB) kopiert, 7,86539 s, 137 MB/s
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 Datensätze ein
    1024+0 Datensätze aus
    1073741824 Bytes (1,1 GB) kopiert, 9,78325 s, 110 MB/s

> OCZ

The OCZ Drives use compression on Data, so with uncompressible encrypted
Data, speeds are expected to be way lower. Still, seek times should be
as low as ever and the drive shouldn't get slower when it gets full, so
there should be enough speed.

OCZ-VERTEX2 180GB

-   SSD: OCZ
-   Model Number: Vertex2
-   Capacity: 180Gb
-   User: crobe
-   Filesystem: ext4 on dm-crypt with AES, essiv, sha256
-   The bottleneck for the read/write speeds is definately the drive

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   2842 MB in  2.00 seconds = 1422.61 MB/sec
    Timing buffered disk reads: 550 MB in  3.00 seconds = 183.26 MB/sec
    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 Datensätze ein
    1024+0 Datensätze aus
    1073741824 Bytes (1,1 GB) kopiert, 16,9194 s, 63,5 MB/s
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 Datensätze ein
    1024+0 Datensätze aus
    1073741824 Bytes (1,1 GB) kopiert, 14,5509 s, 73,8 MB/s

Same values for bonnie++.

> Samsung

SAMSUNG 470 128GB

-   SSD: SAMSUNG 470 128GB
-   Firmware: AXM09B1Q
-   Capacity: 128 GB
-   User: FredericChopin

    # cryptsetup status
    type:    LUKS1
    cipher:  aes-xts-plain
    keysize: 512 bits
    offset:  8192 sectors

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   3226 MB in  2.00 seconds = 1614.42 MB/sec
    Timing buffered disk reads: 570 MB in  3.00 seconds = 189.84 MB/sec
    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 9.62518 s, 112 MB/s
    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 9.34282 s, 115 MB/s

SAMSUNG 830 256GB

-   SSD: Samsung 830 256GB
-   Model Number: MZ-7PC256B/WW
-   Firmware Version: CXM03BQ1
-   Capacity: 256 GB
-   User: stefseel
-   Kernel: 3.4.6-1-ARCH (with aesni_intel module)
-   Filesystem: ext4 (relatime,discard) over LVM2 over dm-crypt/LUKS
    (allow-discards)
-   System: Lenovo ThinkPad T430 (i5-3210M)

    # hdparm -Tt /dev/sda
    /dev/sda:
    Timing cached reads:   15000 MB in  2.00 seconds = 7500 MB/sec
    Timing buffered disk reads: 1470 MB in  3.00 seconds = 490 MB/sec

With default Arch settings with installed pm-utils:
JOURNAL_COMMIT_TIME_AC=0, DRIVE_READAHEAD_AC=256

    # dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.62668 s, 300 MB/s

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 4.07337 s, 170 MB/s

    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.154298 s, 7.0 GB/s

What annoyed me was the poor read performance. I observed that in
battery mode with unplugged AC the read rate was 500 MB/s. I did some
research and found out that pm-utils is to blame. In AC mode it sets
journal commit time to zero and readahead to 256 whereas in battery mode
it sets journal commit time to 600 and readahead to 3072. See scripts
/usr/lib/pm-utils/power.d/journal-commit and
/usr/lib/pm-utils/power.d/readahead. So I added a custom config to set
journal commit time always to 600 and readahead always to 4096, the
result made me happy :)

    # cat /etc/pm/config.d/config
    DRIVE_READAHEAD_AC=4096
    DRIVE_READAHEAD_BAT=4096
    JOURNAL_COMMIT_TIME_AC=600
    JOURNAL_COMMIT_TIME_BAT=600

    # echo 3 > /proc/sys/vm/drop_caches
    # dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 2.15534 s, 500 MB/s

However there is still an issue: after resuming from suspend read rate
goes down to 270 MB/s.

  

SAMSUNG 830 256GB

-   User: hunterthompson
-   SSD: SAMSUNG 830 256GB
-   Firmware: CXM03B1Q
-   Capacity: 256 GB
-   System: Thinkpad X230, 16GB PC-1600 CL9 Kingston HyperX
-   CPU: i7-3520M, AES-NI, Hyper-Threaded, 2.9GHz-3.6GHz, Steady 3.4GHz
    with all 4 threads 100%
-   Kernel: x86_64 linux-grsec 3.5.4-1-grsec (Desktop, Virt, Host, KVM,
    Security)
-   Encryption: Full Disk, LVM2 on LUKS dm-crypt, Allow-Discards
-   Cryptsetup: -h sha512 -c aes-xts-plain64 -y -s 512 luksFormat
    --align-payload=8192
-   Filesystem: mkfs.ext4 -b 4096 -E stride=128,stripe-width=128
    /dev/mapper/VolGroup00-lvolhome
-   fstab:
    ext4,rw,noatime,nodiratime,discard,stripe=128,data=ordered,errors=remount-ro
-   Notes: SATAIII, partitions aligned and no swap

    % dd bs=1M count=1024 if=7600_Retail_Ultimate_DVD.iso  of=/dev/null conv=fdatasync
    dd: fsync failed for ‘/dev/null’: Invalid argument
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.42075 s, 314 MB/s

    % dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.48574 s, 308 MB/s

    % dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.45361 s, 311 MB/s

    % dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 3.44276 s, 312 MB/s

Truecrypt
---------

Comparison - high end SCSI RAID 0 hard drive benchmark
======================================================

LSI 320-2X Megaraid SCSI
------------------------

-   SSD: N/A
-   Model Number: LSI MegaRAID 320-2x RAID 0 x 2 Seagate Cheetah
    ST373455LC 15,000 RPM 146GB drives
-   Capacity: 292Gb
-   User: rabinnh
-   Filesystem: ext4 on x86_64
-   Comment: No, this is not an SSD, but Googlers should have a
    reasonable basis for comparison to a high end hard drive system, and
    you won't get much higher end for an individual workstation. The
    cost of this disk subsystem is conservatively $760, and it gives at
    best half the performance of most SSDs.

    $sudo hdparm -Tt /dev/sda2
    /dev/sda2:
     Timing cached reads:   6344 MB in  2.00 seconds = 3174.02 MB/sec
     Timing buffered disk reads: 442 MB in  3.01 seconds = 146.97 MB/sec

    $dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 7.13482 s, 150 MB/s

    $echo 3 > /proc/sys/vm/drop_caches
    $dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 7.24267 s, 148 MB/s

    $dd if=tempfile of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB) copied, 0.459814 s, 2.3 GB/s

Retrieved from
"https://wiki.archlinux.org/index.php?title=SSD_Benchmarking&oldid=253151"

Category:

-   Storage
