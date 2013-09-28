Poclbm
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Need to change    
                           style according to       
                           Help:Style and           
                           Help:Editing. (Discuss)  
  ------------------------ ------------------------ ------------------------

Poclbm (Python OpenCL Bitcoin miner) is a python program/script made by
m0mchil on Github (https://github.com/m0mchil/poclbm), it mines Bitcoins
using an OpenCL capable device. Here's how to install and use it as a
systemd service.

(i'm sorry for the inconvenience but i have absolutely no experience
using a wiki CMS, so this tutorial is gonna be in plain text format,
without all the text formatting options provided by the wiki software)

1. Facts and stuff

Mining Bitcoins is when you use your computer to generate "blocks" which
are used to verify transactions in the Bitcoin network, currently a
generated block will give you 50 BTC, however it will drop to 25 BTC by
the end of November 2012... as more blocks get generated, difficulty
increases, and today (as of November 2012) the estimated time to
generate a block on an average gaming computer is over 2 years, so it's
not really worth the electricity you'll "waste" trying to generate a
block... also note that it's random and sometimes you may get lucky and
still (despite the difficulty and stuff) generate a block using your
standard gaming computer, however it's very unlikely and not worth the
risk of waiting months (while your computer is using lots of
electricity), you'll probably end up stopping it and paying your
enormous electricity bill without having generated anything... but
there's a solution to that : pool mining.

A pool is a network of computers mining together to generate a block,
and the total reward is shared between all the people that contributed
to generate the block, so when using a pool you'll get smaller but
regular incomes and using the appropriate hardware (see below) it may be
actually a profitable business.

When mining, the CPU isn't ideal and even a low-end graphics card will
beat your high-end CPU so we're only using the GPU for mining, so with a
correct configuration the machine used for mining can be used for
something else, for example a web server, and if you're only mining then
you may want to use a low-end single-core CPU and a low-end motherboard,
and RAM isn't used either so 2GB of RAM is more than enough.

NVIDIA cards aren't ideal for mining and you'll waste more money (on
electricity) than you'll generate, even when using a pool, so unless you
do it for experimentation/fun, or if you use your computer as a heat
source (i use mine in my bedroom and it's producing more heat than my
usual electric heater) it's not worth it.

ATI/AMD cards are the best choice for this, they have a lower price and
use less electricity while having extreme performance (for mining)
compared to NVIDIA cards (a single ATI card is more powerful than my 3x
NVIDIA GTX580), so if you're doing this for profit you need ATI cards.

Also, there is a bug on some drivers (both ATI and NVIDIA) that makes
the miner use 100% CPU on 2 cores (even if mining on the GPU), i'm not
sure what causes that but it seems to also affect Windows systems so
you'll have to try it yourself.

2. Required stuff

-   An OpenGL capable device with the correct drivers installed
    (proprietary driver required unfortunately)
-   Packages "python2", "python2-pyopencl", "python2-pyserial" and "git"
    available in the official repositories.
-   For the "run as a service part" you'll need a full-systemd
    installation.

3. Installation Log in as root, cd to / and execute this command :

git clone git://github.com/m0mchil/poclbm.git

this will make a folder called "poclbm" and download the latest version
in it.

4. Testing and running manually

to run it manually, log in as root (or any user having the rights to
read/write in /poclbm), cd in /poclbm like so :

cd /poclbm

and execute the miner (you'll need your pool login and password for
this) like so :

python2 poclbm.py username:password@server:port

that will start the miner on all OpenCL devices, if it exits and prints
an error "No OpenCL devices found" that means your OpenCL configuration
is wrong and you're probably missing a package/driver, if everything
goes well it should start mining and display a hash rate (x MH/s), you
can do Ctrl+C to exit. If you just want to run the miner manually then
that's all you need to do, when you want to mine just cd into /poclbm
with the right user and execute the command above, and Ctrl+C once you
want to stop.

5. Running as a systemd service

Create the service file "/usr/lib/systemd/system/poclbm.service" using
your favorite text editor with the following contents :

[Unit] Description=Python OpenCL Bitcoin miner After=network.target

[Service] ExecStart=/poclbm/start.sh Type=simple

[Install] WantedBy=multi-user.target

  
 finally create the "/poclbm/start.sh" and adapt the python command
using your login/password from your pool, the --verbose parameter is
important :

1.  !/bin/sh

cd /poclbm python2 poclbm.py user.password@server:port --verbose

finally make the file executable like so :

chmod +x /poclbm/start.sh

and start the service : systemctl start poclbm.service

you can stop the service with : systemctl stop poclbm.service

you can see the status of the service (the performance, etc...) with :
systemctl status poclbm.service

you can also register the service to auto-start with the system (if your
maching is dedicated to mining) with : systemctl enable poclbm.service

and disable the auto-start with : systemctl disable poclbm.service

Retrieved from
"https://wiki.archlinux.org/index.php?title=Poclbm&oldid=234187"

Category:

-   Applications
