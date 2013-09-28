Envy24control
=============

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Some sections    
                           are blank and need to be 
                           filled in with relevant  
                           content. (Discuss)       
  ------------------------ ------------------------ ------------------------

envy24control is an application included in the alsa-tools package. It
enables controlling the digital mixer, channel gains, and other hardware
settings for sound cards based on the VIA Ice1712 chipset (A.K.A.
Envy24).

envy24control's user interface is loosely based on the Delta Control
Panel software included with the purchase of M-Audio Delta series audio
cards -- most of the tabs, controls, and capabilities are similar in the
two applications. However, because they are two separate applications,
the user manual for Delta Control Panel software is only marginally
useful for envy24control users. This article aims to provide usage
guidance for those using ice1712-based cards and envy24control with Arch
Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Supported cards                                                    |
|     -   2.1 Understanding your sound card                                |
|         -   2.1.1 Read your sound card manual                            |
|                                                                          |
| -   3 Application overview                                               |
|     -   3.1 Monitor Inputs                                               |
|         -   3.1.1 Meters                                                 |
|         -   3.1.2 Faders                                                 |
|         -   3.1.3 Tips and tricks                                        |
|                                                                          |
|     -   3.2 Monitor PCMs                                                 |
|         -   3.2.1 Tips and tricks                                        |
|                                                                          |
|     -   3.3 Patchbay / Router                                            |
|         -   3.3.1 Tips and tricks                                        |
|                                                                          |
|     -   3.4 Hardware Settings                                            |
|         -   3.4.1 Master Clock                                           |
|         -   3.4.2 Rate State                                             |
|             -   3.4.2.1 Settings combinations and their behaviors        |
|                                                                          |
|         -   3.4.3 Actual Rate                                            |
|                                                                          |
|     -   3.5 Analog Volume                                                |
|         -   3.5.1 DAC faders                                             |
|         -   3.5.2 ADC faders                                             |
|         -   3.5.3 Tips and tricks                                        |
|                                                                          |
|     -   3.6 Profiles                                                     |
|                                                                          |
| -   4 Usage examples                                                     |
|     -   4.1 Recording a single track in Ardour (Ardour does monitoring)  |
|         -   4.1.1 envy24control settings                                 |
|         -   4.1.2 Ardour settings                                        |
|         -   4.1.3 JACK connections                                       |
|                                                                          |
|     -   4.2 Recording a single track in Ardour (Audio Hardware does      |
|         monitoring)                                                      |
|         -   4.2.1 envy24control settings                                 |
|         -   4.2.2 Ardour settings                                        |
|         -   4.2.3 JACK connections                                       |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

envy24control is included with the alsa-tools package in the community
repository:

    # pacman -S alsa-tools

Note:mudita24 is an alternative to envy24control available in the AUR.
It is identical to envy24control, except that it has some clearer UI
labels, peak meter indicators, and a few other bells and whistles.

Supported cards
---------------

envy24control is designed to control ice1712-based cards, including, but
not limited to:

-   M-Audio Delta 1010
-   M-Audio Delta 1010LT
-   M-Audio Delta DiO 2496
-   M-Audio Delta 66
-   M-Audio Delta 44
-   M-Audio Delta 410
-   M-Audio Audiophile 2496
-   Terratec EWS 88MT
-   EWS 88D
-   EWX 24/96
-   DMX 6Fire
-   Phase 88
-   Hoontech Soundtrack DSP 24
-   Soundtrack DSP 24 Value
-   Soundtrack DSP 24 Media 7.1
-   Event Electronics EZ8
-   Digigram VX442
-   Lionstracs
-   Mediastation
-   Terrasoniq TS 88
-   Roland/Edirol DA-2496

> Understanding your sound card

If you have one of the cards in the list above, know that it has a
hardware digital audio mixer built into it (the Ice1712 chip). This
mixer accepts digital audio streams from hardware inputs and outgoing
streams from software audio devices (such as those provided by JACK),
mixes them internally, and then sends the mixed output to the card's
hardware outputs. envy24control controls this mixer.

Read your sound card manual

It is vital that you understand your sound card's features and
capabilities. If you do not, envy24control will not make working with
the card any clearer or easier. It is more likely to do just the
opposite. Save yourself some frustration: read the manual.

Application overview
--------------------

> Monitor Inputs

