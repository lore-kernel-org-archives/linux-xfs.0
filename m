Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5C8K3Pt205135 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 03:20:03 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JMuaNKDpLxGSVj1G for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 01:20:00 -0700 (PDT)
Date: Tue, 12 Jun 2012 18:19:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: remove xfs_ialloc_find_free
Message-ID: <20120612081957.GM22848@dastard>
References: <20120605144647.051012936@bombadil.infradead.org>
	<20120605144835.503963603@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120605144835.503963603@bombadil.infradead.org>
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

On Tue, Jun 05, 2012 at 10:46:48AM -0400, Christoph Hellwig wrote:
> This function is entirely trivial and only has one caller, so remove it to
> simplify the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
