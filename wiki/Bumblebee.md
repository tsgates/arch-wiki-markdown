Bumblebee
=========

From Bumblebee's FAQ:

"Bumblebee is an effort to make NVIDIA Optimus enabled laptops work in
GNU/Linux systems. Such feature involves two graphics cards with two
different power consumption profiles plugged in a layered way sharing a
single framebuffer."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Bumblebee: Optimus for Linux                                       |
| -   2 Installation                                                       |
|     -   2.1 Installing Bumblebee with Intel / Nvidia                     |
|     -   2.2 Installing Bumblebee with Intel / Nouveau                    |
|                                                                          |
| -   3 Start Bumblebee                                                    |
| -   4 Usage                                                              |
| -   5 Configuration                                                      |
|     -   5.1 Optimizing Speed when using VirtualGL as bridge              |
|     -   5.2 Power Management                                             |
|         -   5.2.1 Default power state of NVIDIA card using bbswitch      |
|         -   5.2.2 Enable NVIDIA card during shutdown                     |
|                                                                          |
|     -   5.3 Multiple monitors                                            |
|                                                                          |
| -   6 CUDA Without Bumblebee                                             |
| -   7 Troubleshooting                                                    |
|     -   7.1 [VGL] ERROR: Could not open display :8                       |
|     -   7.2 [ERROR]Cannot access secondary GPU                           |
|         -   7.2.1 No devices detected.                                   |
|         -   7.2.2 NVIDIA(0): Failed to assign any connected display      |
|             devices to X screen 0                                        |
|                                                                          |
|     -   7.3 ERROR: ld.so: object 'libdlfaker.so' from LD_PRELOAD cannot  |
|         be preloaded: ignored                                            |
|     -   7.4 Fatal IO error 11 (Resource temporarily unavailable) on X    |
|         server                                                           |
|     -   7.5 Video tearing                                                |
|     -   7.6 Bumblebee can't connect to socket                            |
|                                                                          |
| -   8 Important Links                                                    |
+--------------------------------------------------------------------------+

Bumblebee: Optimus for Linux
----------------------------

Optimus Technology is an hybrid graphics implementation without a
hardware multiplexer. The integrated GPU manages the display while the
dedicated GPU manages the most demanding rendering and ships the work to
the integrated GPU to be displayed. When the laptop is running on
battery supply, the dedicated GPU is turned off to save power and
prolong the battery life.

Bumblebee is a software implementation comprising of two parts:

-   Render programs off-screen on the dedicated video card and display
    it on the screen using the integrated video card. This bridge is
    provided by VirtualGL or primus (read further) and connects to a X
    server started for the discrete video card.
