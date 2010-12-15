Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFNOHOR248557 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 17:24:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12466152DF0A
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 15:26:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	GIxDvKT9rO7TpVGY for <xfs@oss.sgi.com>;
	Wed, 15 Dec 2010 15:26:09 -0800 (PST)
Date: Thu, 16 Dec 2010 10:26:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/10] writeback updates V2
Message-ID: <20101215232606.GJ9925@dastard>
References: <20101210084215.259628825@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101210084215.259628825@bombadil.infradead.org>
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

On Fri, Dec 10, 2010 at 03:42:15AM -0500, Christoph Hellwig wrote:
>  - add IO_DIRECT per Dave's review comment
>  - fix up a commit message as per Dave's review comment
>  - add Reviewed-by: tags for Dave's reviews

Christoph, do you want me to add this to my xfs-for-2.6.38 branch so
it is easier to test with all the other pending changes we have for
2.6.38?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
