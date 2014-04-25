Logitech Quickcam Pro 9000
==========================

The Logitech QuickCam Pro 9000 is an expensive and fairly high-quality
webcam that is available in several versions. It is of course and UVC
device and as such works out-of-the-box in most cases, but if you want
to maximize the usefulness of this device on Arch Linux you'll need to
do some magic.

Contents
--------

-   1 Usage Scenario
-   2 Capture Software
-   3 Building the Software
-   4 Registering Camera Controls

Usage Scenario
--------------

I use the webcam to record videos for a blog, and I want the highest
possible image quality. As such, I will be capturing uncompressed, raw
video and audio, use the autofocus feature of the camera and maintain a
constant 25 FPS framerate. Using uncompressed video means you will avoid
compression artifacts, minimize CPU load during capture and allows the
video encoder to work as efficent as possible when doing the final
encoding of the result. By using autofocus (as opposed to having a
fixed, inifinite focus) you'll get the sharpest possible image.

By default the camera is limited to 15 FPS as long as auto-exposure is
being used. This is because the time required for each frame is longer
if lighting conditions are dim as less light hits the sensor. 15 FPS is
the hard limit that the autoexposure mechanism must maintain at all
times. Unfortunately for us 15 FPS looks really bad, so we need to
switch autoexposure off and instead provide good, fixed lighting
conditions.

If you just want to use the camera as webcam, you should instead use a
compressed format such as MJPEG which minimizes the load on the USB bus
and the host CPU. Cheaper webcams typically lacks these compressed
formats because they require more hardware and license fees.

Capture Software
----------------

By far the best capture software I've found is guvcview. Not only does
it allow you to specify exactly the formats to use for both audio, video
and container but it also has the ability to control the focus of the
camera. Focus control is not part of the UVC standard, and without a
software component that handles it you'll not be able to use the AF
functionality at all. Unfortunately, guvcview is not available from the
regular Arch Linux repositories and has to be built "manually" along
with some support libraries.

Building the Software
---------------------

libwebcam is the support library needed for AF control. guvcview is the
viewer/capture application.

Both applications are built easily using the AUR/ABS build system. In
the case of libwebcam I used the patches and build scripts provided by
esteemed member whitelynx.

Registering Camera Controls
---------------------------

During the installation of libwebcam the following line will be added to
your /etc/udev/rules.d/80-uvcdynctrl.rules

    ACTION=="add", SUBSYSTEM=="video4linux", DRIVERS=="uvcvideo", RUN+="/lib/udev/uvcdynctrl"

After the installation, disconnect and reconnect your camera to trigger
the rules, then start guvcview once as root, just to let it initialize
the AF controls. If you are not yet a member of the "video" group, you
should add yourself to it and login anew. After this you should be able
to use the cameras full feature set, including autofocus, even as a
regular user.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logitech_Quickcam_Pro_9000&oldid=306024"

Category:

-   Imaging

-   This page was last modified on 20 March 2014, at 17:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
