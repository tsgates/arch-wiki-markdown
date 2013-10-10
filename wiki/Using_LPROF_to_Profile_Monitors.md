Using LPROF to Profile Monitors
===============================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           ICC_Profiles.            
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Summary

This article will explain the concept of monitor calibration and
profiling. It explains the building of lprof color profiler from the
provided PKGBUILD, and its use in profiling your monitor.

Required software

VIGRA (v?)

lcms (v1.15 ?)

Related articles

CMYK support in The GIMP

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Before you read                                                    |
|     -   1.1 About LCD monitors                                           |
|     -   1.2 When to calibrate monitors                                   |
|     -   1.3 Prerequisites for building lprof                             |
|                                                                          |
| -   2 About monitor calibration                                          |
|     -   2.1 Black point                                                  |
|     -   2.2 Color (white) temperature                                    |
|     -   2.3 Brightness                                                   |
|     -   2.4 Contrast                                                     |
|     -   2.5 Phosphors                                                    |
|                                                                          |
| -   3 Building lprof                                                     |
| -   4 Calibrating the monitor                                            |
|     -   4.1 Setting brightness/contrast                                  |
|     -   4.2 Setting the color temperature                                |
|     -   4.3 Profiling the monitor                                        |
|                                                                          |
| -   5 Where to save profiles                                             |
| -   6 Resources                                                          |
|     -   6.1 Monitor phosphor characteristics                             |
+--------------------------------------------------------------------------+

Before you read
---------------

Monitor calibration is an essential step in accurate color rendering.
DTP software such as Scribus makes use of monitor ICC profile to display
color accurately and enable preview of publication's colors as they
would appear on a printed copy.

For general use (such as watching videos, viewing family photos, etc)
monitor calibration is not necessary. This article is intended for DTP
and pre-press professionals who need accurate color reproduction.

> About LCD monitors

LCD monitors require a different approach to monitor profiling. They are
not covered in this article, because the original author had no access
to such devices.

> When to calibrate monitors

Some people may say any time is a good time. But to do it correctly,
weather is the primary concern. Yes, the weather. 6500K daylight color
temperature (standard in DTP and pre-press) is not some arbitrary
temperature (you do not really have to know what that means, really). It
is the temperature of white on a sunny day at noon. What that means is
that we need a sunny day, and around noon to profile our monitor
properly. This advice comes from seasoned image editing technicians, so
take it and you will be happy. :)

> Prerequisites for building lprof

In order to build the color profiler tool, lprof, you need root access.
You need to be familiar with how the Arch Build System works and how to
make packages using makepkg script and PKGBUILDS.

Moreover, in order to build lprof, you will need to build VIGRA, a
computer vision library.

There exist PKGBUILDs for both components and the lprof PKGBUILD will be
presented in this articles (in case it disappears from its original
locations).

About monitor calibration
-------------------------

Monitor calibration is carried out in three simple steps.

1.  set monitor's black point by adjusting brightness control
2.  set monitor's color temperature
3.  profile monitor using a profiling tool

But before you do that, we will discuss some terms that will be used in
this article.

> Black point

Black point of the monitor is the black that is displayed when the
device gets no input from the graphic card. If you display an image that
has RGB values of 0, 0, 0, then you will be able to 'see' the monitor's
black point.

> Color (white) temperature

Also referred to as the white point, this is the color temperature of
the white. The higher the temperature, the cooler the white (which runs
contrary to our notion of hot and cold), and vice versa. For DTP and
pre-press, the standard white point is 6500K.

The factory default of most monitors sets the white point at 9300K. This
is too cool for DTP. On some monitor makes and models, there are
advanced controls for fine-tuning the white point.

> Brightness

What people usually refer to as brightness is actually a control that
shifts the black point. By shifting the black point, one gets the
impression that the picture is becoming brighter or darker. What
actually happens is that the black point gets moved, so the pure black
also gets brighter or darker.

> Contrast

Contrast control adjusts the distance of white (RGB = 255, 255, 255) to
black (RGB = 0, 0, 0) point. The black point is not changed while the
white point becomes brighter or darker effectively expanding or
compressing the range of brightness values that can be reproduced. For
monitor calibration purposes, this value should always be the maximum
available on a device.

> Phosphors

The phosphors, or primaries as they are often called, are three sets of
values (two numbers each). Some manufacturers publish data on phosphor
values in user manuals, but this is not true in most cases. Using
specialized software, or web search engines is the most common method of
getting this information.

Building lprof
--------------

The PKGBUILD for lprof has been presented at the Arch Linux Forum in
this thread.

But, before you build lprof, you need to build VIGRA, which can be found
in the AUR.