The Monitor Inputs page is effectively a mixer for your card's hardware
inputs. It enables you to meter the "post-gain" incoming audio signals
and adjust their volumes in the card's on-board "monitor" mixer. For
each physical card input, there is a pair of volume faders, mute
buttons, and pre-fader level meters. On the far left, there is a meter
indicating the overall signal level being routed to the on-board mixer's
"pre out." The output of this digital mixer may be assigned to any of
your card's hardware outputs on the Patchbay /Router page, by selecting
"Digital Mix L/R." (Typically, you would do this for the hardware
outputs that your monitor speakers are connected to, e.g. "H/W OUT
1/2.")

Meters

Each mixer input channel has its own level meter that indicates the
"pre-fader" levels of the incoming audio signal and are therefore not
affected by the fader settings. Each input's meters are color-coded into
three sections: green, orange, and red. The green section is a safe
zone; most incoming audio signals should fill at least this section of
the meter when recording. The orange section represents a hotter zone;
it is both safe and recommended to adjust the incoming signal to meter
mostly in this zone when recording. The red zone represents danger; when
the signal hits 0dB, overload and audio clipping may occur. Adjust the
output level of your audio source along with the appropriate "ADC"
faders on the "Analog Volume" page so that the incoming audio levels do
not peak in the red very often or for too long. Let your ears be the
judge. See #Analog Volume.

Faders

The faders control the signal level in the card's digital mix. They do
not control the level of the incoming audio signals -- they are
"post-meter." There is no gain control; the faders can only attenuate
(reduce) the signal levels. A pair of faders can be "ganged", so that
both channels can be controlled as a stereo pair. The mute buttons do
exactly what you would expect: they mute the outgoing channel.

A mono signal can be panned by setting the stereo faders or mute
controls accordingly. For example, to pan hard left, mute the right
channel. To pan soft right, set the right fader higher than the left. To
preserve a stereo signal coming into 2 hardware inputs -- "H/W In 1/2",
for example -- mute the right fader on "H/W In 1", and mute the left
fader on "H/W In 2."

The highest level setting on the faders is 0dB, or Unity Gain, which is
an easy way of indicating a gain of factor 1 (equivalent to 0dB) where
both input and output are at the same voltage level and impedance. Since
there is no amplification available, clipping is impossible on the
outgoing signal. If the incoming audio signal levels are ideal -- say,
-12dB to -3dB (in the orange) -- it is perfectly safe to set the faders
to 0dB (the highest level setting.)

The overall audio signal level of the on-board digital mixer's "pre-out"
is indicated by the large meters on the far left, labeled "Digital
Mixer." This meter is visible on all pages in the application's UI and
displays the same information regardless of which page is active.

Tips and tricks

-   The input meters display the audio signal levels being sent to the
    digital mixer on your card -- they are "pre-fader."

-   To control the incoming audio signal level, adjust the the
    appropriate "ADC" fader(s) on the "Analog Volume" page in
    conjunction with the output level of your source. E.g., your
    outboard mixer, your mic pre-amp, etc.

Tip:As a rule of thumb, set the appropriate "ADC" fader(s) to 127. This
is unity gain (0dB) and will pass the audio source's output signal
through as-is to the digital mixer (with no amplification or
attenuation). See #Analog Volume.

-   The incoming audio signal levels and input meters are not affected
    by adjustments to the faders or mute buttons on the "Monitor Inputs"
    page.

-   The volume controls (faders and mute buttons) determine the audio
    signal level in the card's on-board digital mixer.

> Monitor PCMs

Tip:For the inquisitive: PCM is an acronym for Pulse Code Modulation.

The Monitor PCMs page is effectively a monitor mixer for your card's
software inputs. Software inputs are the digital audio streams sent by
your software applications. Typically, on a Linux-based Digital Audio
Workstation (DAW), this means JACK. The power of this functionality is
most apparent when "Digital Mix" is connected to a pair of audio outputs
in the Patchbay / Router tab, and you are mixing multiple sources from
both hardware and software inputs See #Usage examples.

The faders, meters, and mute buttons operate identically to those on the
Monitor Inputs page.

Tips and tricks

-   The available software inputs are displayed as "playback_X", where X
    is a sequential number, in JACK's Connections dialog (in the
    "Writable Clients / Input Ports" box.) The number of available
    inputs will vary depending on your specific card.

