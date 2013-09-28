XKB
===

X KeyBoard extension, or XKB, defines the way keyboards codes are
handled in X, and provides access to internal translation tables. It's
the basic mechanism that allows using multiple keyboard layouts in X.

Learning about XKB can be hard without some hands-on experience. This
page is intended to help users to start with XKB by doing some changes
to their keymaps. It's not meant as a complete guide to all XKB
features. Instead, it skips over gritty details and focuses on the most
practical things first.

If you ended up here looking for a simple way to configure your
keyboard, be sure to check Configuring keyboard layouts in X first.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Precautions and preparations                                       |
| -   2 Getting and setting XKB layout                                     |
| -   3 Basic information on XKB                                           |
|     -   3.1 Tools and values                                             |
|     -   3.2 Keycode translation                                          |
|     -   3.3 Keysyms and states                                           |
|     -   3.4 Actions                                                      |
|                                                                          |
| -   4 Editing the layout                                                 |
|     -   4.1 xkb_keycodes                                                 |
|     -   4.2 xkb_types                                                    |
|     -   4.3 xkb_compatibility                                            |
|     -   4.4 xkb_symbols                                                  |
|     -   4.5 xkb_geometry                                                 |
|                                                                          |
| -   5 Basic examples                                                     |
|     -   5.1 Simple key assignment                                        |
|     -   5.2 Multiple layouts                                             |
|     -   5.3 Additional symbols                                           |
|         -   5.3.1 Compose key                                            |
|         -   5.3.2 Level3                                                 |
|                                                                          |
|     -   5.4 Meta, Super and Hyper                                        |
|         -   5.4.1 Real modifiers                                         |
|         -   5.4.2 Keysym tracking                                        |
|                                                                          |
| -   6 Preset configuration                                               |
|     -   6.1 xmodmap                                                      |
|                                                                          |
| -   7 Indicators                                                         |
| -   8 Modifiers and types                                                |
|     -   8.1 Using real modifiers in standard types                       |
|     -   8.2 Switching a single modifier bit                              |
|     -   8.3 modifier_map                                                 |
|                                                                          |
| -   9 Multiple keyboards                                                 |
| -   10 Debugging XKB                                                     |
| -   11 Virtual Modifiers                                                 |
|     -   11.1 Defining virtual modifiers                                  |
|     -   11.2 Keysym interpretation                                       |
|     -   11.3 Client side notes                                           |
|                                                                          |
| -   12 XKB control bits                                                  |
|     -   12.1 Overlays                                                    |
|     -   12.2 Mouse control                                               |
|                                                                          |
| -   13 See Also                                                          |
+--------------------------------------------------------------------------+

Precautions and preparations
----------------------------

It is possible (and, in fact, easy) to end up disabling some keys on
your keyboard for the current X session while working with XKB. This
includes modifiers, cursor arrows and Enter key, as well as
C-A-Backspace and C-A-Fx combinations. Make sure you have some way to
terminate the session without using your keyboard.

While it is rare, changing XKB configuration can sometimes hang or crash
X server. Make sure you can handle it. Having some way to killall X or
reboot the host remotely may be a good idea.

Stop xxkb, or any other layout switching applications. xxkb actively
changes XKB state. Debugging both at the same time is not a good idea.

And finally, be warned: it is very easy to get used to custom layout.

Getting and setting XKB layout
------------------------------

Use xkbcomp (package xorg-xkbcomp) to manipulate XKB data. To get
current configuration, run

       xkbcomp $DISPLAY output.xkb

To upload the data back to the server, run

       xkbcomp input.xkb $DISPLAY

Note that without $DISPLAY argument xkbcomp will try to compile .xkb
file into (mostly useless) .xkm file, without uploading anything to the
server. It will, however, check the syntax and report errors.

Once the layout is ready, save it as ~/.Xkeymap and make ~/.xinitrc load
it on startup:

       test -f ~/.Xkeymap && xkbcomp ~/.Xkeymap $DISPLAY

The actual file name is irrelevant. Note that unlike standard
system-wide configuration via xorg.conf, this is a per-user keymap.
Also, there is absolutely no problem changing XKB configuration while X
is running.

Basic information on XKB
------------------------

The core XKB functionality is quite simple, and it's necessary to have a
some ideas on how it works before starting working on the keymaps.

> Tools and values

