Fluxbox Style Guide
===================

This is a list of all the theme items that can be customized in a
fluxbox theme.cfg

This file is in two parts: the first explains what each of the items
does the second part is a complete list that can be copied and pasted
into a theme.cfg to get you started.

This has been specially structured to group the relevant items

Contents
--------

-   1 How the items work
    -   1.1 {texture type}
    -   1.2 {color}
    -   1.3 {filename}
    -   1.4 {integer}
    -   1.5 {boolean}
    -   1.6 {alpha}
    -   1.7 {round}
    -   1.8 {justify}
    -   1.9 {bullet}
    -   1.10 {string}
    -   1.11 {font}
    -   1.12 Explanation of items that are a little confusing
    -   1.13 Notes for getting started
-   2 Structured items
    -   2.1 The toolbar
        -   2.1.1 General settings
        -   2.1.2 The clock area
        -   2.1.3 The workspace title area
        -   2.1.4 The iconbar
        -   2.1.5 Empty - when no windows are shown as icons
        -   2.1.6 Focused window icon
        -   2.1.7 Unfocused window icon
        -   2.1.8 The toolbar buttons for prevworkspace, nextworkspace,
            prevwindow and next window
    -   2.2 The windows
        -   2.2.1 General
    -   2.3 Focused and unfocused window
        -   2.3.1 titlebar
        -   2.3.2 label
        -   2.3.3 handle
        -   2.3.4 grips
        -   2.3.5 button
        -   2.3.6 window buttons
        -   2.3.7 close
        -   2.3.8 max
        -   2.3.9 icon
        -   2.3.10 stick
        -   2.3.11 stuck
    -   2.4 The menu
        -   2.4.1 general settings
        -   2.4.2 title - top of each menu
        -   2.4.3 frame - menu body
        -   2.4.4 hilite
        -   2.4.5 details
        -   2.4.6 set the wallpaper with an app...
        -   2.4.7 The slit

How the items work
------------------

Each item is structured mainobject.subobject.item: value e.g.
toolbar.clock.pixmap: value

The values that are available only depend on the item part e.g. .pixmap:
{filename}

The pixmap item needs a {filename} e.g. toolbar.clock.pixmap: clock.xpm

That's it! All you need to know is the options for each value. Here I'll
show what the different options can befor each value with some examples.
Part 2 gives a list of all the items and the type of value needed for
each and can be copied to a file by you.

> {texture type}

pixmap options: requires a filename in *.pixmap

     pixmap
       tiled

non-pixmap options: uses .color to color the objects, use.colorTo for
gradients and highlights

     flat
       gradient
         vertical
         horizontal
         diagonal
         crossdiagonal
         pipecross
         elliptic
         rectangle
         pyramid

e.g menu.frame: Flat Gradient Vertical  
 or

       raised
       sunken
         bevel1
         bevel2
           gradient
             vertical
             horizontal
             diagonal
             crossdiagonal
             pipecross
             elliptic
             rectangle
             pyramid

e.g. menu.title: Raised Bevel1 Gradient Vertical

> {color}

any hex color

     #ffffff
     #000000

e.g menu.title.textColor: #ffffff

any rgb colour as shown in /usr/X11R6/lib/X11/rgb.txt

    rgb:4/3/2

e.g menu.title.textColor: rgb:4/3/2

any colour

    white
    black

e.g menu.title.textColor: white

> {filename}

the name of a .xpm file stored in pixmaps, which should be in the same
directory as theme.cfg e.g. menu.title.pixmap: iconbarf.xpm

> {integer}

a whole number that gives the height/width of something in pixels e.g
window.title.height: 22

> {boolean}

Something set to either on or off

    true
    false

e.g.toolbar.shaped: true

> {alpha}

a transparency setting - should be an integer between 0 and 255 where 0
is invisible/transparent  
 and 255 is solid/opaque - 150 is popular

e.g.window.alpha: 255

> {round}

