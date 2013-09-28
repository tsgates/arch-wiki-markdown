ArchHosting
===========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This a scratchpad for ideas on setting up a Arch Linux based weblog host.
-------------------------------------------------------------------------

Rationale:

-   To provide (cheap) shell accounts, email services, etc for Arch
    Linux users who wish to host their weblogs/personal websites on
    their preferred server OS (Arch Linux, not Debian or Redhat).

Options: There are two possibities that come to mind which are feasable.

1.  Find someone who is willing to colocate an Arch Box for us.
2.  Buy Ram/HD Space from a VM/Xen provider like
    http://rimuhosting.com/order/startorder.jsp

Discussion:

-   Costs of setting up service and paying per month would be via a
    money-pooling arrangement. Perhaps we can setup an adsense account +
    paypal box to help defray costs. I personally am not interested in
    setting up a non-profit biz (xterminus), and I figure if we can find
    a few more interested people who would be interested in cooperating
    in such a venture, we ought to be able to setup a VERY cheap hosting
    solution for ourselves. - xterminus (Sat Apr 15 17:41:34 PDT 2006)

-   RimU Hosting's cheapest plan is around 20 bucks a month, which
    really doesn't provide enough ram for apache + mysql to run well. I
    suggest a plan providing at least 160 megs of ram. ($40 a month). If
    we can find 6 more people, that would make each user's cost about $5
    us a month for hosting.

At this price though, we might be able to simply buy a cheap colo
solution though. - xterminus (Sat Apr 15 17:41:34 PDT 2006)

-   Perhaps there in an OSS organization that can is already established
    as a non-profit org which can help handle the money or even host a
    box? It would be nice to get a 'corporate' sponsor too though  :) -
    xterminus (Sat Apr 15 17:41:34 PDT 2006)

-   Do we want a 'common' dns name? Maybe users.archlinux.org or
    archusers.org? I'm going to assume everybody allready owns a domain
    name for now - xterminus (Sat Apr 15 17:41:34 PDT 2006)
    -   I guess it might be nice to have a front page to add links to
        everyone... maybe. planet.archlinux.org seems like it would be
        the ideal place for all the blogs to be linked together. Codemac
        21:05, 15 April 2006 (EDT)

-   Isnt it cheaper to go with a Virtual server. I found a offer link
    here which would be cheaper and guarantee 256MB ram...--Danst0
    03:45, 21 June 2006 (EDT)

-   I can offer dservers with the following specs:

     CPU: Celeron D 2.4Ghz
     RAM: 512MB DDR 333Mhz
     HDD: 80GB
     NET: 100Mbit/s
     TRAFFIC: 4TB/mo free traffic (TB as in 1024*1024*1024*1024 bytes :) )
     IPS: one per default, up to 4
     OS: Arch

these go for like 45EUR/mo (includes a tiny fee for my time). kth5

-   There is also Slicehost. 256mg ram, 10gb hd, 100gb bandwidth, for
    $20/month. Been thinking of getting one for myself actually. Sjoden
    21:11, 19 April 2008 (EDT)
    -   I've been using Slicehost for some time with Arch Linux. Works
        fine with 256 MB RAM, with a single exception. Compiling large
        programs on-line can bog down. Of course, you can compile
        off-line. I do find that I get constant SSH attacks, but I
        solved that using the knock daemon documented elsewhere on this
        wiki. Rod Price 26 Oct 2009.

-   Slicehost got taken over by Rackspace recently. I checked their site
    a few days ago and could not find any simple VPS plans anymore - it
    seems they're trying to push people to their 'cloud' stuff. Whatever
    Slicehost's present plans may be, Linode has cheaper plans, their
    entry level plan being Linode 512, with the following specs:
    -   512 MB RAM
    -   20 GB storage
    -   200 GB bandwidth
    -   19,95 USD a month

Linode has excellent service and a correct billing policy.

-   Besides Linode, there's also Tilaa, an even cheaper Dutch VPS
    provider. Their cheapest plan provides the following:
    -   2 CPU cores at your disposal
    -   512 MB RAM
    -   20 GB storage
    -   250 GB traffic
    -   10,95 EUR a month (VAT excluded)

I have no experience with Tilaa myself though. .:B:. 30 Nov 2011.

  
 Issues:

-   Root Access:

I suggest disabling the root user's account and giving out sudo access
to those paying + comfortable doing admin tasks. This way we have a log
of who's doing what with the root account. - xterminus (Sat Apr 15
17:41:34 PDT 2006)

-   -   Yea, there is no need for an actual root user, as long as
        /etc/sudoers exists. Codemac 21:07, 15 April 2006 (EDT)

-   Services:

Apache + MySQL obviously. Keeping memory use low should be a priority.
That said, maybe we can provide generic shells for irc users for cheaper
or for a one-time fee?

-   -   Maybe lighttpd instead of Apache? Codemac 03:02, 17 April 2006
        (EDT)
    -   Ruby as well Codemac 03:02, 17 April 2006 (EDT)
    -   Might be a good idea to have Nginx running on port 80 and
        proxying traffix to Apache running on localhost:8080 - this way
        we can use Nginx to serve static files and just proxy to Apache
        for the more complex websites. (I assume there will likely be
        lots of static content). silverbucket 14:02, 31 August 2012
        (CET)

Other Ideas:

-   Asterisk server for real-time voip conferences?
    -   I second this. WillySilly

-   Jabber Gateway?
    -   I second this. Codemac 21:09, 15 April 2006 (EDT)

-   Email of course.
    -   Webmail too?
        -   I wouldn't suggest to have a mailservice on such a thing.
            Too much traffic due to spam and so expensive, network and
            ressource wise. kth5

-   I don't know where things are with this now, but maybe it makes
    sense talking to HCoop guys about this idea in general and
    colocation in particular? foxcub

-   Im down for this, maybe I can help (I have a webhosting business
    using a reseller hosting package, maybe we can get some services
    unloaded onto my servers, I am also down for being the "corporate
    sponsor" you were talking about. I can also contribute with some
    maintenance fees. I would like someone to contact me and explain
    whats the plan at the moment, Arch has given me lots of stuff an I
    would like to give something back. Maybe we can open a forum thread
    for this instead of discussing things here? 655321

Todo:

1.  Finish Brainstorming.
2.  Establish a timeline to get it all running
3.  Establish who is in charge of what, where money goes.
4.  Come up with a TOS, do ppl need to sign it or is a click thru okay?

FORUM thread continuing this topic is here: Arch Hosting Project

Interested Parties:

Xterminus

Codemac

WillySilly

Ality

droog

GSF

kth5

rxvt

zoglesby

moire

Sjoden

Joetotale

655321

silverbucket

Retrieved from
"https://wiki.archlinux.org/index.php?title=ArchHosting&oldid=220746"

Category:

-   Arch development