-   Disable the dedicated video card when it is not in use (see the
    #Power Management section)

It tries to mimic the Optimus technology behavior; using the dedicated
GPU for rendering when needed and power it down when not in use. The
present releases only support rendering on-demand, automatically
starting a program with the discrete video card based on workload is not
implemented.

Warning:Bumblebee is still under heavy development! But your help is
very welcome.

Installation
------------

Before installing Bumblebee check your BIOS and activate Optimus (older
laptops call it "switchable graphics") if possible (BIOS doesn't have to
provide this option), and install the intel driver for the secondary on
board graphics card.

Several packages are available for a complete setup:

-   bumblebee (or bumblebee-git) - the main package providing the daemon
    and client programs.
-   (optional) bbswitch (or bbswitch-dkms) - recommended for saving
    power by disable the Nvidia card.
-   (optional) If you want more than just saving power, that is
    rendering programs on the discrete Nvidia card you also need:
    -   a driver for the Nvidia card. The open-source nouveau driver or
        the more closed-source nvidia driver. See the subsection.
    -   a render/display bridge. Two packages are currently available
        for that, primus (or primus-git) and virtualgl. Only one of them
        is necessary, but installing them side-by-side does not hurt.

Note:If you want to run a 32-bit application on a 64-bit system you must
install the proper lib32-* libraries for the program. In addition to
this, you also need to install lib32-virtualgl or lib32-primus (or
lib32-primus-git), depending on your choice for the render bridge. Just
make sure you run primusrun instead of optirun if you decide to use
Primus render bridge.

> Installing Bumblebee with Intel / Nvidia

-   Install intel-dri, xf86-video-intel, bumblebee and nvidia.

    # pacman -S intel-dri xf86-video-intel bumblebee nvidia

If you want to run 32-bit applications (like games with wine) on a
64-bit system you need the lib32-nvidia-utils package too.

    # pacman -S lib32-nvidia-utils

Note:Do not install lib32-nvidia-libgl! Bumblebee will find the correct
lib32 nvidia libs without it.

> Installing Bumblebee with Intel / Nouveau

Install nouveau and required packages first:

    # pacman -S xf86-video-nouveau nouveau-dri mesa

-   xf86-video-nouveau experimental 3D acceleration driver
-   nouveau-dri Mesa classic DRI + Gallium3D drivers
-   mesa Mesa 3-D graphics libraries

Start Bumblebee
---------------

In order to use Bumblebee it is necessary add yourself (and other users)
to the bumblebee group:

    # gpasswd -a $USER bumblebee

where $USER is the login name of the user to be added. Then log off and
on again to apply the group changes.

To start bumblebee automatically at startup, enable bumblebeed service:

    # systemctl enable bumblebeed

Finished - reboot system and use the shell program optirun for Optimus
NVIDIA rendering!

If you simply wish to disable your nvidia card, this should be all that
is needed, apart from having bbswitch installed. The bumblebeed daemon
will, by default, instruct bbswitch to turn off the card when it starts.
See also the power management section below.

Usage
-----

The command line programm optirun shipped with Bumblebee is your best
friend for running applications on your Optimus NVIDIA card.

Test Bumblebee if it works with your Optimus system:

    $ optirun glxgears -info

If it succeeds and the terminal you are running from mentions something
about your NVIDIA - Optimus with Bumblebee is working!

General Usage:

    $ optirun [options] <application> [application-parameters]

Some Examples:

Start Windows applications with Optimus:

    $ optirun wine <windows application>.exe

Use NVIDIA Settings with Optimus:

    $ optirun -b none nvidia-settings -c :8 

For a list of options for optirun view its manual page:

    $ man optirun

A new program is soon becoming the default choice because of better
performance, namely primus. Currently you need to run this program
separately (it does not accept options unlike optirun), but in the
future it will be started by optirun. Usage:

    $ primusrun glxgears

Configuration
-------------

You can configure the behaviour of Bumblebee to fit your needs. Fine
tuning like speed optimization, power management and other stuff can be
configured in /etc/bumblebee/bumblebee.conf

> Optimizing Speed when using VirtualGL as bridge

Bumblebee renders frames for your Optimus NVIDIA card in an invisible X
Server with VirtualGL and transports them back to your visible X Server.

Frames will be compressed before they are transported - this saves
bandwidth and can be used for speed-up optimization of bumblebee:

To use an other compression method for a single application:

    $ optirun -c <compress-method> application

The method of compres will affect performance in the GPU/GPU usage.
Compressed methods (such as jpeg) will load the CPU the most but will
load GPU the minimum necessary; uncompressed methods loads the most on
GPU and the CPU will have the minimum load possible.

Compressed Methods are: jpeg, rgb, yuv

Uncompressed Methods are: proxy, xv

To use a standard compression for all applications set the VGLTransport
to <compress-method> in /etc/bumblebee/bumblebee.conf:

    /etc/bumblebee/bumblebee.conf

    [...]
    [optirun]
    VGLTransport=proxy
    [...]

You can also play with the way VirtualGL reads back the pixels from your
graphic card. Setting VGL_READBACK environment variable to pbo should
increase the performance. Compare these two:

    # PBO should be faster.
    VGL_READBACK=pbo optirun glxspheres
    # The default value is sync.
    VGL_READBACK=sync optirun glxspheres

Note:CPU frequency scaling will affect directly on render performance

> Power Management

The goal of power management feature is to turn off the NVIDIA card when
it is not used by bumblebee any more. If bbswitch is installed, it will
be detected automatically when the Bumblebee daemon starts. No
additional configuration is necessary.

Default power state of NVIDIA card using bbswitch

The default behavior of bbswitch is to leave the card power state
unchanged. bumblebeed does disable the card when started, so the
following is only necessary if you use bbswitch without bumblebeed.

Set load_state and unload_state module options according to your needs
(see bbswitch documentation).

    /etc/modprobe.d/bbswitch.conf

    options bbswitch load_state=0 unload_state=1

Enable NVIDIA card during shutdown

The NVIDIA card may not correctly initialize during boot if the card was
powered off when the system was last shutdown. One option is to set
TurnCardOffAtExit=false in /etc/bumblebee/bumblebee.conf, however this
will enable the card everytime you stop the Bumblebee daemon, even if
done manually. To ensure that the NVIDIA card is always powered on
during shutdown, add the following hook function (if using bbswitch):

    /etc/rc.d/functions.d/nvidia-card-enable

    nvidia_card_enable() {
      BBSWITCH=/proc/acpi/bbswitch

      stat_busy "Enabling NVIDIA GPU"

      if [ -w ${BBSWITCH} ]; then
        echo ON > ${BBSWITCH}
        stat_done
      else
        stat_fail
      fi
    }

    add_hook shutdown_poweroff nvidia_card_enable

> Multiple monitors

Note:This configuration is only valid for laptops, where the extra
output is hardwired to the intel card. Unfortunately this is not the
case for some (or most?) laptops, where, lets say, the HDMI output is
hardwired to the NVIDIA card. In that case there is no such an ideal
solution, as shown here. But you can make your extra output at least
usable with the instructions on the bumblebee wiki page.

You can set up multiple monitors with xorg.conf. Set them to use the
Intel card, but Bumblebee can still use the NVIDIA card. One example
configuration is below for two identical screens with 1080p resolution
and using the HDMI out.

    /etc/X11/xorg.conf

    Section "Screen"
        Identifier     "Screen0"
        Device         "intelgpu0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "TwinView" "0"
        SubSection "Display"
            Depth          24
            Modes          "1980x1080_60.00"
        EndSubSection
    EndSection

    Section "Screen"
        Identifier     "Screen1"
        Device         "intelgpu1"
        Monitor        "Monitor1"
        DefaultDepth   24
        Option         "TwinView" "0"
        SubSection "Display"
            Depth          24
            Modes          "1980x1080_60.00"
        EndSubSection
    EndSection

    Section "Monitor"
        Identifier     "Monitor0"
        Option         "Enable" "true"
    EndSection

    Section "Monitor"
        Identifier     "Monitor1"
        Option         "Enable" "true"
    EndSection

    Section "Device"
        Identifier     "intelgpu0"
        Driver         "intel"
        Option         "XvMC" "true"
        Option         "UseEvents" "true"
        Option         "AccelMethod" "UXA"
        BusID          "PCI:0:2:0"
    EndSection

    Section "Device"
        Identifier     "intelgpu1"
        Driver         "intel"
        Option         "XvMC" "true"
        Option         "UseEvents" "true"
        Option         "AccelMethod" "UXA"
        BusID          "PCI:0:2:0"
    EndSection

    Section "Device"
        Identifier "nvidiagpu1"
        Driver "nvidia"
        BusID "PCI:0:1:0"
    EndSection

You need to probably change the BusID for both the Intel and the Nvidia
card.

    $ lspci | grep VGA

    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)

