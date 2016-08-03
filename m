Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F79F7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 18:16:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98297AC003
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 16:16:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XPWBZlGrrekqyU3B for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2016 16:16:16 -0700 (PDT)
Date: Thu, 4 Aug 2016 09:15:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Spam on this list
Message-ID: <20160803231529.GX16044@dastard>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<57CF7681619F42CCB4C0CF589E9686E5@dinulap>
	<alpine.LSU.2.20.1608031453290.5594@Grypbagne.inyvabe>
	<4382687.Pe7d1tBhVA@merkaba>
	<9b25f9f9-8a55-8744-9f18-c1045fae0f79@telefonica.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9b25f9f9-8a55-8744-9f18-c1045fae0f79@telefonica.net>
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
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: XFS mail list <xfs@oss.sgi.com>

On Wed, Aug 03, 2016 at 03:34:58PM +0200, Carlos E. R. wrote:
> On 2016-08-03 15:21, Martin Steigerwald wrote:
> 
> > Lista, Carlos, I recommend: If you are concerned about spam on the list 
> > contact the listmasters of it. They are the ones that can address it globally 
> > for the list.
> 
> Oh, I did, long ago. Still waiting.

Yes, that is the fundamental issue - spam filtering is essentially
controlled by SGI's internal infrastructure, which we have little
option on.

What it comes down to is whether we continue to use this list
(xfs@oss.sgi.com) or whether we move to linux-xfs@vger.kernel.org
so we get much more robust and up-to-date spam filtering. The issue
with doing this is forcing everyone to resubscribe, and then
capturing everything that is still sent to xfs@oss.sgi.com.

That said, I'm seriously tempted right now just to say "we're moving
to vger" and asking everyone to resubscribe to that list, and then
making xfs@oss.sgi.com respond with "list moved to vger, please
repost there". i.e. not even put a forwarding gateway in place.

If we do that, then I'll also shut down all the XFS git trees on
oss.sgi.com - I'll add commits to the them to say "go to
kernel.org". I'll need to work something out for the tarball
releases, but kernel.org does have functionality for that, too, so
that may just be a small change of process on my end (i.e. use kup).
Once that is done, we'll be running completely on community provided
infrastructure....

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