Use xev (package xorg-xev) to get keycodes and to check how your keymap
works. Sample output:

       KeyPress event, serial 45, synthetic NO, window 0x2200001,
           root 0xad, subw 0x0, time 183176240, (796,109), root:(867,413),
           state 0x1, keycode 21 (keysym 0x2b, plus), same_screen YES,
           XLookupString gives 1 bytes: (2b) "+"
           XmbLookupString gives 1 bytes: (2b) "+"
           XFilterEvent returns: False

Note keycode 21, state 0x1 and keysym 0x2b aka plus. Keycode 21 is what
input device supplied to X, typically a physical key index of some sort.
The state represents modifier keys, 0x01 is Shift. Keycode together with
the state value is what X sends to the application in XKeyEvent(3)
structure. Keysym and corresponding string is what the client obtained
using XLookupString(3) and friends.

The bits in the state field have pre-defined names: Shift, Lock,
Control, Mod1, Mod2, Mod3, Mod4 and Mod5, lowest to highest. Thus,
Ctrl+Shift is 0x05, and so on. Client applications typically only check
the bits they need, so an application with normal keyboard input and
Ctrl+key shortcuts usually makes no distinction between Control and
Control+Mod3 states.

Keysyms are numeric, too. A lot of them have names, declared in
/usr/include/X11/keysymdef.h with KP_ prefix. However, the number is
what clients actually receive. Keysyms are only important when an
application expects some particular values; typically that is keys like
arrows, Enter, Backspace, F-keys, and various shortcuts. For the rest,
the string is used.

> Keycode translation

XKB works mostly at the XLookupString stage, transforming incoming
keycode into keysym according to its own internal state, which is group
and state values:

       (keycode, group, state) → keysym

Group typically represents a "layout", as in US-English, French-AZERTY,
Russian, Greek etc. There can be at most 4 groups.

Internally, the translation involves additional steps:

       (keycode [, group]) → type
       (state, type) → level
       (keycode, group, level) → S[keycode][group][level]

with S being the translation table (actually called xkb_symbols, see
below).

Types are used to tell which modifiers affect which keys; essentially
it's a way to reduce the third dimension of S. For example, typical
alphanumeric key is only affected by Shift; it's type is set to
TWO_LEVEL, and

       (state, TWO_LEVEL) → level = ((state >> 0) & 0x01) = state & 0x01

which is either 0 or 1. Thus it's S[keycode][0..4][0..1] instead of
S[keycode][0..4][0..256].

> Keysyms and states

In X terms, a and Ctrl+a means same keysym and different states, but a
and A are different keysyms.

Generally it is XKB task to provide different keysyms, but states are
handled later by individual applications.

Also, states in XKB have somewhat delayed effect, that is, you must have
the state set prior to pressing a key.

Example: Ctrl+h can be configured to act as backspace in rxvt
(application setting). This way rxvt will receive h keysym with Control
bit set in the state value, and if will be clearly different from
Backspace keysym. Alternatively, XKB can be used to make Ctrl+h
combination generate Backspace keysym with Control bit set; in this
case, rxvt will not see any difference between physical Backspace key
and h key as long as Ctrl key is pressed. Making Ctrl+h combination
generate Backspace keysym with no Control bit set is an XKB task, too,
but it's much more difficult to implement than Control+Backspace.

> Actions

Keysym obtained from the table above can also trigger some action:

       (keysym, state) → action

For XKB, setting or locking a modifier bit is an action, and so is any X
server interaction like switching consoles, terminating the server,
moving pointer etc. Actions do not generally affect keysyms, and
generating a keysym is not an action.

There's only one possible action for each (keysym, state) pair.

Editing the layout
------------------

Start with whatever default configuration your server has. Whenever
possible, make the changes gradually and test them.

The .xkb file produced by xkbcomp is a simple text file. C++ style
comments, // till the end of line, are allowed. Section names, as in
xkb_keycodes "name-here", are irrelevant at this point and can be
omited.

> xkb_keycodes

Keycode definition. The rest of the file doesn't use numeric keycodes,
only symbolic keylabels defined in this section.

It's a good idea to leave only those keys the keyboard in question
actually has here.

The labels themselves are arbitrary. They are only used in xkb_symbols
section later.

> xkb_types

This section comes before xkb_symbols, so take a look, but try not to
make changes yet. Standard types depend a lot on virtual modifiers,
which will be explained later. For now, just find the types you need.
Start with the following: ONE_LEVEL, TWO_LEVEL, ALPHABETIC.