-   "PCM Out 1/2" are typically used by applications like Ardour for
    their main outs. This is so common, the default signal routed to
    your card's physical outputs come from "PCM Out 1/2." Therefore,
    when using your card for monitoring rather than Ardour's, use "PCM
    Out 3" or higher to monitor the signal you are actively recording to
    maintain mixing flexibility. See #Usage Examples.

-   When connecting the "capture_1/2" output port to input ports in
    JACK's Connections dialog, be sure to mute the "H/W In 1/2" on the
    Monitor Inputs page. For example, if you use JACK to connect
    "capture_1/2" to "playback_3/4", not muting "H/W In 1/2" on the
    Monitor Inputs page will result in a combination of the direct input
    hardware signal with a software version of the same signal in the
    mixer (remember your card is a mixer!), and this usually produces
    signal phase problems or worse. Depending on the situation, you
    could even produce a signal loop.

> Patchbay / Router

This page allows you to connect each of the card's hardware outputs to
specific audio sources within the card's board.

The two leftmost vertical columns, "H/W Out 1/2 (L/R)", connects these
outputs to one of these signal sources:

1.  The default setting, "PCM Out 1/2", is your music software outputs.
    For example, Ardour's main outs connected to "playback_1/2" via
    JACK's Connections dialog.
2.  "Digital Mix" is the output of the card's mixer.This handy option
    allows you to mix hardware and software audio sources directly in
    your card's mixer with near-zero latency.
3.  "S/PDIF In L/R" is a direct connection to the card's S/PDIF inputs.
4.  "H/W In 1/2" is a direct connection to the card's analog audio
    inputs.

The two rightmost columns, "S/PDIF Out 1/2 (L/R)", function identically
as the above, but the first option is labeled differently (and a bit
confusingly):

1.  The "S/PDIF Out 1/2 (L/R)" option connects these outputs to your
    music software outputs. Again, for example, Ardour's main outs
    connected via JACK.

Tips and tricks

-   Typically, you would select the same option for both the L and R of
    a stereo output pair. (In fact, the Delta Control Panel software
    that ships with M-Audio sound cards forces this behavior: there is
    no separate L and R channel on this page. The envy24control
    developers provided additional flexibility in this regard.)

-   Depending on your card, the number of "playback_X" channels
    available in JACK's Connections dialog will vary. Usually, the two
    highest-numbered channels are "S/PDIF Out 1/2 (L/R)." This may or
    may not be the case with your configuration; take a few minutes to
    experiment and make a note.

-   Learn to use the "Digital Mix" option. It is an extremely powerful
    feature that allows you to take some of the audio processing load
    off your recording software by handling the monitor mix with your
    card's hardware instead. This also provides the added benefit of
    near-zero latency while monitoring. See #Usage examples.

-   It should be fairly clear by now that the on-board mixer and
    patchbay / router in your sound card is highly versatile. You may
    want to re-read this page and make some practice adjustments to
    become proficient in routing and mixing with envy24control. If in
    the process you end up confused, you can set the card back to its
    default configuration by selecting the topmost option in all of the
    columns on the "Patchbay / Router" page.

> Hardware Settings

Master Clock

This section allows you to select the source and codec sample rate of
the card's master clock. Int indicates a selection that will rely on the
card's internal crystal for the clock. S/PDIF In is an advanced
capability most often used when synchronizing two or more Ice1712-based
cards. To achieve this, one card is set to an Int rate -- it will serve
as the master clock. The "S/PDIF Outs" of the master clock card are
connected to the "S/PDIF Ins" of the second card, and that card's clock
is set to S/PDIF In, effectively "chaining" them together.

When using an Int option, Int 44100 (44.1 kHz) and higher are
recommended for digital recording.

Rate State

When Reset is selected, the codec sample rate selected in the "Master
Clock" section is regarded as the "idle" sample rate. This means that
when your card is in use by a software application such as JACK, the
rate is set by that application. The card will then switch (if
necessary) to the selected sample rate whenever it's not in use by an
application. Think of the complete name for this tickbox as Reset Rate
When Idle.

The codec sample rate can be locked to a specific rate by selecting
Locked. When you do this, the card will disallow applications from
setting the sample rate differently. If an application attempts to do
so, you will most likely experience errors and/or XRUNS.

Tip:It's a common misconception that the selected clock rate and the
rate of your software applications must match, or you'll get oodles of
XRUNS. In practice, as long as Locked is not selected, this should not
be the case (and the author has never experienced this being a problem).
Of course, your mileage may vary depending on your setup. To be sure,
setting all applications' clock rates consistently eliminates one more
possible source of XRUNS.

