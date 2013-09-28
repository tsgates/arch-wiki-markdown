Map scancodes to keycodes
=========================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

scancodes are the lowest identification numbers for a key, they are from
the kernel and are not used by applications that's why we have to map
them to keycodes which correspond to functions.

See Extra Keyboard Keys for more information.

There are three ways of mapping scancodes to keycodes:

-   Using udev
-   Using the kernel tool setkeycodes

The preferred one is to use udev because it uses hardware information
(which is a quite reliable source) to choose the keyboard model in a
database. It means that if your keyboard model as been defined in the
database, your keys are recognized "out of the box" and can be seen by
Xorg. That's why by expanding the database you are helping the linux
community and maybe someday we won't have to care about scancodes.

Using udev
----------

First, you need to create a keymap file that udev will recognise. Some
examples can be found in /lib/udev/keymaps/, and you should use one of
these if it works for your keyboard model. Otherwise, you need to create
one yourself. The format of each line in a keymap is '<scancode>
<keycode>'. You can work out <scancode> (looks like 0xXX) using

    # /lib/udev/keymap -i input/eventX

and pressing the relevant keys. Replace input/eventX with your keyboard
device, which can be found by running

    $ /lib/udev/findkeyboards

The choices for <keycode> are listed as KEY_<KEYCODE> in
/usr/include/linux/input.h, but you need to change these to lower case
and remove the KEY_ prefix (for example, KEY_PROG3 corresponds to
prog3). A sorted list is available here.

Once you have a keymap, you need to tell udev to use it. This can be
done with a udev rule. Here is a simple example:

    SUBSYSTEM=="input", ATTRS{name}=="AT Translated Set 2 keyboard", RUN+="/lib/udev/keymap input/$name /path/to/keymap"

If you place the keymap file in /lib/udev/keymaps/, you can omit the
full path. Now the keymap will be active the next time you restart. You
can run the following command to activate it immediately:

    # /lib/udev/keymap input/eventX /path/to/keymap

For more information about keymaps and how to send them upstream, see
/usr/share/doc/systemd/README.keymap.txt.

Using the kernel tool setkeycodes
---------------------------------

See the detailed article: setkeycodes.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Map_scancodes_to_keycodes&oldid=248189"

Category:

-   Keyboards
