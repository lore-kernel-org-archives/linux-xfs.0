Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n192HNIW211861 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 20:17:24 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B614FC62A
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 18:16:46 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	hQaMlQ8nlnvJh59c for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 18:16:46 -0800 (PST)
Date: Mon, 9 Feb 2009 13:16:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/17] xfs: remove superflous inobt macros
Message-ID: <20090209021644.GE8830@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073201.697358000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073201.697358000@bombadil.infradead.org>
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

On Mon, Jan 26, 2009 at 02:31:43AM -0500, Christoph Hellwig wrote:
> xfs_ialloc_btree.h has a a cuple of macros that only obsfucate the code
> but don't provide any abstraction benefits.  This patches removes those
> and cleans up the reamaining defintions up a little.
> 
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