rounding options for corners

    TopLeft
    TopRight
    BottomLeft
    BottomRight

e.g.window.roundCorners: TopLeft TopRight

> {justify}

where text or an image is postioned

    Center
    Left
    Right

e.g.window.justify: Center

> {bullet}

only used for menu.bullet: option. for non pixmaps styles only.

    triangle
    square
    diamond
    empty

e.g.menu.bullet: triangle

> {string}

only used for the root.command: option. lets you set the path to a
wallapaper image and which application to display it

    fbsetbg -f wallpaper.png

e.g.root.command: fbsetbg -a mywallpaper.png

> {font}

what font to use!

    font-size

e.g.menu.frame.font: trebuchet-10

there are several options that can be used in any combination

    bold
    shadow
    italic

these need to be colon or comma separated

    font-size:bold:shadow:italic

e.g.menu.title.font: trebuchet-10:shadow:bold

> Explanation of items that are a little confusing

.colorTo - if you use a gradient setting then the belnd is between
.color and .colorTo

.borderWidth - gives a border of {integer} width. 0 will give no border

.bevelwidth - the bevel is between the border and the object e.g. in the
menu, menu.bevelWidth increases the space between menu entries

.picColor - sets the color of a default fluxbox image that is added on
top of an item e.g. toolbar.button.picColor

.alpha - a transparency setting

> Notes for getting started

1. using window.label and window.title with window.bevelWidth

When you use window.label this will overlay window.title. however, if
you set window.bevelWidth the window.title will show as a "border"
around window.label i.e. window.label floats over window.title This
allows some quite simple but cool effects but does restrict window
buttons (see below)

2. using toolbar and toolbar.iconbar.*, toolbar.clock,
toolbar.workspace, toolbar.button

As with 1. above. toolbar is overlayed by toolbar.iconbar.*,
toolbar.clock, toolbar.workspace and toolbar.button. Again setting
toolbar.bevelWidth allows all of the these to float over toolbar, giving
a border/layer effect

3. using window buttons

If window.bevelWidth is not used then all window.* buttons (close, icon,
etc) may be any size but must be square and all have the same
dimensions. This allows some very creative button designs and most
styles at Fluxmod use this method

However, if window.bevelWidth is used then the buttons are restricted in
size by the font used for window.label. Here the best thing to do is
choose the font size you want for window.label then make your pixmaps to
the correct size. Or, in this case, you could set the window.button
options to give a background and allow fluxbox to overlay with the
default pixmaps (you can choose the colour with
window.button.*.picColor) or create your own to the correct dimensions.

4. using * (wildcards)

Structured items
----------------

A theme.cfg template is laid out below:

     This work is licensed under the Creative Commons
     Attribution-NonCommercial-ShareAlike License.
     To view a copy of this license, visit
     http://creativecommons.org/licenses/by-nc-sa/1.0/
     or send a letter to Creative Commons,
     559 Nathan Abbott Way, Stanford, California 94305, USA.

    ---------------------------------------------
     FluxMOD http://www.fluxmod.dk
     Style Name:
     Style Author:
     Style Date:
    ---------------------------------------------

> The toolbar

General settings

toolbar.borderWidth: {integer}  
 toolbar.borderColor: {color}  

toolbar.shaped: {boolean}  
 toolbar.alpha: {alpha}  
 toolbar.height: {integer}  

The clock area

toolbar.clock.font: {font}  
 toolbar.clock.textColor: {color}  
 toolbar.clock.justify: {justify}  

toolbar.clock: {texture type}  
 toolbar.clock.pixmap: {filename}  
 toolbar.clock.color: {color}  
 toolbar.clock.colorTo: {color}  
 toolbar.clock.borderWidth: {integer}  
 toolbar.clock.borderColor: {color}  

The workspace title area

toolbar.workspace.font: {font}  
 toolbar.workspace.textColor: {color}  
 toolbar.workspace.justify: {justify}  

