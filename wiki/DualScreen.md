DualScreen
==========

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Multihead.  
                           Notes: DualScreen is     
                           only a specific case of  
                           Multihead. (Discuss)     
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Background                                                         |
| -   2 Extended Screen                                                    |
|     -   2.1 VGA1 left of HDMI1 at their preferred resolutions            |
|     -   2.2 VGA1 right of HDMI1 at 1024x768                              |
|     -   2.3 VGA1 above HDMI1 at preferred resolution                     |
|     -   2.4 VGA1 below HDMI1 at 1024x768                                 |
|                                                                          |
| -   3 Extended Screen using XRandR and an xorg.conf file                 |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Background
----------

Xwindows drives the underlying graphical interface of most if not all
Unix/Linux computers providing a GUI. It was developed in 1984 at MIT.
After around 35 years of development, tweaking and adding of new
hardware and ideas, it is generally acknowledged to be a bit of a beast.
It should be remembered that the common configuration at time of
development was a single mini running X providing individual views to
Xterminals in a timesharing system. Nowadays the norm is X providing a
single screen on a desktop or laptop.

All of this means that there are many ways of achieving the same thing
and many slightly different things that can meet the same purpose. In
modern X versions sometimes you can get away with limited or no
configuration. In the last few years the boast is that X is self
configuring. Certainly the best practice rule of thumb is less
configuration is better - that is only configure what is wrong.

Extended Screen
---------------

This approach works well when the monitors are the same size and
resolution. Interesting things happen - like windows off screen etc -
when they are not. It is supposed to work but does not. It should also
be noted that in a full desktop environment such as Gnome there are
built-in GUI utilities to achieve this. However *box environments
suffer.

1) Identify where your windows manager or desktop environment places
startup code. For fluxbox this is ~/.fluxbox/startup

2) Add the xrandr utility and if you like GUI the arandr utility

    pacman -S xorg-xrandr arandr

3) From the commandline run xrandr and you will see something like:

    xrandr -q

produces

    Screen 0: minimum 320 x 200, current 3280 x 1080, maximum 8192 x 8192
    VGA1 connected 1360x768+0+0 (normal left inverted right x axis y axis) 406mm x 229mm
      1360x768       60.0*+
      1024x768       75.1     75.0     60.0  
      832x624        74.6  
      800x600        75.0     60.3  
      640x480        75.0     60.0  
      720x400        70.1  
    HDMI1 connected 1920x1080+1360+0 (normal left inverted right x axis y axis) 477mm x 268mm
      1920x1080      60.0*+
      1600x1200      60.0  
      1680x1050      60.0  
      1280x1024      75.0     60.0  
      1440x900       59.9  
      1280x960       60.0  
      1152x864       75.0  
      1024x768       75.1     70.1     60.0  
      832x624        74.6  
      800x600        75.0     60.3     56.2  
      640x480        72.8     75.0     60.0  
      720x400        70.1  
    DP1 disconnected (normal left inverted right x axis y axis)
    HDMI2 disconnected (normal left inverted right x axis y axis)
    HDMI3 disconnected (normal left inverted right x axis y axis)
    DP2 disconnected (normal left inverted right x axis y axis)
    DP3 disconnected (normal left inverted right x axis y axis)

4) Note down the portnames of the monitors attached - in the case of the
above "VGA1" and "HDMI1"

5) Decide which resolution you are going to use. Each monitor has a
preferred mode that, according to the manufacturer, is the best
visually. These are marked by a "+". The mode a monitor is running at is
marked by a "*". You should if possible use the preferred mode and a
mode shared by both monitors. You can also add modes: see the Xrandr
page.

6) Decide which monitor is on the left or right (or top and bottom) and
configure as follows:

> VGA1 left of HDMI1 at their preferred resolutions

    xrandr --output VGA1 --mode 1360x768 --pos 0x0 --output HDMI1 --mode 1920x1080 --pos 1360x0

-   --output specifies which port to use
-   --mode specifies which mode to use
-   --pos specifies the x/y coordinates of this monitor on the big
    virtual screen

or

    xrandr --output VGA1 --mode 1360x768 --output HDMI1 --mode 1920x1080 --right-of VGA1

-   --right-of places the previous screen (HDMI1) to the right of the
    specified screen (VGA1)

> VGA1 right of HDMI1 at 1024x768

    xrandr --output VGA1 --mode 1024x768 --pos 1920x0 --output HDMI1 --mode 1024x768 --pos 0x0

or

    xrandr --output VGA1 --mode 1024x768 --output HDMI1 --mode 1024x768 --left-of VGA1

-   --left-of places the previous screen (HDMI1) to the left of the
    specified screen (VGA1)

> VGA1 above HDMI1 at preferred resolution

    xrandr --output VGA1 --preferred --output HDMI1 --mode 1920x1080 --pos 0x768

or

    xrandr --output VGA1 --mode 1360x768 --output HDMI1 --mode 1920x1080 --below VGA1

-   --below places the previous screen (HDMI1) below the specified
    screen (VGA1)

> VGA1 below HDMI1 at 1024x768

    xrandr --output VGA1 --mode 1024x768 --pos 0x768 --output HDMI1 --mode 1024x768 --pos 0x0

or

    xrandr --output VGA1 --mode 1024x768 --output HDMI1 --mode 1024x768 --above VGA1

-   --above places the previous screen (HDMI1) to the above the
    specified screen (VGA1)

7) Play around at the command line until you have a setting that works
for you. When you do simply copy that call to xrandr into your window
manager/desktop startup file. Arandr is a GUI interface to xrandr and
may have some benefits in your search for a solution.

I found that some settings and approaches worked better than others and
that even the best did not work in all cases because of the differences
between my two monitors.

Extended Screen using XRandR and an xorg.conf file
--------------------------------------------------

Another way to set up a Dual Screen is by using an xorg.conf file. This
configuration should work with most open-source drivers - anything that
has support for XRandR.

Setting up a Dual Screen configuration you only need the two sections
after the given filename as follows:

    /etc/X11/xorg.conf

    Section "Monitor"
        Identifier  "VGA1"
        Option      "Primary" "true"
    EndSection
    #
    Section "Monitor"
        Identifier  "HDMI1"
        Option      "RightOf" "VGA1"
    EndSection

Where VGA1 and HDMI1 are monitor ports.

Notes:

-   You specify the individual ports using the Identifier lines in the
    Monitor sections. These are the same ports that are listed by
    xrandr -q

-   This setup does not specify which resolutions to use or absolute
    positions relative to each other of both monitor's images. To
    specify those you could add a preferred mode which is given as an x
    size, a lower-case "x", and a y size, and you could also specify a
    position which is given as an x coordinate, a space, and then a y
    coordinate, to the Monitor sections:

        Option "PreferredMode" "1920x1080"
        Option "Position" "0 0"

-   Setting up a Dual Screen this way uses XRandR. On the Multihead page
    there is another method to configure X-Server file(s) called
    Xinerama. Xinerama is used when complex display setups are required.

See also
--------

-   Dual Screen is discussed in the Xorg article.
-   http://intellinuxgraphics.org/dualhead.html - Source for XRandR
    information
-   http://www.thinkwiki.org/wiki/Xorg_RandR_1.2 - Source for XRandR
    information
-   man intel - Source for Intel information

Retrieved from
"https://wiki.archlinux.org/index.php?title=DualScreen&oldid=233609"

Category:

-   X Server
