Advanced Traffic Control
========================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Still unfinished! 
                           Need to add more qdiscs, 
                           more examples, fix       
                           orthography, etc.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary help replacing me

This article gives an introduction to traffic shaping and control by
using queueing disciplines.

> Related

After reading this, reading the "Linux Advanced Routing and Traffic
Control" article is highly recommended

One of the advanced and least known network features from the linux
kernel, is the ability to control and shape the traffic. While is common
for users know the basic use of iproute2 by using the ip command, is
very common to ignore other powerful features like the ones offered by
the tc command.

The goal of this article is to show how to shape the traffic by using
queueing disciplines. For instance, if you ever had to forbid downloads
or torrents on a network that you admin, and not because you were
against those services, but because users were "abusing" the bandwidth,
then you could use queueing disciplines to allow that kind of traffic
and, at the same time, be sure that one user can't slowdown the entire
network.

This is an advanced article; you are expected to have certain knowledge
of network devices, iptables, etc.

Contents
--------

-   1 Queueing
    -   1.1 Classless Qdiscs
        -   1.1.1 fifo_fast
        -   1.1.2 Token Bucket Filter (TBF)
        -   1.1.3 Stochastic Fairness Queueing (SFQ)
        -   1.1.4 CoDel and Fair Queueing CoDel
    -   1.2 Classful Qdiscs
        -   1.2.1 Hierarchical Token Bucket (HTB)
-   2 Filters
    -   2.1 Using tc only
    -   2.2 Using tc + iptables

Queueing
--------

Queuing controls how data is sent; we have no way to control how we
receive data. However, since TCP/IP packages are sent using a slow start
- that is, it starts sending the packages slow and keeps sending them
faster and faster, until packages start getting rejected - is therefore
possible to control how much traffic is received on a lan by dropping
packages that arrive at a router before they get forwarded.

That is, we need to set the queueing disciplines (qdiscs for short) on
the router to start dropping packages according to our rules on the
network device connected to the lan, NOT on the network device connected
to the internet.

And in order to be the ones controlling the shape of the traffic, we
need to be the slowest link of the chain; that is, if the connection has
a maximum download speed of 500k, is a good idea to set the limit of the
output to 450k. Otherwise, is going to be the modem shaping the traffic
instead of us.

Each network device has a root where a qdisc can be set. By default,
this root has a fifo_fast qdisc. (more info below)

There are two kind of diciplines: classful and classless.

Classful qdiscs allows you to create classes, which work like branches
on a tree. You can then set rules to filter packages to each class. Each
class can have assigned other classful or classless qdisc.

Classless qdiscs does not allows to add more qdiscs to it.

Before starting to configure qdiscs, first we need to remove any
existing qdisc from the root. This will remove any qdisc from the eth0
device:

    tc qdisc del dev eth0 root

> Classless Qdiscs

These are queues that do basic manage of traffic by reordering, slowing
or dropping packets. This qdiscs don't allow the creation of classes.

fifo_fast

This is the default qdisc. In every network device where no custom qdisc
configuration has been applied, fifo_fast is the qdisc set on the root.
fifo means First In First Out, that is, the first package to get in, is
going to be the first to be sent. This way, no package get special
treatment.

Token Bucket Filter (TBF)

This qdisc allows bytes to pass, as long certain rate limit is not
passed.

It works by creating a virtual bucket and then dropping tokens at
certain speed, filling that bucket. Each packages takes a virtual token
from the bucket, and use it to get permission to pass. If too many
packages arrive, the bucket will have no more tokens left and the
remaining packages are going to wait certain time for new tokens. If the
tokens don't arrive fast enough, the packages are going to be dropped.
On the opposite case (too little packages to be sent), the tokens can be
used to allow some burst (uploading pikes) to happen.

That means this qdisc is useful to slow down an interface.

Example:

Uploading can fill a modem's queue and as result, while you are
uploading a huge file, the interactivity is destroyed.

    tc qdisc add dev ppp0 root tbf rate 220kbit latency 50ms burst 1540         # The upload speed should be changed to your upload speed minus a small few percent (to be the slowest link of the chain)

This configuration sets a TBF for the ppp0 device, limiting the upload
speed to 220k, setting a latency of 50ms for a package before being
dropped, and a burst of 1540. It works by keeping the queueing on the
linux machine (where it can be shaped) instead of the modem.

Stochastic Fairness Queueing (SFQ)

This is a round-robin qdisc. Each conversation is set on a fifo queue,
and on each round, each conversation has the possibility to send data.
Thats why is called "Fairness" Is also called "Stochastic" because it
does not really creates a queue for each conversation, instead it uses a
hashing algorithm. For the hash, there is the chance for multiple
sessions on the same bucket. To solve this, SFQ changes its hashing
algorithm often to prevent that this becomes noticeable.

