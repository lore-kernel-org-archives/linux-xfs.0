Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2KGhZ08062020 for <xfs@oss.sgi.com>; Sat, 20 Mar 2010 11:43:35 -0500
Date: Sat, 20 Mar 2010 12:45:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] xfs: simplify XLOG_SECTOR_ROUND*()
Message-ID: <20100320164514.GC31444@infradead.org>
References: <201003182253.o2IMruwI001866@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201003182253.o2IMruwI001866@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 18, 2010 at 05:53:56PM -0500, Alex Elder wrote:
> Hopefully this is convincing.

I think it is.

> While I was at it, I converted XLOG_SECTOR_ROUNDDOWN_BLKNO() to use
> the round_down() macro.

That looks good, too.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
