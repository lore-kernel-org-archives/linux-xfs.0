Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBQCD883239779 for <xfs@oss.sgi.com>; Mon, 26 Dec 2011 06:13:09 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WlWnqO3rIhrXJsS7 for <xfs@oss.sgi.com>;
	Mon, 26 Dec 2011 04:13:05 -0800 (PST)
Date: Mon, 26 Dec 2011 23:13:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 v2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111226121302.GE12731@dastard>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
	<20111220200841.GA2788@infradead.org>
	<20111223214703.GW29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111223214703.GW29840@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Fri, Dec 23, 2011 at 03:47:03PM -0600, Ben Myers wrote:
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> Mark also reviewed this.
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Just a process note here: if Mark reviewed the code and is happy
with it, then he needs to send his reviewed-by tag himself. If he's
got concerns, then he needs to discuss them on the list with the
patch author, not just in private with you. If a person's questions
are not posted to the mailing list or posted by proxy and they
didn't aprticipate in discussions on the list, then there is no
evidence that the person ever reviewed the patch. Hence the tag has
no value because it is not verifiable.

More importantly, tags are a semi-formal statement that a set of
actions has been taken by that person - see
Documentation/SubmittingPatches for the actions different tags
imply. Hence it is important the actions they imply are verifiable,
and it also reinforces the fact that they only have value when they
are issued by the email address (or a known alias) in the tag....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