Example:

This configuration sets SFQ on the root on the eth0 device, configuring
it to perturb (alter) its hashing algorithm every 10 seconds.

    tc qdisc add dev eth0 root sfq perturb 10

CoDel and Fair Queueing CoDel

CoDel (Controlled Delay) is an attempt to limit buffer bloating and
minimize latency in saturated network links by distinguishing good
queues (that empty quickly) from bad queues that stay saturated and
slow. The fair queueing Codel utilizes fair queues to more readily
distribute available bandwidth between Codel flows. The configuration
options are limited intentionally, since the algorithm is designed to
work with dynamic networks, and there are some corner cases to consider
that are discussed on the bufferbloat wiki concerning Codel, including
issues on very large switches and sub megabit connections. Additional
information is available in:

     man tc-codel
     man tc-fq_codel

Warning:Make sure your ethernet driver supports Byte Queue Limits before
using CoDel. Here is a list of drivers supported as of kernel 3.6

> Classful Qdiscs

Classful qdiscs are very useful if you have different kinds of traffic
which should have differing treatment. A classful qdisc allows you to
have branches. The branches are called classes.

Setting a classful qdisc requires that you name each class. To name a
class, is used the classid parameter. The parent parameter, as the name
indicates, point to the parent of the class.

All the names should be set as x:y where x is the name of the root, and
y is the name of the class. Normally, root is called 1: and their
children are things like 1:10

Hierarchical Token Bucket (HTB)

HTB is well suited for setups where you have a fixed amount of bandwidth
which you want to divide for different purposes, giving each purpose a
guaranteed bandwidth, with the possibility of specifying how much
bandwidth can be borrowed. Here is an example with comments explaining
what does each line:

    # This line sets a HTB qdisc on the root of eth0, and it specifies that the class 1:30 is used by default. It sets the name of the root as 1:, for future references.
    tc qdisc add dev eth0 root handle 1: htb default 30

    # This creates a class called 1:1, which is direct descendant of root (the parent is 1:), this class gets assigned also an HTB qdisc, and then it sets a max rate of 6mbits, with a burst of 15k
    tc class add dev eth0 parent 1: classid 1:1 htb rate 6mbit burst 15k

    # The previous class has this branches:

    # Class 1:10, which has a rate of 5mbit
    tc class add dev eth0 parent 1:1 classid 1:10 htb rate 5mbit burst 15k

    # Class 1:20, which has a rate of 3mbit
    tc class add dev eth0 parent 1:1 classid 1:20 htb rate 3mbit ceil 6mbit burst 15k

    # Class 1:30, which has a rate of 1kbit. This one is the default class.
    tc class add dev eth0 parent 1:1 classid 1:30 htb rate 1kbit ceil 6mbit burst 15k

    # Martin Devera, author of HTB, then recommends SFQ for beneath these classes:
    tc qdisc add dev eth0 parent 1:10 handle 10: sfq perturb 10 
    tc qdisc add dev eth0 parent 1:20 handle 20: sfq perturb 10 
    tc qdisc add dev eth0 parent 1:30 handle 30: sfq perturb 10 

Filters
-------

Once a classful qdisc is set on root (which may contain classes with
more classful qdiscs), is necessary to use filters to indicate which
package should be processed by which class.

On a classless-only environment, filters are not necessary.

You can filter packages by using tc, or a combination of tc + iptables.

> Using tc only

Here is an example explaining a filter:

    # This command adds a filter to the qdisc 1: of dev eth0, set the priority of the filter to 1, matches packages with a destination port 22, and make the class 1:10 process the packages that match
    tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip dport 22 0xffff flowid 1:10

    # This filter is attached to the qdisc 1: of dev eth0, has a priority of 2, and matches the ip address 4.3.2.1 exactly, and matches packages with a source port of 80, then makes class 1:11 process the packages that match
    tc filter add dev eth0 parent 1: protocol ip prio 2 u32 match ip src 4.3.2.1/32 match ip sport 80 0xffff flowid 1:11

> Using tc + iptables

iptables has a method called fwmark, which can be used to add a mark to
packages, a mark that can survive routing across interfaces.

First, this makes packages marked with 6, to be processed by the 1:30
class

    tc filter add dev eth0 protocol ip parent 1: prio 1 handle 6 fw flowid 1:30 

This sets that mark 6, using iptables

    iptables -A PREROUTING -t mangle -i eth0 -j MARK --set-mark 6

You can then use the regular way of iptables to match packages and then
use fwmark to mark them.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Advanced_Traffic_Control&oldid=268497"

Category:

-   Networking

-   This page was last modified on 28 July 2013, at 04:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