ONE_LEVEL keys are not affected by modifiers; typically it's Enter,
Space, Escape, F keys, Shift/Alt/Ctrl keys and so on. TWO_LEVEL and
ALPHABETIC keys produce different keysyms depending on Shift state. All
alphanumeric keys are of these types. ALPHABETIC additionally respects
CapsLock.

Type description themselves are quite simple. The line

       modifiers= Shift+NumLock+LevelThree;

means keys of this type are affected by Shift, NumLock and LevelThree
bits only. Map lines like

       map[Shift+LevelThree]= Level4;

define which combination corresponds to which level value. xkbcomp uses
"LevelN" when dumping the data, but short and much more convenient "N"
can be used as well.

level_name lines are irrelevant and can be ignored.

> xkb_compatibility

Action definitions (interpret) and keyboard leds (indicator) among other
things. It is ok to remove stuff you do not have or do not use, like
keypad actions, mouse control or extra modifiers.

Note that key+AnyOfOrNone(all) is equivalent to just key, but key is
much easier to read.

Check groups switching if you need it. LockGroup(group=N) can be useful
if you have four groups, otherwise ISO_Next_Group/ISO_Prev_Group are
enough. LatchGroup can be useful for unusual setups.

> xkb_symbols

The main section that defines what each key does. Syntax:

       key <LABL> { [ G1L1, G1L2, G1L3, ... ], [ G2L1, G2L2, G2L3, ... ], ... }