toolbar.workspace: {texture type}  
 toolbar.workspace.pixmap: {filename}  
 toolbar.workspace.color: {color}  
 toolbar.workspace.colorTo: {color}  
 toolbar.workspace.borderWidth: {integer}  
 toolbar.workspace.borderColor: {color}  

The iconbar

where windows are shown depending on Iconbar Mode which is set by
right-clicking on the fluxbox toolbar  

toolbar.iconbar.borderWidth: {integer}  
 toolbar.iconbar.borderColor: {color}  

Empty - when no windows are shown as icons

toolbar.iconbar.empty: {texture type}  
 toolbar.iconbar.empty.pixmap: {filename}  
 toolbar.iconbar.empty.color: {color}  
 toolbar.iconbar.empty.colorTo: {color}  

Focused window icon

toolbar.iconbar.focused.font: {font}  
 toolbar.iconbar.focused.textColor: {color}  
 toolbar.iconbar.focused.justify: {justify}  
 toolbar.iconbar.focused: {texture type}  
 toolbar.iconbar.focused.pixmap: {filename}  
 toolbar.iconbar.focused.color: {color}  
 toolbar.iconbar.focused.colorTo: {color}  
 toolbar.iconbar.focused.borderWidth: {integer}  
 toolbar.iconbar.focused.borderColor: {color}  

Unfocused window icon

toolbar.iconbar.unfocused.font: {font}  
 toolbar.iconbar.unfocused.textColor: {color}  
 toolbar.iconbar.unfocused.justify: {justify}  
 toolbar.iconbar.unfocused: {texture type}  
 toolbar.iconbar.unfocused.pixmap: {filename}  
 toolbar.iconbar.unfocused.color: {color}  
 toolbar.iconbar.unfocused.colorTo: {color}  
 toolbar.iconbar.unfocused.borderWidth: {integer}  
 toolbar.iconbar.unfocused.borderColor: {color}  

The toolbar buttons for prevworkspace, nextworkspace, prevwindow and next window

toolbar.button {texture type}  
 toolbar.button.pixmap: {filename}  
 toolbar.button.color: {color}  
 toolbar.button.colorTo: {color}  
 toolbar.button.picColor: {color}  
 toolbar.button.pressed: {texture type}  
 toolbar.button.pressed.pixmap: {filename}  
 toolbar.button.pressed.color: {color}  
 toolbar.button.pressed.colorTo: {color}  
 toolbar.button.pressed.picColor: {color}  

> The windows

focus is the currently selected window - unfocus is in the background

General

window.font: {font}  
 window.justify: {justify}  
 window.roundCorners: {round}  
 window.alpha: {alpha}  
 window.bevelWidth: {integer}  
 window.borderWidth: {integer}  
 window.borderColor: {color}  

> Focused and unfocused window

titlebar

the "background" of the window title. This is layered under window.label
- see the note in part one

window.title.height: {integer}   
 window.title.focus: {texture type}  
 window.title.focus.pixmap: {filename}  
 window.title.focus.color: {color}  
 window.title.focus.colorTo: {color}  
 window.title.unfocus: {texture type}  
 window.title.unfocus.pixmap: {filename}  
 window.title.unfocus.color: {color}  
 window.title.unfocus.colorTo: {color}  

label

the text background. This is layered over window.title - see the note in
part one

window.label.focus: {texture type}  
 window.label.focus.pixmap: {filename}  
 window.label.focus.color: {color}  
 window.label.focus.colorTo: {color}  
 window.label.focus.textColor: {color}  
 window.label.unfocus: {texture type}  
 window.label.unfocus.pixmap: {filename}  
 window.label.unfocus.color: {color}  
 window.label.unfocus.colorTo: {color}  
 window.label.unfocus.textColor: {color}  

handle

the bar along the bottom of the window for resizing vertically

