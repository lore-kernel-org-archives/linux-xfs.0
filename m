Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p340IDiu135878 for <xfs@oss.sgi.com>; Sun, 3 Apr 2011 19:18:14 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4938815AF7CC
	for <xfs@oss.sgi.com>; Sun,  3 Apr 2011 17:21:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qM1cORn2qgIbMJBa for <xfs@oss.sgi.com>;
	Sun, 03 Apr 2011 17:21:27 -0700 (PDT)
Date: Mon, 4 Apr 2011 10:21:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix xfs_debug warnings
Message-ID: <20110404002125.GM6957@dastard>
References: <20110402181340.GA12639@infradead.org>
	<20110402220905.GA1861@infradead.org>
	<20110403001648.GH6957@dastard>
	<20110403105823.GA3872@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110403105823.GA3872@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Apr 03, 2011 at 06:58:23AM -0400, Christoph Hellwig wrote:
> On Sun, Apr 03, 2011 at 10:16:48AM +1000, Dave Chinner wrote:
> > Looks good, though I don't get those warnings using gcc-4.4.4. I
> > guess it's gcc-4.6 issuing the warnings?
> 
> Debian testing recently updated to gcc 4.5.2 from gcc 4.4.x, I think
> that's when I started to see them.

Ok, my build box is still running on squeeze which would explain the
difference. I'll look at upgrading it in the not-too-distant future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