Here is the lprof PKGBUILD:

    pkgname=lprof
    pkgver=1.11.4.1
    pkgrel=1
    pkgdesc="Imaging device calibration tool"
    url="http://lprof.sourceforge.net/"
    license="GPL"
    depends=('qt>=3' 'lcms>=1.12' 'vigra>=1.3')
    makedepends=('python>=1.53' 'scons')
    source=(http://dl.sourceforge.net/lprof/${pkgname}-${pkgver}.tar.gz)
    md5sums=('2177c77c24aa10db9b7681d264735ea9')

    build() {
      cd ${startdir}/src/${pkgname}-${pkgver}
      sed -i "s/'tiff'/'tiff','png'/" SConstruct || return 1
      python scons.py PREFIX=/usr || return 1
      install -d ${startdir}/pkg/usr
      python scons.py PREFIX=${startdir}/pkg/usr install
    }

Just copy the contents into a PKGBUILD file and build the package.

Calibrating the monitor
-----------------------

Before you start lprof (or any other calibration/profiling tool) there
are some steps must can carry out that do not require any software.

> Setting brightness/contrast

Adjust the lighting in the room to what you will be using when working.
Even if your screen is coated with an anti-reflective coating, you
should avoid light falling directly on it. Let your monitor warm up for
at least an hour for the image to get stabilized. It is not uncommon for
Linux to be kept up 24/7 without shutting down, so you may consider that
unless you hate the noise and/or light. That way, monitor will be always
on (and your unpaid electric bills will quickly block your doorway),

1.  Set contrast (usually a control with half-black-half-white circle)
    to maximum. If you find you cannot tolerate the bright highlights,
    you may lower contrast a little. The higher the better.
2.  Next, display a pure black over entire screen. You can do this by
    creating a small black PNG image (all pixels have RGB = 0, 0, 0).
    Open it up in Gwenview (you can install it along with KDE) or any
    other picture viewer that is capable of displaying an image in
    full-screen mode without any controls.
3.  Reduce the vertical size of the picture (not the PNG image displayed
    by a picture viewer but the whole of what's displayed on the screen)
    to something around 60% or 70% of the full height. What is revealed
    above and below the picture is called a non-scanned area, and since
    that are is not receiving any voltage, it is the blackest of black
    your monitor is capable of displaying.
4.  Locate the brightness control (usually a sun, circle with rays
    projecting from it's edges) and lower the value until the black
    image matches the non-scanned area.

> Setting the color temperature

As we said in the introduction, setting color temperature must occur at
noon. If you only have fixed factory default color temperature, you do
not really need to wait for the sunny day to come. Just set it to 6500K.

Place your monitor so that you can see outside the window and your
screen at the same time. For this step, you also need to create a white
square image (RGB = 255, 255, 255), roughly 10 by 10 centimeters (4 by 3
inches). Using the same Gwenview technique as with brightness/contrast,
display the white square on a pure black background.

1.  First, prepare your eyes by staring at the outside world for a
    while. Let them adjust to the daylight viewing condition for a few
    minutes.
2.  Glance at the monitor, and the white square for a few second (it has
    to be short, because eyes will readjust quickly).
3.  If the square seems yellowish, you need higher color temperature, or
    if it has a blueish cast, the temperature needs to be lowered.
4.  Keep glancing, looking out the window, and adjusting the white
    temperature, until the square looks pure white

Take your time with the steps described above. It is essential to get it
right.

> Profiling the monitor

Start lprof. You will be presented by a fairly large window with
multiple tabs on the right.

1.  Click on the Monitor Profiler tab. Then click on the large Enter
    monitor values >> button.
2.  White point should be set to 6500K (daylight).
3.  Primaries should be set to either SMPTE RP145-1994, or EBU
    Tech.3213-E or P22, or whatever appropriate values for your monitor.
    If you come across correct values for your monitor, enter those by
    selecting User Defined from the drop-down. If in doubt, you may use
    P22 for all monitors with Trinitron CRTs (in this case, Trinitron is
    not related to Sony Trinitron mointors and TVs), and SMPTE
    RP145-1994 for other CRTs.
4.  Click the Set Gamma and Black Point button.
5.  You will now see a full-screen view of two charts with some controls
    at the bottom.
6.  Uncheck the Link channels check-box and adjust individual Red,
    Green, and Blue gamma by either moving the slider left or right, or
    by entering and changing values in the three boxes to the left. The
    goal is to make the chart on the left (the smaller square one) flat.
    When you are satisfied with how it looks, check the Link channels
    check-box and adjust the gamma again.
7.  When you are done, click OK. Click OK again.

When you are finished entering monitor values, you might want to enter
some information about the monitor. This is not mandatory, but it is
always nice to know what profile is for what.

1.  Click Profile identification button.
2.  Fill in the data.
3.  Click OK to finish.

After you are all done, click on the '...' button next to Output Profile
File box. Enter the name of your profile: somemonitor.icc. Click Create
Profile button, and you are done.

Where to save profiles
----------------------

You can save your created profiles anywhere you want, but the common
locations for color profiles are:

-   /usr/share/color/icc (used by Scribus and Separate plugin for The
    GIMP)
-   /usr/lib/scribus/profiles (used by Scribus)
-   /home/(your_user_name)/.color/icc (used by Scribus)

None of the locations seem to be standard. It is recommended that you
put your profiles in /usr/share/color/icc, and keep copies in a
non-hidden directory in your home directory.

Resources
---------

Here are some links you may find useful:

-   Information on CRT (Wikipedia)
-   International Color Consortium (ICC home page)
-   A completely different view on image processing (Accurate Image
    Manipulation)
-   About color management (Wikipedia)
-   Introduction to ICC color profile format (ICC home page)

> Monitor phosphor characteristics

make/model

monitor type

phosphor type

RED

GREEN

BLUE

DELL P1110

CRT

P22

0.625 / 0.34

0.28 / 0.595

0.155 / 0.07

Retrieved from
"https://wiki.archlinux.org/index.php?title=Using_LPROF_to_Profile_Monitors&oldid=237856"

Category:

-   Graphics and desktop publishing