Settings combinations and their behaviors

  Locked   Reset   Behavior
  -------- ------- --------------------------------------------------------------------------------------------------------------------------
  -        X       Software applications can set codec sample rate; card returns to selected rate when not in use (default and recommended)
  -        -       Software applications can set codec sample rate; card leaves rate at last rate specified when not in use
  X        -       Codec sample rate is locked to selected rate; applications may not specify other rates (beware XRUNS!)

Actual Rate

This displays the current codec sample rate of the card. Depending on
your settings, this may vary as it's controlled by applications such as
JACK or Ardour and/or by envy24control itself. See #Master Clock and
#Rate State for details.

> Analog Volume

The faders on the "Analog Volume" page control the signal levels of the
digital-to-analog (DAC) and analog-to-digital (ADC) converters of your
card.

DAC faders

These faders are attenuators for the level of the outgoing analog audio
signal after it's been converted from digital audio and sent to the
hardware outputs. These are the "post-outs" of your card; think of them
like the "main outs" or "main mix" faders on a hardware mixer. A value
of 127 (maximum volume) is 0dB, or unity gain.

ADC faders

The ADC faders control attenuation or amplification of incoming analog
audio signals being converted from your card's hardware inputs. They are
effectively "gain" controls. A value of 127 is 0dB, or unity gain.
Setting a fader all the way up provides +18dB of gain. Setting the fader
all the way down attenuates the signal by -63dB, effectively muting the
audio signal.

Tips and tricks

-   One of the most common solutions when you can't hear your incoming
    audio signal is to check the ADC faders for the hardware inputs into
    which your source is plugged. Until you adjust the ADC faders for
    the appropriate channels, the signal is effectively muted.

-   Setting the "ADC" faders to 127 (0dB) is the recommended starting
    value when adjusting incoming audio signal levels. This way,
    clipping is impossible in the card's digital mixer, and you only
    need to use your audio source's output level controls for
    adjustments.

-   If your audio source's maximum output levels are too low and do not
    meter in the orange on the "Monitor Inputs" page when the ADC fader
    is set to 127, slide the ADC fader up in small increments to amplify
    the signal until the desired levels are reached.

Note:Using the ADC's amplifier is typically not ideal because you're
likely amplifying a weak signal -- noise and all. The ideal solution is
to find an external way to boost your audio source's signal. For
example, use a mic preamp, route your guitar through a direct box, etc.

-   The numbering of the faders is zero-based. So, "DAC 0" corresponds
    to "H/W Out 1 (L)", "DAC 1" corresponds to "H/W Out 2 (R)", and so
    on. This is also true for the "ADC" faders.

> Profiles

TODO

Usage examples
--------------

> Recording a single track in Ardour (Ardour does monitoring)

This example assumes you have a mono audio source plugged into your
card's analog input "H/W In 1." For example, a microphone through a
pre-amp.

envy24control settings

-   All channels on the "Monitor Inputs" and "Monitor PCMs" pages muted
    and faders down. (This seems counter-intuitive at first, but
    remember that you are not using the mixer, so none of these controls
    matter in this example.)
-   On the "Patchbay / Router" page, select "PCM Out 1/2" in the "H/W
    Out 1/2 (L/R)" columns. This is where Ardour is sending its master
    outs.
-   On the "Analog Volume" page, set the appropriate faders (e.g., "DAC
    0/1") to 127 (full volume), and set the "ADC 0" fader to 127 (unity
    gain or 0dB.)
-   On the "Monitor Inputs" page, watch the "H/W In 1" meter and adjust
    the output volume on your audio source until most peaks fall in the
    "orange" zone. This is about -12dB through -3dB.
-   Once the JACK connections are made as described below, you will also
    be able to meter Ardour's master out signal on "PCM Out 1/2" in the
    "Monitor PCMs" page.

Ardour settings

-   Create a normal mono track. For this example, it will be called
    "Audio 1."
-   Under Options > Monitoring, ensure that Ardour does monitoring is
    selected. VERY IMPORTANT!
-   Ensure "Auto Input" is enabled; you can find the button in the upper
    right-hand corner. This will cause the signal for your track to
    toggle between the recorded track and the input signal, depending on
    whether or not the track is "armed" for recording.
-   After making the JACK connections as described below, arm "Audio 1"
    for recording and make any level adjustments in Ardour, using the
    "Audio 1" meter.

