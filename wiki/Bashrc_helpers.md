Bashrc helpers
==============

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Core        
                           Utilities.               
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

inspired by the note taker, little todo script

    todo() {
       test -f $HOME/.todo || touch $HOME/.todo
       if test $# = 0
       then 
               cat $HOME/.todo
       elif test $1 = -l
       then
               cat -n $HOME/.todo
       elif test $1 = -c
       then
               > $HOME/.todo
       elif test $1 = -r
       then
               cat -n $HOME/.todo
               echo -ne "----------------------------\nType a number to remove: "
               read NUMBER
               sed -ie ${NUMBER}d $HOME/.todo
       else
               echo $@ >> $HOME/.todo
       fi
    }

  
 a little note taker

    note ()
    {
           #if file doesn't exist, create it
           [ -f $HOME/.notes ] || touch $HOME/.notes
           #no arguments, print file
           if [ $# = 0 ]
           then
                   cat $HOME/.notes
           #clear file
           elif [ $1 = -c ]
           then
                   > $HOME/.notes
           #add all arguments to file
           else
                   echo "$@" >> $HOME/.notes
           fi
    }

  
 extracting function, alternatively you can use atool (in
community-repo)

    extract() {
     local e=0 i c
     for i; do
       if [ -f $i && -r $i ]; then
           c=
           case $i in
             *.tar.bz2) c='tar xjf'    ;;
             *.tar.gz)  c='tar xzf'    ;;
             *.bz2)     c='bunzip2'    ;;
             *.gz)      c='gunzip'     ;;
             *.tar)     c='tar xf'     ;;
             *.tbz2)    c='tar xjf'    ;;
             *.tgz)     c='tar xzf'    ;;
             *.7z)      c='7z x'       ;;
             *.Z)       c='uncompress' ;;
             *.exe)     c='cabextract' ;;
             *.rar)     c='unrar x'    ;;
             *.xz)      c='unxz'       ;;
             *.zip)     c='unzip'      ;;
             *)     echo "$0: cannot extract \`$i': Unrecognized file extension" >&2; e=1 ;;
           esac
           [ $c ] && command $c "$i"
       else
           echo "$0: cannot extract \`$i': File is unreadable" >&2; e=2
       fi
     done
     return $e
    }

  

    docview ()
    {
      if [ -f $1 ] ; then
          case $1 in
              *.pdf)       xpdf $1    ;;
              *.ps)        oowriter $1    ;;
              *.odt)       oowriter $1     ;;
              *.txt)       leafpad $1       ;;
              *.doc)       oowriter $1      ;;
              *)           echo "don't know how to extract '$1'..." ;;
          esac
      else
          echo "'$1' is not a valid file!"
      fi
    }

  
 calculator

    calc() { echo "scale=3;$@" | bc -l ; }

  

Kingbash - menu driven auto-completion (see
https://bbs.archlinux.org/viewtopic.php?id=101010)

install kingbash from aur then insert following in your .bashrc

    function kingbash.fn() {
      echo -n "KingBash> $READLINE_LINE" #Where "KingBash> " looks best if it resembles your PS1, at least in length.
      OUTPUT=`/usr/bin/kingbash "$(compgen -ab -A function)"`
      READLINE_POINT=`echo "$OUTPUT" | tail -n 1`
      READLINE_LINE=`echo "$OUTPUT" | head -n -1`
      echo -ne "\r\e[2K"; }
    bind -x '"\t":kingbash.fn'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bashrc_helpers&oldid=206867"

Category:

-   Dotfiles
