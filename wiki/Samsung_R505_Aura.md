Samsung R505 Aura
=================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 LCD Brightness                                                     |
|     -   1.1 Making things more convenient: Step 1                        |
|     -   1.2 Making things more convenient: Step 2                        |
|                                                                          |
| -   2 Audio Volume hotkeys                                               |
+--------------------------------------------------------------------------+

> LCD Brightness

LCD brightness information can be found in the following files:

/sys/devices/virtual/backlight/acpi_video0/brightness  
 /sys/devices/virtual/backlight/acpi_video0/actual_brightness  
 /sys/devices/virtual/backlight/acpi_video0/max_brightness  

Since the Fn + Up, Down buttons seem unwilling to work, you can also do
the following to adjust the brighness:

    # echo <Number> > /sys/devices/virtual/backlight/acpi_video/brightness

If you have tried this already, you have probably received an error
message saying something like "permission denied". Therefore, you first
have to change the file owner of
/sys/devices/virtual/backlight/acpi_video/brightness to your username.
You can do this by

    # sudo chown <usrname> /sys/class/backlight/acpi_video0/brightness

where <usrname> is the name of your user.

  

Making things more convenient: Step 1

The Above command for changing the brightness is not very handy, but
this can be fixed with a few shell-scripts designed for this purpose.
Consider the following as examples that you may alter to fit your needs.

     [brightnessUp]
     #!bin/bash
     b=`head -1 /sys/class/backlight/acpi_video0/brightness` 
     mb=`head -1 /sys/class/backlight/acpi_video0/max_brightness` 
     if [ $b -lt $mb ] 
     then
         nb=`expr $b + 1`
     else
         nb=`expr $b`
     fi 
     echo $nb > /sys/class/backlight/acpi_video0/brightness
     

     [brightnessDown]
     #!bin/bash
     b=`head -1 /sys/class/backlight/acpi_video0/brightness` 
     mb=0
     if [ $b -gt $mb ] 
     then
         nb=`expr $b - 1`
     else
         nb=`expr $b`
     fi 
     echo $nb > /sys/class/backlight/acpi_video0/brightness
     

     [brightnessSet]
     #!bin/bash
     mb=`head -1 /sys/class/backlight/acpi_video0/max_brightness` 
     if [ $# -ne 1 ]
     then
       echo "Usage: brightnessSet {val}"
     else
         if ([ $1 -le $mb ] && [ $1 -ge 0 ])
         then
             echo $1 > /sys/class/backlight/acpi_video0/brightness   
         else
             echo "error: specify brightness in [0-$mb]"
         fi 
     fi
     

     [brightnessGet]
     #!bin/bash
     b=`head -1 /sys/class/backlight/acpi_video0/brightness` 
     mb=`head -1 /sys/class/backlight/acpi_video0/max_brightness` 
     echo "current screen brightness: $b of $mb"
     

Using these and defining aliases for these scripts in your .bashrc you
can easily control your screen brightness form your terminal.

The Downside of this is obviously that the File
/sys/class/backlight/acpi_video0/brightness gets restored (or recreated)
on every startup, as it merely represents a register in your graphics
device. Therefore, you have to execute the above command for the owner
change from "root" to "<usrname>" on every startup. Since this is pretty
annoying, there is, of course, a workaround.

Making things more convenient: Step 2

To enable you to change the screen brightness without having to manually
execute the "sudo chown"-command on every startup, you have to do the
following.

First, generate a shell script named "brightnessControl" (or whatever
you wish) with the following content:

     [brightnessControl]
     #!/bin/bash 
     sudo chown <usrname> /sys/class/backlight/acpi_video0/brightness
     

Note: You may have to exchange the shebang in the first line with the
appropriate one for your shell.

Second, move the shell script into a directory that is within your $PATH
variable, e.g.

    # sudo mv brightnessControl /usr/bin/brightnessControl

Now you have to make your script executable by doing

    # sudo chmod 755 /usr/bin/brightnessControl

This would be a nice thing, but sadly, you need root privileges to
perform the script you have just written. This is why you have to enable
running this script without password. This is done by typing

    # sudo EDITOR=nano visudo

and adding the line

    <usrname> ALL=(ALL) NOPASSWD:/usr/bin/brightnessControl

where <username> again is the name of your user. Be careful - you can
mess up quite a lot changing stuff in your sudoers file.

Now you only have to add /usr/bin/brightnessControl to some kind of
autostart list of your desktop environment. If you are using LXDE, for
example, open the file

    ~/.config/lxsession/LXDE/autostart

(or create it, if it does not exist already) and add the line

    /usr/bin/brightnessControl

Congratulations, you are done! Now you can execute the above scripts at
any time. You can define yourself aliases in your .bashrc, or you can
just also make them executables via "chmod 755" and move them into one
of your $PATH directories, so you can execute them easily.

You can, of course, also define keybindings to execute the commands for
you. Depending on whether you made your scripts executable or not the
appropriate commands to paste into your keybindings-config-file or gui
interface are

    /bin/bash /path/to/your/script (for shell-scripts)
    /path/to/your/executable (for executables)

The appropriate identifiers for the Fn-Up and the Fn-Down keys are
"XF86MonBrightnessUp" and "XF86MonBrightnessDown", so you can - if you
wish - finally get them to work correctly now.

If you are using LXDE, you can to this by adding the following lines
into the <keyboard> section of your ~/.config/openbox/lxde-rc.xml file.

     <!-- Keybindings for screen brightness -->
        <keybind key="XF86MonBrightnessUp">
          <action name="Execute">
            <command>BRIGHTNESS-UP</command>
          </action>
        </keybind>
        <keybind key="XF86MonBrightnessDown">
          <action name="Execute">
            <command>BRIGHTNESS-DOWN</command>
          </action>
        </keybind>
     

Where "BRIGHTNESS-UP" and "BRIGHTNESS-DOWN" stand for the above
mentioned expressions

    /bin/bash /path/to/your/script (for shell-scripts)
    /path/to/your/executable (for executables)

Also, you can simply use the name of your script if you put it into a
directory which is contained within your $PATH variable. But remember
that these commands are not called within a bash, so you do not have
access to your "extended" $PATH variable you might have achieved by
changing your .bashrc.

> Audio Volume hotkeys

If you are using LXDE, the following steps will get your Audio Volume
hotkeys Fn-Right and Fn-Left as well as Fn-F6 to work.

First, you have to make sure that alsa is configured correctly. You can
configure alsa using

    # alsaconfig

Executing

    # alsamixer

you can adjust the volumes to a convenient setting. Then, adding

    @ alsa

to the DAEMONS section of your rc.conf, you can ensure that the values
you just specified will be loaded on every startup. Finally, paste the
following lines into the <keyboard>-section of your
~/.config/openbox/lxde-rc.xml file.

     <!-- Keybindings for audio volume control -->
        <keybind key="XF86AudioRaiseVolume">
          <action name="Execute">
            <command>amixer -q set PCM 2+ unmute</command>
          </action>
        </keybind>
        <keybind key="XF86AudioLowerVolume">
          <action name="Execute">
            <command>amixer -q set PCM 2- unmute</command>
          </action>
        </keybind><keybind key="XF86AudioMute">
          <action name="Execute">
            <command>amixer -q set Master toggle</command>
          </action>
        </keybind>
     

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_R505_Aura&oldid=196723"

Category:

-   Samsung
