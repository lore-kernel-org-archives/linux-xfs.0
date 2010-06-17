Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5H6a5HS164825 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 01:36:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E98E14EFADF
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 23:38:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	h24tc4LiZKmr0Jtw for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 23:38:41 -0700 (PDT)
Date: Thu, 17 Jun 2010 16:38:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsqa: test open_by_handle() on unlinked and freed
	inode clusters V2
Message-ID: <20100617063839.GW6590@dastard>
References: <1276742800-9845-1-git-send-email-david@fromorbit.com>
	<20100617055657.GA5208@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100617055657.GA5208@infradead.org>
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

On Thu, Jun 17, 2010 at 01:56:57AM -0400, Christoph Hellwig wrote:
> The patch is missing the new stale_handle.c file.

Ah, sorry - PEBKAC. Just resent it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
