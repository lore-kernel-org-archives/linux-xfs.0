Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM0H3qO028055 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 18:17:03 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 172CD1D218B8
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:17:00 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tyBeVQFB1hpoNkP2 for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 16:17:00 -0800 (PST)
Date: Tue, 22 Nov 2011 11:16:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs v3.1.7
Message-ID: <20111122001657.GG2386@dastard>
References: <20111117233139.GL29840@sgi.com>
	<20111119175102.GA3334@infradead.org>
	<20111121154040.GU749@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111121154040.GU749@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 09:40:40AM -0600, Ben Myers wrote:
> Hey Christoph,
> 
> On Sat, Nov 19, 2011 at 12:51:02PM -0500, Christoph Hellwig wrote:
> > On Thu, Nov 17, 2011 at 05:31:39PM -0600, Ben Myers wrote:
> > > Version 3.1.7 of xfsprogs has been released.
> > 
> > Can we please avoid totally uncoordinated and rushed release in
> > the future?
> 
> That sounds like a good idea.  Do you have a date in mind?  Lets get it
> on the calendar.

"When it is ready" is the normal date. We don't really do things
based on a box on a calendar round here. ;)

Indeed, before the next release we really need to do another
kernel/userspace resync - userspace is at 2.6.38, and it needs to be
brought up to sync so we don't get into the same problem of the last
resync where it took weeks to do and test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
