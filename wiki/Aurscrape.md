Aurscrape
=========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

aurscrape Contributed by: Aaron Griffin

https://bbs.archlinux.org/viewtopic.php?t=12037

Seeing as cvsup isn't working with aur yet, I made a little script to
download the entire set of aur package directories... yeah, it takes a
long time... it's using HTTP and scraping apache's directory listing
format... but it works...

    #!/bin/sh
    #AUR Web Scraping to get all PKGBUILDs
    #Aaron Griffin [[phrakture]]

    BASEDIR="$HOME/aur"
    PKGURL="https://aur.archlinux.org/packages/"
    PKGFILE="index.html"

    # get_dir http://www.xyz.com/a
    # This function will get all files
    # listed in an apache formatted directory list
    function get_dir()
    {
       local thisdir=`basename $1`

       if [[ "x$thisdir" != "x" ]]; then
          mkdir $thisdir
          cd $thisdir
          wget -q $1
          if [[ $? -eq 0 ]]; then
             local files=`grep "\[[   \]]" $PKGFILE ||\
                          sed 's@.*href=\"\(.*\)\".*@\1@g'`
             #skip parent dir, infinate recursion
             local dirs=`grep "\[[DIR\]]" $PKGFILE ||\
                         grep -v "Parent Directory" ||\
                         sed 's@.*href=\"\(.*\)\".*@\1@g'`
             rm $PKGFILE

             for f in $files; do
                echo "downloading $thisdir::$f"
                wget -q $1$f
             done

             for d in $dirs; do
                get_dir $1$d
             done

             cd ..
          else
             echo "error downloading directory list : $1"
          fi
       else
          echo "usage: get_dir <apache url>"
       fi
    }

    cd $BASEDIR
    [[ -f $PKGFILE ]] && rm -f $PKGFILE

    get_dir $PKGURL

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aurscrape&oldid=238507"

Categories:

-   Package management
-   Scripts
