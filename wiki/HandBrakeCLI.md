HandBrakeCLI
============

  Summary
  -----------------------------------------------------------------------------------------------------------------
  This article attempts to walk users through the installation and basic usage and configuration of HandBrakeCLI.

HandBrakeCLI is command-line driven interface to a collection of
built-in libraries which enables the decoding, encoding and conversion
of audio and video streams to MP4 (M4V) and MKV container formats with
an emphasis on H.264/MPEG-4 AVC encoding through x264.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package installation                                               |
| -   2 Encoding examples                                                  |
|     -   2.1 Single-pass x264 (very high-quality)                         |
|     -   2.2 Two-pass x264 (very high-quality)                            |
|                                                                          |
| -   3 Adding subtitles                                                   |
+--------------------------------------------------------------------------+

Package installation
--------------------

Install handbrake-cli from the Official Repositories.

Encoding examples
-----------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Single-pass and  
                           Two-pass sections are    
                           the same? (Discuss)      
  ------------------------ ------------------------ ------------------------

> Single-pass x264 (very high-quality)

    HandBrakeCLI -i X-Men.First.Class.2011.vob -o X-Men.First.Class.2011.mkv -E lame -B 160k -6 stereo -R 48000 -e x264 -x b_adapt=2:bframes=8:direct=auto:fast_pskip=0:deblock=-1,-1:psy-rd=1,0.15:me=umh:me_range=24:partitions=all:ref=16:subq=10:trellis=2:rc_lookahead=60:frameref=15:threads=auto -s1 -S 2250 -2 -v2

> Two-pass x264 (very high-quality)

    HandBrakeCLI -i X-Men.First.Class.2011.vob -o X-Men.First.Class.2011.mkv -E lame -B 160k -6 stereo -R 48000 -e x264 -x b_adapt=2:bframes=8:direct=auto:fast_pskip=0:deblock=-1,-1:psy-rd=1,0.15:me=umh:me_range=24:partitions=all:ref=16:subq=10:trellis=2:rc_lookahead=60:frameref=15:threads=auto -s1 -S 2250 -2 -v2

ULTRAFAST TESTING

    HandBrakeCLI -i Hostel.II.vob -o Hostel.II.mkv -E lame -B 128k -6 dpl2 -R 48000 -e x264 -x ref=1:bframes=0:cabac=0:8x8dct=0:weightp=0:me=dia:subq=0:rc-lookahead=0:mbtree=0:analyse=none:trellis=0:aq-mode=0:scenecut=0:no-deblock=1:threads=auto -s1 -S 750 -v

Adding subtitles
----------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: TODO. (Discuss)  
  ------------------------ ------------------------ ------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=HandBrakeCLI&oldid=207123"

Category:

-   Audio/Video
