Mouse Polling Rate
==================

If you have invested in a high resolution mouse, adjusting the USB
polling rate is a common trick to utilise the added precision it brings.
The polling rate (or report rate) determines how often the mouse sends
information to your computer. Measured in Hz, this setting equates to
lag time (in ms).

By default, the USB polling rate is set at 125hz. The table below
represents combinations of Hz values and their corresponding delay time:

  Hz     ms
  ------ ----
  1000   1
  500    2
  250    4
  125    8
  100    10

If the polling rate is set at 125 Hz, the mouse cursor can only be
updated every 8 milliseconds. In situations where lag is critical (for
example games), it is useful to decrease this value to as little as
possible. Increasing the polling interval will improve precision at the
tradeoff of using more CPU resources, therefore care should be taken
when adjusting this value.

Setting the polling rate
------------------------

Here we are using the usbhid module of the kernel to set a custom
"mousepoll" rate. Simply add the following line to your
/etc/modprobe.d/modprobe.conf file:

    options usbhid mousepoll=[polling interval]

(where [polling interval] is a number in ms from the table above. For
example, to set a polling rate of 500Hz:

    options usbhid mousepoll=2

To change the polling rate without rebooting

    modprobe -r usbhid && modprobe usbhid

Warning:Make sure that both commands execute otherwise you will be
unable to use the mouse and keyboard and will have to reboot or ssh into
your machine.

Then unplug and replug your mouse.

Note:If you use the usbinput and udev hooks in your initramfs, usbhid
will included on the image and you'll need to add
/etc/modprobe.d/modprobe.conf to the FILES entry in
/etc/mkinitcpio.conf. Remember to regenerate your image after changing
the config. Without doing this, the module will be inserted during early
userspace without the polling option. Alternatively, you can add
usbhid.mousepoll=X to your kernel command line.

Displaying current mouse rate
-----------------------------

A tool exists (named evhz) that can display the current mouse refresh
rate -- useful when checking that your customised polling settings have
been applied.

The original source no longer exists ([1]), so a mirror has been
provided here: evhz.c. Full credit goes to the original author, Alan
Kivlin.

Compile it with:

    gcc -o evhz evhz.c

Note:

If compiling fails with the following message

    evhz.c: In function ‘main’:
    evhz.c:36:2: warning: incompatible implicit declaration of built-in function ‘memset’ [enabled by default]

Add

    #include <string.h>

To the includes part of the code and retry.

Then execute as root:

    ./evhz

Alternatively, Windows tools such as DirectX mouserate checker can be
run using WINE.

Further Reading
---------------

-   CS:S Mouse Optimization Guide -- largely aimed at Windows users,
    though the same principles apply for Linux.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mouse_Polling_Rate&oldid=211601"

Category:

-   Mice
