KEYMAP
======

The KEYMAP variable is specified in the /etc/vconsole.conf file. It
defines what keymap the keyboard is in the virtual consoles. Keytable
files are provided by the kbd package.

Keyboard layouts
----------------

This is the list of known keymap settings to work for the corresponding
keyboard layouts. Most keymaps can be found in the
/usr/share/kbd/keymaps/i386/layout (layout=qwerty, azerty, dvorak, etc.)
directory.

Less common but nonetheless useful keymaps for Arch Linux are found in
the /usr/share/kbd/keymaps/architecture (architecture=mac, sun, etc.)
directory.

You can find more info about your keyboard layout with:
less /usr/share/X11/xkb/rules/base.lst

Note:In an X session, you can use setxkbmap to instantly apply keyboard
layout: setxkbmap -layout dvorak

Note:You can also use this method to modify single keys. This command
would assign the compose functionality to the caps lock key:
setxkbmap -option 'compose:caps' This allows for example to write
umlauts easily. Example for Umlaut A:  CAPSLOCK, ", A -> Ä. You can also
configure the right Windows key as a Compose key with
setxkbmap -option 'compose:rwin'

Note:If these keymaps do not work for you, make sure the keymap file
exists in /usr/share/kbd/keymaps/ using find:
find /usr/share/kbd/keymaps/ -name "*[your desired keymap]*"

Note:You can see some instructions on how to use some keymaps in their
respective files with:  zless /usr/share/kbd/keymaps/.../.../xx.map.gz

  Keyboard                         Keymap setting
  -------------------------------- -----------------------------
  Armenian                         KEYMAP=am
  Armenian (Eastern)               KEYMAP=am -variant eastern
  Belgian                          KEYMAP=be-latin1
  Brazilian Portuguese             KEYMAP=br-abnt2
  Canadian-French                  KEYMAP=cf
  Canadian Multilingual (in AUR)   KEYMAP=ca_multi
  Colemak (US)                     KEYMAP=colemak
  Croatian                         KEYMAP=croat
  Czech                            KEYMAP=cz-lat2
  Danish                           KEYMAP=dk
  Dvorak                           KEYMAP=dvorak
  Finnish                          KEYMAP=fi-latin1
  French                           KEYMAP=fr-latin1
  Georgian                         KEYMAP=ge
  German                           KEYMAP=de-latin1
  German (no dead keys)            KEYMAP=de-latin1-nodeadkeys
  Greek                            KEYMAP=gr
  Italian                          KEYMAP=it
  Lithuanian (qwerty)              KEYMAP=lt.baltic
  Norwegian                        KEYMAP=no-latin1
  Polish                           KEYMAP=pl
  Portuguese                       KEYMAP=pt-latin9
  Romanian                         KEYMAP=ro_win
  Russian                          KEYMAP=ru4
  Singapore                        KEYMAP=sg-latin1
  Slovene                          KEYMAP=slovene
  Swedish                          KEYMAP=sv-latin1
  Swiss-French                     KEYMAP=fr_CH-latin1
  Swiss-German                     KEYMAP=de_CH-latin1
  Spanish Spaniard                 KEYMAP=es
  Spanish Latin American           KEYMAP=la-latin1
  Spanish Dvorak                   KEYMAP=dvorak-es
  Turkish                          KEYMAP=tr_q-latin5
  Ukrainian                        KEYMAP=ua
  United Kingdom                   KEYMAP=uk

Configuring the Console Keymap
------------------------------

1.  cd to /usr/share/kbd/keymaps/i386/qwerty
2.  Copy your default keymap (us.map.gz) to a new file personal.map.gz
3.  gunzip the new map file
4.  Edit personal.map using your favorite editor. Examples:
    -   Make the Right Alt key same as Left Alt key (Emacs)  
        change the line include "linux-with-alt-and-altgr" to
        include "linux-with-two-alt-keys"
    -   Swap CapsLock with Escape (Vim)  
        make keycode 1 = Caps_Lock and keycode 58 = Escape
    -   Make CapsLock another Control key  
        change the line keycode 58 = Caps_Lock to keycode 58 = Control
    -   Swap CapsLock with Left Control key  
        make keycode 29 = Caps_Lock and keycode 58 = Control

5.  gzip the map file
6.  Change the default keyboard layout file that will be used by editing
    /etc/vconsole.conf (you might have to create this file) and changing
    the line that says KEYMAP=us to KEYMAP=personal
7.  Reboot to use your keymap the way nature intended (or run "loadkeys
    personal")

Retrieved from
"https://wiki.archlinux.org/index.php?title=KEYMAP&oldid=251998"

Category:

-   Internationalization