JACK connections

    +-----------------------+                   +-------------------+
    |       OUTPUTS         |                   |      INPUTS       |
    |-----------------------|                   |-------------------|
    | Ardour                |                   | Ardour            |
    |  Audio 1/out 1        +---+   +-----------+  Audio 1/in 1     |
    |  Audio 1/out 2        +-+ +---|-----------+  master/in 1      |
    |  ...                  | +-----|-----------+  master/in 2      |
    |  ...                  |       |           |                   |
    |  master/out 1         +-------|-----+     | System            |
    |  master/out 2         +-------|---+ +-----+   playback_1      |
    |                       |       |   +-------+   playback_2      |
    | System                |       |           |   ...             |
    |   capture_1           +-------+           |                   |
    |   capture_2           |                   |                   |
    |   ...                 |                   |                   |
    +-----------------------+                   +-------------------+

> Recording a single track in Ardour (Audio Hardware does monitoring)

As with the first example, this example also assumes you have a mono
audio source plugged into your card's analog input "H/W In 1." For
example, a microphone through a pre-amp.

envy24control settings

-   Mute all channels on the "Monitor Inputs" page. Watch the "H/W In 1"
    meter and adjust the output volume on your audio source until most
    peaks fall in the "orange" zone. This is about -12dB through -3dB.
-   On the "Patchbay / Router" page, select "Digital Mix" in the "H/W
    Out 1/2 (L/R)" columns.
-   On the "Analog Volume" page, set the appropriate faders (e.g., "DAC
    0/1") to 127 (full volume), and set the "ADC 0" fader to 127 (unity
    gain or 0dB.)
-   On the "Monitor PCMs" page, unmute the L channel of "PCM Out 1" and
    set the fader to 20. Unmute the R channel of "PCM Out 2" and set the
    fader to 20. This will preserve the stereo field of Ardour's master
    outs.
-   Also on the "Monitor PCMs" page, unmute both the L and R channels of
    "PCM Out 3" and set the faders to 20. This is where [[JACK][] will
    be routing your incoming audio source's signal for monitoring.
-   After making the JACK connections as described below, use the faders
    on the "Monitor PCMs" page to adjust levels in your monitor mix.
    (This will make more sense once you have recorded a track: the
    playback will be routed to "PCM Out 1/2" because these are Ardour's
    master outs.)

Ardour settings

-   Create a normal mono track. For this example, it will be called
    "Audio 1."
-   Under Options > Monitoring, ensure that Audio Hardware does
    monitoring is selected. VERY IMPORTANT!
-   Ensure "Auto Input" is disabled; you can find the button in the
    upper right-hand corner. (This is optional, but helps to avoid
    confusion.)
-   After making the JACK connections as described below, arm "Audio 1"
    for recording and make any level adjustments in Ardour, using the
    "Audio 1" meter.

JACK connections

    +-----------------------+                   +-------------------+
    |       OUTPUTS         |                   |      INPUTS       |
    |-----------------------|                   |-------------------|
    | Ardour                |                   | Ardour            |
    |  Audio 1/out 1        +---+   +-----------+  Audio 1/in 1     |
    |  Audio 1/out 2        +-+ +---|-----------+  master/in 1      |
    |  ...                  | +-----|-----------+  master/in 2      |
    |  ...                  |       |           |                   |
    |  master/out 1         +-------|-----+     | System            |
    |  master/out 2         +-------|---+ +-----+   playback_1      |
    |                       |       |   +-------+   playback_2      |
    | System                |       |       +---+   playback_3      |
    |   capture_1           +-------+-------+   |   ...             |
    |   capture_2           |                   |                   |
    |   ...                 |                   |                   |
    +-----------------------+                   +-------------------+

Note:"capture_1" is connected to both "Ardour:Audio 1/in 1" and
"System:playback_3."

See also
--------

envy24control is loosely based on the UI and functionality provided by
the Windows/Mac Delta Control Panel software that ships with M-Audio
Delta series hardware. The documentation in the cards' user manual
loosely applies; be prepared to spend some time experimenting and
getting familiar with your card's capabilities and the software. Some
manuals for popular Delta series cards:

-   Delta 1010LT
-   Delta 44
-   Delta 66
-   Delta Audiophile 2496

Retrieved from
"https://wiki.archlinux.org/index.php?title=Envy24control&oldid=211282"

Category:

-   Audio/Video
