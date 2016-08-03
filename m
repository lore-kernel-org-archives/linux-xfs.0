Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F4F77CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 18:29:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 421FC304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 16:29:55 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bPTsWgnTa4HdBWCy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 16:29:52 -0700 (PDT)
Date: Wed, 3 Aug 2016 16:29:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Spam on this list
Message-ID: <20160803232943.GI8593@birch.djwong.org>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<57CF7681619F42CCB4C0CF589E9686E5@dinulap>
	<alpine.LSU.2.20.1608031453290.5594@Grypbagne.inyvabe>
	<4382687.Pe7d1tBhVA@merkaba>
	<9b25f9f9-8a55-8744-9f18-c1045fae0f79@telefonica.net>
	<20160803231529.GX16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803231529.GX16044@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Carlos E. R." <robin.listas@telefonica.net>, XFS mail list <xfs@oss.sgi.com>

On Thu, Aug 04, 2016 at 09:15:29AM +1000, Dave Chinner wrote:
> On Wed, Aug 03, 2016 at 03:34:58PM +0200, Carlos E. R. wrote:
> > On 2016-08-03 15:21, Martin Steigerwald wrote:
> > 
> > > Lista, Carlos, I recommend: If you are concerned about spam on the list 
> > > contact the listmasters of it. They are the ones that can address it globally 
> > > for the list.
> > 
> > Oh, I did, long ago. Still waiting.
> 
> Yes, that is the fundamental issue - spam filtering is essentially
> controlled by SGI's internal infrastructure, which we have little
> option on.
> 
> What it comes down to is whether we continue to use this list
> (xfs@oss.sgi.com) or whether we move to linux-xfs@vger.kernel.org
> so we get much more robust and up-to-date spam filtering. The issue
> with doing this is forcing everyone to resubscribe, and then
> capturing everything that is still sent to xfs@oss.sgi.com.
> 
> That said, I'm seriously tempted right now just to say "we're moving
> to vger" and asking everyone to resubscribe to that list, and then
> making xfs@oss.sgi.com respond with "list moved to vger, please
> repost there". i.e. not even put a forwarding gateway in place.
> 
> If we do that, then I'll also shut down all the XFS git trees on
> oss.sgi.com - I'll add commits to the them to say "go to
> kernel.org". I'll need to work something out for the tarball
> releases, but kernel.org does have functionality for that, too, so
> that may just be a small change of process on my end (i.e. use kup).
> Once that is done, we'll be running completely on community provided
> infrastructure....
> 
> Thoughts?

YAY!

By the way, could we update the docs on
http://xfs.org/index.php/XFS_Papers_and_Documentation ?

The filesystem structure guide is a little out of date.

(The user guide probably is too, but as I've only been sending patches
for the disk format guide I'm keeping my mouth shut about the others.)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
