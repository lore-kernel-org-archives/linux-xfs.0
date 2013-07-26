Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D358A29E21
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:43:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B35848F8035
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 12:43:48 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	EbRzCK43f7VIwtr2 for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 12:43:47 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 8E66C1F0014B
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 15:43:46 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id M4rL7LX01myf for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 15:43:42 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 66CD71F0017E
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 15:43:42 -0400 (EDT)
Date: Fri, 26 Jul 2013 15:43:42 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <21422056.2320.1374867822351.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51F2CD8B.8080207@hardwarefreak.com>
Subject: A short digression on FOSS (Re: understanding speculative
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

> IMNSHO, CentOS is a free proprietary chrome plated dog turd. It's
> flashy on the outside and claims it's "ENTERPRISE", "just like RHEL!".
> Then you crack it open and find nothing but crap inside. So you take it
> back to the store that gave it away for free and the doors are barred,
> the place out of business. The chrome has peeled off and you're stuck
> with crap that difficult to use. Every time you touch it you get dirty
> in some fashion.

Don't hold back, Stan; tell us how you *really* feel.  :-)

> FYI, many of the folks on the XFS list are Red Hat employees, including
> Dave. They'll gladly assist RHEL customers here if needed. However, to
> support CentOS users, especially in your situation, they'd have to use
> Red Hat Inc resources to hunt down the information related to the CentOS
> kernel you have that correlates to the RHEL kernel it is copied from.
> So they've just consumed Red Hat Inc resources to directly assist a free
> competitor who copied their distro.

At this point, Stan, though, I believe you've forgotten the Social Contract
of Free/Open Source software: *I didn't built [most of] that*.  And 
participating in the FOSS ecosystem is the price I pay to not have had to
build that.

Red Hat, admittedly, is a much larger contributor to both the kernel, and user
space, than some other people.  And CentOS is, admittedly, much more of a 
knockoff than most other distributions.

But it would also be good to remember, here, the reason why it looked necessary
to create CentOS in the first place: Red Hat went into the commercial 
software business with RHEL, and left behind Fedora which -- I've tried --
is not really a practical solution for business use, the way, say, RH 7 was,
or SuSE 10/11 were.

There was an amazingly large amount of commerce that was big enough to
use Linux, but not big enough to pay $1200/machine/year for the privilege,
which ought to be no surprise to anyone who does this for a living.

I am myself, in fact, about to switch to CentOS, because the Release 
Configuration Manager for openSUSE has gone insane, not only replacing
sysVinit with Mr Poettering's $EXPLETIVE, but *dropping support throughout
the packaging system for sysV compatible initscripts on boot-start apps*.

Without proper notice of deprecation.

It isn't always just the code.

But to address your specific point, I don't believe that RH is going to 
base its opinion on what time its employees spend supporting the remainder
of the FOSS ecosystem on whether the relevant distro was copied from theirs,
or not -- and I will be disappointed, publicly, and vocally, if they do.

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
