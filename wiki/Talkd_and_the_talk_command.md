Talkd and the talk command
==========================

The "talk" command allows you to talk to other users on the same system,
which is useful if you're both SSH'd in from somewhere. Using it is very
simple; to talk to someone the command is just

    talk <username> <tty>

However, getting it working requires some setup.

1. First, install the inetutils package, which contains talk and talkd.
These also rely on xinetd, so install that as well. You might also need
the screen command; it's in the screen package.

    pacman -S inetutils xinetd screen

2. Configure the xinetd service entry by setting "disable = no" in
/etc/xinetd.d/talk.

3. If you are using tcp_wrappers or something similar, Add an allow
entry like this:

    talkd: 127.0.0.1

4. Now start xinetd:

    systemctl start xinetd.service

5. If you're on the local system, you might need to start a screen
session to make yourself show up on the "w" and "who" commands -- you
need to show up there or talk won't work.

6. Allow write access in your terminal:

    mesg y

Talk should work now.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Talkd_and_the_talk_command&oldid=242382"

Category:

-   System administration
