Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIvKPn123516 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:57:20 -0500
Date: Sat, 10 Sep 2011 14:57:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/25] xfs: move allocation ranges inode bmalloca structure
Message-ID: <20110910185718.GC4750@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060644.392598929@bombadil.infradead.org>
	<1315612576.1999.134.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315612576.1999.134.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 06:56:16PM -0500, Alex Elder wrote:
> Lots of this patch is simply renaming xfs_bmalloca fields
> "off" -> "offset", "rval" -> "blkno", and "alen" -> "length".
> Those are very much appreciated changes.  I know there are
> already a lot of patches in this series but it would have
> been easier to see the "real" change had that part been
> pulled out as a trivial extra one.

I'll look into it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
