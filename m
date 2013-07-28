Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2571A7F6A
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 20:50:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3AF3AC001
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 18:50:50 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	huZBXsrCsUMGa0Pu for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 18:50:48 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 134121F0090B
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 21:50:48 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id MR7RZ3rgX8cX for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 21:50:43 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id A3B3C1F008DC
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 21:50:43 -0400 (EDT)
Date: Sat, 27 Jul 2013 21:50:43 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <6559720.2408.1374976243593.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <043835EA-08D4-4945-92F0-173BFE2C604C@gmail.com>
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
> From: "aurfalien" <aurfalien@gmail.com>

> > If Dave thinks *that* question is out of bounds, then when I do my
> > rotating reformat to recover from my recent power supply induced
> > crash, XFS will not be the file system I pick off the pulldown menu
> > to reformat with.
> 
> Well, you'll be missing out. Who cares what any one thinks in terms of
> Free vs Fee paradigms, XFS is simply a rockin FS.

You bet; we've put dozens of TB on and off it in 9 years of running
MythTV.  And in the 2 instances where it's blown its brains out, 
Dave, in particular, has been very helpful in putting it back together;
it's a little unnerving, actually, to look the handle up after an 
IRC chat and discover you had the lead dev on the phone.

> I was really intrigued by his and Linus's back and forth not to long
> ago, some great knowledge for sure.

I was watching that; I didn't see it end.  Did it?

> This list is great so filter whats applicable and toss the rest in a
> bit bucket.

As it happens, though, My Sister's DVR is *not* the only machine with
Really Big Filesystems on it*, and it really does matter to me what the
development policies are on critical subsystems like this; hence my 
query above.

I really really *love* SuSE, after 8 years, but they've made a critical 
change I simply can't tolerate for commercial use, and I'm going to have
to pick a new distro.  (And anyone who says "well, just switch to SLES" 
either forgets that that's $1200/server/year, or forgets where Linux came
from in the first place...)

CentOS is the only thing that's anywhere close.

* ... for which I'm responsible ...

Cheers
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
