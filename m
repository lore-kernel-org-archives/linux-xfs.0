Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o524dAht048173 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 23:39:11 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DFB01B15F47
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 21:41:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	NBIQTD4PCfdti9tp for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 21:41:36 -0700 (PDT)
Date: Wed, 2 Jun 2010 14:41:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/17] xfs: improve xfs_isilocked
Message-ID: <20100602044134.GC7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160859.397431345@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160859.397431345@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:30PM -0400, Christoph Hellwig wrote:
> Use rwsem_is_locked to make the assertations for shared locks work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
