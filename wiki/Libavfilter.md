Libavfilter
===========

Installing libavfilter with ffmpeg
----------------------------------

The ffmpeg in the current repositories comes without most filters, such
as overlay and movie. Those are needed if you want to watermark videos
or add a logo to a video. To enable them, you'll have to install ffmpeg
from SVN and configure it with --enable-filter=movie
--enable-avfilter-lavf

1. Install libavfilter from SVN

     svn co svn://svn.ffmpeg.org/soc/libavfilter
     ./checkout.sh

2. Configure and make:

     cd ffmpeg
     ./configure --enable-filter=movie --enable-avfilter
     make

If you want to add the most commonly used formats to your ffmpeg binary,
your ./configure line may look something like this:

     ./configure --enable-filter=movie --enable-avfilter --enable-libmp3lame \
     --enable-libtheora --enable-libvorbis --enable-libx264 \
     --enable-libxvid --enable-gpl

The new ffmpeg binary will in the the 'ffmpeg' folder.

Example for watermarking a video with ffmpeg:

     ./ffmpeg -i video.avi -vf "movie=0:png:logo.png [wm];[in][wm] overlay=X:Y:1 [out]" out.avi

You'll have to replace X and Y with the actual offset in the video,
where you would like your logo or watermark to be positioned.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Libavfilter&oldid=197884"

Category:

-   Audio/Video
