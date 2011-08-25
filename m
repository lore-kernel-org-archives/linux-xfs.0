Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P6K3WT167314 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:20:03 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FEC1139C128
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:22:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L1BjrF8xS0vvqs6S for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 23:22:52 -0700 (PDT)
Date: Thu, 25 Aug 2011 16:19:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: preparing a new xfsprogs release?
Message-ID: <20110825061959.GN3162@dastard>
References: <20110825050828.GA30775@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110825050828.GA30775@infradead.org>
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

On Thu, Aug 25, 2011 at 01:08:28AM -0400, Christoph Hellwig wrote:
> We have the libxfs resync and a healthy amount of fixes in xfsprogs,
> what about cutting a release in about 1-2 weeks from now?

Probably a good idea.

Once it is release, I'll look at doing another kernel code sync -
this one will be a lot smaller than the last - and then we can start
adding all the new stuff we've got on top of it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
