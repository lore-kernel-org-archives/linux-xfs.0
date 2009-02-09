Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n192nCGb214032 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 20:49:12 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FA2FFC754
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 18:48:34 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	2cYw3jYHKsdckxWW for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 18:48:34 -0800 (PST)
Date: Mon, 9 Feb 2009 13:42:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/17] xfs: use mutex_is_locked in XFS_DQ_IS_LOCKED
Message-ID: <20090209024259.GJ8830@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073203.550396000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073203.550396000@bombadil.infradead.org>
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

On Mon, Jan 26, 2009 at 02:31:52AM -0500, Christoph Hellwig wrote:
> Now that we have a helper to test if a mutex is held use it instead of our
> own little hacks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