The BusID is 0:2:0

CUDA Without Bumblebee
----------------------

This is not well documented, but you do not need Bumblebee to use CUDA
and it may work even on machines where optirun fails. For a guide on how
to get it working with the Lenovo IdeaPad Y580 (which uses the GeForce
660M), see:
https://wiki.archlinux.org/index.php/Lenovo_IdeaPad_Y580#NVIDIA_Card.
Those instructions are very likely to work with other machines (except
for the acpi-handle-hack part, which may not be necessary).

Troubleshooting
---------------

Note:Please report bugs at Bumblebee-Project's GitHub tracker as
described in its Wiki.

> [VGL] ERROR: Could not open display :8

There is a known problem with some wine applications that fork and kill
the parent process without keeping track of it (for example the free to
play online game "Runes of Magic")

This is a known problem with VirtualGL. As of bumblebee 3.1, so long as
you have it installed, you can use Primus as your render bridge:

    $ optirun -b primus wine <windows program>.exe

If this does not work, an alternative walkaround for this problem is:

    $ optirun bash
    $ optirun wine <windows program>.exe

  

If using NVIDIA drivers a fix for this problem is to edit
/etc/bumblebee/xorg.conf.nvidia and change Option ConnectedMonitor to
CRT-0.

> [ERROR]Cannot access secondary GPU

