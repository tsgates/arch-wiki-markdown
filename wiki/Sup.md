Sup
===

  Summary help replacing me
  ------------------------------------------------------------------------------
  An overview of the text-based mail client known for tagging and fast search.

Sup is a powerful new mail client developed for people who manage lots
of mail. It can be viewed as a cross between Mutt and Gmail, with very
fast operation and search, tagging, automatic contact management,
support for a wide variety of accounts at once, and more.

Contents
--------

-   1 Installation
-   2 Configuring Sup
-   3 Using Sup
-   4 Backing-up and Restoring Sup
-   5 List of Keybindings
    -   5.1 Keybindings from inbox-mode
    -   5.2 Keybindings from thread-index-mode
    -   5.3 Keybindings from thread-view-mode
    -   5.4 Keybindings from contact-list-mode
    -   5.5 Keybindings from line-cursor-mode
    -   5.6 Keybindings from scroll-mode
    -   5.7 Global keybindings
-   6 Crashing with: Illegal instruction (core dumped)
-   7 More Information

Installation
------------

Install sup-git from the AUR. Although the developers suggest that you
install Sup via

       gem install sup

As you get the latest version directly from the developers.

Configuring Sup
---------------

Sup comes with an easy to use configuration tool called sup-config. To
use it, start it in the console and walk through the steps, which are as
follows:

1.  Enter your full name.
2.  Enter your primary e-mail address, as well as any alternate e-mail
    addresses.
3.  Enter the path to your signature file, if you have one.
4.  Enter the editor that should be used to compose new mail, as well as
    any arguments that should be passed to it.
5.  Add sources for your mail, including:
    1.  mbox files
    2.  maildir directories

Support for remote sources (POP3, IMAP, IMAPS, and mbox+ssh) was removed
in the 0.12 release.

Sup is for the most part only an MUA (mail user agent) and cannot handle
downloading mail on its own. You can use tools like offlineimap,
fetchmail, and rsync to transfer email to the local system mbox or
maildir folders.

The sup wiki has an example for configuring a gmail+imap source using
offlineimap. The Mutt#POP3 subsection shows some additional mail
transfer methods.

After the email sources have been added, sup-config will execute the
sup-sync command to import mail into your mailbox.

Using Sup
---------

Execute the sup command to start the Sup mail client. The program should
show the messages imported by sup-config.

The most important key for new users to remember is the "?" key. This
will display a full list of keyboard commands at any point, reminding
new users how to navigate the program.

To navigate between threads, use the arrow keys or the "j" and "k" keys
("J" and "K" work like the Page Up and Page Down keys). To jump between
threads with new messages, press the Tab key. Sup doesn't load all
threads by default; press "M" to load more (more messages will
automatically load to fill the window).

To view a thread, select it and press the Enter key. To expand or
collapse an individual message while viewing a thread, select the
message and press the Enter key. Press "N" to expand only new messages
(the default view) or "E" to toggle the state of all messages. Press "o"
to show or hide hidden parts of a message (such as signatures).

To navigate between messages in a thread, press the "n" and "p" keys. To
display the headers on a message, press the "h" key.

To cycle through buffers, press the "b" key, or press the ";" key to
view a list of all of the open buffers. To kill a buffer, press the "x"
key.

To archive a thread, press the "a" key. This will hide it from the inbox
until someone replies to it, at which point it will reappear. To kill a
thread, press the "&" key. This is equivalent to Gmail's "mute"
function, which hides a message even if people reply to it. It will
never re-appear in the inbox, but it will still show up in search
results.

To star a thread, press the "*" key. To mark a thread as spam, press the
"S" key. Sup doesn't have any built-in spam filter; for that, consider a
program such as spamassassin.

To tag a thread, press the "t" key. To label the messages in a thread,
press the "l" key. To search labels, press the "L" key. Enter a label
for which to search or press the Enter key to call up a list of labels.
To perform a full text search, press the "\" key.

To view a list of contacts, press the "C" key. To e-mail one of the
people on the list, select his or her name and press the Enter key.

Backing-up and Restoring Sup
----------------------------

Backing-up e-mail is very important. To ensure that you do not lose
anything, first back up the sources, such as mbox files and maildir
directories, then run:

    $ sup-dump > filename

This will back-up all message states in a text file. To restore your
message states from this text file, simply run:

    $ sup-sync [<source>+] --restored --restore filename

Just remember that the commands above only back-up and restore message
states. The messages themselves will need to be backed-up separately.

List of Keybindings
-------------------

Keybindings from inbox-mode

    a : Archive thread (remove from inbox)
    A : Archive thread (remove from inbox) and mark read

Keybindings from thread-index-mode

       M : Load 20 more threads
      !! : Load all threads (may list a _lot_ of threads)
      ^G : Cancel current search
       @ : Refresh view         
       * : Star or unstar all messages in thread
       N : Toggle new/read status of all messages in thread
       l : Edit or add labels for a thread          
       e : Edit message (drafts only)     
       S : Mark/unmark thread as spam
       d : Delete/undelete thread    
       & : Kill thread (never to be seen in inbox again)
       $ : Save changes now                          
     tab : Jump to next new thread
       r : Reply to latest message in a thread
       f : Forward latest message in a thread 
       t : Tag/untag selected thread
       T : Tag/untag all threads
       g : Tag matching threads
    +, = : Apply next command to all tagged threads
       # : Force tagged threads to be joined into the same thread
       u : Undo the previous action

