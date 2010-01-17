Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBofg3009593 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:50:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD0D0F18D3B
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:51:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id htYmtPZEeYUOneFP for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:51:40 -0800 (PST)
Date: Sun, 17 Jan 2010 06:51:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] xfsprogs: fix print format warnings in xfs_io
Message-ID: <20100117115140.GC10994@infradead.org>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
	<1263463752-5052-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263463752-5052-8-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 09:09:10PM +1100, Dave Chinner wrote:
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  io/madvise.c |    2 +-
>  io/mincore.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
