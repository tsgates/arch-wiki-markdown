Newschecker
===========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Newschecker.py
==============

This is a little script that I wrote to check the rss feeds of various
websites for updates, ect. It uses python's urllib, and can be somewhat
slow for somewebsites. The output is plain text; the script below
displays the dates that websites were last updated.

To use it, do the following:

1.  Edit the pre variable, adding your username. By default, the script
    will create a configureation file in ~/.newsrc. This can be changed
    to anywhere where you would like to save this file.
2.  Declare any feeds that you would like to check. This is accomplished
    by adding a dictionary following this template:

    Feed_Name = {"name":"Feed's Name", \
                 "feed":"URL of the feed's location", \
                 "n1":"", \
                 "n2":"", \
                 "update":0}

Don't edit the last three entries.

1.  Add your feed to the sites list
2.  This is the tricky part, since rss feeds are not standardized across
    all websites, you need to add a new function for processing your
    feed. I won't go into details how to do that here, however, good
    tutorials can be found here and here. You will also need to add a
    call for the function inside of the check() function.
3.  The print_filler() function can be edited to customize what is
    displayed if a feed has not been updated.
4.  Whenever you add a new feed, you must delete the old newsrc file.

I personally use this program in conjunction with conky, having it
executed with a command like this:

    ${execi 1800 python /path/to/newscheck.py}

This function will find the current version of a sourceforge project:

    def process_sourceforge(urlxml):
            reflist = urlxml.getElementsByTagName("item")
            sites[2]["n2"] = reflist[0].childNodes[1].childNodes[0].nodeValue[a:b]

where a is the number of letters in the project's name plus 1 and the
difference between a and b is the number of digits in the projects
version number (including any periods, hyphens, etc).

This function will return the last time a sourceforge project was
updated:

    def process_sourceforge(urlxml):
            reflist = urlxml.getElementsByTagName("item")
            sites[2]["n2"] = reflist[0].childNodes[11].childNodes[0].nodeValue

  

  

    #!/usr/bin/env python

    #   Copywrite 2006 Peter Garceau
    #   This program is free software; you can redistribute it and/or modify
    #   it under the terms of the GNU General Public License as published by
    #   the Free Software Foundation; either version 2 of the License, or
    #   (at your option) any later version.
    # 
    #   This program is distributed in the hope that it will be useful,
    #   but WITHOUT ANY WARRANTY; without even the implied warranty of
    #   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    #   GNU General Public License for more details.
    #  
    #   You should have received a copy of the GNU General Public License
    #   along with this program; if not, write to the Free Software
    #   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, 
    #   USA.
    #

    import os
    from xml.dom import minidom
    import xml.dom.ext
    import urllib

    #Defines the path to rc file
    pre = "/home/username"
    rc = os.path.join(pre,".newsrc")
        
    #Declair feeds here
    swiftfox = {"name":"Swiftfox", \
                   "feed":"http://rss.getswiftfox.com/rss.xml", \
                   "n1":"", \
                   "n2":"", \
                   "update":0}

    quodlibet = {"name":"Quodlibet", \
                   "feed":"http://www.sacredchao.net/quodlibet/timeline?daysback=90&max=50&milestone=on&format=rss", \
                   "n1":"", \
                   "n2":"", \
                   "update":0}

    #Add feeds to this list
    sites = [swiftfox, quodlibet]

    #Creates a new config file
    def makerc():
        doc = xml.dom.minidom.Document()
        root_element = doc.createElement("newsrc")
        doc.appendChild(root_element)
        for a in sites:
               site_element = doc.createElement("site")
               root_element.appendChild(site_element)
               site_element.setAttribute("name",a["name"])
               blank = doc.createTextNode("Initialized")
               site_element.appendChild(blank)
               xml.dom.ext.PrettyPrint(doc, open(rc, "w"))
        
    #Loads an rc file
    def load():
        doc = minidom.parse(rc)
        reflist = doc.getElementsByTagName('site')
        for a in sites:
               for b in reflist:
                       if a["name"] == b.getAttribute("name"):
                               a["n1"] = b.childNodes[0].nodeValue 

    #Checks the feed on the internet
    def check():
           for a in sites:
                   try:
                           urlget = urllib.urlopen(a["feed"])
                           urlxml = minidom.parse(urlget)
                           urlget.close()
                           if a["name"] == "Swiftfox":
                                   process_swiftfox(urlxml)
                           if a["name"] == "Quodlibet":
                                   process_quodlibet(urlxml)
                   except IOError:
                           print "Cannot Connect to Website"

    #Processes the swiftfox feed
    def process_swiftfox(urlxml):
           reflist = urlxml.getElementsByTagName("item")
           for a in reflist:
                   if a.childNodes[9].childNodes[0].nodeValue[:8] == "Swiftfox":
                           sites[0]["n2"] = a.childNodes[7].childNodes[0].nodeValue


    #Process the quodlibet feed
    def process_quodlibet(urlxml):
           reflist = urlxml.getElementsByTagName("item")
           sites[1]["n2"] = reflist[0].childNodes[3].childNodes[0].nodeValue


    #checks if feed has been updated
    def check_update():
           for a in sites:
                   if a["n1"] == a["n2"]:
                           a["update"] = 0
                   else:
                           a["update"] = 1

    #prints final output of program
    def final_print():
           doc = minidom.parse(rc)
           for a in sites:
                   if a["update"] == 1:
                           for b in doc.childNodes[0].childNodes:
                                   try:
                                           if b.getAttribute("name") == a["name"]:
                                                   b.childNodes[0].nodeValue = a["n2"]
                                   except AttributeError:
                                           pass
                           print " " + "NEW" + " " + a["name"] + " updated " + a["n2"] 
           xml.dom.ext.PrettyPrint(doc, open(rc, "w"))

    #prints filler at the end of the program, for formatting purposes
    def print_filler():
           for a in sites:
                   if a["update"] == 0:
                           print " " + a["name"] + " updated " + a["n1"]

    try:
           isitthere = open(rc)
           isitthere.close()
    except IOError:
           makerc()

    load()
    check()
    check_update()
    final_print()
    print_filler()

Retrieved from
"https://wiki.archlinux.org/index.php?title=Newschecker&oldid=198603"

Category:

-   Scripts
