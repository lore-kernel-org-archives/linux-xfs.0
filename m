Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KKHiXP109647 for <xfs@oss.sgi.com>; Fri, 20 May 2011 15:17:44 -0500
Subject: Re: [PATCH 1/9] xfs: remove the unused XFS_BMAPI_RSVBLOCKS flag
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110511150711.367977044@bombadil.infradead.org>
References: <20110511150402.258164661@bombadil.infradead.org>
	<20110511150711.367977044@bombadil.infradead.org>
Date: Fri, 20 May 2011 15:17:40 -0500
Message-ID: <1305922660.1964.57.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-05-11 at 11:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-kill-XFS_BMAPI_RSVBLOCKS)
> The XFS_BMAPI_RSVBLOCKS is unused, and as far as I can see has always been.
> Remove it to simplify the bmapi implementation and conserve stack space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