Keybindings from thread-view-mode

          h : Toggle detailed header
          H : Show full message header
          V : Show full message (raw form)
    <enter> : Expand/collapse or activate item
          E : Expand/collapse all messages
          e : Edit draft
          y : Send draft
          l : Edit or add labels for a thread
          o : Expand/collapse all quotes in a message
          n : Jump to next open message
          p : Jump to previous open message
          z : Align current message in buffer
          * : Star or unstar message
          N : Toggle unread/read status of message
          r : Reply to a message
          f : Forward a message or attachment
          i : Edit alias/nickname for a person
          D : Edit message as new
          s : Save message/attachment to disk
          S : Search for messages from particular people
          m : Compose message to person
          ( : Subscribe to/unsubscribe from mailing list
          ) : Subscribe to/unsubscribe from mailing list
          | : Pipe message or attachment to a shell command
         .a : Archive this thread and kill buffer
         .d : Delete this thread and kill buffer
         .s : Mark this thread as spam and kill buffer
         .N : Mark this thread as unread and kill buffer
         ,a : Archive this thread, kill buffer, and view next
         ,d : Delete this thread, kill buffer, and view next
         ,s : Mark this thread as spam, kill buffer, and view next
         ,N : Mark this thread as unread, kill buffer, and view next
         ,n : Kill buffer, and view next
         ]a : Archive this thread, kill buffer, and view previous
         ]d : Delete this thread, kill buffer, and view previous
         ]s : Mark this thread as spam, kill buffer, and view previous
         ]N : Mark this thread as unread, kill buffer, and view previous
         ]n : Kill buffer, and view previous

Keybindings from contact-list-mode

       M : Load 10 more contacts
       D : Drop contact list and reload
    a, i : Edit alias/or name for contact
       t : Tag/untag current line
       + : Apply next command to all tagged items
       S : Search for messages from particular people

Keybindings from line-cursor-mode

    <down arrow>, j : Move cursor down one line
      <up arrow>, k : Move cursor up one line
            <enter> : Select this item

Keybindings from scroll-mode

                            J, ^E : Down one line
                            K, ^Y : Up one line
                  <left arrow>, h : Left one column
                    <right arrow> : Right one column
         <page down>, <space>, ^F : Down one page
    <page up>, p, <backspace>, ^B : Up one page
                               ^D : Down one half page
                               ^U : Up one half page
                     <home>, ^, 1 : Jump to top
                         <end>, 0 : Jump to bottom
                                [ : Jump to the left
                                / : Search in current buffer
                                n : Jump to next search occurrence in buffer

Global keybindings

       q : Quit Sup, but ask first
       Q : Quit Sup immediately
       ? : Show help
       b : Switch to next buffer
       B : Switch to previous buffer
       x : Kill the current buffer
       ; : List all buffers
       C : List contacts
      ^L : Redraw screen
    \, F : Search all messages
       U : Show all unread messages
       L : List labels
       P : Poll for new messages
    m, c : Compose new message
      ^G : Do nothing
       R : Edit most recent draft message

Crashing with: Illegal instruction (core dumped)
------------------------------------------------

sup uses a search engine called Xapian which is being compiled to use
SSE2 instructions. If your CPU does not support SSE2 instructions you
will encounter the error message:

       Illegal instruction (core dumped)

To solve this you have to compile Xapian with the flag --disable-sse.

1. Looking at the PKGBUILD for ruby-xapian-ruby you can see that it
downloads a gem from https://rubygems.org/gems/xapian-ruby. Download the
gem.

2. run these commands

       gem unpack xapian-ruby.gem
       gem unpack --spec xapian-ruby.gem
       mv xapian-ruby.gemspec xapian-ruby/
       cd xapian-ruby

3. You are suppose to edit the Rakefile. Your goal is to change the 2
lines where it runs the config changes. All you have to do is to append
--disable-sse to the end of those configuration commands:

       system! "./configure --prefix=#{prefix} --exec-prefix=#{prefix} --disable-sse"
       system! "./configure --prefix=#{prefix} --exec-prefix=#{prefix} --with-ruby --disable-sse"

And save those changes.

4. run

       gem build xapian-ruby.gemspec
       gem install --local xapian-ruby.gem

This should solve the problem with Xapian not running on old CPUs. It
should also be mentioned that if it is your first time you run
sup-config and you have done everything correctly but still end up wih
the error message

       This Sup version expects a v4 index, but you have an existing v0 index. Please run sup-dump to save your labels, move /home/user/.sup/xapian out of the way, and run sup-sync --restore. (RuntimeError)
       Rats, that failed. You may have to do it manually.

it is possible that you also have this issue, try to run the other
executables such as sup or sup-dump to see if you get the Illegal
instruction (core dumped) error message.

  

More Information
----------------

Sup has a website with a README, a new user guide, a FAQ, and a
philosophical statement, as well as a wiki.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sup&oldid=305391"

Category:

-   Email Client

-   This page was last modified on 18 March 2014, at 00:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