window.handleWidth: {integer}  
 window.handle.focus: {texture type}  
 window.handle.focus.pixmap: {filename}  
 window.handle.focus.color: {color}  
 window.handle.focus.colorTo: {color}  
 window.handle.unfocus: {texture type}  
 window.handle.unfocus.pixmap: {filename}  
 window.handle.unfocus.color: {color}  
 window.handle.unfocus.colorTo: {color}  

grips

either side of the handle for resizing in horizontally and vertically

window.grip.focus: {texture type}  
 window.grip.focus.pixmap: {filename}  
 window.grip.focus.color: {color}  
 window.grip.focus.colorTo: {color}  
 window.grip.unfocus: {texture type}  
 window.grip.unfocus.pixmap: {filename}  
 window.grip.unfocus.color: {color}  
 window.grip.unfocus.colorTo: {color}  

button

sets the background for the window buttons - not visible if window
buttons (below) are used

window.button.focus: {texture type}  
 window.button.focus.pixmap: {filename}  
 window.button.focus.color: {color}  
 window.button.focus.colorTo: {color}  
 window.button.focus.picColor: {color}  
 window.button.unfocus: {texture type}  
 window.button.unfocus.pixmap: {filename}  
 window.button.unfocus.color: {color}  
 window.button.unfocus.colorTo: {color}  
 window.button.unfocus.picColor: {color}  
 window.button.pressed: {texture type}  
 window.button.pressed.pixmap: {filename}  
 window.button.pressed.color: {color}  
 window.button.pressed.colorTo: {color}  

window buttons

close, max and min, shade, stick and stuck

close

window.close.pixmap: {filename}  
 window.close.unfocus.pixmap: {filename}  
 window.close.pressed.pixmap: {filename}  

max

window.maximize.pixmap: {filename}  
 window.maximize.unfocus.pixmap: {filename}  
 window.maximize.pressed.pixmap: {filename}  

icon

window.iconify.pixmap: {filename}  
 window.iconify.unfocus.pixmap: {filename}  
 window.iconify.pressed.pixmap: {filename}  

stick

window.stick.pixmap: {filename}  
 window.stick.unfocus.pixmap: {filename}  
 window.stick.pressed.pixmap: {filename}  

stuck

window.stuck.pixmap: {filename}  
 window.stuck.unfocus.pixmap: {filename}  

> The menu

general settings

menu.borderWidth: {integer}  
 menu.bevelWidth: {integer}  
 menu.borderColor: {color}  

title - top of each menu

menu.title.font: {font}  
 menu.title.textColor: {color}  
 menu.title.justify: {justify}  
 menu.title: {texture type}  
 menu.title.pixmap: {filename}  
 menu.title.color: {color}  
 menu.title.colorTo: {color}  

frame - menu body

menu.frame.font: {font}  
 menu.frame.textColor: {color}  
 menu.frame.disableColor: {color}  
 menu.frame.justify: {justify}  
 menu.frame: {texture type}  
 menu.frame.pixmap: {filename}  
 menu.frame.color: {color}  
 menu.frame.colorTo: {color}  

hilite

how the options are highlighted when mouse is over them

menu.hilite.textColor: {color}  
 menu.hilite: {texture type}  
 menu.hilite.pixmap: {filename}  
 menu.hilite.color: {color}  
 menu.hilite.colorTo: {color}  

details

menu.roundCorners: {round}  
 menu.bullet.position: {justify}  
 menu.bullet: {bullet}  
 menu.submenu.pixmap: {filename}  
 menu.selected.pixmap: {filename}  
 menu.unselected.pixmap: {filename}  

  

set the wallpaper with an app...

rootCommand: {string}  

The slit

settings for the slit - not applicable if slit alpha is set to 0

slit: {texture type}  
 slit.pixmap: {filename}  
 slit.color: {color}  
 slit.colorTo: {color}  
 slit.borderWidth: {integer}  
 slit.bevelWidth: {integer}  
 slit.borderColor: {color}  

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fluxbox_Style_Guide&oldid=225245"

Categories:

-   Eye candy
-   Stacking WMs

-   This page was last modified on 26 September 2012, at 14:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
