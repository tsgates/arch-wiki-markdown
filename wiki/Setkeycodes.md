Setkeycodes
===========

setkeycodes, as you can see in its man page, associates scancodes to
keycodes. Obviously enough, it takes two arguments: the first argument
is the scancode, the second argument is the keycode. However, it is not
always easy to determine these arguments. The simplest way to determine
the exact scancode is to look at the system log: in fact, any time we
press a key which has a scancode but no keycode, the kernel suggests us
to use just 'setkeycodes' to assign a keycode to it. In the message the
kernel gives us also the scancode we have to use actually. However, also
this code is not always usable as it is: when it is composed of four
characters and starts with an 'e', then we can use it as it is as the
first argument for 'setkeycodes'. On the contrary, when the kernel gives
us only two digits, we have to prepend '0x' to it. As an example,
suppose that the kernel tells us that the scancode is 71; then the first
argument for 'setkeycodes' will be 0x71. To see the last 10 lines of the
kernel log you can type:

    $ dmesg|tail -10

The second argument is partially arbitrary. Partially! In fact:

1.  the keycode has to be in the range 1-127;
2.  it should not conflict with the keycodes already mapped to a
    character in your keymap.

In order to respect the second condition, you have to look at your
keymap. In configuring your system through /etc/rc.conf, you have chosen
your keymap, or decided to stay with the default one: in fact rc.conf
includes a 'KEYMAP' setting. The keymaps are stored in your system in
one of the subfolders into /usr/share/kbd/keymaps/i386/. E.g., mine is
the Italian keymap and its path is
/usr/share/kbd/keymaps/i386/qwerty/it.map.gz. It is a text file
compressed with gzip2. Let us gunzip it.

    # gunzip /usr/share/kbd/keymaps/i386/qwerty/it.map.gz

Now we can read it (sometimes less is able to read also gzipped files:
in this case the above passage is dispensable):

    # less /usr/share/kbd/keymaps/i386/qwerty/it.map

We have to choose a keycode not conflicting with those already
associated with characters. Most of the lines in the keymap are of the
following format:

    keycode <keycode> = <keysym>

These lines are ordered according to the numeric value of the keycode,
thus it is easy to find the highest keycode used by the keymap. Thus,
the second argument for 'setkeycodes" has to in the range between the
successor of this highest keycode and 127.

Let us say that 112 is in this range (this is actually true with the
italian keymap): now we can actually use 'setkeycodes':

    # setkeycodes 0x71 112

If we run 'showkey' again, we can see that our hotkey has now the
keycode 112. However, this is true only for the current session. To make
this permanent, we need to execute 'setkeycodes' each time we boot our
system. This can be done inserting the following line in /etc/rc.local:

    setkeycodes 0x71 112 &

We can also use systemd to make the change permanent. This is preferable
since sysvinit is deprecated. For it to work we need to create a
.service file with the following contents:

    /etc/systemd/system/setkeycodes.service

    [Unit]
    Description=Change keycodes at boot

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/setkeycodes 0x71 112

    [Install]
    WantedBy=multi-user.target

With this we created a service which will change the keycode at boot. We
activate this service file with:

    # systemctl enable setkeycodes

Retrieved from
"https://wiki.archlinux.org/index.php?title=Setkeycodes&oldid=254669"

Categories:

-   Security
-   Other hardware
-   Input devices