No devices detected.

In some instances, running optirun will return:

    [ERROR]Cannot access secondary GPU - error: [XORG] (EE) No devices detected.
    [ERROR]Aborting because fallback start is disabled.

In this case, you will need to move the file
/etc/X11/xorg.conf.d/20-intel.conf to somewhere else. Restart the
bumblebeed daemon, and it should work. If you do need to change some
features on Intel module, a workaround is to move your
/etc/X11/xorg.conf.d/20-intel.conf to /etc/X11/xorg.conf.

It could be also necessary to comment the driver line in
/etc/X11/xorg.conf.d/10-monitor.conf.

If you're using the nouveau driver you could try switching to the nVidia
driver.

You might need to define the nvidia card somewhere (e.g. file
/etc/X11/xorg.conf.d), and remember to change the BusID using lspci.

    Section "Device"
        Identifier "nvidiagpu1"
        Driver "nvidia"
        BusID "PCI:0:1:0"
    EndSection

NVIDIA(0): Failed to assign any connected display devices to X screen 0

If the console output is:

    [ERROR]Cannot access secondary GPU - error: [XORG] (EE) NVIDIA(0): Failed to assign any connected display devices to X screen 0
    [ERROR]Aborting because fallback start is disabled.

You can change this line in /etc/bumblebee/xorg.conf.nvidia:

    Option "ConnectedMonitor" "DFP"

to

    Option "ConnectedMonitor" "CRT"

> ERROR: ld.so: object 'libdlfaker.so' from LD_PRELOAD cannot be preloaded: ignored

You probably want to start a 32-bit application with bumblebee on a
64-bit system. See the "Note" box in #Installation.

> Fatal IO error 11 (Resource temporarily unavailable) on X server

Change KeepUnusedXServer in /etc/bumblebee/bumblebee.conf from false to
true. Your program forks into background and bumblebee don't know
anything about it.

> Video tearing

Video tearing is a somewhat common problem on Bumblebee. To fix it, you
need to enable vsync. It should be enabled by default on the Intel card,
but verify that from Xorg logs. To check whether or not it is enabled
for nvidia, run:

    $ optirun nvidia-settings -c :8 

X Server XVideo Settings -> Sync to VBlank and
OpenGL Settings -> Sync to VBlank should both be enabled. The Intel card
has in general less tearing, so use it for video playback. Especially
use VA-API for video decoding (e.g. mplayer-vaapi and with -vsync
parameter).

Refer to the Intel article on how to fix tearing on the Intel card.

If it is still not fixed, try to disable compositing from your desktop
environment. Try also disabling triple buffering.

> Bumblebee can't connect to socket

You might get something like:

    $ optirun glxspheres

    [ 1648.179533] [ERROR]You've no permission to communicate with the Bumblebee daemon. Try adding yourself to the 'bumblebee' group
    [ 1648.179628] [ERROR]Could not connect to bumblebee daemon - is it running?

If you are already in the bumblebee group ($ groups | grep bumblebee),
you may try removing the socket /var/run/bumblebeed.socket.

Important Links
---------------

-   Bumblebee Project repository
-   Bumblebee Project Wiki
-   Bumblebee Project bbswitch repository

Join us at #bumblebee at freenode.net

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bumblebee&oldid=256163"

Categories:

-   Graphics
-   X Server
