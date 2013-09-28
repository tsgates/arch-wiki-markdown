ID3 Tag Problems
================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Description of the Problem                                         |
| -   2 Solution                                                           |
|     -   2.1 Scripted Solution                                            |
|     -   2.2 Alternative (Fake) Solution                                  |
+--------------------------------------------------------------------------+

Description of the Problem
==========================

MP3 ID3 tags have gone through several versions. The most recent one is
ID3v2.4. gStreamer (0.10) supports the newest tag version, but if a file
also has older tags included, gStreamer will have trouble deciding which
to use. In particular, some older tag versions were written at the end
of the file while the newer ones are created at the beginning. This
causes applications such as Rhythmbox or Banshee that use gStreamer to
have trouble displaying the "correct" tags. In fact, some tag editing
software will simply overwrite one of the tags, leaving the others to
keep causing havoc on your nicely organized music collection. For more
information about the problem, see
http://www.savvyadmin.com/rhythmbox-id3-tag-issues/.

Solution
========

YOU MIGHT LOSE ALL YOUR TAG INFO. PROCEED WITH CAUTION!

You might want to see if editing your files with an ID3v2.4 tag editor
(exfalco (as part of quodlibet), tagtool, easytag) will simply work. If
it doesn't, be ready to get your hands dirty.

> Scripted Solution

The program eyeD3 (python-eyed3 in extra) can manipulate tags through
the command line. We will be using it. The process goes like this:

-   Use a program to rename your files into a form that you'll be able
    to reload into the tags later (e.g., Genre/Artist/Year - Album/Track
    - Title.mp3). This can be done through any tag editor mentioned
    above.
-   Convert tags to ID3v2.4 (through eyeD3):

     find music-dir/ -iname "*.mp3" -exec eyeD3 --to-v2.4 {} \;

-   Check to see if your problem is solved (by running Rhythmbox, for
    example). If so, you are done.
-   Strip the tag info (through eyeD3) using the following script:

    #!/usr/bin/env python

    # truncates a file after a TAG pattern is found
    # use at your own risk!
    #
    # for a bunch of files, you may want to:
    # find somewhere/ -iname "*.mp3" -exec tag-wipe.py {} \;
    #
    # ulysses - ulysses@naosei.net

    import sys

    def main ():
    	name = sys.argv[1]
    	input = file(name, "r+")

    	offset = -1024
    	input.seek(offset, 2)
    	pos = input.tell()
    	
    	while True:
    		tag = input.read(3)
    		if tag == "TAG":
    			print(name + ": found the damn tag - truncating at 0x%08x") % pos
    			input.truncate(pos)

    			input.close()
    			sys.exit()
    		elif offset >= -2:
    			print(name + ": no damn tag found")
    			input.close()
    			sys.exit()
    		else:
    			offset += 1
    			input.seek(offset, 2)
    	
    if __name__ == "__main__":
    	main()

Don't forget to run it:

    find music-dir/ -iname "*.mp3" -exec tag-wipe.py {} \;

-   Retag your files from the filenames.

The script above was taken from
http://ubuntuforums.org/showpost.php?p=2108913&postcount=11.

> Alternative (Fake) Solution

Start using OGG Vorbis. Not really a solution, but a nice alternative.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ID3_Tag_Problems&oldid=197880"

Category:

-   Audio/Video
