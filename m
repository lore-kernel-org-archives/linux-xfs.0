Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84C2E7F3F
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 16:00:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04C47AC001
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 14:00:27 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	tD6VkE6vDr5Ra1Wo for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 14:00:26 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 056A91F002CC
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 17:00:26 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id agAsJOC78Ass for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 17:00:21 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id CBEB41F00210
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 17:00:21 -0400 (EDT)
Date: Sat, 27 Jul 2013 17:00:21 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <6869770.2390.1374958821773.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51F343F5.5080709@hardwarefreak.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>

> On 7/26/2013 2:43 PM, Jay Ashworth wrote:
> 
> > But to address your specific point, I don't believe that RH is going
> > to
> > base its opinion on what time its employees spend supporting the
> > remainder
> > of the FOSS ecosystem on whether the relevant distro was copied from
> > theirs,
> > or not -- and I will be disappointed, publicly, and vocally, if they
> > do.
> 
> On 7/26/2013 8:26 PM, Dave Chinner wrote:

In a message which, for some reason, I do not see here in my list folder;
(it wasn't in my inbox either; this seems a running thing)

> > Disclaimer: I'm the primary RHEL XFS developer, employed by Red Hat.
> >
> > CentOS is a rebadged RHEL product that is released for free. If you
> > want bugs fixed in CentOS, then generally you are on your own. If
> > you want paid support where people will fix problems you have, you
> > need to pay for RHEL.
> >
> > You get what you pay for.
> 
> Jay, I'm awaiting your public and vocal disappointment. BTW, Dave has
> stated this position regarding CentOS many times. I'm guessing you're
> new to the XFS list (July 13 maybe) or simply missed such prior posts
> if you've been lurking much longer.

I am new to the list, yes.  But -- and I can only reply to what you 
quoted here; apologies to DC if it's less than what he wrote -- I am
in fact disappointed: in Dave for the strawman reply.  No one, that I 
saw, *reported bugs or asked for support* with CentOS.

The question -- and it was coming from someone who sounded like
they had read their Raymond, Moen, and Tatham, was "how do I 
determine *which version of the XFS drivers* is in the kernel
I'm running, so that I can helpfully report my problems to the list".

If Dave thinks *that* question is out of bounds, then when I do my 
rotating reformat to recover from my recent power supply induced 
crash, XFS will not be the file system I pick off the pulldown menu
to reformat with.

As I've just had to explain to the openSUSE release configuration 
people over sysVinit and packaging, the policies of the developers
underneath the code are *much* more important to me than the code
is, or what the code does.

If the implication of Dave's comment above is that he's not interested
in bug reports from people who aren't paid customers of RH, I'm fine
with that as well; his call.  Clearly, I won't be one of those,
either; my sister isn't interested in paying $1200/yr for the OS on
her DVR.

Perhaps I'm misinterpreting one of you.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
