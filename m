Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o525RpQA053237 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 00:27:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC7D3146E309
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 22:30:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	tM1QovGrgOeEGABq for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 22:30:17 -0700 (PDT)
Date: Wed, 2 Jun 2010 15:30:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/17] xfs: give xfs_item_ops methods the correct
	prototypes
Message-ID: <20100602053015.GH7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160900.816713118@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160900.816713118@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:35PM -0400, Christoph Hellwig wrote:
> Stop the function pointer casting madness and give all the xfs_item_ops the
> correct prototypes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup. Long overdue.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
