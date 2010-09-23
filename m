Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N0gFFA092045 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 19:42:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 915FE18490E7
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 17:43:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	FzCWJnU05Ubb0dJK for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 17:43:08 -0700 (PDT)
Date: Thu, 23 Sep 2010 10:43:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/16] xfs: batch inode reclaim lookup
Message-ID: <20100923004305.GL2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-14-git-send-email-david@fromorbit.com>
	<20100922173410.GF5697@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922173410.GF5697@infradead.org>
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

On Wed, Sep 22, 2010 at 01:34:10PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 22, 2010 at 04:44:26PM +1000, Dave Chinner wrote:
> > This is based on ideas suggested in a proof-of-concept patch
> > posted by Nick Piggin.
> 
> Hmm, I can't remember seeing that patch.

http://oss.sgi.com/archives/xfs/2010-07/msg00348.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