<LABL> is keylabel from xkb_keycodes section, GiLj is keysym for group i
level j. The number of keysyms in each group must match the number of
levels defined for this type (xkbcomp will warn you if it doesn't).

Check /usr/include/X11/keysymdef.h for the list of possible keysyms.
Aside from those listed, you can also use Unnnn for Unicode symbol with
hex code nnnn, e.g. U0301 for combining acute accent. Note that a and
U0061 are treated differently (for instance, most applications expect
Ctrl+a, not Ctrl+U0061 because their numeric values are different.

Key types are also specified here, either as

       key.type = "T1";
       key <...> { ... };
       key <...> { ... };
       key <...> { ... };
       key.type = "T2";
       key <...> { ... };
       key <...> { ... };

or individually for each key:

       key <...> { type = "T", [ .... ], [ .... ] };

Key type may be different in different groups. This is somewhat
counter-intuitive, but actually has some useful applications. To set
types for each group, use this:

       key <...> { type[1] = "T1", type[2] = "T2", [ ... ], [ ... ] };

You can set labels for the groups using

       name[1] = "EN";     // group 1
       name[2] = "RU";     // group 2
       name[3] = "UA";     // group 3

This is what xxkb will show if labels are enabled there.

The section also contains modifier_map lines. Leave them alone for now,
or check Virtual Modifiers below.

> xkb_geometry

A completely irrelevant section describing physical keyboard layout. Can
be deleted without any consequences.

Basic examples
--------------

Check your existing layout first, as it likely contains standard
definition for many common keys.

Thoughout the text, "xkb_keycodes { text }" means "text" should be added
to xkb_keycodes section. Whenever it's clear from context, section names
are omited.

> Simple key assignment

Enabling additional (aka multimedia) keys:

       xkb_keycodes {
           <VOL-> = 122;       // check with xev
           <VOL+> = 123;
       }
       
       xkb_symbols {
           key.type = "ONE_LEVEL";
           key <VOL-> { [ XF86AudioLowerVolume ] };
           key <VOL+> { [ XF86AudioRaiseVolume ] };
       }

Escape on CapsLock, for vimers mostly:

       key.type = "ONE_LEVEL";
       key <CAPS> { [ Escape ] };

Exchanging Ins and PrintScreen (in case they are reversed — happens on
Dell laptop keyboards):

       key.type = "ONE_LEVEL";
       key <IN?>  { [    Print ] };
       key <PRSC> { [   Insert ] };

Changing shift to a sticky key version (which exists in fedora 17 at
least):

Remove interpret statements which are unnecessary or may get in the way

       //interpret Shift+AnyOfOrNone(all) {
       //	action= LatchMods(modifers=Shift);
       //   };

       //    interpret Shift_L+AnyOfOrNone(all) {
       //        action= SetMods(modifiers=Shift,clearLocks);
       //    };

       key <LFSH> {         [         ISO_Level2_Latch ] };

> Multiple layouts

For regular alphanumeric keys, just add a second/third/fourth [ ]
section to the key definition:

       key.type = "ALPHABETIC";
       key <AD01> { [ q, Q ], [ a, A ] };      // QWERTY-AZERTY

       key <AC02> { [        s,        S ],        // two cyrillic layouts
                    [    U044B,    U042B ],
                    [    U0456,    U0406 ] };

Layout switching is done by triggering action LockGroup:

       interpret ISO_Next_Group { action = LockGroup(group=+1); };
       interpret ISO_Prev_Group { action = LockGroup(group=-1); };

Typically this means placing ISO_Next_Group and ISO_Prev_Group keysyms
in correct group/level positions. Note that groups wrap, so if you have
two groups and hit ISO_Next_Group twice, you'll return to the group you
started with.

Cyclic switching between two or more layouts with a dedicated key:

       key.type = "ONE_LEVEL";
       key <RWIN> { [ ISO_Next_Group ] }

If you have more than two layouts and some keys to spare, it may be a
better idea to have a dedicated key for each layout. Example for three
layouts:

       key.type = "ONE_LEVEL";
       key <RCTL> { [ ISO_Next_Group ],    // g1: switch to g2
                    [ ISO_Prev_Group ],    // g2: switch back to g1
                    [ ISO_Prev_Group ] };  // g3: switch to g2

       key <MENU> { [ ISO_Prev_Group ],    // g1: switch to g3
                    [ ISO_Next_Group ],    // g2: switch to g3
                    [ ISO_Next_Group ] };  // g3: switch back to g1

With four layouts, you'll likely have to use ISO_First_Group and
ISO_Last_Group.

The same idea can be implemented with only one key by utilizing
TWO_LEVEL type:

       key.type = "TWO_LEVEL";
       key <MENU> { [ ISO_Next_Group, ISO_Prev_Group ],   
                    [ ISO_Prev_Group, ISO_Next_Group ],   
                    [ ISO_Prev_Group, ISO_Next_Group ] }; 

This way it's Menu for group 2 and Shift-Menu for group 3. To use Ctrl
or Alt instead of Shift, replace TWO_LEVEL with PC_CONTROL_LEVEL2 or
PC_ALT_LEVEL2 types respectively.

Switching using two modifier keys (Shift+Shift, Ctrl+Shift etc) can be
done by using something other than ONE_LEVEL for these keys. Shift+Shift
example:

       key.type = "TWO_LEVEL";
       key <LFSH> { [ Shift_L, ISO_Prev_Group ] };
       key <RTSH> { [ Shift_R, ISO_Next_Group ] };

To latch a group (aka toggle; set for the time you hold the key only),
use LatchGroup action typically bound to ISO_Group_Latch keysym:

       key <RCTL> { [ ISO_Group_Latch ] }

Adjust ISO_Group_Latch definition in xkb_compatibility section to use
the right group:

       interpret ISO_Group_Latch { action = LatchGroup(group=3); };

Check /usr/share/X11/xkb/symbols/group for more standard examples.

> Additional symbols

Typing more with the same keys.

Compose key

Easy to set up and extremely useful for entering common unicode
characters.

       key <RALT> { [ Multi_key ] };

Check dedicated wiki page for more info.

Level3

The idea is similar to Alt or AltGr in their original meaning:
alphanumeric keys get additional characters, activated by holding down
some modifier key.

First of all, setting up the modifier.

       xkb_symbols { 
           key <LWIN> { [ISO_Level3_Shift ] };
           modifier_map Mod5 { ISO_Level3_Shift };
       }

Also, the following should already be defined in the relevant sections,
but in case it isn't:

       xkb_compatibility {
           interpret ISO_Level3_Shift { action= SetMods(modifiers=Mod5); };
       }
       
       xkb_types {
           type "THREE_LEVEL" {
               modifiers= Shift+Mod5;
               map[Shift]= Level2;
               map[Mod5]= Level3;
               map[Shift+Mod5]= Level3;
               level_name[Level1]= "Base";
               level_name[Level2]= "Shift";
               level_name[Level3]= "Level3";
           };
           type "FOUR_LEVEL" {
               modifiers= Shift+LevelThree;
               map[Shift]= Level2;
               map[LevelThree]= Level3;
               map[Shift+LevelThree]= Level4;
               level_name[Level1]= "Base";
               level_name[Level2]= "Shift";
               level_name[Level3]= "Alt Base";
               level_name[Level4]= "Shift Alt";
           };
       }

Note standard definitions have LevelThree instead of Mod5 in
xkb_compatibility and xkb_types. As long as modifier_map above uses
Mod5, there is no practical difference, you will end up using Mod5 bit
anyway.

Now, the keys themselves, vi-style cursors in this case:

       key.type = "THREE_LEVEL";
       key <AC06> { [ h, H,  Left ] };
       key <AC07> { [ j, J,  Down ] };
       key <AC08> { [ k, K,    Up ] };
       key <AC09> { [ l, L, Right ] };

As you may find out using xev, this produces Mod5+Left instead of just
Left. But that is ok as most appications ignore state bits they do not
use. For an alternative solution, check Overlays below.

> Meta, Super and Hyper

Real modifiers

Some applications (notably emacs) allow meaningful use of higher state
bits. It is usually assumed there are modifier keys called Meta, Super
and Hyper on the keyboard beside standard Shift, Ctrl and Alt, which
control these bits.

From XKB point of view this means setting Mod2, Mod3, Mod4 and Mod5
modifier bits. Because all you need is the bits themselves, there's no
need to edit types like in the Level3 example above.

       xkb_compatibility {
           interpret Super_L { action = SetMods(modifiers=Mod3); };
       }

       xkb_symbols {
           key <LWIN> { [ Super_L ] };
           modifier_map Mod3 { Super_L };
       }

Standard definitions use Super modifier instead of Mod3 in
xkb_compatibility. You can keep that, just make sure modifier_map line
is in place.

Keep in mind there is no strict correspondence between ModN and named
modifiers like Super, Hyper or even Alt. Mod1 is the only one that is
widely used; some applications call it Meta, some Alt. For the others,
check how particular application treats state bits, and/or check Virtual
modifiers below.

Keysym tracking

At least one application (openbox) is known to track KeyPress/KeyRelease
events for Meta_[LR], Super_[LR] and Hyper_[LR] keysyms instead of
relying on the state bits. In such case

       xkb_symbols {
           key <LWIN> { [ Super_L ] };
       }

is enough and you can omit interpret and modifier_map lines.

Speaking of openbox, note it actually allows both methods: "S-h" tracks
Super_[LR] events while "Mod3-h" checks relevant state bit.

Preset configuration
--------------------

XKB is often configured by specifying XkbTypes/XkbCompat/XkbSymbols, or
XkbModel/XkbLayout (+XkbVariant/XkbOptions), or XkbKeymap, typically in
/etc/X11/xorg.conf or /etc/X11/xorg.conf.d/*.conf, like this:

       Option  "XkbModel"    "thinkpad60"                                                                                                  
       Option  "XkbLayout"   "us,sk,de"                                                                                                    
       Option  "XkbVariant"  "altgr-intl,qwerty,"                                                                                          
       Option  "XkbOptions"  "grp:menu_toggle,grp_led:caps"        

These values define full XKB map (the one that can be dumped by xkbcomp)
by combining several files from /usr/share/X11/xkb. In fact, equivalent
.xkb file for xkbcomp can be obtained using setxkbmap -print:

       setxkbmap -model thinkpad60 -layout us,sk,de -variant altgr-intl,qwerty \
           -option -option grp:menu_toggle -option grp_led:caps -print

Note include statements in the output. The files for each section are
fetched from relevant subdirectories under /usr/share/X11/xkb, i.e.

       xkb_types { include "complete" };

means xkbcomp will look for /usr/share/X11/xkb/types/complete. Plus
signs mean concatenation, so

       xkb_keycodes { include "evdev+aliases(qwerty)" };

means

       xkb_keycodes {
           include "evdev";
           include "aliases(qwerty)";
       };

Parenthesis select named section from the file. Check
/usr/share/X11/xkb/keycodes/aliases and note

       xkb_keycodes "qwerty" { ... };

this is the part aliases(qwerty) refers to. Finally, colons allow
shifting parts of layout to another group.

Unlike XkbTypes/XkbCompat/XkbSymbols/XkbGeometry values, which define
relevant .xkb file sections directly, XkbModel, XkbLayout and XkbRules
refer to additional non-xkb files found under /usr/share/X11/xkb/rules/
that match model and layout values to specific symbols and geometry.
XkbKeymap refers to complete keymaps. Check Ivan Pascal page for
detailed description.

Just like with xkbcomp approach, this kind of configuration can be done
on the fly: use setxkbmap without -print option.

The files from /usr/share/X11/xkb are a good source of examples,
especially when it comes to standard keyboard features with nontrivial
XKB implementation (e.g. keypad/NumLock handling). Also, these are the
files you have to edit to push your changes upstream. Check X Keyboard
Config Rules before doing it though.

> xmodmap

While sometimes used in conjunction with preset configuration, xmodmap
is not directly related to XKB. This tool uses different (pre-XKB) ideas
on how keycodes are processed within X; in particular, xmodmap lacks the
notion of groups and types, so trying to set more than one keysym per
key is not likely to work.

Generally it is not recommended to use xmodmap, except maybe for the
simpliest tasks. XKB-compatible equivalent of xmodmap is xkbcomp;
however, xkbcomp lacks -e option, so it is not that simple. Anyway,
whenever possible, xkbcomp should be preferred.

Indicators
----------

As in "keyboard leds". Indicator names are used to match the to the
physical LEDs in xkb_keycodes section. Otherwise, they are irrelevant.
Indicators not matched to any LED are called "virtual"; xkbvleds
(package xorg-xkbutils) can be used to check their state. Example:

       xkb_keycodes {
           indicator 1 = "LED1";       // first physical LED
       }

Indicators always reflect specified part of XKB internal state. Two
common modes is showing modifier state:

       xkb_compatibility {
           indicator "LED1" { modifiers = Lock; }; // CapsLock indicator
       }

or current group:

       xkb_compatibility {
           indicator "LED1" { groups = 0x06; };    // "group 2 or group 3 is active"
       }

The values are bitmasks. For groups, bit 1 is group 1, bit 2 is group 2
and so on.

  

Modifiers and types
-------------------

At some point it may become necessary to clean up types section, and/or
to introduce unusual types.

Types and modifiers are tightly connected, so it makes a lot of sense to
start with the modifier bits first, before doing anything with the type
descriptions.

Decide which bits you will use. There are only eight of them, and of
those, Shift, Control and Mod1 are widely used in applications, and Lock
(aka CapsLock) has pre-defined meaning which also may be hard to
override. The remaining four, however, are fair play.

Warning: four standard types, ONE_LEVEL, TWO_LEVEL, ALPHABETIC and
KEYPAD, receive special treatment in xkbcomp. They may work differently
just because they are named this way. Avoid deleting them. If some
changes do not work as expected, try adding a new type instead.

> Using real modifiers in standard types

Depending of your base configuration, there may be a lot of unused
standard types like EIGHT_LEVEL or PC_RCONTROL_LEVEL2. Remove them to
avoid doing unnecessary work.

Now, some standard types use virtual modifiers. If you decide to use
them, check Virtual modifiers below and skip this section. Otherwise,
it's a good idea to get rid of them completely. Check the types you
need, and either replace them with corresponding real ones, or remove
relevant definitions. Example:

       type "KEYPAD" {
           modifiers= Shift+NumLock;
           map[Shift]= Level2;
           map[NumLock]= Level2;
           level_name[Level1]= "Base";
           level_name[Level2]= "Number";
       };

if you use Mod2 for NumLock, change the type to

       type "KEYPAD" {
           modifiers= Shift+Mod2;
           map[Shift]= Level2;
           map[Mod2]= Level2;
           level_name[Level1]= "Base";
           level_name[Level2]= "Number";
       };

if you are not going to have NumLock modifier, change it to

       type "KEYPAD" {
           modifiers= Shift;
           map[Shift]= Level2;
           level_name[Level1]= "Base";
           level_name[Level2]= "Number";
       };

Do the same in xkb_compatibility section too. Once it's done, you should
be able to remove all "virtual_modifiers" lines in the file.

> Switching a single modifier bit

Basically all you need is a keysym with a relevant interpretation entry.
Example for Mod5 switching with LWIN key, with ISO_Level3_Shift for
keysym:

       xkb_compatibility {
           interpret ISO_Level3_Shift { action = SetMods(modifiers=Mod5); };
       }
       
       xkb_symbols {
           key <LWIN> { [ISO_Level3_Shift ] };
       }

Aside from SetMods, you can also use LockMods or LatchMods. SetMods
makes a regular "on while pressed" modifier key. LockMods makes an
"on/off" switch like CapsLock or NumLock. LatchMods means "on until next
keypress" aka sticky modifier

> modifier_map

Modifier map is a table that maps each of eight modifier bits to at most
two keys:

       modifier_map Mod1 { Alt_L, Alt_R };

In the core protocol, without XKB, it means more or less the same thing
as

       interpret Alt_L { action = SetMods(modifiers=Mod1); };
       interpret Alt_R { action = SetMods(modifiers=Mod1); };

XKB does not use modifier map in its original meaning. Within XKB, its
only function is to map virtual modifiers (see below).

However, the table is easily accessible by clients, and there is one
counter-intuitive (but well-known) trick involving it: modifier map is
used to tell which of ModX bits is Alt. Because of this, it is a good
idea to have one modifier mapped to Alt_L or Alt_R as shown above.
Unless you have very good reasons to do otherwise, it should be Mod1.

Multiple keyboards
------------------

XKB allows setting keymap for a single connected physical keyboard only.
This feature can be extremely useful for multi-keyboard setups when
keyboards in question are different; consider a laptop with a full-size
USB keyboard attached.

First of all, use xinput (package xorg-xinput) to get device IDs:

       AT Translated Set 2 keyboard                id=11   [slave  keyboard (3)]

Now,

       xkbcomp -i 11 file.xkb $DISPLAY

or

       setxkbmap -device 11 ...

will set keymap for specified keyboard only. Dumping XKB configuration
works too:

       xkbcomp -i 11 $DISPLAY file.xkb

Note xkbcomp -i11 will not work and will not give a clear error message
either. Make sure you have space after -i.

Debugging XKB
-------------

When keys do not work as expected, the first thing to check is XKB
internal state: modifiers, effective group and control bits. All three
can be used to drive leds; use xkbvleds to check them

       indicator "LED1" { modifiers = Lock; };
       indicator "LED2" { groups = 2; };
       indicator "LED3" { controls = audiblebell; };
       

Additionally, xkbwatch shows all (real) modifiers together with their
lock/latch status. Modifiers are also reported by xev. Xxkb can be used
to monitor effective group, but make sure two_state mode is off.

In case interpretations section does not work well, make sure to check
for duplicated "interpret" blocks. Better yet, try commenting out
anything related to specific keysym. See section 9.2 for explanation.

It also makes sense to check what exactly the server got by downloading
the keymap back with

       xkbcomp $DISPLAY out.xkb

The results tend to be different from the input file. There is no known
work-around for this.

Virtual Modifiers
-----------------

One of the most troublesome parts of XKB, virtual modifiers appear
prominently in all standard keymaps, despite being a relatively minor
and mostly useless feature. The term itself is grossly misleading, and
most of the docs do not help much either.

So, first of all: virtual modifiers are not modifiers in the same way
real modifiers are. If anything, it is a way to name some of the real
modifiers. They are not 16 more bits that can be used in level
definitions. They are 16 possible names, each referring to one (or some,
or none) of the 8 modifier bits.

Real modifier bits are called Shift, Lock, Control and Mod1-Mod5. There
are no Alt among them. Virtual modifiers were introduced to allow saying
something like

       #define Alt Mod1

to applications willing to use this information.

It is possible to make a usable layout without defining virtual
modifiers at all. Among standard modifiers, only Alt/Meta actually need
such treatment, because Shift and Control are real modifiers anyway and
NumLock is not normally used as a modifier.

Also, unlike most of the keymap-related things that affect any
application using basic Xlib functions, virtual modifiers must be
queried explicitly using XKBlib calls. Not all applications actually do
that.

> Defining virtual modifiers

The mapping between virtual and real modifiers is defined in a rather
weird way using keysyms as a medium. Refer to XKBproto for some reasons
behind this. Real modifiers M are assigned to a key using

       modifier_map M { <keysym> };

Virtual modifiers V can be assigned to a key using

       interpret <keysym> { virtualMod = V; };

If a virtual modifier V shares at least one keysym with a real modifier
M, it is bound to M.

Note that virtual modifier names are not pre-defined and must be
declared in xkb_compatibility and xkb_types sections before using them:

       xkb_compatibility "complete" {
           virtual_modifiers LevelThree,NumLock,Alt;
       }

  

> Keysym interpretation

Virtual modifiers can be used in interpret <keysym> blocks as if they
were defined to the respective real modifiers. For a virtual modifier V
not bound to any real modifier, this means

       #define V

type declaration, and

       interpret <key> { }
       interpret <key>+V { }

blocks will be treated as duplicates. Only one of them, the last one in
the file, will work. xkbcomp usually gives a warning in cases like this.

> Client side notes

Handling XKB virtual modifiers on the client side requires some
non-trivial server interaction. Most applications just do not bother,
sticking with 8 real modifiers supplied in XKeyEvent.state.

However, it is possible for an application to obtain virtual modifiers
associated with a key press. Gtk, for instance, has
gdk-keymap-translate-keyboard-state() which may or may not be used in
particular application.

Some others may implement something that looks like virtual modifier
support, but actually isn't. Check openbox example in section 5.3.3.2.
Regarding Alt handling, check section 8.3.

XKB control bits
----------------

A bunch of bit flags affecting various aspects of XKB functionality. To
control them, use {Set,Latch,Lock}Controls actions.

> Overlays

This feature allows temporary changing keycode (together with associated
keysyms) for a key. Example:

       xkb_keycodes {
           <KP4> = 83;      // both keycodes must be defined,
           <K04> = 144;     // even if the device can't produce the second one
       };

       xkb_compatibility {
           interpret Overlay1_Enable { action = LockControls(controls=overlay1); };
       };

       xkb_symbols {
           key <KP4> { [ KP_Left ], overlay1=<KO4> };
           key <KO4> { [ KP_4 ] };

           key <NMLK> { [ Overlay1_Enable ] };
       };

Let's assume 83 is a "real" code the keyboard can produce. With overlay1
bit off, the key will produce KP_Left keysym. With overlay1 bit on, it
will produce keycode 144 and associated keysym KP_4, taking it from a
different xkb_symbols row.

The principal difference between overlays and user-defined types, which
can be used to accomplish similar behavior too, is that overlays change
keycode and leave no traces in the state field. However, overlays are
very limited. There are only two control bits, overlay1 and overlay2),
and each key can have only one alternative keycode, so writing

           key <KP4> { [ KP_Left ], overlay1=<KO4>, overlay2=<KX4> };

is useless (but xkbcomp won't warn you). Each key has only one
"alternative keycode" field, the choice between overlay1= and overlay2=
only determines which of the two bits enables that alternative keycode.

The only well-know application for overlays is implementing
keypad/NumLock, as shown above. Check /usr/share/X11/xkb/symbols/keypad
for a complete example.

> Mouse control

XKB allows controlling mouse pointer from keyboard. When set up
properly, it can be extremely useful. However, its usability depends a
lot on particular physical keyboard layout and on user's individual
preferences.

From XKB point of view it is relatively simple to implement, one should
just trigger relevant actions. Fairly complete implementation can be
found in /usr/share/X11/xkb/compat/mousekeys.

Note that the actions won't work unless MouseKeys control bit is set:

       interpret Pointer_EnableKeys { action= LockControls(controls=MouseKeys); };

Because most keyboards do not have dedicated mouse control keys,
combining MouseKeys and one of the Overlay flags may be a good idea:

       interpret Pointer_EnableKeys { action= LockControls(controls=MouseKeys+Overlay1); };

This allows moving pointer control keys to appropriate overlay block:

       xkb_keycodes {
           <MUP> = 218;
           <MDWN> = 212;
           <MLFT> = 214;
           <MRHT> = 216;
       }
        
       xkb_symbols {
           key   <UP> { [    Up ], overlay1 = <MUP> };
           key <LEFT> { [  Left ], overlay1 = <MLFT> };
           key <RGHT> { [ Right ], overlay1 = <MRHT> };
           key <DOWN> { [  Down ], overlay1 = <MDWN> };
            
           key <MUP>  { [ Pointer_Up ] };
           key <MDWN> { [ Pointer_Down ] };
           key <MLFT> { [ Pointer_Left ] };
           key <MRHT> { [ Pointer_Right ] };
       }

This way it is possible to assign non-mouse actions to the keys used to
control mouse, and thus, for example, use modifier keys to generate
mouse buttons events.

See Also
--------

http://www.x.org/wiki/XKB and links therein, especially

-   An Unreliable Guide To XKB Configuration. Similar in scope to this
    page, with a bit different point of view. Recommended for a general
    picture.
-   Ivan Pascal XKB docs. One of the oldest and most well-known guides.
    Focuses a lot on details, and explains some of exotic XKB features.
-   XKB protocol specification. Comprehensive description of all XKB
    features. Extremely useful for understating how XKB works, includes
    a good description of virtual modifiers among other things. Some
    practice with xkbcomp is strongly recommended though, because the
    features are described on protocol level.
-   X.org Wiki - XKB. Additional links to XKB resources.

Retrieved from
"https://wiki.archlinux.org/index.php?title=XKB&oldid=239060"

Categories:

-   X Server
-   Input devices
-   Internationalization
