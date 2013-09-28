Driver Testing
==============

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
                           Reason: This project is  
                           not active for a long    
                           time. And it is really a 
                           good thing. The dark     
                           Ages of Linux driver is  
                           gone. (Discuss)          
  ------------------------ ------------------------ ------------------------

HOWTO: Become an Arch Linux Tester for drivers/modules and related hardware
===========================================================================

Modules are an odd beast. They are specific to a kernel, and tend to do
a lot of things that only someone intimate with the hardware can really
tell you. Due to this, it's generally MORE important to test hardware
drivers than other packages. In addition, testing is harder for the
developers because not everyone has all the hardware needed.

We (Arch Linux, that is) will be implementing a clear path for people to
test modules before release, so we can at least get a "looks like it
works" nod from those. What we'd like to do is gather a set of TUs and
Developers for right now. When we figure out a workable system we will
be able to pull in members of the community who have the hardware and
are willing to take some time out of their day to test new packages.

> How will this work?

The idea isn't really fully fleshed out right now. In theory though,
testers will sign up for a given module/package and will receive emails
when a new version hits the CVS repos (and most likely in [testing] as
well). It may be pretty informal, but testers should probably respond as
soon as possible to the maintainer of the package.

For the purpose of email filtering, let's layout a format for responses:

       Subject: [arch-testing] package-name success

or

       Subject: [arch-testing] package-name failure

Comments and all that should be in the email body, but keeping this
information in the subject will help maintainers (a) filter testing
emails and (b) see the status at a quick glance.

> Alright, how can I help?

-   New User <email@foo.bar>
    -   module1: hardware name or comment
    -   module2: hardware name or comment
    -   module3: hardware name or comment

Using the format above, please list your name, email, and
hardware/modules you are willing to test.

Please note: it's best if you only add modules you use, not modules you
*can* use, unless you're willing to spend time testing on each new
release.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Driver_Testing&oldid=249600"

Category:

-   Hardware
