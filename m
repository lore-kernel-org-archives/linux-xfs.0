Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E1C17CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 15:42:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82AA4AC001
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 13:42:26 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	PmBUFP448MWwcAKF for <xfs@oss.sgi.com>;
	Tue, 01 Mar 2016 13:42:23 -0800 (PST)
Date: Wed, 2 Mar 2016 08:42:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: futher writeback updates
Message-ID: <20160301214222.GK30721@dastard>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<20160301130113.GA3901@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160301130113.GA3901@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 05:01:13AM -0800, Christoph Hellwig wrote:
> Any comments?

I pulled them in to my testing stack yesterday afternoon.  There's a
good chance I'll end up delaying commiting these to the next merge
window, simply because I don't have the bandwidth at this point to
process any more significant changes to the for-next tree.  I think
it's much more important right now to get the rmap/reflink in the
the 4.6 merge window than these writeback changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
