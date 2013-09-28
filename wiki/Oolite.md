Oolite
======

Oolite is a space trading / sim game based on the well-known Elite game
from the 80's.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Troubleshooting                                                    |
|     -   2.1 Testing for shader problem                                   |
|     -   2.2 Verify which setting works                                   |
|     -   2.3 Feedback                                                     |
|     -   2.4 Radeon HD 2xxx and later videocards                          |
+--------------------------------------------------------------------------+

Installation
------------

Oolite used to be in AUR, but has been moved to Community repo, use:

    pacman -Syu oolite

Troubleshooting
---------------

Oolite uses shaders extensively which may not work well with all
drivers, especially the gallium OSS drivers.

By default Oolite starts with full shaders, if it hangs on the title
screen please follow these 3 steps:

> Testing for shader problem

Run Oolite from terminal with this command:

    LIBGL_ALWAYS_INDIRECT=1 oolite

If Oolite works, the problem is with the shaders. In case this does not
help, you have a different problem. Post about this on the Arch Linux
forums or register a bug.

> Verify which setting works

Open ~/GNUstep/Defaults/.GNUstepDefaults in an editor, scroll down and
to the bottom, and look for these lines:

    <key>shader-mode</key>
    	<integer>3</integer>

Try changing the value of this key to 2 and 1 and test if Oolite runs
normally (WITHOUT LIBGL_ALWAYS_INDIRECT stuff).

Note: The lines with shader-mode key are not always present, but it is
safe to add them.

> Feedback

For the value of shader-mode that works, please post
~/.Oolite/Logs/Latest.log on the Oolite forum, along with the highest
shader-mode value that works for you.

This info will be used to determine the correct default shader setting
for Oolite for your card/driver combination. This will then become part
of the Oolite graphics configuration data in a later version.

> Radeon HD 2xxx and later videocards

Mesa 8.0.2 has no problems i am aware of running oolite with shaders,
but Oolite 1.76 still disables shaders for this driver.

If you wish to use shaders:

1.  Execute
    cp /usr/share/oolite/Resources/Config/gpu-settings.plist ~/.Oolite/AddOns
    as USER
2.  Edit ~/.Oolite/AddOns/gpu-settings.plist and replace SHADERS_OFF (2
    times) with SHADERS_FULL in the section shown below



    "ATI R600/R700 family (X/Gallium3D)" =
    {
    	/*
    		We have reports of Oolite hanging when using Gallium3D on AMD R600/R700 family GPUs with
    		shaders enabled. As a stopgap, we forcibly disable shaders on affected systems.
    		See http://aegidian.org/bb/viewtopic.php?f=9&t=9416
    	*/
    	
    	match =
    	{
    		vendor = "X\\.Org";
    		renderer = "Gallium .*(?:AMD|AT[Ii]) R[A-Za-z]?[67]\\d{2}(?!\\d)";
    	};
    	maximum_shader_level = "SHADERS_OFF";
    	default_shader_level = "SHADERS_OFF";
    };

Retrieved from
"https://wiki.archlinux.org/index.php?title=Oolite&oldid=244136"

Category:

-   Gaming
