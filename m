Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q215A2v6078715 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 23:10:02 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ZsFZM2RsLtWMcGZg for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 21:10:01 -0800 (PST)
Message-ID: <4F4F04A7.4030500@sandeen.net>
Date: Wed, 29 Feb 2012 23:09:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Warning from unlock_new_inode
References: <20120222220137.GB3650@quack.suse.cz>
	<20120228083444.GB22995@infradead.org>
	<20120229005351.GV3592@dastard> <20120229014906.GX3592@dastard>
In-Reply-To: <20120229014906.GX3592@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On 2/28/12 7:49 PM, Dave Chinner wrote:

...

> Jan, can you try the (untested) patch below?
> 
> Cheers,
> 
> Dave.

Just for the list's benefit - we tested this with the in-house NFS benchmark reproducer, and the tester also reported success.

Thanks Dave!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
