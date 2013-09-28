Font Configuration/fontconfig Examples
======================================

Configurations can vary to a degree. Please feel free to post your
fontconfig configurations and the rationale behind them.

brebs' configuration
--------------------

This is a quest to get all fonts looking beautiful at all sizes,
weights, etc., by tweaking the fontconfig rules for Infinality
rendering. The latest version is maintained here -- brebs

Basic config with no hinting for italic or bold and some other tuning
---------------------------------------------------------------------

    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <match target="font" >
        <edit mode="assign" name="autohint">  <bool>true</bool></edit>
        <edit mode="assign" name="hinting">	  <bool>false</bool></edit>
        <edit mode="assign" name="lcdfilter"> <const>lcddefault</const></edit>
        <edit mode="assign" name="hintstyle"> <const>hintslight</const></edit>
        <edit mode="assign" name="antialias"> <bool>true</bool></edit>
        <edit mode="assign" name="rgba">      <const>rgb</const></edit>
      </match>

      <match target="font">
        <test name="pixelsize" qual="any" compare="more"><double>15</double></test>
        <edit mode="assign" name="lcdfilter"><const>lcdlight</const></edit>
        <edit mode="assign" name="hintstyle"><const>hintnone</const></edit>
      </match>

      <match target="font">
        <test name="weight" compare="more"><const>medium</const></test>
        <edit mode="assign" name="hintstyle"><const>hintnone</const></edit>
        <edit mode="assign" name="lcdfilter"><const>lcdlight</const></edit>
      </match>

      <match target="font">
        <test name="slant"  compare="not_eq"><double>0</double></test>
        <edit mode="assign" name="hintstyle"><const>hintnone</const></edit>
        <edit mode="assign" name="lcdfilter"><const>lcdlight</const></edit>
      </match>

    </fontconfig>

Sharp fonts
-----------

It took me a while to find font settings that are sharp and not overly
blurred. This font config does exactly that and seems to work fine
everywhere. I searched for this because "Chromium" wasn't looking good
with no aliasing at all. The below config fixes that as well.

    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <match target="font">
        <edit name="antialias" mode="assign"><bool>true</bool></edit>
        <edit name="hinting" mode="assign"><bool>true</bool></edit>
        <edit name="hintstyle" mode="assign"><const>hintfull</const></edit>
        <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
        <edit name="rgba" mode="assign"><const>rgb</const></edit>
      </match>
    </fontconfig>

Retrieved from
"https://wiki.archlinux.org/index.php?title=Font_Configuration/fontconfig_Examples&oldid=254582"

Category:

-   Fonts
